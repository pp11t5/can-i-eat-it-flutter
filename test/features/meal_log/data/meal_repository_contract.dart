import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 계약 테스트 스위트 (신 계약).
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
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
    test('timeline은 List<TimelineItem>을 반환한다', () async {
      final repo = create();
      final result = await repo.timeline(DateTime(2026, 6, 17));
      expect(result, isA<List<TimelineItem>>());
    });

    test('timeline은 Future를 반환한다 (await 가능)', () async {
      final repo = create();
      await expectLater(repo.timeline(DateTime(2026, 6, 17)), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('weekly — 반환 형태', () {
    test('weekly는 List<WeeklyDay>을 반환한다', () async {
      final repo = create();
      final result = await repo.weekly(DateTime(2026, 6, 17));
      expect(result, isA<List<WeeklyDay>>());
    });
  });

  // -------------------------------------------------------------------------
  group('appendFood — 기본 동작', () {
    test('appendFood는 MealFood를 반환한다', () async {
      final repo = create();
      final result = await repo.appendFood(foodExternalId: 'f-1');
      expect(result, isA<MealFood>());
    });

    test('appendFood 결과의 mealFoodId는 비어 있지 않다', () async {
      final repo = create();
      final result = await repo.appendFood(foodExternalId: 'f-1');
      expect(result.mealFoodId, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('appendFoodByText — 미지원 seam', () {
    test('appendFoodByText는 UnimplementedError를 던진다', () async {
      final repo = create();
      await expectLater(
        repo.appendFoodByText(foodTextInput: '아메리카노'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('appendFood → mealDetail 연계', () {
    test('appendFood 후 mealDetail을 호출하면 MealRecord를 반환한다', () async {
      final repo = create();
      final food = await repo.appendFood(foodExternalId: 'f-1');
      // appendFood 응답의 mealRecordExternalId 로 식사 상세 조회.
      final record = await repo.mealDetail(food.mealRecordExternalId!);
      expect(record, isA<MealRecord>());
    });

    test('appendFood 후 식사에 해당 음식이 포함된다', () async {
      final repo = create();
      final food = await repo.appendFood(foodExternalId: 'f-1');
      final record = await repo.mealDetail(food.mealRecordExternalId!);
      expect(
        record.foods.map((f) => f.mealFoodId),
        contains(food.mealFoodId),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('deleteMeal — 기본 동작', () {
    test('deleteMeal은 Future<void>를 반환한다', () async {
      final repo = create();
      final food = await repo.appendFood(foodExternalId: 'f-1');
      await expectLater(
        repo.deleteMeal(food.mealRecordExternalId!),
        completes,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('deleteFood — 기본 동작', () {
    test('deleteFood는 Future<void>를 반환한다', () async {
      final repo = create();
      final food = await repo.appendFood(foodExternalId: 'f-1');
      await expectLater(repo.deleteFood(food.mealFoodId), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('candidates — 반환 형태', () {
    test('candidates는 List<MealCandidatesDay>을 반환한다', () async {
      final repo = create();
      final result = await repo.candidates();
      expect(result, isA<List<MealCandidatesDay>>());
    });
  });
}
