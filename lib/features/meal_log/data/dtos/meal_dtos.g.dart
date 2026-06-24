// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalysisSectionDto _$AnalysisSectionDtoFromJson(Map<String, dynamic> json) =>
    _AnalysisSectionDto(
      ment: json['ment'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$AnalysisSectionDtoToJson(_AnalysisSectionDto instance) =>
    <String, dynamic>{
      'ment': instance.ment,
      'content': instance.content,
    };

_MealAnalysisDto _$MealAnalysisDtoFromJson(Map<String, dynamic> json) =>
    _MealAnalysisDto(
      judgmentGrade: json['judgmentGrade'] as String,
      triggerAnalysis: json['triggerAnalysis'] == null
          ? null
          : AnalysisSectionDto.fromJson(
              json['triggerAnalysis'] as Map<String, dynamic>),
      allergyAnalysis: json['allergyAnalysis'] == null
          ? null
          : AnalysisSectionDto.fromJson(
              json['allergyAnalysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MealAnalysisDtoToJson(_MealAnalysisDto instance) =>
    <String, dynamic>{
      'judgmentGrade': instance.judgmentGrade,
      'triggerAnalysis': instance.triggerAnalysis,
      'allergyAnalysis': instance.allergyAnalysis,
    };

_StateRecordDto _$StateRecordDtoFromJson(Map<String, dynamic> json) =>
    _StateRecordDto(
      stateRecordId: json['stateRecordId'] as String,
      label: json['label'] as String,
      date: json['date'] as String,
      timingMinutes: (json['timingMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$StateRecordDtoToJson(_StateRecordDto instance) =>
    <String, dynamic>{
      'stateRecordId': instance.stateRecordId,
      'label': instance.label,
      'date': instance.date,
      'timingMinutes': instance.timingMinutes,
    };

_MealFoodNestedDto _$MealFoodNestedDtoFromJson(Map<String, dynamic> json) =>
    _MealFoodNestedDto(
      mealRecordExternalId: json['mealRecordExternalId'] as String?,
      name: json['name'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$MealFoodNestedDtoToJson(_MealFoodNestedDto instance) =>
    <String, dynamic>{
      'mealRecordExternalId': instance.mealRecordExternalId,
      'name': instance.name,
      'category': instance.category,
    };

_MealFoodRecordDetailDto _$MealFoodRecordDetailDtoFromJson(
        Map<String, dynamic> json) =>
    _MealFoodRecordDetailDto(
      mealFoodId: json['mealFoodId'] as String,
      eatenAt: json['eatenAt'] as String,
      food: MealFoodNestedDto.fromJson(json['food'] as Map<String, dynamic>),
      analysis: json['analysis'] == null
          ? null
          : MealAnalysisDto.fromJson(json['analysis'] as Map<String, dynamic>),
      stateRecord: json['stateRecord'] == null
          ? null
          : StateRecordDto.fromJson(
              json['stateRecord'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MealFoodRecordDetailDtoToJson(
        _MealFoodRecordDetailDto instance) =>
    <String, dynamic>{
      'mealFoodId': instance.mealFoodId,
      'eatenAt': instance.eatenAt,
      'food': instance.food,
      'analysis': instance.analysis,
      'stateRecord': instance.stateRecord,
    };

_MealDetailFoodDto _$MealDetailFoodDtoFromJson(Map<String, dynamic> json) =>
    _MealDetailFoodDto(
      mealFoodId: json['mealFoodId'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      eatenAt: json['eatenAt'] as String,
    );

Map<String, dynamic> _$MealDetailFoodDtoToJson(_MealDetailFoodDto instance) =>
    <String, dynamic>{
      'mealFoodId': instance.mealFoodId,
      'name': instance.name,
      'category': instance.category,
      'eatenAt': instance.eatenAt,
    };

_MealRecordDetailDto _$MealRecordDetailDtoFromJson(Map<String, dynamic> json) =>
    _MealRecordDetailDto(
      mealRecordId: json['mealRecordId'] as String,
      eatenAt: json['eatenAt'] as String,
      meals: (json['meals'] as List<dynamic>?)
              ?.map(
                  (e) => MealDetailFoodDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MealDetailFoodDto>[],
      stateRecords: (json['stateRecords'] as List<dynamic>?)
          ?.map((e) => StateRecordDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealRecordDetailDtoToJson(
        _MealRecordDetailDto instance) =>
    <String, dynamic>{
      'mealRecordId': instance.mealRecordId,
      'eatenAt': instance.eatenAt,
      'meals': instance.meals,
      'stateRecords': instance.stateRecords,
    };

_WeeklyDayDto _$WeeklyDayDtoFromJson(Map<String, dynamic> json) =>
    _WeeklyDayDto(
      date: json['date'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      judgementList: (json['judgementList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$WeeklyDayDtoToJson(_WeeklyDayDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'dayOfWeek': instance.dayOfWeek,
      'judgementList': instance.judgementList,
    };

_MealCandidateDto _$MealCandidateDtoFromJson(Map<String, dynamic> json) =>
    _MealCandidateDto(
      mealRecordId: json['mealRecordId'] as String,
      representativeFood: MealFoodNestedDto.fromJson(
          json['representativeFood'] as Map<String, dynamic>),
      otherFoodCount: (json['otherFoodCount'] as num?)?.toInt() ?? 0,
      eatenAt: json['eatenAt'] as String,
    );

Map<String, dynamic> _$MealCandidateDtoToJson(_MealCandidateDto instance) =>
    <String, dynamic>{
      'mealRecordId': instance.mealRecordId,
      'representativeFood': instance.representativeFood,
      'otherFoodCount': instance.otherFoodCount,
      'eatenAt': instance.eatenAt,
    };

_MealCandidatesDayDto _$MealCandidatesDayDtoFromJson(
        Map<String, dynamic> json) =>
    _MealCandidatesDayDto(
      date: json['date'] as String,
      meals: (json['meals'] as List<dynamic>?)
              ?.map((e) => MealCandidateDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MealCandidateDto>[],
    );

Map<String, dynamic> _$MealCandidatesDayDtoToJson(
        _MealCandidatesDayDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'meals': instance.meals,
    };

_CreateMealRecordRequestDto _$CreateMealRecordRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _CreateMealRecordRequestDto(
      foodExternalId: json['foodExternalId'] as String,
      eatenAt: json['eatenAt'] as String?,
      mealRecordId: json['mealRecordId'] as String?,
    );

Map<String, dynamic> _$CreateMealRecordRequestDtoToJson(
        _CreateMealRecordRequestDto instance) =>
    <String, dynamic>{
      'foodExternalId': instance.foodExternalId,
      'eatenAt': instance.eatenAt,
      'mealRecordId': instance.mealRecordId,
    };
