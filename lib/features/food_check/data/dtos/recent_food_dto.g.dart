// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_food_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentFoodDto _$RecentFoodDtoFromJson(Map<String, dynamic> json) =>
    _RecentFoodDto(
      foodExternalId: json['foodExternalId'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      searchedAt: DateTime.parse(json['searchedAt'] as String),
    );

Map<String, dynamic> _$RecentFoodDtoToJson(_RecentFoodDto instance) =>
    <String, dynamic>{
      'foodExternalId': instance.foodExternalId,
      'name': instance.name,
      'category': instance.category,
      'searchedAt': instance.searchedAt.toIso8601String(),
    };
