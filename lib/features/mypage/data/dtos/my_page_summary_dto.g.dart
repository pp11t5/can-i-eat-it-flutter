// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_page_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyPageProfileSummaryDto _$MyPageProfileSummaryDtoFromJson(
        Map<String, dynamic> json) =>
    _MyPageProfileSummaryDto(
      nickName: json['nickName'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      disease: json['disease'] as String? ?? '',
    );

Map<String, dynamic> _$MyPageProfileSummaryDtoToJson(
        _MyPageProfileSummaryDto instance) =>
    <String, dynamic>{
      'nickName': instance.nickName,
      'profileImage': instance.profileImage,
      'disease': instance.disease,
    };

_FoodHistorySummaryDto _$FoodHistorySummaryDtoFromJson(
        Map<String, dynamic> json) =>
    _FoodHistorySummaryDto(
      safeCount: (json['safeCount'] as num?)?.toInt() ?? 0,
      cautionCount: (json['cautionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FoodHistorySummaryDtoToJson(
        _FoodHistorySummaryDto instance) =>
    <String, dynamic>{
      'safeCount': instance.safeCount,
      'cautionCount': instance.cautionCount,
    };

_WeeklySummaryDto _$WeeklySummaryDtoFromJson(Map<String, dynamic> json) =>
    _WeeklySummaryDto(
      mealRecordCount: (json['mealRecordCount'] as num?)?.toInt() ?? 0,
      recentSymptomCount: (json['recentSymptomCount'] as num?)?.toInt() ?? 0,
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      mealCount: json['mealCount'] == null
          ? const MealCountDto()
          : MealCountDto.fromJson(json['mealCount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeeklySummaryDtoToJson(_WeeklySummaryDto instance) =>
    <String, dynamic>{
      'mealRecordCount': instance.mealRecordCount,
      'recentSymptomCount': instance.recentSymptomCount,
      'streakCount': instance.streakCount,
      'mealCount': instance.mealCount,
    };

_MyPageSummaryDto _$MyPageSummaryDtoFromJson(Map<String, dynamic> json) =>
    _MyPageSummaryDto(
      profile: json['profile'] == null
          ? null
          : MyPageProfileSummaryDto.fromJson(
              json['profile'] as Map<String, dynamic>),
      foodHistory: json['foodHistory'] == null
          ? null
          : FoodHistorySummaryDto.fromJson(
              json['foodHistory'] as Map<String, dynamic>),
      weeklySummary: json['weeklySummary'] == null
          ? null
          : WeeklySummaryDto.fromJson(
              json['weeklySummary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyPageSummaryDtoToJson(_MyPageSummaryDto instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'foodHistory': instance.foodHistory,
      'weeklySummary': instance.weeklySummary,
    };
