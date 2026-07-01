import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/repositories/dictionary_repository.dart';

/// [DictionaryRepository] 계약 테스트 스위트.
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
///
/// [seeded]: `true`면 최소 1건 이상의 데이터가 존재한다고 가정
/// (verdict 값 검증). `false`면 빈 저장소로 간주해 빈 페이지·count 0을 검증한다.
///
/// 사용법:
/// ```dart
/// dictionaryRepositoryContract(MockDictionaryRepository.seeded, seeded: true);
/// ```
void dictionaryRepositoryContract(
  DictionaryRepository Function() makeRepo, {
  required bool seeded,
}) {
  // -------------------------------------------------------------------------
  group('getSafe — 반환 형태', () {
    test('getSafe는 DictionaryPage를 반환한다', () async {
      final repo = makeRepo();
      final result = await repo.getSafe();
      expect(result, isA<DictionaryPage>());
    });

    test('getSafe는 Future를 반환한다 (await 가능)', () async {
      final repo = makeRepo();
      await expectLater(repo.getSafe(), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('getCautionRisk — 반환 형태', () {
    test('getCautionRisk는 DictionaryPage를 반환한다', () async {
      final repo = makeRepo();
      final result = await repo.getCautionRisk();
      expect(result, isA<DictionaryPage>());
    });
  });

  // -------------------------------------------------------------------------
  group('getCount — 반환 형태', () {
    test('getCount는 DictionaryCount를 반환한다', () async {
      final repo = makeRepo();
      final result = await repo.getCount();
      expect(result, isA<DictionaryCount>());
    });

    test('safeCount·cautionRiskCount는 비음수다', () async {
      final repo = makeRepo();
      final result = await repo.getCount();
      expect(result.safeCount, greaterThanOrEqualTo(0));
      expect(result.cautionRiskCount, greaterThanOrEqualTo(0));
    });
  });

  if (seeded) {
    // -------------------------------------------------------------------------
    group('seeded — verdict 계약', () {
      test('getSafe 항목은 모두 verdict==recommend다', () async {
        final repo = makeRepo();
        final page = await repo.getSafe();
        expect(page.items, isNotEmpty);
        for (final item in page.items) {
          expect(item.verdict, VerdictLevel.recommend);
        }
      });

      test('getCautionRisk 항목은 모두 recommend가 아니다 (caution·risk·unknown)', () async {
        final repo = makeRepo();
        final page = await repo.getCautionRisk();
        expect(page.items, isNotEmpty);
        for (final item in page.items) {
          expect(
            item.verdict,
            isIn([
              VerdictLevel.caution,
              VerdictLevel.risk,
              VerdictLevel.unknown,
            ]),
          );
        }
      });

      test('getCount는 getSafe·getCautionRisk 항목 수와 일관된다', () async {
        final repo = makeRepo();
        final safePage = await repo.getSafe();
        final cautionRiskPage = await repo.getCautionRisk();
        final count = await repo.getCount();
        expect(count.safeCount, safePage.items.length);
        expect(count.cautionRiskCount, cautionRiskPage.items.length);
      });
    });
  } else {
    // -------------------------------------------------------------------------
    group('empty — 빈 저장소 계약', () {
      test('getSafe는 빈 페이지를 반환한다', () async {
        final repo = makeRepo();
        final page = await repo.getSafe();
        expect(page.items, isEmpty);
      });

      test('getCautionRisk는 빈 페이지를 반환한다', () async {
        final repo = makeRepo();
        final page = await repo.getCautionRisk();
        expect(page.items, isEmpty);
      });

      test('getCount는 safeCount·cautionRiskCount 모두 0이다', () async {
        final repo = makeRepo();
        final count = await repo.getCount();
        expect(count.safeCount, 0);
        expect(count.cautionRiskCount, 0);
      });
    });
  }
}
