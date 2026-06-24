import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'meal_entities.freezed.dart';

// ---------------------------------------------------------------------------
// MealAnalysis — analysis 스냅샷
// ---------------------------------------------------------------------------

/// 음식별 분석 스냅샷 (POST/foodDetail 응답에서만).
///
/// 서버 `analysis.judgmentGrade` + `triggerAnalysis`/`allergyAnalysis`{ment,content}.
/// food_check의 [VerdictItem]{emphasis,body}와 의미는 같으나 키 이름이 다르므로
/// meal_log 전용 [AnalysisSection]을 둔다 (계약 드리프트 방지).
@freezed
abstract class MealAnalysis with _$MealAnalysis {
  const factory MealAnalysis({
    /// analysis.judgmentGrade (대문자 grade → fromGrade).
    required VerdictLevel judgmentGrade,

    /// analysis.triggerAnalysis. grade=UNKNOWN 등 누락 가능 → nullable.
    AnalysisSection? trigger,

    /// analysis.allergyAnalysis. 누락 가능 → nullable.
    AnalysisSection? allergy,
  }) = _MealAnalysis;
}

/// 분석 섹션 단건 (서버 {ment, content}).
@freezed
abstract class AnalysisSection with _$AnalysisSection {
  const factory AnalysisSection({
    /// 강조 문구.
    required String ment,

    /// 본문.
    required String content,
  }) = _AnalysisSection;
}

// ---------------------------------------------------------------------------
// StateRecord — 증상 섭취 기록 (증상레이어 공유)
// ---------------------------------------------------------------------------

/// 증상 섭취 기록 단건.
///
/// 식사상세/음식상세에서 표시되고, W5-2 증상레이어가 공유한다.
@freezed
abstract class StateRecord with _$StateRecord {
  const factory StateRecord({
    /// 서버 stateRecordId.
    required String stateRecordId,

    /// 증상 라벨 (예: '속쓰림').
    required String label,

    /// 기록 날짜 ('YYYY-MM-DD' 문자열 그대로).
    required String date,

    /// 식후 경과 분. "식후 N분" 포맷은 표시 레이어 책임.
    required int timingMinutes,
  }) = _StateRecord;
}

// ---------------------------------------------------------------------------
// MealFood — 음식 단위
// ---------------------------------------------------------------------------

/// 음식 단위 엔티티 (구 mealId 대체).
///
/// 타임라인 single 변형·group 내 음식·식사상세 내 음식·foodDetail 응답을 모두
/// 표현하는 단일 엔티티. [analysis]는 상세/POST 응답에서만 채워지므로 nullable.
@freezed
abstract class MealFood with _$MealFood {
  const factory MealFood({
    /// 음식 식별자 (구 mealId 대체).
    required String mealFoodId,

    /// 음식 표시 이름.
    required String name,

    /// 음식 카테고리. 서버가 없으면 null → FoodThumbnail 기본.
    String? category,

    /// 섭취 시각 (ISO-8601 문자열 그대로, 표시 전용).
    required String eatenAt,

    /// food.mealRecordExternalId (POST 응답에만 존재, append/재판정용).
    String? mealRecordExternalId,

    /// analysis. 상세·foodDetail·POST 응답에만. 타임라인/목록엔 null.
    MealAnalysis? analysis,
  }) = _MealFood;
}

// ---------------------------------------------------------------------------
// MealRecord — 식사 단위
// ---------------------------------------------------------------------------

/// 식사 단위 엔티티 (GET /meal-records/{id} 대응). 식사 = 음식들 + 상태기록들.
@freezed
abstract class MealRecord with _$MealRecord {
  const factory MealRecord({
    /// 식사 기록 식별자.
    required String mealRecordId,

    /// 식사 대표 섭취 시각 (ISO 그대로).
    required String eatenAt,

    /// 식사 내 음식 목록 (서버 meals[]). 각 음식의 analysis는 null.
    @Default(<MealFood>[]) List<MealFood> foods,

    /// 연관 상태기록 목록.
    @Default(<StateRecord>[]) List<StateRecord> stateRecords,
  }) = _MealRecord;
}

// ---------------------------------------------------------------------------
// TimelineItem — sealed union 3변형
// ---------------------------------------------------------------------------

/// 타임라인 항목 (GET /timeline?date= result.items[] 대응).
///
/// `timeLineType` 판별자로 single/group/symptom 분기. 자동 union JSON을 쓰지
/// 않고 DTO 레이어 수동 팩토리([TimelineItemDto])가 직렬화 책임을 진다.
@freezed
sealed class TimelineItem with _$TimelineItem {
  const TimelineItem._();

  /// single: 음식 1개짜리 식사.
  const factory TimelineItem.single({
    required String mealRecordId,
    required String mealRecordDateTime,
    required String mealFoodName,
    required VerdictLevel grade,
    @Default(0) int etcCount,
  }) = TimelineSingle;

  /// group: 음식 2개 이상짜리 식사.
  const factory TimelineItem.group({
    required String mealRecordId,
    required String mealRecordDateTime,
    @Default(<String>[]) List<String> representativeFoods,
    @Default(0) int etcCount,
  }) = TimelineGroup;

  /// symptom: 증상 기록.
  const factory TimelineItem.symptom({
    required SymptomState symptomState,
    required int afterMealMinutes,
    required String occurredAt,
  }) = TimelineSymptom;
}

// ---------------------------------------------------------------------------
// WeeklyDay — 주간 도트
// ---------------------------------------------------------------------------

/// 주간 도트 단일 (GET /timeline/weekly?date= result[] 대응).
@freezed
abstract class WeeklyDay with _$WeeklyDay {
  const factory WeeklyDay({
    /// 'YYYY-MM-DD'.
    required String date,

    /// SAT|SUN|MON… (표시 안 쓰면 보관만).
    required String dayOfWeek,

    /// judgementList[], ≤3, 대문자 grade → VerdictLevel.
    @Default(<VerdictLevel>[]) List<VerdictLevel> judgements,
  }) = _WeeklyDay;
}

// ---------------------------------------------------------------------------
// MealCandidate / MealCandidatesDay — 증상 연결 후보 (증상레이어 공유)
// ---------------------------------------------------------------------------

/// 증상 연결 후보 일자 묶음 (GET /meal-records/candidates result[] 대응).
///
/// W5-1은 인터페이스+엔티티+DTO만 정의. 화면 소비는 W5-2.
@freezed
abstract class MealCandidatesDay with _$MealCandidatesDay {
  const factory MealCandidatesDay({
    /// 'yyyy-MM-dd'.
    required String date,
    @Default(<MealCandidate>[]) List<MealCandidate> meals,
  }) = _MealCandidatesDay;
}

/// 증상 연결 후보 식사 단건.
@freezed
abstract class MealCandidate with _$MealCandidate {
  const factory MealCandidate({
    required String mealRecordId,

    /// representativeFood.name.
    required String representativeFoodName,

    /// representativeFood.category.
    String? representativeFoodCategory,

    /// 대표 외 추가 음식 수.
    @Default(0) int otherFoodCount,

    /// ISO.
    required String eatenAt,
  }) = _MealCandidate;
}
