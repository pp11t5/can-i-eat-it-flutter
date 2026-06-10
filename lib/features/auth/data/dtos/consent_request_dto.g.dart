// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsentRequestDto _$ConsentRequestDtoFromJson(Map<String, dynamic> json) =>
    _ConsentRequestDto(
      tos: json['tos'] as bool,
      privacy: json['privacy'] as bool,
      healthSensitive: json['healthSensitive'] as bool,
      marketing: json['marketing'] as bool,
    );

Map<String, dynamic> _$ConsentRequestDtoToJson(_ConsentRequestDto instance) =>
    <String, dynamic>{
      'tos': instance.tos,
      'privacy': instance.privacy,
      'healthSensitive': instance.healthSensitive,
      'marketing': instance.marketing,
    };
