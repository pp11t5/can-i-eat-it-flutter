import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/dtos/food_symptom_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

void main() {
  group('FoodSymptomDto', () {
    test('전체 필드를 파싱하고 toEntity에 반영한다', () {
      final dto = FoodSymptomDto.fromJson(const {
        'symptomId': 'symptom-1',
        'symptomState': 'uncomfortable',
        'symptomTypes': ['heartburn_reflux'],
        'occurredAt': '2026-06-20T20:30:00+09:00',
        'mealRecordId': 'meal-1',
        'afterMealMinutes': 30,
      });
      expect(dto.symptomId, 'symptom-1');
      expect(dto.symptomState, 'uncomfortable');
      expect(dto.symptomTypes, ['heartburn_reflux']);
      expect(dto.occurredAt, '2026-06-20T20:30:00+09:00');
      expect(dto.mealRecordId, 'meal-1');
      expect(dto.afterMealMinutes, 30);

      final entity = dto.toEntity();
      expect(entity, isA<FoodSymptom>());
      expect(entity.symptomId, 'symptom-1');
      expect(entity.symptomState, SymptomState.uncomfortable);
      expect(entity.symptomTypes, ['heartburn_reflux']);
      // occurredAt은 KST 이중변환 방지를 위해 원문 문자열 그대로 보관한다.
      expect(entity.occurredAt, '2026-06-20T20:30:00+09:00');
      expect(entity.mealRecordId, 'meal-1');
      expect(entity.afterMealMinutes, 30);
    });

    test('symptomTypes·afterMealMinutes 누락 시 각각 빈배열·0으로 폴백된다', () {
      final dto = FoodSymptomDto.fromJson(const {
        'symptomId': 'symptom-1',
        'symptomState': 'normal',
        'occurredAt': '2026-06-20T20:30:00+09:00',
        'mealRecordId': 'meal-1',
      });
      expect(dto.symptomTypes, isEmpty);
      expect(dto.afterMealMinutes, 0);
    });

    test('미지 symptomState 값은 normal로 폴백된다', () {
      final entity = FoodSymptomDto.fromJson(const {
        'symptomId': 'symptom-1',
        'symptomState': 'new_state',
        'occurredAt': '2026-06-20T20:30:00+09:00',
        'mealRecordId': 'meal-1',
      }).toEntity();
      expect(entity.symptomState, SymptomState.normal);
    });
  });
}
