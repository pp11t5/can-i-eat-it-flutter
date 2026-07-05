// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_symptom_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodSymptomDto _$FoodSymptomDtoFromJson(Map<String, dynamic> json) =>
    _FoodSymptomDto(
      symptomId: json['symptomId'] as String,
      symptomState: json['symptomState'] as String,
      symptomTypes: (json['symptomTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      occurredAt: json['occurredAt'] as String,
      mealRecordId: json['mealRecordId'] as String,
      afterMealMinutes: (json['afterMealMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FoodSymptomDtoToJson(_FoodSymptomDto instance) =>
    <String, dynamic>{
      'symptomId': instance.symptomId,
      'symptomState': instance.symptomState,
      'symptomTypes': instance.symptomTypes,
      'occurredAt': instance.occurredAt,
      'mealRecordId': instance.mealRecordId,
      'afterMealMinutes': instance.afterMealMinutes,
    };
