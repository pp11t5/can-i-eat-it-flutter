// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodSummaryDto _$FoodSummaryDtoFromJson(Map<String, dynamic> json) =>
    _FoodSummaryDto(
      foodExternalId: json['foodExternalId'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$FoodSummaryDtoToJson(_FoodSummaryDto instance) =>
    <String, dynamic>{
      'foodExternalId': instance.foodExternalId,
      'name': instance.name,
      'category': instance.category,
    };
