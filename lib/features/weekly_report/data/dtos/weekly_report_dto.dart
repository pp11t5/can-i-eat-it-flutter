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
      );
}
