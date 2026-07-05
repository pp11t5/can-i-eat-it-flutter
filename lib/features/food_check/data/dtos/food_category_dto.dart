import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';

part 'food_category_dto.freezed.dart';
part 'food_category_dto.g.dart';

/// GET /foods/categories 응답 항목 DTO.
///
/// 서버 JSON 필드: camelCase. entity 변환: [toEntity].
@freezed
abstract class FoodCategoryDto with _$FoodCategoryDto {
  const factory FoodCategoryDto({
    required String code,
    required String displayName,
  }) = _FoodCategoryDto;

  factory FoodCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodCategoryDtoFromJson(json);
}

extension FoodCategoryDtoMapper on FoodCategoryDto {
  FoodCategory toEntity() => FoodCategory(
        code: code,
        displayName: displayName,
      );
}
