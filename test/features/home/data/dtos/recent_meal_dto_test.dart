import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/data/dtos/recent_meal_dto.dart';
import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

void main() {
  group('RecentMealDto', () {
    test('foodName·category·eatenAt·symptomState를 파싱하고 toEntity에 반영한다', () {
      final dto = RecentMealDto.fromJson(const {
        'foodName': '된장찌개',
        'category': 'soup_stew',
        'eatenAt': '2026-07-05T12:30:00+09:00',
        'symptomState': 'comfortable',
      });
      expect(dto.foodName, '된장찌개');
      expect(dto.category, 'soup_stew');
      expect(dto.eatenAt, '2026-07-05T12:30:00+09:00');
      expect(dto.symptomState, 'comfortable');

      final entity = dto.toEntity();
      expect(entity, isA<RecentMeal>());
      expect(entity.foodName, '된장찌개');
      expect(entity.category, 'soup_stew');
      // eatenAt은 KST 이중변환 방지를 위해 원문 문자열 그대로 보관한다.
      expect(entity.eatenAt, '2026-07-05T12:30:00+09:00');
      expect(entity.symptomState, SymptomState.comfortable);
    });

    test('category·symptomState 누락 시 null로 폴백된다', () {
      final dto = RecentMealDto.fromJson(const {
        'foodName': '아메리카노',
        'eatenAt': '2026-07-05T09:00:00+09:00',
      });
      expect(dto.category, isNull);
      expect(dto.symptomState, isNull);

      final entity = dto.toEntity();
      expect(entity.category, isNull);
      expect(entity.symptomState, isNull);
    });
  });
}
