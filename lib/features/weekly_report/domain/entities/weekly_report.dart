import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_report.freezed.dart';

// ---------------------------------------------------------------------------
// WeeklyReport — 주간 리포트 (마이페이지)
// ---------------------------------------------------------------------------

/// 주간 리포트 엔티티 (GET /my-page/reports 대응).
///
/// 도넛 분포(권장/주의/위험 식사 수)와 연속 편안 스트릭을 담는다.
/// 증상 집계는 서버 응답에 아직 없어 nullable seam으로 둔다(필드 추가 시 자동 점등).
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

    /// 기록된 증상 집계. 서버 응답에 필드가 없으면 null(빈상태로 렌더).
    SymptomReport? symptomReport,
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

// ---------------------------------------------------------------------------
// SymptomReport — 기록된 증상 카드 (Figma node 2523:14131)
// ---------------------------------------------------------------------------

/// 기록된 증상 집계 엔티티 (Swagger `recordedSymptom` 대응, A3 정합).
///
/// 서버는 증상 종류별 카운트를 배열이 아닌 4개 고정 필드로 내려준다
/// ([throatForeignBodyCount]/[acidRefluxCount]/[coughCount]/[chestTightnessCount]).
/// [typeCounts]는 막대 그래프 렌더링(화면 소비부) 호환을 위해 이 4개 필드로부터
/// 계산되는 getter다.
@freezed
abstract class SymptomReport with _$SymptomReport {
  const factory SymptomReport({
    /// 이번 주 증상 기록 총 횟수 (서버 `symptomCount`).
    required int symptomCount,

    /// 평균 기록 시간 라벨 (서버 `averageTime`, 예: '16:30'). 값 없으면 pill 미노출.
    String? averageTime,

    /// 평균 강도 (서버 `averageLevel`). 값 없으면 pill 미노출.
    int? averageLevel,

    /// 이물감 기록 횟수 (서버 `throatForeignBodyCount`).
    @Default(0) int throatForeignBodyCount,

    /// 신물 기록 횟수 (서버 `acidRefluxCount`).
    @Default(0) int acidRefluxCount,

    /// 기침 기록 횟수 (서버 `coughCount`).
    @Default(0) int coughCount,

    /// 답답함 기록 횟수 (서버 `chestTightnessCount`).
    @Default(0) int chestTightnessCount,
  }) = _SymptomReport;

  const SymptomReport._();

  /// 증상 종류별 카운트 (막대 그래프용). 서버가 4개 고정 카운트 필드로 내려주므로
  /// 화면 소비부(막대 렌더링) 호환을 위해 여기서 [SymptomTypeCount] 리스트로 구성한다.
  List<SymptomTypeCount> get typeCounts => [
        SymptomTypeCount(
          type: 'throat_foreign_body',
          label: '이물감',
          count: throatForeignBodyCount,
        ),
        SymptomTypeCount(
          type: 'acid_reflux',
          label: '신물',
          count: acidRefluxCount,
        ),
        SymptomTypeCount(type: 'cough', label: '기침', count: coughCount),
        SymptomTypeCount(
          type: 'chest_tightness',
          label: '답답함',
          count: chestTightnessCount,
        ),
      ];
}

// ---------------------------------------------------------------------------
// SymptomTypeCount — 증상 종류별 카운트 (막대 1열)
// ---------------------------------------------------------------------------

/// 증상 종류별 카운트 엔티티.
@freezed
abstract class SymptomTypeCount with _$SymptomTypeCount {
  const factory SymptomTypeCount({
    /// 서버 원문 증상 종류 코드 (예: 'throat_foreign_body').
    required String type,

    /// 화면 표시 라벨 (예: '이물감').
    required String label,

    /// 해당 종류 기록 횟수.
    required int count,
  }) = _SymptomTypeCount;
}
