// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eat_verdict_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EatVerdictDto _$EatVerdictDtoFromJson(Map<String, dynamic> json) =>
    _EatVerdictDto(
      level: json['level'] as String,
      reason: json['reason'] as String,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$EatVerdictDtoToJson(_EatVerdictDto instance) =>
    <String, dynamic>{
      'level': instance.level,
      'reason': instance.reason,
      'sources': instance.sources,
    };
