// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'judgment_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JudgmentItemDto _$JudgmentItemDtoFromJson(Map<String, dynamic> json) =>
    _JudgmentItemDto(
      emphasis: json['emphasis'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$JudgmentItemDtoToJson(_JudgmentItemDto instance) =>
    <String, dynamic>{
      'emphasis': instance.emphasis,
      'body': instance.body,
    };

_StateRecordDto _$StateRecordDtoFromJson(Map<String, dynamic> json) =>
    _StateRecordDto(
      label: json['label'] as String,
      date: json['date'] as String,
      timing: json['timing'] as String,
    );

Map<String, dynamic> _$StateRecordDtoToJson(_StateRecordDto instance) =>
    <String, dynamic>{
      'label': instance.label,
      'date': instance.date,
      'timing': instance.timing,
    };

_StateRecordsDto _$StateRecordsDtoFromJson(Map<String, dynamic> json) =>
    _StateRecordsDto(
      total: (json['total'] as num).toInt(),
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => StateRecordDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StateRecordDto>[],
    );

Map<String, dynamic> _$StateRecordsDtoToJson(_StateRecordsDto instance) =>
    <String, dynamic>{
      'total': instance.total,
      'records': instance.records,
    };

_SubstituteDto _$SubstituteDtoFromJson(Map<String, dynamic> json) =>
    _SubstituteDto(
      foodExternalId: json['foodExternalId'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SubstituteDtoToJson(_SubstituteDto instance) =>
    <String, dynamic>{
      'foodExternalId': instance.foodExternalId,
      'name': instance.name,
    };

_JudgmentResponseDto _$JudgmentResponseDtoFromJson(Map<String, dynamic> json) =>
    _JudgmentResponseDto(
      foodExternalId: json['foodExternalId'] as String,
      foodName: json['foodName'] as String,
      category: json['category'] as String?,
      grade: json['grade'] as String,
      personalTitle: json['personalTitle'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => JudgmentItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <JudgmentItemDto>[],
      stateRecords: json['stateRecords'] == null
          ? null
          : StateRecordsDto.fromJson(
              json['stateRecords'] as Map<String, dynamic>),
      substitutes: (json['substitutes'] as List<dynamic>?)
              ?.map((e) => SubstituteDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SubstituteDto>[],
    );

Map<String, dynamic> _$JudgmentResponseDtoToJson(
        _JudgmentResponseDto instance) =>
    <String, dynamic>{
      'foodExternalId': instance.foodExternalId,
      'foodName': instance.foodName,
      'category': instance.category,
      'grade': instance.grade,
      'personalTitle': instance.personalTitle,
      'items': instance.items,
      'stateRecords': instance.stateRecords,
      'substitutes': instance.substitutes,
    };

_TextJudgmentResponseDto _$TextJudgmentResponseDtoFromJson(
        Map<String, dynamic> json) =>
    _TextJudgmentResponseDto(
      foodName: json['foodName'] as String,
      grade: json['grade'] as String,
      personalTitle: json['personalTitle'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => JudgmentItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <JudgmentItemDto>[],
      stateRecords: json['stateRecords'] == null
          ? null
          : StateRecordsDto.fromJson(
              json['stateRecords'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextJudgmentResponseDtoToJson(
        _TextJudgmentResponseDto instance) =>
    <String, dynamic>{
      'foodName': instance.foodName,
      'grade': instance.grade,
      'personalTitle': instance.personalTitle,
      'items': instance.items,
      'stateRecords': instance.stateRecords,
    };
