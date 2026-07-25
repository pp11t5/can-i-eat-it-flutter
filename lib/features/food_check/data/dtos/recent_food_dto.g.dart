// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_food_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentFoodDto _$RecentFoodDtoFromJson(Map<String, dynamic> json) =>
    _RecentFoodDto(
      id: (json['id'] as num).toInt(),
      query: json['query'] as String,
      searchedAt: DateTime.parse(json['searchedAt'] as String),
    );

Map<String, dynamic> _$RecentFoodDtoToJson(_RecentFoodDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'searchedAt': instance.searchedAt.toIso8601String(),
    };
