// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComfortableStateDto _$ComfortableStateDtoFromJson(Map<String, dynamic> json) =>
    _ComfortableStateDto(
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      recommendedMealCount:
          (json['recommendedMealCount'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ComfortableStateDtoToJson(
        _ComfortableStateDto instance) =>
    <String, dynamic>{
      'streakCount': instance.streakCount,
      'recommendedMealCount': instance.recommendedMealCount,
      'percentage': instance.percentage,
    };

_MealCountDto _$MealCountDtoFromJson(Map<String, dynamic> json) =>
    _MealCountDto(
      recommendCount: (json['recommendCount'] as num?)?.toInt() ?? 0,
      cautionCount: (json['cautionCount'] as num?)?.toInt() ?? 0,
      riskCount: (json['riskCount'] as num?)?.toInt() ?? 0,
      unknownCount: (json['unknownCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MealCountDtoToJson(_MealCountDto instance) =>
    <String, dynamic>{
      'recommendCount': instance.recommendCount,
      'cautionCount': instance.cautionCount,
      'riskCount': instance.riskCount,
      'unknownCount': instance.unknownCount,
    };

_SymptomTypeCountDto _$SymptomTypeCountDtoFromJson(Map<String, dynamic> json) =>
    _SymptomTypeCountDto(
      type: json['type'] as String? ?? '',
      label: json['label'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SymptomTypeCountDtoToJson(
        _SymptomTypeCountDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'count': instance.count,
    };

_SymptomReportDto _$SymptomReportDtoFromJson(Map<String, dynamic> json) =>
    _SymptomReportDto(
      recordedCount: (json['recordedCount'] as num?)?.toInt() ?? 0,
      averageTimeLabel: json['averageTimeLabel'] as String?,
      averageIntensity: (json['averageIntensity'] as num?)?.toInt(),
      typeCounts: (json['typeCounts'] as List<dynamic>?)
              ?.map((e) =>
                  SymptomTypeCountDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SymptomReportDtoToJson(_SymptomReportDto instance) =>
    <String, dynamic>{
      'recordedCount': instance.recordedCount,
      'averageTimeLabel': instance.averageTimeLabel,
      'averageIntensity': instance.averageIntensity,
      'typeCounts': instance.typeCounts,
    };

_WeeklyReportDto _$WeeklyReportDtoFromJson(Map<String, dynamic> json) =>
    _WeeklyReportDto(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      weekLabel: json['weekLabel'] as String,
      comfortableState: ComfortableStateDto.fromJson(
          json['comfortableState'] as Map<String, dynamic>),
      mealCount:
          MealCountDto.fromJson(json['mealCount'] as Map<String, dynamic>),
      symptomReport: json['symptomReport'] == null
          ? null
          : SymptomReportDto.fromJson(
              json['symptomReport'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeeklyReportDtoToJson(_WeeklyReportDto instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'weekLabel': instance.weekLabel,
      'comfortableState': instance.comfortableState,
      'mealCount': instance.mealCount,
      'symptomReport': instance.symptomReport,
    };
