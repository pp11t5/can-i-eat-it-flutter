import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';
import 'package:can_i_eat_it/features/mypage/domain/repositories/my_page_repository.dart';

/// [MyPageRepository] 계약 테스트 스위트.
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
///
/// [seeded]: `true`면 현실적인 값(닉네임·카운트 양수)이 존재한다고 가정한다.
/// `false`면 빈 상태로 간주해 모든 카운트가 0/빈 문자열임을 검증한다.
///
/// 사용법:
/// ```dart
/// myPageRepositoryContract(MockMyPageRepository.seeded, seeded: true);
/// ```
void myPageRepositoryContract(
  MyPageRepository Function() makeRepo, {
  required bool seeded,
}) {
  // -------------------------------------------------------------------------
  group('getSummary — 반환 형태', () {
    test('getSummary는 MyPageSummary를 반환한다', () async {
      final repo = makeRepo();
      final result = await repo.getSummary();
      expect(result, isA<MyPageSummary>());
    });

    test('getSummary는 Future를 반환한다 (await 가능)', () async {
      final repo = makeRepo();
      await expectLater(repo.getSummary(), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('필드 비음수 계약', () {
    test('foodHistory·weeklySummary·mealCount의 모든 카운트는 비음수다', () async {
      final repo = makeRepo();
      final result = await repo.getSummary();
      expect(result.foodHistory.safeCount, greaterThanOrEqualTo(0));
      expect(result.foodHistory.cautionCount, greaterThanOrEqualTo(0));
      expect(result.weeklySummary.mealRecordCount, greaterThanOrEqualTo(0));
      expect(result.weeklySummary.recentSymptomCount, greaterThanOrEqualTo(0));
      expect(result.weeklySummary.streakCount, greaterThanOrEqualTo(0));
      expect(
        result.weeklySummary.mealCount.recommendCount,
        greaterThanOrEqualTo(0),
      );
    });
  });

  if (seeded) {
    // -------------------------------------------------------------------------
    group('seeded — 값 존재 계약', () {
      test('profile.nickName은 비어 있지 않다', () async {
        final repo = makeRepo();
        final result = await repo.getSummary();
        expect(result.profile.nickName, isNotEmpty);
      });

      test('foodHistory 카운트 합은 0보다 크다', () async {
        final repo = makeRepo();
        final result = await repo.getSummary();
        final total =
            result.foodHistory.safeCount + result.foodHistory.cautionCount;
        expect(total, greaterThan(0));
      });
    });
  } else {
    // -------------------------------------------------------------------------
    group('empty — 빈 상태 계약', () {
      test('profile.nickName은 빈 문자열이다', () async {
        final repo = makeRepo();
        final result = await repo.getSummary();
        expect(result.profile.nickName, isEmpty);
      });

      test('foodHistory·weeklySummary는 모두 0이다', () async {
        final repo = makeRepo();
        final result = await repo.getSummary();
        expect(result.foodHistory.safeCount, 0);
        expect(result.foodHistory.cautionCount, 0);
        expect(result.weeklySummary.mealRecordCount, 0);
        expect(result.weeklySummary.recentSymptomCount, 0);
        expect(result.weeklySummary.streakCount, 0);
      });
    });
  }
}
