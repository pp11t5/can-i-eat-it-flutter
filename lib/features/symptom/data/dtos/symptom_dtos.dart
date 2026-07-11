import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

part 'symptom_dtos.freezed.dart';
part 'symptom_dtos.g.dart';

// ---------------------------------------------------------------------------
// 중첩 응답 DTO
// ---------------------------------------------------------------------------

/// linkedMeal 내 음식 단건 DTO.
@freezed
abstract class SymptomLinkedFoodDto with _$SymptomLinkedFoodDto {
  const factory SymptomLinkedFoodDto({
    required String mealFoodId,
    required String name,
    String? category,
  }) = _SymptomLinkedFoodDto;

  factory SymptomLinkedFoodDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomLinkedFoodDtoFromJson(json);
}

extension SymptomLinkedFoodDtoMapper on SymptomLinkedFoodDto {
  SymptomLinkedFood toEntity() => SymptomLinkedFood(
        mealFoodId: mealFoodId,
        name: name,
        category: category,
      );
}

/// linkedMeal DTO.
@freezed
abstract class SymptomLinkedMealDto with _$SymptomLinkedMealDto {
  const factory SymptomLinkedMealDto({
    required String mealRecordId,
    @Default(<SymptomLinkedFoodDto>[]) List<SymptomLinkedFoodDto> foods,
  }) = _SymptomLinkedMealDto;

  factory SymptomLinkedMealDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomLinkedMealDtoFromJson(json);
}

extension SymptomLinkedMealDtoMapper on SymptomLinkedMealDto {
  SymptomLinkedMeal toEntity() => SymptomLinkedMeal(
        mealRecordId: mealRecordId,
        foods: foods.map((f) => f.toEntity()).toList(),
      );
}

/// 분석 항목 단건 DTO (서버 {emphasis, body}).
@freezed
abstract class SymptomAnalysisItemDto with _$SymptomAnalysisItemDto {
  const factory SymptomAnalysisItemDto({
    required String emphasis,
    required String body,
  }) = _SymptomAnalysisItemDto;

  factory SymptomAnalysisItemDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomAnalysisItemDtoFromJson(json);
}

extension SymptomAnalysisItemDtoMapper on SymptomAnalysisItemDto {
  SymptomAnalysisItem toEntity() =>
      SymptomAnalysisItem(emphasis: emphasis, body: body);
}

/// analysis 래퍼 DTO (서버 {items: [...]}).
@freezed
abstract class SymptomAnalysisDto with _$SymptomAnalysisDto {
  const factory SymptomAnalysisDto({
    @Default(<SymptomAnalysisItemDto>[]) List<SymptomAnalysisItemDto> items,
  }) = _SymptomAnalysisDto;

  factory SymptomAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomAnalysisDtoFromJson(json);
}

// ---------------------------------------------------------------------------
// SymptomResponseDto — POST·GET 공통 응답
// ---------------------------------------------------------------------------

/// 증상 응답 DTO (POST /symptoms · GET /symptoms/{id} result).
///
/// 모든 nullable 필드는 ?? const [] / null 방어 적용.
/// linkedMeal / analysis 는 nullable 이며 toEntity 에서 안전하게 처리.
@freezed
abstract class SymptomResponseDto with _$SymptomResponseDto {
  const factory SymptomResponseDto({
    required String symptomId,
    required String symptomState,
    required String stateTitle,
    @Default(<String>[]) List<String> symptomTypes,
    required String occurredAt,
    SymptomLinkedMealDto? linkedMeal,
    SymptomAnalysisDto? analysis,
  }) = _SymptomResponseDto;

  factory SymptomResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomResponseDtoFromJson(json);
}

extension SymptomResponseDtoMapper on SymptomResponseDto {
  Symptom toEntity() => Symptom(
        symptomId: symptomId,
        symptomState: SymptomStateMapper.fromServer(symptomState),
        stateTitle: stateTitle,
        symptomTypes: symptomTypes
            .map(SymptomTypeMapper.fromServerNullable)
            .whereType<SymptomType>()
            .toList(),
        occurredAt: occurredAt,
        linkedMeal: linkedMeal?.toEntity(),
        analysisItems: (analysis?.items ?? const [])
            .map((i) => i.toEntity())
            .toList(),
      );
}

// ---------------------------------------------------------------------------
// 요청 DTO 3종
// ---------------------------------------------------------------------------

/// POST /symptoms 요청 바디.
///
/// occurredAt null 이면 body 에서 누락(서버가 현재 시각 사용) — impl 에서 removeWhere.
/// mealRecordId null 이면 body 에서 누락(서버가 식사 미연결로 해석) — impl 에서 removeWhere.
/// symptomTypes 빈 목록이면 [] 로 전송.
@freezed
abstract class SymptomCreateRequestDto with _$SymptomCreateRequestDto {
  const factory SymptomCreateRequestDto({
    required String symptomState,
    @Default(<String>[]) List<String> symptomTypes,
    String? occurredAt,
    String? mealRecordId,
    String? memo,
  }) = _SymptomCreateRequestDto;

  factory SymptomCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomCreateRequestDtoFromJson(json);
}

/// PUT /symptoms/{symptomId} 요청 바디.
///
/// occurredAt 은 update 시 필수 (서버 계약).
/// mealRecordId null 이면 body 에서 누락(서버가 식사 미연결로 해석) — impl 에서 removeWhere.
@freezed
abstract class SymptomUpdateRequestDto with _$SymptomUpdateRequestDto {
  const factory SymptomUpdateRequestDto({
    required String symptomState,
    @Default(<String>[]) List<String> symptomTypes,
    required String occurredAt,
    String? mealRecordId,
    String? memo,
  }) = _SymptomUpdateRequestDto;

  factory SymptomUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomUpdateRequestDtoFromJson(json);
}

/// PATCH /symptoms/{symptomId}/memo 요청 바디.
///
/// memo null 허용 (메모 초기화 용).
@freezed
abstract class SymptomMemoUpdateRequestDto with _$SymptomMemoUpdateRequestDto {
  const factory SymptomMemoUpdateRequestDto({
    String? memo,
  }) = _SymptomMemoUpdateRequestDto;

  factory SymptomMemoUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomMemoUpdateRequestDtoFromJson(json);
}
