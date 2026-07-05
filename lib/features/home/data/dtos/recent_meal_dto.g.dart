// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_meal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentMealDto _$RecentMealDtoFromJson(Map<String, dynamic> json) =>
    _RecentMealDto(
      foodName: json['foodName'] as String,
      category: json['category'] as String?,
      eatenAt: json['eatenAt'] as String,
      symptomState: json['symptomState'] as String?,
    );

Map<String, dynamic> _$RecentMealDtoToJson(_RecentMealDto instance) =>
    <String, dynamic>{
      'foodName': instance.foodName,
      'category': instance.category,
      'eatenAt': instance.eatenAt,
      'symptomState': instance.symptomState,
    };
