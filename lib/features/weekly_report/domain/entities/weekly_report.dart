import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_report.freezed.dart';

// ---------------------------------------------------------------------------
// WeeklyReport — 주간 리포트 (마이페이지)
// ---------------------------------------------------------------------------

/// 주간 리포트 엔티티 (GET /my-page/reports 대응).
///
/// 도넛 분포(권장/주의/위험 식사 수)와 연속 편안 스트릭을 담는다.
/// 증상 시간대·트리거 후보는 백엔드 변경 예정으로 미포함 (seam 필요 시 추가).
@freezed
abstract class WeeklyReport with _$WeeklyReport {
  const factory WeeklyReport({
    /// 리포트 시작일 (서버 원문 문자열, 'YYYY-MM-DD').
    required String startDate,

    /// 리포트 종료일 (서버 원문 문자열, 'YYYY-MM-DD').
    required String endDate,

    /// 주차 표시 라벨 (예: '이번 주').
    required String weekLabel,

    /// 연속 편안 상태.
    required ComfortableState comfortableState,

    /// 도넛 분포용 식사 판정 카운트.
    required MealCount mealCount,
  }) = _WeeklyReport;
}

// ---------------------------------------------------------------------------
// ComfortableState — 연속 편안 스트릭
// ---------------------------------------------------------------------------

/// 연속 편안 상태 엔티티.
@freezed
abstract class ComfortableState with _$ComfortableState {
  const factory ComfortableState({
    /// 연속 편안 일수(스트릭).
    required int streakCount,

    /// 권장 식사 수.
    required int recommendedMealCount,

    /// 편안 비율(%).
    required double percentage,
  }) = _ComfortableState;
}

// ---------------------------------------------------------------------------
// MealCount — 도넛 분포 카운트
// ---------------------------------------------------------------------------

/// 식사 판정 카운트 엔티티 (도넛 분포).
@freezed
abstract class MealCount with _$MealCount {
  const factory MealCount({
    /// 권장 식사 수.
    required int recommendCount,

    /// 주의 식사 수.
    required int cautionCount,

    /// 위험 식사 수.
    required int riskCount,

    /// 확인 어려움 식사 수. 기존 생성자·목·골든 보호 위해 @Default(0)(required 금지).
    @Default(0) int unknownCount,
  }) = _MealCount;
}
