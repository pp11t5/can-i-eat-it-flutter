import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

import 'meal_repository_contract.dart';

void main() {
  // -------------------------------------------------------------------------
  // 계약 테스트 — empty 팩토리로 실행
  // -------------------------------------------------------------------------
  group('MockMealRepository — 저장소 계약', () {
    mealRepositoryContract(MockMealRepository.empty);
  });

  // -------------------------------------------------------------------------
  group('empty 팩토리', () {
    test('empty 팩토리는 timeline이 빈 목록이다', () async {
      final repo = MockMealRepository.empty();
      expect(await repo.timeline(DateTime(2026, 6, 17)), isEmpty);
    });

    test('empty 팩토리는 weekly가 빈 목록이다', () async {
      final repo = MockMealRepository.empty();
      expect(await repo.weekly(DateTime(2026, 6, 17)), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('seeded 팩토리', () {
    test('seeded 팩토리는 timeline에 single/group/symptom 변형이 모두 있다', () async {
      final repo = MockMealRepository.seeded();
      final items = await repo.timeline(DateTime(2026, 6, 17));
      expect(items.whereType<TimelineSingle>(), isNotEmpty);
      expect(items.whereType<TimelineGroup>(), isNotEmpty);
      expect(items.whereType<TimelineSymptom>(), isNotEmpty);
    });

    test('seeded mealDetail record-002는 음식 3건을 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final record = await repo.mealDetail('record-002');
      expect(record.foods.length, 3);
    });

    test('seeded mealDetail record-002는 stateRecords 1건을 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final record = await repo.mealDetail('record-002');
      expect(record.stateRecords.length, 1);
      expect(record.stateRecords[0].timingMinutes, 30);
    });

    test('seeded foodDetail food-001은 analysis를 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final food = await repo.foodDetail('food-001');
      expect(food.analysis, isNotNull);
      expect(food.analysis!.trigger, isNotNull);
      expect(food.analysis!.allergy, isNotNull);
    });

    test('seeded weekly는 judgements를 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final weekly = await repo.weekly(DateTime(2026, 6, 17));
      expect(weekly, isNotEmpty);
      expect(weekly[0].judgements, isNotEmpty);
    });

    test('seeded candidates는 후보를 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final candidates = await repo.candidates();
      expect(candidates, isNotEmpty);
      expect(candidates[0].meals, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('deleteMeal', () {
    test('deleteMeal 후 timeline에서 해당 식사가 사라진다', () async {
      final repo = MockMealRepository.seeded();
      await repo.deleteMeal('record-001');
      final items = await repo.timeline(DateTime(2026, 6, 17));
      final singleIds = items
          .whereType<TimelineSingle>()
          .map((i) => i.mealRecordId)
          .toList();
      expect(singleIds, isNot(contains('record-001')));
    });

    test('deleteMeal 후 해당 mealDetail 조회 시 예외', () async {
      final repo = MockMealRepository.seeded();
      await repo.deleteMeal('record-001');
      await expectLater(
        repo.mealDetail('record-001'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('deleteFood', () {
    test('deleteFood 후 식사에서 해당 음식이 사라진다', () async {
      final repo = MockMealRepository.seeded();
      await repo.deleteFood('food-002');
      final record = await repo.mealDetail('record-002');
      expect(
        record.foods.map((f) => f.mealFoodId),
        isNot(contains('food-002')),
      );
    });

    test('마지막 음식 삭제 시 식사도 함께 삭제된다', () async {
      final repo = MockMealRepository.seeded();
      // record-001은 food-001 하나뿐.
      await repo.deleteFood('food-001');
      await expectLater(
        repo.mealDetail('record-001'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('appendFood', () {
    test('mealRecordId 없이 appendFood 시 신규 식사가 생성된다', () async {
      final repo = MockMealRepository.empty();
      final food = await repo.appendFood(foodExternalId: 'f-tofu');
      final record = await repo.mealDetail(food.mealRecordExternalId!);
      expect(record.foods.length, 1);
    });

    test('mealRecordId 지정 시 같은 식사에 음식이 추가된다', () async {
      final repo = MockMealRepository.empty();
      final first = await repo.appendFood(foodExternalId: 'f-1');
      final recordId = first.mealRecordExternalId!;
      await repo.appendFood(foodExternalId: 'f-2', mealRecordId: recordId);
      final record = await repo.mealDetail(recordId);
      expect(record.foods.length, 2);
    });
  });

  // -------------------------------------------------------------------------
  group('appendFoodByText', () {
    test('mealRecordId 없이 appendFoodByText 시 신규 식사가 생성된다', () async {
      final repo = MockMealRepository.empty();
      final food = await repo.appendFoodByText(foodTextInput: '아메리카노');
      final record = await repo.mealDetail(food.mealRecordExternalId!);
      expect(record.foods.length, 1);
      expect(record.foods[0].name, '아메리카노');
    });

    test('mealRecordId 지정 시 같은 식사에 음식이 추가된다', () async {
      final repo = MockMealRepository.empty();
      final first = await repo.appendFood(foodExternalId: 'f-1');
      final recordId = first.mealRecordExternalId!;
      await repo.appendFoodByText(
        foodTextInput: '아메리카노',
        mealRecordId: recordId,
      );
      final record = await repo.mealDetail(recordId);
      expect(record.foods.length, 2);
    });

    test('앞뒤 공백은 trim되어 저장된다', () async {
      final repo = MockMealRepository.empty();
      final food = await repo.appendFoodByText(foodTextInput: '  아메리카노  ');
      expect(food.name, '아메리카노');
    });

    test('100자 초과 이름은 실구현과 동일하게 100자(grapheme 기준)로 잘린다 '
        '(pr-review 소소 수정 ③, meal_repository_impl.dart 정합)', () async {
      final repo = MockMealRepository.empty();
      final longName = '가' * 150;
      final food = await repo.appendFoodByText(foodTextInput: longName);
      expect(food.name.length, 100);
      expect(food.name, '가' * 100);
    });
  });

  // -------------------------------------------------------------------------
  group('mealDetail — 존재하지 않는 id는 예외를 던진다', () {
    test('없는 mealRecordId로 mealDetail 호출 시 예외가 발생한다', () async {
      final repo = MockMealRepository.empty();
      await expectLater(
        repo.mealDetail('no-such-record'),
        throwsA(isA<Exception>()),
      );
    });

    test('없는 mealFoodId로 foodDetail 호출 시 예외가 발생한다', () async {
      final repo = MockMealRepository.empty();
      await expectLater(
        repo.foodDetail('no-such-food'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('timeline — 날짜 인수 무관 동작 (mock은 날짜 무시)', () {
    test('다른 날짜를 넘겨도 동일한 항목 목록을 반환한다', () async {
      final repo = MockMealRepository.seeded();
      final a = await repo.timeline(DateTime(2026, 6, 17));
      final b = await repo.timeline(DateTime(2026, 1, 1));
      expect(a.length, b.length);
    });
  });
}
