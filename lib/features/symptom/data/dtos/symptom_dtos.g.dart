// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SymptomLinkedFoodDto _$SymptomLinkedFoodDtoFromJson(
        Map<String, dynamic> json) =>
    _SymptomLinkedFoodDto(
      mealFoodId: json['mealFoodId'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$SymptomLinkedFoodDtoToJson(
        _SymptomLinkedFoodDto instance) =>
    <String, dynamic>{
      'mealFoodId': instance.mealFoodId,
      'name': instance.name,
      'category': instance.category,
    };

_SymptomLinkedMealDto _$SymptomLinkedMealDtoFromJson(
        Map<String, dynamic> json) =>
    _SymptomLinkedMealDto(
      mealRecordId: json['mealRecordId'] as String,
      foods: (json['foods'] as List<dynamic>?)
              ?.map((e) =>
                  SymptomLinkedFoodDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SymptomLinkedFoodDto>[],
    );

Map<String, dynamic> _$SymptomLinkedMealDtoToJson(
        _SymptomLinkedMealDto instance) =>
    <String, dynamic>{
      'mealRecordId': instance.mealRecordId,
      'foods': instance.foods,
    };

_SymptomAnalysisItemDto _$SymptomAnalysisItemDtoFromJson(
        Map<String, dynamic> json) =>
    _SymptomAnalysisItemDto(
      emphasis: json['emphasis'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$SymptomAnalysisItemDtoToJson(
        _SymptomAnalysisItemDto instance) =>
    <String, dynamic>{
      'emphasis': instance.emphasis,
      'body': instance.body,
    };

_SymptomAnalysisDto _$SymptomAnalysisDtoFromJson(Map<String, dynamic> json) =>
    _SymptomAnalysisDto(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  SymptomAnalysisItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SymptomAnalysisItemDto>[],
    );

Map<String, dynamic> _$SymptomAnalysisDtoToJson(_SymptomAnalysisDto instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

_SymptomResponseDto _$SymptomResponseDtoFromJson(Map<String, dynamic> json) =>
    _SymptomResponseDto(
      symptomId: json['symptomId'] as String,
      symptomState: json['symptomState'] as String,
      stateTitle: json['stateTitle'] as String,
      symptomTypes: (json['symptomTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      occurredAt: json['occurredAt'] as String,
      linkedMeal: json['linkedMeal'] == null
          ? null
          : SymptomLinkedMealDto.fromJson(
              json['linkedMeal'] as Map<String, dynamic>),
      analysis: json['analysis'] == null
          ? null
          : SymptomAnalysisDto.fromJson(
              json['analysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SymptomResponseDtoToJson(_SymptomResponseDto instance) =>
    <String, dynamic>{
      'symptomId': instance.symptomId,
      'symptomState': instance.symptomState,
      'stateTitle': instance.stateTitle,
      'symptomTypes': instance.symptomTypes,
      'occurredAt': instance.occurredAt,
      'linkedMeal': instance.linkedMeal,
      'analysis': instance.analysis,
    };

_SymptomCreateRequestDto _$SymptomCreateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _SymptomCreateRequestDto(
      symptomState: json['symptomState'] as String,
      symptomTypes: (json['symptomTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      occurredAt: json['occurredAt'] as String?,
      mealRecordId: json['mealRecordId'] as String,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$SymptomCreateRequestDtoToJson(
        _SymptomCreateRequestDto instance) =>
    <String, dynamic>{
      'symptomState': instance.symptomState,
      'symptomTypes': instance.symptomTypes,
      'occurredAt': instance.occurredAt,
      'mealRecordId': instance.mealRecordId,
      'memo': instance.memo,
    };

_SymptomUpdateRequestDto _$SymptomUpdateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _SymptomUpdateRequestDto(
      symptomState: json['symptomState'] as String,
      symptomTypes: (json['symptomTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      occurredAt: json['occurredAt'] as String,
      mealRecordId: json['mealRecordId'] as String,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$SymptomUpdateRequestDtoToJson(
        _SymptomUpdateRequestDto instance) =>
    <String, dynamic>{
      'symptomState': instance.symptomState,
      'symptomTypes': instance.symptomTypes,
      'occurredAt': instance.occurredAt,
      'mealRecordId': instance.mealRecordId,
      'memo': instance.memo,
    };

_SymptomMemoUpdateRequestDto _$SymptomMemoUpdateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _SymptomMemoUpdateRequestDto(
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$SymptomMemoUpdateRequestDtoToJson(
        _SymptomMemoUpdateRequestDto instance) =>
    <String, dynamic>{
      'memo': instance.memo,
    };
