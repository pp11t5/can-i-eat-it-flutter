// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthProfileDto _$HealthProfileDtoFromJson(Map<String, dynamic> json) =>
    _HealthProfileDto(
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      symptomFrequency: (json['symptom_frequency'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      diagnosed: json['diagnosed'] as bool? ?? false,
      triggerFoods: (json['trigger_foods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      customTriggers: json['custom_triggers'] as String?,
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$HealthProfileDtoToJson(_HealthProfileDto instance) =>
    <String, dynamic>{
      'conditions': instance.conditions,
      'symptom_frequency': instance.symptomFrequency,
      'diagnosed': instance.diagnosed,
      'trigger_foods': instance.triggerFoods,
      'custom_triggers': instance.customTriggers,
      'medications': instance.medications,
      'allergies': instance.allergies,
    };
