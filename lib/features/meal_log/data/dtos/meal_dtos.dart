import 'package:characters/characters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'meal_dtos.freezed.dart';
part 'meal_dtos.g.dart';

// ---------------------------------------------------------------------------
// 공유 서브 DTO
// ---------------------------------------------------------------------------

/// 분석 섹션 DTO (서버 {ment, content}).
@freezed
abstract class AnalysisSectionDto with _$AnalysisSectionDto {
  const factory AnalysisSectionDto({
    required String ment,
    required String content,
  }) = _AnalysisSectionDto;

  factory AnalysisSectionDto.fromJson(Map<String, dynamic> json) =>
      _$AnalysisSectionDtoFromJson(json);
}

extension AnalysisSectionDtoMapper on AnalysisSectionDto {
  AnalysisSection toEntity() => AnalysisSection(ment: ment, content: content);
}

/// analysis 스냅샷 DTO.
@freezed
abstract class MealAnalysisDto with _$MealAnalysisDto {
  const factory MealAnalysisDto({
    required String judgmentGrade,
    AnalysisSectionDto? triggerAnalysis,
    AnalysisSectionDto? allergyAnalysis,
  }) = _MealAnalysisDto;

  factory MealAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$MealAnalysisDtoFromJson(json);
}

extension MealAnalysisDtoMapper on MealAnalysisDto {
  MealAnalysis toEntity() => MealAnalysis(
        judgmentGrade: VerdictLevelGrade.fromGrade(judgmentGrade),
        trigger: triggerAnalysis?.toEntity(),
        allergy: allergyAnalysis?.toEntity(),
      );
}

/// 증상 기록 단건 DTO.
///
/// food_check에도 동명의 `StateRecordDto`가 있으나 다른 라이브러리 파일이므로
/// 충돌 없음(part 단위 격리). 신 meal_log 모델은 stateRecordId+timingMinutes.
@freezed
abstract class StateRecordDto with _$StateRecordDto {
  const factory StateRecordDto({
    required String stateRecordId,
    required String label,
    required String date,
    required int timingMinutes,
  }) = _StateRecordDto;

  factory StateRecordDto.fromJson(Map<String, dynamic> json) =>
      _$StateRecordDtoFromJson(json);
}

extension StateRecordDtoMapper on StateRecordDto {
  StateRecord toEntity() => StateRecord(
        stateRecordId: stateRecordId,
        label: label,
        date: date,
        timingMinutes: timingMinutes,
      );
}

/// 중첩 food 객체 DTO (POST/foodDetail·candidates 공유).
@freezed
abstract class MealFoodNestedDto with _$MealFoodNestedDto {
  const factory MealFoodNestedDto({
    String? mealRecordExternalId,
    required String name,
    String? category,
  }) = _MealFoodNestedDto;

  factory MealFoodNestedDto.fromJson(Map<String, dynamic> json) =>
      _$MealFoodNestedDtoFromJson(json);
}

// ---------------------------------------------------------------------------
// MealFoodRecordDetailDto — POST·foodDetail 공통 응답
// ---------------------------------------------------------------------------

/// 음식 상세 DTO (POST /meal-records · GET foods/{id} 응답).
@freezed
abstract class MealFoodRecordDetailDto with _$MealFoodRecordDetailDto {
  const factory MealFoodRecordDetailDto({
    required String mealFoodId,
    required String eatenAt,
    required MealFoodNestedDto food,
    MealAnalysisDto? analysis,
    StateRecordDto? stateRecord,
  }) = _MealFoodRecordDetailDto;

  factory MealFoodRecordDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealFoodRecordDetailDtoFromJson(json);
}

extension MealFoodRecordDetailDtoMapper on MealFoodRecordDetailDto {
  MealFood toEntity() => MealFood(
        mealFoodId: mealFoodId,
        name: food.name,
        category: food.category,
        eatenAt: eatenAt,
        mealRecordExternalId: food.mealRecordExternalId,
        analysis: analysis?.toEntity(),
      );
}

// ---------------------------------------------------------------------------
// MealRecordDetailDto — GET /meal-records/{id}
// ---------------------------------------------------------------------------

/// 식사 상세 내 음식 DTO (analysis 없음).
@freezed
abstract class MealDetailFoodDto with _$MealDetailFoodDto {
  const factory MealDetailFoodDto({
    required String mealFoodId,
    required String name,
    String? category,
    required String eatenAt,
  }) = _MealDetailFoodDto;

  factory MealDetailFoodDto.fromJson(Map<String, dynamic> json) =>
      _$MealDetailFoodDtoFromJson(json);
}

extension MealDetailFoodDtoMapper on MealDetailFoodDto {
  MealFood toEntity() => MealFood(
        mealFoodId: mealFoodId,
        name: name,
        category: category,
        eatenAt: eatenAt,
      );
}

/// 식사 상세 DTO (GET /meal-records/{id}).
@freezed
abstract class MealRecordDetailDto with _$MealRecordDetailDto {
  const factory MealRecordDetailDto({
    required String mealRecordId,
    required String eatenAt,
    @Default(<MealDetailFoodDto>[]) List<MealDetailFoodDto> meals,
    // stateRecords?: 명시 null까지 방어하기 위해 nullable + toEntity에서 ?? []
    List<StateRecordDto>? stateRecords,
  }) = _MealRecordDetailDto;

  factory MealRecordDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordDetailDtoFromJson(json);
}

extension MealRecordDetailDtoMapper on MealRecordDetailDto {
  MealRecord toEntity() => MealRecord(
        mealRecordId: mealRecordId,
        eatenAt: eatenAt,
        foods: meals.map((f) => f.toEntity()).toList(),
        stateRecords:
            (stateRecords ?? const []).map((r) => r.toEntity()).toList(),
      );
}

// ---------------------------------------------------------------------------
// ConnectedSymptomsDto — 타임라인 single/group의 연결증상
// ---------------------------------------------------------------------------

/// 연결증상 DTO (타임라인 single/group 항목의 connectedSymptoms 대응).
@freezed
abstract class ConnectedSymptomsDto with _$ConnectedSymptomsDto {
  const factory ConnectedSymptomsDto({
    required String symptomId,
    required String symptomState,
    required int afterMealMinutes,
    @Default(<String>[]) List<String> representativeSymptoms,
    @Default(0) int etcCount,
  }) = _ConnectedSymptomsDto;

  factory ConnectedSymptomsDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectedSymptomsDtoFromJson(json);
}

extension ConnectedSymptomsDtoMapper on ConnectedSymptomsDto {
  ConnectedSymptoms toEntity() => ConnectedSymptoms(
        symptomId: symptomId,
        symptomState: SymptomStateMapper.fromServer(symptomState),
        afterMealMinutes: afterMealMinutes,
        representativeSymptoms: representativeSymptoms,
        etcCount: etcCount,
      );
}

// ---------------------------------------------------------------------------
// Timeline polymorphic DTO — 수동 디스패치 팩토리
// ---------------------------------------------------------------------------

/// timeLineType 디스크리미네이터로 분기하는 수동 팩토리.
///
/// 알 수 없는 timeLineType 은 null 을 반환한다. 호출부는 리스트 매핑 시
/// `.whereType<TimelineItem>()` 로 걸러 신규 타입 추가에도 무크래시.
abstract final class TimelineItemDto {
  /// j['connectedSymptoms']가 있으면 [ConnectedSymptoms]로 매핑, 없으면 null.
  ///
  /// 서버가 필드 일부(symptomId/symptomState/afterMealMinutes 등)를 누락한
  /// 채로 보내면 [ConnectedSymptomsDto.fromJson]이 TypeError를 던질 수 있다.
  /// 칩은 부차 UI이므로 파싱 실패 시 null로 흡수하고 항목 자체는 살린다.
  static ConnectedSymptoms? _connectedSymptomsOf(Map<String, dynamic> j) {
    try {
      final raw = j['connectedSymptoms'] as Map<String, dynamic>?;
      return raw == null
          ? null
          : ConnectedSymptomsDto.fromJson(raw).toEntity();
    } catch (_) {
      return null;
    }
  }

  /// j['timeIcon']을 [TimeIcon]으로 매핑. 비문자열·이상값이면 null(hour 휴리스틱
  /// 폴백에 위임)로 흡수해 항목 파싱 자체는 실패시키지 않는다.
  static TimeIcon? _timeIconOf(Map<String, dynamic> j) {
    final raw = j['timeIcon'];
    return raw is String ? TimeIconMapper.fromServer(raw) : null;
  }

  static TimelineItem? fromJson(Map<String, dynamic> j) {
    final type = j['timeLineType'] as String?;
    switch (type) {
      case 'single':
        // 필수 필드 중 하나라도 null/누락이면 항목 자체를 스킵(whereType 처리).
        final mealRecordId = j['mealRecordId'] as String?;
        final mealRecordDateTime = j['mealRecordDateTime'] as String?;
        final mealFoodName = j['mealFoodName'] as String?;
        final gradeRaw = j['grade'] as String?;
        if (mealRecordId == null ||
            mealRecordDateTime == null ||
            mealFoodName == null ||
            gradeRaw == null) {
          return null;
        }
        return TimelineItem.single(
          mealRecordId: mealRecordId,
          mealRecordDateTime: mealRecordDateTime,
          mealFoodName: mealFoodName,
          grade: VerdictLevelGrade.fromGrade(gradeRaw),
          etcCount: (j['etcCount'] as num?)?.toInt() ?? 0,
          // 서버 제공됨(mealFoodCategory).
          categoryCode: j['mealFoodCategory'] as String?,
          timeIcon: _timeIconOf(j),
          connectedSymptoms: _connectedSymptomsOf(j),
        );
      case 'group':
        // 필수 필드 중 하나라도 null/누락이면 항목 스킵.
        final mealRecordId = j['mealRecordId'] as String?;
        final mealRecordDateTime = j['mealRecordDateTime'] as String?;
        if (mealRecordId == null || mealRecordDateTime == null) {
          return null;
        }
        return TimelineItem.group(
          mealRecordId: mealRecordId,
          mealRecordDateTime: mealRecordDateTime,
          representativeFoods: (j['representativeFoods'] as List?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
          etcCount: (j['etcCount'] as num?)?.toInt() ?? 0,
          // 서버 제공됨(mealFoodCategory).
          categoryCode: j['mealFoodCategory'] as String?,
          timeIcon: _timeIconOf(j),
          connectedSymptoms: _connectedSymptomsOf(j),
        );
      case 'symptom':
        // 필수 필드 중 하나라도 null/누락이면 항목 스킵.
        final symptomStateRaw = j['symptomState'] as String?;
        final afterMealMinutes = (j['afterMealMinutes'] as num?)?.toInt();
        final occurredAt = j['occurredAt'] as String?;
        if (symptomStateRaw == null ||
            afterMealMinutes == null ||
            occurredAt == null) {
          return null;
        }
        return TimelineItem.symptom(
          symptomState: SymptomStateMapper.fromServer(symptomStateRaw),
          afterMealMinutes: afterMealMinutes,
          occurredAt: occurredAt,
          timeIcon: _timeIconOf(j),
          symptomId: j['symptomId'] as String?,
        );
      default:
        return null;
    }
  }
}

// ---------------------------------------------------------------------------
// WeeklyDayDto
// ---------------------------------------------------------------------------

/// 주간 도트 DTO (GET /timeline/weekly result[] 항목).
@freezed
abstract class WeeklyDayDto with _$WeeklyDayDto {
  const factory WeeklyDayDto({
    required String date,
    required String dayOfWeek,
    // 서버 키 'judgementList'와 필드명 동일 → JsonKey 불필요.
    @Default(<String>[]) List<String> judgementList,
  }) = _WeeklyDayDto;

  factory WeeklyDayDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyDayDtoFromJson(json);
}

extension WeeklyDayDtoMapper on WeeklyDayDto {
  WeeklyDay toEntity() => WeeklyDay(
        date: date,
        dayOfWeek: dayOfWeek,
        judgements: judgementList.map(VerdictLevelGrade.fromGrade).toList(),
      );
}

// ---------------------------------------------------------------------------
// Candidates DTO
// ---------------------------------------------------------------------------

/// 증상 연결 후보 식사 단건 DTO.
@freezed
abstract class MealCandidateDto with _$MealCandidateDto {
  const factory MealCandidateDto({
    required String mealRecordId,
    required MealFoodNestedDto representativeFood,
    @Default(0) int otherFoodCount,
    required String eatenAt,
  }) = _MealCandidateDto;

  factory MealCandidateDto.fromJson(Map<String, dynamic> json) =>
      _$MealCandidateDtoFromJson(json);
}

extension MealCandidateDtoMapper on MealCandidateDto {
  MealCandidate toEntity() => MealCandidate(
        mealRecordId: mealRecordId,
        representativeFoodName: representativeFood.name,
        representativeFoodCategory: representativeFood.category,
        otherFoodCount: otherFoodCount,
        eatenAt: eatenAt,
      );
}

/// 증상 연결 후보 일자 묶음 DTO.
@freezed
abstract class MealCandidatesDayDto with _$MealCandidatesDayDto {
  const factory MealCandidatesDayDto({
    required String date,
    @Default(<MealCandidateDto>[]) List<MealCandidateDto> meals,
  }) = _MealCandidatesDayDto;

  factory MealCandidatesDayDto.fromJson(Map<String, dynamic> json) =>
      _$MealCandidatesDayDtoFromJson(json);
}

extension MealCandidatesDayDtoMapper on MealCandidatesDayDto {
  MealCandidatesDay toEntity() => MealCandidatesDay(
        date: date,
        meals: meals.map((m) => m.toEntity()).toList(),
      );
}

// ---------------------------------------------------------------------------
// 요청 DTO — POST /meal-records 4분화 (신규/기존 × by-text/by-id)
// ---------------------------------------------------------------------------

/// POST /meal-records(신규) · POST /meal-records/{id}/foods(기존) 요청 바디 (by-text).
///
/// ⚠️ judgedGrade 필드 없음 — 서버가 analysis 를 계산한다(F-10).
/// null 필드는 직렬화 시 누락한다(impl에서 removeWhere).
@freezed
abstract class MealRecordTextRequestDto with _$MealRecordTextRequestDto {
  const factory MealRecordTextRequestDto({
    required String name,
    String? eatenAt,
  }) = _MealRecordTextRequestDto;

  factory MealRecordTextRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordTextRequestDtoFromJson(json);
}

/// POST /meal-records/foods/{id}(신규) · POST /meal-records/{id}/foods/{id}(기존)
/// 요청 바디 (by-id). foodExternalId 는 경로 파라미터로 전달되므로 바디에는 없다.
///
/// null 필드는 직렬화 시 누락한다(impl에서 removeWhere).
@freezed
abstract class MealRecordByIdRequestDto with _$MealRecordByIdRequestDto {
  const factory MealRecordByIdRequestDto({
    String? eatenAt,
  }) = _MealRecordByIdRequestDto;

  factory MealRecordByIdRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordByIdRequestDtoFromJson(json);
}

/// 서버 name 제약(≤100자) 준수 — trim 후 초과분을 자른다.
///
/// [MealRecordTextRequestDto.name] 조립 전 impl이 호출한다. DTO 레벨에서 직접
/// 단위 테스트 가능하도록 top-level 함수로 둔다.
///
/// `String.substring`은 UTF-16 코드유닛 기준이라 서로게이트 쌍(이모지 등)이나
/// 결합 문자소(자소)를 반토막 낼 수 있다(pr-review 소소 수정 ③). 대신
/// `characters` 패키지의 grapheme cluster 기준으로 잘라 완전한 문자만 남긴다.
String clampMealName(String input) {
  final trimmed = input.trim().characters;
  return trimmed.length > 100 ? trimmed.take(100).toString() : trimmed.toString();
}
