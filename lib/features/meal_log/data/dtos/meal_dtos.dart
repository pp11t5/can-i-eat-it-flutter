import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/data/dtos/food_summary_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

part 'meal_dtos.freezed.dart';
part 'meal_dtos.g.dart';

// ---------------------------------------------------------------------------
// StateRecordDto
// ---------------------------------------------------------------------------

/// 증상 기록 단건 DTO (StateRecordDto 서버 계약).
@freezed
abstract class StateRecordDto with _$StateRecordDto {
  const factory StateRecordDto({
    required String label,
    required String date,
    required String timing,
  }) = _StateRecordDto;

  factory StateRecordDto.fromJson(Map<String, dynamic> json) =>
      _$StateRecordDtoFromJson(json);
}

extension StateRecordDtoMapper on StateRecordDto {
  StateRecord toEntity() => StateRecord(
        label: label,
        date: date,
        timing: timing,
      );
}

// ---------------------------------------------------------------------------
// MealFoodDetailDto
// ---------------------------------------------------------------------------

/// 식사 기록 내 음식 상세 DTO (MealFoodDetailDto 서버 계약).
///
/// [FoodSummaryDto] 와 달리 [description] 필드를 추가로 보유한다.
@freezed
abstract class MealFoodDetailDto with _$MealFoodDetailDto {
  const factory MealFoodDetailDto({
    required String externalId,
    required String name,
    String? category,
    String? description,
  }) = _MealFoodDetailDto;

  factory MealFoodDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealFoodDetailDtoFromJson(json);
}

extension MealFoodDetailDtoMapper on MealFoodDetailDto {
  MealFood toEntity() => MealFood(
        externalId: externalId,
        name: name,
        category: category,
        description: description,
      );
}

// ---------------------------------------------------------------------------
// MealRecordSummaryDto
// ---------------------------------------------------------------------------

/// 식사 기록 요약 DTO (타임라인·POST 응답 대응).
@freezed
abstract class MealRecordSummaryDto with _$MealRecordSummaryDto {
  const factory MealRecordSummaryDto({
    required String mealId,
    required String mealGroupId,
    required String eatenAt,
    required FoodSummaryDto food,
    String? judgedGrade,
  }) = _MealRecordSummaryDto;

  factory MealRecordSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordSummaryDtoFromJson(json);
}

extension MealRecordSummaryDtoMapper on MealRecordSummaryDto {
  MealRecord toEntity() => MealRecord(
        mealId: mealId,
        mealGroupId: mealGroupId,
        eatenAt: eatenAt,
        food: food.toEntity(),
        judgedGrade: judgedGrade != null
            ? VerdictLevelGrade.fromGrade(judgedGrade!)
            : null,
      );
}

// ---------------------------------------------------------------------------
// MealRecordDetailDto
// ---------------------------------------------------------------------------

/// 식사 기록 상세 DTO (GET /meals/{id} · PATCH 응답 대응).
@freezed
abstract class MealRecordDetailDto with _$MealRecordDetailDto {
  const factory MealRecordDetailDto({
    required String mealId,
    required String mealGroupId,
    required String eatenAt,
    String? memo,
    String? judgedGrade,
    required MealFoodDetailDto food,
    @Default(<StateRecordDto>[]) List<StateRecordDto> stateRecords,
  }) = _MealRecordDetailDto;

  factory MealRecordDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordDetailDtoFromJson(json);
}

extension MealRecordDetailDtoMapper on MealRecordDetailDto {
  MealDetail toEntity() => MealDetail(
        mealId: mealId,
        mealGroupId: mealGroupId,
        eatenAt: eatenAt,
        memo: memo,
        judgedGrade: judgedGrade != null
            ? VerdictLevelGrade.fromGrade(judgedGrade!)
            : null,
        food: food.toEntity(),
        stateRecords: stateRecords.map((r) => r.toEntity()).toList(),
      );
}

// ---------------------------------------------------------------------------
// MealGroupDto
// ---------------------------------------------------------------------------

/// 끼니 그룹 DTO (GET /meals?date= 응답 항목).
@freezed
abstract class MealGroupDto with _$MealGroupDto {
  const factory MealGroupDto({
    required String mealGroupId,
    required String eatenAt,
    @Default(<MealRecordSummaryDto>[]) List<MealRecordSummaryDto> records,
  }) = _MealGroupDto;

  factory MealGroupDto.fromJson(Map<String, dynamic> json) =>
      _$MealGroupDtoFromJson(json);
}

extension MealGroupDtoMapper on MealGroupDto {
  MealGroup toEntity() => MealGroup(
        mealGroupId: mealGroupId,
        eatenAt: eatenAt,
        records: records.map((r) => r.toEntity()).toList(),
      );
}

// ---------------------------------------------------------------------------
// 요청 DTO
// ---------------------------------------------------------------------------

/// POST /meals 요청 바디.
@freezed
abstract class CreateMealRecordRequestDto with _$CreateMealRecordRequestDto {
  const factory CreateMealRecordRequestDto({
    required String foodExternalId,
    String? eatenAt,
    String? mealGroupId,
    String? judgedGrade,
  }) = _CreateMealRecordRequestDto;

  factory CreateMealRecordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMealRecordRequestDtoFromJson(json);
}

/// POST /meals/text 요청 바디.
@freezed
abstract class CreateMealByTextRequestDto with _$CreateMealByTextRequestDto {
  const factory CreateMealByTextRequestDto({
    required String foodTextInput,
    String? eatenAt,
    String? mealGroupId,
    String? judgedGrade,
  }) = _CreateMealByTextRequestDto;

  factory CreateMealByTextRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMealByTextRequestDtoFromJson(json);
}

/// PATCH /meals/{mealId} 요청 바디.
@freezed
abstract class UpdateMealMemoRequestDto with _$UpdateMealMemoRequestDto {
  const factory UpdateMealMemoRequestDto({
    String? memo,
  }) = _UpdateMealMemoRequestDto;

  factory UpdateMealMemoRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMealMemoRequestDtoFromJson(json);
}
