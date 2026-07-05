// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicalInfoDto _$MedicalInfoDtoFromJson(Map<String, dynamic> json) =>
    _MedicalInfoDto(
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$MedicalInfoDtoToJson(_MedicalInfoDto instance) =>
    <String, dynamic>{
      'allergies': instance.allergies,
      'medications': instance.medications,
    };

_MedicalInfoUpdateRequestDto _$MedicalInfoUpdateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _MedicalInfoUpdateRequestDto(
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$MedicalInfoUpdateRequestDtoToJson(
        _MedicalInfoUpdateRequestDto instance) =>
    <String, dynamic>{
      'allergens': instance.allergens,
      'medications': instance.medications,
    };
