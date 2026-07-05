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

_WeeklyReportDto _$WeeklyReportDtoFromJson(Map<String, dynamic> json) =>
    _WeeklyReportDto(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      weekLabel: json['weekLabel'] as String,
      comfortableState: ComfortableStateDto.fromJson(
          json['comfortableState'] as Map<String, dynamic>),
      mealCount:
          MealCountDto.fromJson(json['mealCount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeeklyReportDtoToJson(_WeeklyReportDto instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'weekLabel': instance.weekLabel,
      'comfortableState': instance.comfortableState,
      'mealCount': instance.mealCount,
    };
