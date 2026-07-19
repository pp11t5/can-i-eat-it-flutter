import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

part 'judgment_response_dto.freezed.dart';
part 'judgment_response_dto.g.dart';

// ---------------------------------------------------------------------------
// 공유 서브 DTO
// ---------------------------------------------------------------------------

/// 분석 항목 DTO. 두 응답 타입에서 공유.
///
/// [emphasis]: 강조 문구 (예: "트리거/증상 분석")
/// [body]: 본문 설명
@freezed
abstract class JudgmentItemDto with _$JudgmentItemDto {
  const factory JudgmentItemDto({
    required String emphasis,
    required String body,
  }) = _JudgmentItemDto;

  factory JudgmentItemDto.fromJson(Map<String, dynamic> j) =>
      _$JudgmentItemDtoFromJson(j);
}

/// 섭취 기록 단건 DTO.
@freezed
abstract class StateRecordDto with _$StateRecordDto {
  const factory StateRecordDto({
    required int stateRecordId,
    required String label,
    required String date,   // "YYYY-MM-DD" 문자열 그대로
    required int timingMinutes,
  }) = _StateRecordDto;

  factory StateRecordDto.fromJson(Map<String, dynamic> j) =>
      _$StateRecordDtoFromJson(j);
}

/// 섭취 기록 요약 DTO (stateRecords).
@freezed
abstract class StateRecordsDto with _$StateRecordsDto {
  const factory StateRecordsDto({
    required int total,
    @Default(<StateRecordDto>[]) List<StateRecordDto> records,
  }) = _StateRecordsDto;

  factory StateRecordsDto.fromJson(Map<String, dynamic> j) =>
      _$StateRecordsDtoFromJson(j);
}

/// 대체 음식 DTO.
@freezed
abstract class SubstituteDto with _$SubstituteDto {
  const factory SubstituteDto({
    required String foodExternalId,
    required String name,
  }) = _SubstituteDto;

  factory SubstituteDto.fromJson(Map<String, dynamic> j) =>
      _$SubstituteDtoFromJson(j);
}

// ---------------------------------------------------------------------------
// by-id 응답 DTO — GET /foods/{foodExternalId}/judgment
// ---------------------------------------------------------------------------

/// 등록 음식 판정 응답 DTO (by-id).
///
/// substitutes·category 포함 완전 응답.
///
/// [stateRecords] 는 nullable — 서버가 grade=UNKNOWN 등에서 키를 누락하거나
/// null로 줄 경우에도 TypeError 없이 역직렬화되어야 한다 (S1 방어).
/// toEntity() 에서 null이면 빈 VerdictStateRecords(total:0, records:[])로 폴백.
@freezed
abstract class JudgmentResponseDto with _$JudgmentResponseDto {
  const factory JudgmentResponseDto({
    required String foodExternalId,
    required String foodName,
    String? category,
    required String grade,         // RECOMMEND|CAUTION|RISK|UNKNOWN
    required String personalTitle,
    @Default(<JudgmentItemDto>[]) List<JudgmentItemDto> items,
    StateRecordsDto? stateRecords, // nullable: 누락/null 방어 (S1)
    @Default(<SubstituteDto>[]) List<SubstituteDto> substitutes,
  }) = _JudgmentResponseDto;

  factory JudgmentResponseDto.fromJson(Map<String, dynamic> j) =>
      _$JudgmentResponseDtoFromJson(j);
}

// ---------------------------------------------------------------------------
// by-text 응답 DTO — GET /foods/judgment?foodTextInput=
// ---------------------------------------------------------------------------

/// 자유 텍스트 판정 응답 DTO (by-text).
///
/// foodExternalId·category 없음, substitutes 항상 빈배열(서버 보장).
///
/// [stateRecords] 는 nullable — 서버 누락/null 방어 (S1).
/// toEntity() 에서 null이면 빈 VerdictStateRecords로 폴백.
@freezed
abstract class TextJudgmentResponseDto with _$TextJudgmentResponseDto {
  const factory TextJudgmentResponseDto({
    required String foodName,
    required String grade,
    required String personalTitle,
    @Default(<JudgmentItemDto>[]) List<JudgmentItemDto> items,
    StateRecordsDto? stateRecords, // nullable: 누락/null 방어 (S1)
  }) = _TextJudgmentResponseDto;

  factory TextJudgmentResponseDto.fromJson(Map<String, dynamic> j) =>
      _$TextJudgmentResponseDtoFromJson(j);
}

// ---------------------------------------------------------------------------
// toEntity 매핑 확장
// ---------------------------------------------------------------------------

/// [JudgmentResponseDto] → [EatVerdict] 매핑 (by-id).
extension JudgmentResponseDtoMapper on JudgmentResponseDto {
  EatVerdict toEntity() => EatVerdict(
        level: VerdictLevelGrade.fromGrade(grade),
        foodName: foodName,
        foodExternalId: foodExternalId,
        category: category,
        personalTitle: personalTitle,
        items: items
            .map((e) => VerdictItem(emphasis: e.emphasis, body: e.body))
            .toList(),
        // stateRecords null 폴백 — 서버 누락/null 시 빈 VerdictStateRecords (S1)
        stateRecords: stateRecords == null
            ? const VerdictStateRecords()
            : VerdictStateRecords(
                total: stateRecords!.total,
                records: stateRecords!.records
                    .map(
                      (r) => VerdictStateRecord(
                        stateRecordId: r.stateRecordId,
                        label: r.label,
                        date: r.date,
                        timingMinutes: r.timingMinutes,
                      ),
                    )
                    .toList(),
              ),
        substitutes: substitutes
            .map(
              (s) => VerdictSubstitute(
                foodExternalId: s.foodExternalId,
                name: s.name,
              ),
            )
            .toList(),
      );
}

/// [TextJudgmentResponseDto] → [EatVerdict] 매핑 (by-text).
///
/// by-text 규약: substitutes 항상 빈배열, foodExternalId·category null.
extension TextJudgmentResponseDtoMapper on TextJudgmentResponseDto {
  EatVerdict toEntity() => EatVerdict(
        level: VerdictLevelGrade.fromGrade(grade),
        foodName: foodName,
        foodExternalId: null,
        category: null,
        personalTitle: personalTitle,
        items: items
            .map((e) => VerdictItem(emphasis: e.emphasis, body: e.body))
            .toList(),
        // stateRecords null 폴백 — 서버 누락/null 시 빈 VerdictStateRecords (S1)
        stateRecords: stateRecords == null
            ? const VerdictStateRecords()
            : VerdictStateRecords(
                total: stateRecords!.total,
                records: stateRecords!.records
                    .map(
                      (r) => VerdictStateRecord(
                        stateRecordId: r.stateRecordId,
                        label: r.label,
                        date: r.date,
                        timingMinutes: r.timingMinutes,
                      ),
                    )
                    .toList(),
              ),
        substitutes: const [],   // by-text 규약: 서버가 항상 빈배열
      );
}
