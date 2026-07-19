// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TermResponseDto _$TermResponseDtoFromJson(Map<String, dynamic> json) =>
    _TermResponseDto(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      version: json['version'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      isRequired: json['required'] as bool,
      effectiveDate: json['effectiveDate'] as String?,
    );

Map<String, dynamic> _$TermResponseDtoToJson(_TermResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'version': instance.version,
      'title': instance.title,
      'content': instance.content,
      'required': instance.isRequired,
      'effectiveDate': instance.effectiveDate,
    };
