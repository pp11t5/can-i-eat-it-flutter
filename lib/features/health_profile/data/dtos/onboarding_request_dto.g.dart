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
      triggers: (json['triggers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      customTriggerText: json['customTriggerText'] as String?,
    );

Map<String, dynamic> _$OnboardingRequestDtoToJson(
        _OnboardingRequestDto instance) =>
    <String, dynamic>{
      'symptoms': instance.symptoms,
      'triggers': instance.triggers,
      'allergens': instance.allergens,
      'medications': instance.medications,
      'customTriggerText': instance.customTriggerText,
    };
