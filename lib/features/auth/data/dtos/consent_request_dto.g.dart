// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsentItemDto _$ConsentItemDtoFromJson(Map<String, dynamic> json) =>
    _ConsentItemDto(
      termId: (json['termId'] as num).toInt(),
      agreed: json['agreed'] as bool,
    );

Map<String, dynamic> _$ConsentItemDtoToJson(_ConsentItemDto instance) =>
    <String, dynamic>{
      'termId': instance.termId,
      'agreed': instance.agreed,
    };

_ConsentRequestDto _$ConsentRequestDtoFromJson(Map<String, dynamic> json) =>
    _ConsentRequestDto(
      consents: (json['consents'] as List<dynamic>)
          .map((e) => ConsentItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConsentRequestDtoToJson(_ConsentRequestDto instance) =>
    <String, dynamic>{
      'consents': instance.consents,
    };
