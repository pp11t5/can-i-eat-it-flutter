import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

part 'my_page_summary.freezed.dart';

// ---------------------------------------------------------------------------
// MyPageSummary — GET /my-page/summary (홈·마이 실데이터)
// ---------------------------------------------------------------------------

/// 마이페이지 요약 엔티티 (GET /my-page/summary 대응).
///
/// 홈 화면(인사말 streak·미기록 배지)과 마이페이지(음식 히스토리·주간 기록 카드)가
/// 공유 구독한다.
@freezed
abstract class MyPageSummary with _$MyPageSummary {
  const factory MyPageSummary({
    required MyPageProfileSummary profile,
    required FoodHistorySummary foodHistory,
    required WeeklySummary weeklySummary,
  }) = _MyPageSummary;
}

// ---------------------------------------------------------------------------
// MyPageProfileSummary — profile
// ---------------------------------------------------------------------------

/// 질환 코드. 서버 4종(gerd|gastritis_ulcer|ibs|functional_dyspepsia)과 1:1 정합.
///
/// [unknown]은 미지 서버 값 폴백 (신규 질환 추가 시 앱이 죽지 않도록 하는 안전 기본값).
enum MyPageDisease { gerd, gastritisUlcer, ibs, functionalDyspepsia, unknown }

/// [MyPageDisease] 서버 변환 확장.
extension MyPageDiseaseMapper on MyPageDisease {
  /// 서버 [v] 문자열을 [MyPageDisease] 로 변환한다. 미지 값은 [MyPageDisease.unknown].
  static MyPageDisease fromServer(String v) => switch (v) {
        'gerd' => MyPageDisease.gerd,
        'gastritis_ulcer' => MyPageDisease.gastritisUlcer,
        'ibs' => MyPageDisease.ibs,
        'functional_dyspepsia' => MyPageDisease.functionalDyspepsia,
        _ => MyPageDisease.unknown,
      };
}

/// 마이페이지 요약 프로필 엔티티.
@freezed
abstract class MyPageProfileSummary with _$MyPageProfileSummary {
  const factory MyPageProfileSummary({
    required String nickName,
    String? profileImage,
    required MyPageDisease disease,
  }) = _MyPageProfileSummary;
}

// ---------------------------------------------------------------------------
// FoodHistorySummary — foodHistory
// ---------------------------------------------------------------------------

/// 내 음식 히스토리 요약 엔티티 (마이페이지 카드).
@freezed
abstract class FoodHistorySummary with _$FoodHistorySummary {
  const factory FoodHistorySummary({
    @Default(0) int safeCount,
    @Default(0) int cautionCount,
  }) = _FoodHistorySummary;
}

// ---------------------------------------------------------------------------
// WeeklySummary — weeklySummary
// ---------------------------------------------------------------------------

/// 주간 기록 요약 엔티티 (마이페이지 주간 기록 카드 + 홈 인사말 streak).
///
/// [mealCount]는 weekly_report 도메인의 [MealCount] 엔티티를 재사용한다
/// (unknownCount 포함, 중복 정의 금지).
@freezed
abstract class WeeklySummary with _$WeeklySummary {
  const factory WeeklySummary({
    @Default(0) int mealRecordCount,
    @Default(0) int recentSymptomCount,
    @Default(0) int streakCount,
    required MealCount mealCount,
  }) = _WeeklySummary;
}
