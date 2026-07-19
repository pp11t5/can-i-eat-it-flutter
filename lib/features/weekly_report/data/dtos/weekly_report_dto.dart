// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

part 'weekly_report_dto.freezed.dart';
part 'weekly_report_dto.g.dart';

// ---------------------------------------------------------------------------
// ComfortableStateDto — GET /my-page/reports comfortableState
// ---------------------------------------------------------------------------

/// 연속 편안 상태 DTO (GET /my-page/reports result.comfortableState 대응).
@freezed
abstract class ComfortableStateDto with _$ComfortableStateDto {
  const factory ComfortableStateDto({
    @Default(0) int streakCount,
    @Default(0) int recommendedMealCount,
    @Default(0) double percentage,
  }) = _ComfortableStateDto;

  factory ComfortableStateDto.fromJson(Map<String, dynamic> json) =>
      _$ComfortableStateDtoFromJson(json);
}

extension ComfortableStateDtoMapper on ComfortableStateDto {
  ComfortableState toEntity() => ComfortableState(
        streakCount: streakCount,
        recommendedMealCount: recommendedMealCount,
        percentage: percentage,
      );
}

// ---------------------------------------------------------------------------
// MealCountDto — GET /my-page/reports mealCount
// ---------------------------------------------------------------------------

/// 식사 판정 카운트 DTO (GET /my-page/reports result.mealCount 대응).
@freezed
abstract class MealCountDto with _$MealCountDto {
  const factory MealCountDto({
    @Default(0) int recommendCount,
    @Default(0) int cautionCount,
    @Default(0) int riskCount,
    @Default(0) int unknownCount,
  }) = _MealCountDto;

  factory MealCountDto.fromJson(Map<String, dynamic> json) =>
      _$MealCountDtoFromJson(json);
}

extension MealCountDtoMapper on MealCountDto {
  MealCount toEntity() => MealCount(
        recommendCount: recommendCount,
        cautionCount: cautionCount,
        riskCount: riskCount,
        unknownCount: unknownCount,
      );
}

// ---------------------------------------------------------------------------
// SymptomReportDto — GET /my-page/reports recordedSymptom (A3 정합)
// ---------------------------------------------------------------------------

/// 기록된 증상 집계 DTO (GET /my-page/reports result.recordedSymptom 대응).
///
/// 서버가 항상 필드를 채워 보낸다고 가정할 수 없으므로 개별 필드를 전부
/// nullable/Default로 관대하게 파싱한다.
@freezed
abstract class SymptomReportDto with _$SymptomReportDto {
  const factory SymptomReportDto({
    @Default(0) int symptomCount,
    String? averageTime,
    int? averageLevel,
    @Default(0) int throatForeignBodyCount,
    @Default(0) int acidRefluxCount,
    @Default(0) int coughCount,
    @Default(0) int chestTightnessCount,
  }) = _SymptomReportDto;

  factory SymptomReportDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomReportDtoFromJson(json);
}

extension SymptomReportDtoMapper on SymptomReportDto {
  SymptomReport toEntity() => SymptomReport(
        symptomCount: symptomCount,
        averageTime: averageTime,
        averageLevel: averageLevel,
        throatForeignBodyCount: throatForeignBodyCount,
        acidRefluxCount: acidRefluxCount,
        coughCount: coughCount,
        chestTightnessCount: chestTightnessCount,
      );
}

// ---------------------------------------------------------------------------
// WeeklyReportDto — GET /my-page/reports
// ---------------------------------------------------------------------------

/// 주간 리포트 DTO (GET /my-page/reports result 대응).
@freezed
abstract class WeeklyReportDto with _$WeeklyReportDto {
  const factory WeeklyReportDto({
    required String startDate,
    required String endDate,
    required String weekLabel,
    required ComfortableStateDto comfortableState,
    required MealCountDto mealCount,

    /// 서버 필드명은 `recordedSymptom`(A3). 응답에 없으면 null —
    /// [SymptomReport] 빈상태로 렌더.
    @JsonKey(name: 'recordedSymptom') SymptomReportDto? symptomReport,
  }) = _WeeklyReportDto;

  factory WeeklyReportDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportDtoFromJson(json);
}

extension WeeklyReportDtoMapper on WeeklyReportDto {
  WeeklyReport toEntity() => WeeklyReport(
        startDate: startDate,
        endDate: endDate,
        weekLabel: weekLabel,
        comfortableState: comfortableState.toEntity(),
        mealCount: mealCount.toEntity(),
        symptomReport: symptomReport?.toEntity(),
      );
}
