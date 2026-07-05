import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/dtos/food_category_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';

void main() {
  group('FoodCategoryDto', () {
    test('code·displayName을 파싱하고 toEntity에 반영한다', () {
      final dto = FoodCategoryDto.fromJson(const {
        'code': 'soup_stew',
        'displayName': '국·찌개',
      });
      expect(dto.code, 'soup_stew');
      expect(dto.displayName, '국·찌개');

      final entity = dto.toEntity();
      expect(entity, isA<FoodCategory>());
      expect(entity.code, 'soup_stew');
      expect(entity.displayName, '국·찌개');
    });
  });
}
