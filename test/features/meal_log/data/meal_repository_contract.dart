import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 계약 테스트 스위트.
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
/// [food_repository_contract] 패턴을 복제한 공통 단언 함수.
///
/// 사용법:
/// ```dart
/// mealRepositoryContract(MockMealRepository.empty);
/// ```
void mealRepositoryContract(
  MealRepository Function() create,
) {
  // -------------------------------------------------------------------------
  group('timeline — 반환 형태', () {
    test('timeline은 List<MealGroup>을 반환한다', () async {
      final repo = create();
      final result = await repo.timeline(DateTime(2026, 6, 17));
      expect(result, isA<List<MealGroup>>());
    });

    test('timeline은 Future를 반환한다 (await 가능)', () async {
      final repo = create();
      await expectLater(
        repo.timeline(DateTime(2026, 6, 17)),
        completes,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('create — 기본 동작', () {
    test('create는 MealRecord를 반환한다', () async {
      final repo = create();
      final result = await repo.create(foodExternalId: 'f-1');
      expect(result, isA<MealRecord>());
    });

    test('create 결과의 mealId는 비어 있지 않다', () async {
      final repo = create();
      final result = await repo.create(foodExternalId: 'f-1');
      expect(result.mealId, isNotEmpty);
    });

    test('create 결과의 mealGroupId는 비어 있지 않다', () async {
      final repo = create();
      final result = await repo.create(foodExternalId: 'f-1');
      expect(result.mealGroupId, isNotEmpty);
    });

    test('create에 grade를 전달하면 결과의 judgedGrade가 동일하다', () async {
      final repo = create();
      final result = await repo.create(
        foodExternalId: 'f-1',
        grade: VerdictLevel.caution,
      );
      expect(result.judgedGrade, VerdictLevel.caution);
    });

    test('create에 grade를 전달하지 않으면 결과의 judgedGrade는 null이다', () async {
      final repo = create();
      final result = await repo.create(foodExternalId: 'f-1');
      expect(result.judgedGrade, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('createByText — 기본 동작', () {
    test('createByText는 MealRecord를 반환한다', () async {
      final repo = create();
      final result = await repo.createByText(foodTextInput: '아메리카노');
      expect(result, isA<MealRecord>());
    });

    test('createByText 결과의 mealId는 비어 있지 않다', () async {
      final repo = create();
      final result = await repo.createByText(foodTextInput: '아메리카노');
      expect(result.mealId, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('create → detail 연계', () {
    test('create 후 detail을 호출하면 MealDetail을 반환한다', () async {
      final repo = create();
      final record = await repo.create(foodExternalId: 'f-1');
      final detail = await repo.detail(record.mealId);
      expect(detail, isA<MealDetail>());
    });

    test('create 후 detail의 mealId가 일치한다', () async {
      final repo = create();
      final record = await repo.create(foodExternalId: 'f-1');
      final detail = await repo.detail(record.mealId);
      expect(detail.mealId, record.mealId);
    });
  });

  // -------------------------------------------------------------------------
  group('updateMemo — 기본 동작', () {
    test('updateMemo는 MealDetail을 반환한다', () async {
      final repo = create();
      final record = await repo.create(foodExternalId: 'f-1');
      final detail = await repo.updateMemo(record.mealId, '메모 내용');
      expect(detail, isA<MealDetail>());
    });

    test('updateMemo 후 detail의 memo가 갱신된다', () async {
      final repo = create();
      final record = await repo.create(foodExternalId: 'f-1');
      await repo.updateMemo(record.mealId, '새 메모');
      final detail = await repo.detail(record.mealId);
      expect(detail.memo, '새 메모');
    });

    test('updateMemo에 null을 전달하면 메모가 삭제된다', () async {
      final repo = create();
      final record = await repo.create(foodExternalId: 'f-1');
      await repo.updateMemo(record.mealId, '임시 메모');
      await repo.updateMemo(record.mealId, null);
      final detail = await repo.detail(record.mealId);
      expect(detail.memo, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('delete — 기본 동작', () {
    test('delete는 Future<void>를 반환한다', () async {
      final repo = create();
      final record = await repo.create(foodExternalId: 'f-1');
      await expectLater(repo.delete(record.mealId), completes);
    });
  });
}
