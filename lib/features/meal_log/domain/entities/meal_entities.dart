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

    /// 음식 카테고리. 서버가 없으면 null → CategoryIcon regular 폴백.
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
// TimeIcon — 타임라인 시간대 아이콘 판별자
// ---------------------------------------------------------------------------

/// 타임라인 항목의 서버 지정 시간대 아이콘.
///
/// 없으면(null) 호출부가 기존 hour 휴리스틱으로 폴백한다.
enum TimeIcon { sun, moon }

/// [TimeIcon] 서버 변환 확장.
extension TimeIconMapper on TimeIcon {
  /// 서버 [v] 문자열을 [TimeIcon] 으로 변환한다. 미지값·null 은 null 폴백
  /// (hour 휴리스틱 사용을 호출부에 위임).
  static TimeIcon? fromServer(String? v) => switch (v) {
        'sun' => TimeIcon.sun,
        'moon' => TimeIcon.moon,
        _ => null,
      };
}

// ---------------------------------------------------------------------------
// ConnectedSymptoms — 타임라인 single/group 연결증상
// ---------------------------------------------------------------------------

/// 식사에 연결된 증상 요약 (타임라인 single/group 카드 하단 칩).
///
/// [symptomId] 로 증상 상세(`/symptom/:id`) 이동.
@freezed
abstract class ConnectedSymptoms with _$ConnectedSymptoms {
  const factory ConnectedSymptoms({
    required String symptomId,
    required SymptomState symptomState,
    required int afterMealMinutes,
    @Default(<String>[]) List<String> representativeSymptoms,
    @Default(0) int etcCount,
  }) = _ConnectedSymptoms;
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

    /// 음식 카테고리 코드 (CategoryIcon 표시용). 서버 미제공 시 null → regular 폴백.
    String? categoryCode,

    /// 서버 지정 시간대 아이콘. null 이면 hour 휴리스틱 폴백.
    TimeIcon? timeIcon,

    /// 연결증상. 없으면 칩 미표시.
    ConnectedSymptoms? connectedSymptoms,
  }) = TimelineSingle;

  /// group: 음식 2개 이상짜리 식사.
  const factory TimelineItem.group({
    required String mealRecordId,
    required String mealRecordDateTime,
    @Default(<String>[]) List<String> representativeFoods,
    @Default(0) int etcCount,

    /// 음식 카테고리 코드 (CategoryIcon 표시용). 서버 미제공 시 null → regular 폴백.
    String? categoryCode,

    /// 서버 지정 시간대 아이콘. null 이면 hour 휴리스틱 폴백.
    TimeIcon? timeIcon,

    /// 연결증상. 없으면 칩 미표시.
    ConnectedSymptoms? connectedSymptoms,
  }) = TimelineGroup;

  /// symptom: 증상 기록.
  const factory TimelineItem.symptom({
    required SymptomState symptomState,
    required int afterMealMinutes,
    required String occurredAt,

    /// 서버 지정 시간대 아이콘. symptom 행은 항상 의료 아이콘을 쓰므로 표시엔
    /// 미사용 — 계약 완전성을 위해 보관만.
    TimeIcon? timeIcon,

    /// 증상 상세 식별자. 있으면 탭 가능(구 페이로드 방어 위해 nullable).
    String? symptomId,
  }) = TimelineSymptom;
}

// ---------------------------------------------------------------------------
// MonthlyDay — 월별 판정 집계
// ---------------------------------------------------------------------------

/// 월별 판정 집계 단일 (GET /timeline/monthly?month= result[] 대응, 구 WeeklyDay 대체).
@freezed
abstract class MonthlyDay with _$MonthlyDay {
  const factory MonthlyDay({
    /// 해당 월의 일(day). 서버는 date 문자열이 아닌 day:int만 제공한다.
    /// 표시월(연/월)과 조합한 DateTime 조립은 호출부(화면) 책임.
    required int day,

    /// judgementList[], ≤3, 대문자 grade → VerdictLevel.
    @Default(<VerdictLevel>[]) List<VerdictLevel> judgements,
  }) = _MonthlyDay;
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
