// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingRequestDto _$OnboardingRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _OnboardingRequestDto(
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      symptomFrequency: (json['symptomFrequency'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      diagnosed: json['diagnosed'] as bool? ?? false,
      triggers: (json['triggers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$OnboardingRequestDtoToJson(
        _OnboardingRequestDto instance) =>
    <String, dynamic>{
      'symptoms': instance.symptoms,
      'symptomFrequency': instance.symptomFrequency,
      'diagnosed': instance.diagnosed,
      'triggers': instance.triggers,
      'medications': instance.medications,
      'allergens': instance.allergens,
    };
