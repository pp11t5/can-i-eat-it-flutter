import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/data/dtos/food_summary_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_search_result.dart';

part 'food_search_result_dto.freezed.dart';
part 'food_search_result_dto.g.dart';

/// GET /foods/search 응답 DTO.
///
/// 서버 result는 배열이 아니라 `foods`와 `hasExactMatch`를 포함한 객체다.
@freezed
abstract class FoodSearchResultDto with _$FoodSearchResultDto {
  const factory FoodSearchResultDto({
    @Default(<FoodSummaryDto>[]) List<FoodSummaryDto> foods,
    @Default(false) bool hasExactMatch,
  }) = _FoodSearchResultDto;

  factory FoodSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$FoodSearchResultDtoFromJson(json);
}

extension FoodSearchResultDtoMapper on FoodSearchResultDto {
  FoodSearchResult toEntity() => FoodSearchResult(
        foods: foods.map((food) => food.toEntity()).toList(),
        hasExactMatch: hasExactMatch,
      );
}
