import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';

part 'recent_food_dto.freezed.dart';
part 'recent_food_dto.g.dart';

/// GET /foods/recent 응답 항목 DTO (ADR-0007 §3-1 (5)).
///
/// 서버 JSON 필드: camelCase.
/// entity 변환: [toEntity].
@freezed
abstract class RecentFoodDto with _$RecentFoodDto {
  const factory RecentFoodDto({
    required String foodExternalId,
    required String name,
    String? category,
    required DateTime searchedAt,
  }) = _RecentFoodDto;

  factory RecentFoodDto.fromJson(Map<String, dynamic> json) =>
      _$RecentFoodDtoFromJson(json);
}

extension RecentFoodDtoMapper on RecentFoodDto {
  RecentFood toEntity() => RecentFood(
        foodExternalId: foodExternalId,
        name: name,
        category: category,
        searchedAt: searchedAt,
      );
}
