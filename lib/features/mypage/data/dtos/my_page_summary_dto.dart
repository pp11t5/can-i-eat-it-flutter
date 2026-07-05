import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';
import 'package:can_i_eat_it/features/weekly_report/data/dtos/weekly_report_dto.dart';

part 'my_page_summary_dto.freezed.dart';
part 'my_page_summary_dto.g.dart';

// ---------------------------------------------------------------------------
// MyPageProfileSummaryDto — GET /my-page/summary result.profile
// ---------------------------------------------------------------------------

/// 마이페이지 요약 프로필 DTO (GET /my-page/summary result.profile 대응).
@freezed
abstract class MyPageProfileSummaryDto with _$MyPageProfileSummaryDto {
  const factory MyPageProfileSummaryDto({
    @Default('') String nickName,
    String? profileImage,
    @Default('') String disease,
  }) = _MyPageProfileSummaryDto;

  factory MyPageProfileSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MyPageProfileSummaryDtoFromJson(json);
}

extension MyPageProfileSummaryDtoMapper on MyPageProfileSummaryDto {
  MyPageProfileSummary toEntity() => MyPageProfileSummary(
        nickName: nickName,
        profileImage: profileImage,
        disease: MyPageDiseaseMapper.fromServer(disease),
      );
}

// ---------------------------------------------------------------------------
// FoodHistorySummaryDto — GET /my-page/summary result.foodHistory
// ---------------------------------------------------------------------------

/// 내 음식 히스토리 요약 DTO (GET /my-page/summary result.foodHistory 대응).
@freezed
abstract class FoodHistorySummaryDto with _$FoodHistorySummaryDto {
  const factory FoodHistorySummaryDto({
    @Default(0) int safeCount,
    @Default(0) int cautionCount,
  }) = _FoodHistorySummaryDto;

  factory FoodHistorySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodHistorySummaryDtoFromJson(json);
}

extension FoodHistorySummaryDtoMapper on FoodHistorySummaryDto {
  FoodHistorySummary toEntity() => FoodHistorySummary(
        safeCount: safeCount,
        cautionCount: cautionCount,
      );
}

// ---------------------------------------------------------------------------
// WeeklySummaryDto — GET /my-page/summary result.weeklySummary
// ---------------------------------------------------------------------------

/// 주간 기록 요약 DTO (GET /my-page/summary result.weeklySummary 대응).
///
/// [mealCount]는 weekly_report 데이터레이어의 [MealCountDto]를 재사용한다.
@freezed
abstract class WeeklySummaryDto with _$WeeklySummaryDto {
  const factory WeeklySummaryDto({
    @Default(0) int mealRecordCount,
    @Default(0) int recentSymptomCount,
    @Default(0) int streakCount,
    @Default(MealCountDto()) MealCountDto mealCount,
  }) = _WeeklySummaryDto;

  factory WeeklySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryDtoFromJson(json);
}

extension WeeklySummaryDtoMapper on WeeklySummaryDto {
  WeeklySummary toEntity() => WeeklySummary(
        mealRecordCount: mealRecordCount,
        recentSymptomCount: recentSymptomCount,
        streakCount: streakCount,
        mealCount: mealCount.toEntity(),
      );
}

// ---------------------------------------------------------------------------
// MyPageSummaryDto — GET /my-page/summary
// ---------------------------------------------------------------------------

/// 마이페이지 요약 DTO (GET /my-page/summary result 대응).
@freezed
abstract class MyPageSummaryDto with _$MyPageSummaryDto {
  const factory MyPageSummaryDto({
    required MyPageProfileSummaryDto profile,
    required FoodHistorySummaryDto foodHistory,
    required WeeklySummaryDto weeklySummary,
  }) = _MyPageSummaryDto;

  factory MyPageSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MyPageSummaryDtoFromJson(json);
}

extension MyPageSummaryDtoMapper on MyPageSummaryDto {
  MyPageSummary toEntity() => MyPageSummary(
        profile: profile.toEntity(),
        foodHistory: foodHistory.toEntity(),
        weeklySummary: weeklySummary.toEntity(),
      );
}
