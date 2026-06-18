// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StateRecordDto _$StateRecordDtoFromJson(Map<String, dynamic> json) =>
    _StateRecordDto(
      label: json['label'] as String,
      date: json['date'] as String,
      timing: json['timing'] as String,
    );

Map<String, dynamic> _$StateRecordDtoToJson(_StateRecordDto instance) =>
    <String, dynamic>{
      'label': instance.label,
      'date': instance.date,
      'timing': instance.timing,
    };

_MealFoodDetailDto _$MealFoodDetailDtoFromJson(Map<String, dynamic> json) =>
    _MealFoodDetailDto(
      externalId: json['externalId'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$MealFoodDetailDtoToJson(_MealFoodDetailDto instance) =>
    <String, dynamic>{
      'externalId': instance.externalId,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
    };

_MealRecordSummaryDto _$MealRecordSummaryDtoFromJson(
        Map<String, dynamic> json) =>
    _MealRecordSummaryDto(
      mealId: json['mealId'] as String,
      mealGroupId: json['mealGroupId'] as String,
      eatenAt: json['eatenAt'] as String,
      food: FoodSummaryDto.fromJson(json['food'] as Map<String, dynamic>),
      judgedGrade: json['judgedGrade'] as String?,
    );

Map<String, dynamic> _$MealRecordSummaryDtoToJson(
        _MealRecordSummaryDto instance) =>
    <String, dynamic>{
      'mealId': instance.mealId,
      'mealGroupId': instance.mealGroupId,
      'eatenAt': instance.eatenAt,
      'food': instance.food,
      'judgedGrade': instance.judgedGrade,
    };

_MealRecordDetailDto _$MealRecordDetailDtoFromJson(Map<String, dynamic> json) =>
    _MealRecordDetailDto(
      mealId: json['mealId'] as String,
      mealGroupId: json['mealGroupId'] as String,
      eatenAt: json['eatenAt'] as String,
      memo: json['memo'] as String?,
      judgedGrade: json['judgedGrade'] as String?,
      food: MealFoodDetailDto.fromJson(json['food'] as Map<String, dynamic>),
      stateRecords: (json['stateRecords'] as List<dynamic>?)
              ?.map((e) => StateRecordDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StateRecordDto>[],
    );

Map<String, dynamic> _$MealRecordDetailDtoToJson(
        _MealRecordDetailDto instance) =>
    <String, dynamic>{
      'mealId': instance.mealId,
      'mealGroupId': instance.mealGroupId,
      'eatenAt': instance.eatenAt,
      'memo': instance.memo,
      'judgedGrade': instance.judgedGrade,
      'food': instance.food,
      'stateRecords': instance.stateRecords,
    };

_MealGroupDto _$MealGroupDtoFromJson(Map<String, dynamic> json) =>
    _MealGroupDto(
      mealGroupId: json['mealGroupId'] as String,
      eatenAt: json['eatenAt'] as String,
      records: (json['records'] as List<dynamic>?)
              ?.map((e) =>
                  MealRecordSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MealRecordSummaryDto>[],
    );

Map<String, dynamic> _$MealGroupDtoToJson(_MealGroupDto instance) =>
    <String, dynamic>{
      'mealGroupId': instance.mealGroupId,
      'eatenAt': instance.eatenAt,
      'records': instance.records,
    };

_CreateMealRecordRequestDto _$CreateMealRecordRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _CreateMealRecordRequestDto(
      foodExternalId: json['foodExternalId'] as String,
      eatenAt: json['eatenAt'] as String?,
      mealGroupId: json['mealGroupId'] as String?,
      judgedGrade: json['judgedGrade'] as String?,
    );

Map<String, dynamic> _$CreateMealRecordRequestDtoToJson(
        _CreateMealRecordRequestDto instance) =>
    <String, dynamic>{
      'foodExternalId': instance.foodExternalId,
      'eatenAt': instance.eatenAt,
      'mealGroupId': instance.mealGroupId,
      'judgedGrade': instance.judgedGrade,
    };

_CreateMealByTextRequestDto _$CreateMealByTextRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _CreateMealByTextRequestDto(
      foodTextInput: json['foodTextInput'] as String,
      eatenAt: json['eatenAt'] as String?,
      mealGroupId: json['mealGroupId'] as String?,
      judgedGrade: json['judgedGrade'] as String?,
    );

Map<String, dynamic> _$CreateMealByTextRequestDtoToJson(
        _CreateMealByTextRequestDto instance) =>
    <String, dynamic>{
      'foodTextInput': instance.foodTextInput,
      'eatenAt': instance.eatenAt,
      'mealGroupId': instance.mealGroupId,
      'judgedGrade': instance.judgedGrade,
    };

_UpdateMealMemoRequestDto _$UpdateMealMemoRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _UpdateMealMemoRequestDto(
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$UpdateMealMemoRequestDtoToJson(
        _UpdateMealMemoRequestDto instance) =>
    <String, dynamic>{
      'memo': instance.memo,
    };
