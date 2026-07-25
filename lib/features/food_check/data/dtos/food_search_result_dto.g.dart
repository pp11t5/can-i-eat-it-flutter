// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_search_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodSearchResultDto _$FoodSearchResultDtoFromJson(Map<String, dynamic> json) =>
    _FoodSearchResultDto(
      foods: (json['foods'] as List<dynamic>?)
              ?.map((e) => FoodSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodSummaryDto>[],
      hasExactMatch: json['hasExactMatch'] as bool? ?? false,
    );

Map<String, dynamic> _$FoodSearchResultDtoToJson(
        _FoodSearchResultDto instance) =>
    <String, dynamic>{
      'foods': instance.foods,
      'hasExactMatch': instance.hasExactMatch,
    };
