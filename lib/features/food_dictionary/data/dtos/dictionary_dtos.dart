import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';

part 'dictionary_dtos.freezed.dart';
part 'dictionary_dtos.g.dart';

// ---------------------------------------------------------------------------
// type 문자열 → VerdictLevel 매핑 헬퍼
// ---------------------------------------------------------------------------

/// caution-risk 목록 항목의 서버 `type` 문자열을 [VerdictLevel] 로 변환한다.
///
/// 'safe'→recommend, 'caution'→caution, 'risk'→risk, 그 외→unknown
/// (미지 값은 위험을 과소평가하지 않도록 unknown 폴백).
VerdictLevel _verdictFromType(String type) => switch (type) {
      'caution' => VerdictLevel.caution,
      'risk' => VerdictLevel.risk,
      'safe' => VerdictLevel.recommend,
      _ => VerdictLevel.unknown,
    };

// ---------------------------------------------------------------------------
// SafeFoodItemDto — GET /dictionary/safe 항목
// ---------------------------------------------------------------------------

/// 권장(안전) 음식 항목 DTO (GET /dictionary/safe items[] 대응).
@freezed
abstract class SafeFoodItemDto with _$SafeFoodItemDto {
  const factory SafeFoodItemDto({
    required String foodId,
    required String name,
    String? code,
  }) = _SafeFoodItemDto;

  factory SafeFoodItemDto.fromJson(Map<String, dynamic> json) =>
      _$SafeFoodItemDtoFromJson(json);
}

extension SafeFoodItemDtoMapper on SafeFoodItemDto {
  DictionaryFoodItem toEntity() => DictionaryFoodItem(
        foodId: foodId,
        name: name,
        categoryCode: code,
        verdict: VerdictLevel.recommend,
      );
}

// ---------------------------------------------------------------------------
// CautionRiskFoodItemDto — GET /dictionary/caution-risk 항목
// ---------------------------------------------------------------------------

/// 주의·위험 음식 항목 DTO (GET /dictionary/caution-risk items[] 대응).
@freezed
abstract class CautionRiskFoodItemDto with _$CautionRiskFoodItemDto {
  const factory CautionRiskFoodItemDto({
    required String foodId,
    required String name,
    String? code,
    required String type,
  }) = _CautionRiskFoodItemDto;

  factory CautionRiskFoodItemDto.fromJson(Map<String, dynamic> json) =>
      _$CautionRiskFoodItemDtoFromJson(json);
}

extension CautionRiskFoodItemDtoMapper on CautionRiskFoodItemDto {
  DictionaryFoodItem toEntity() => DictionaryFoodItem(
        foodId: foodId,
        name: name,
        categoryCode: code,
        verdict: _verdictFromType(type),
      );
}

// ---------------------------------------------------------------------------
// SafeDictionaryPageDto — GET /dictionary/safe
// ---------------------------------------------------------------------------

/// 권장(안전) 도감 페이지 DTO (GET /dictionary/safe result 대응).
@freezed
abstract class SafeDictionaryPageDto with _$SafeDictionaryPageDto {
  const factory SafeDictionaryPageDto({
    @Default(<SafeFoodItemDto>[]) List<SafeFoodItemDto> items,
    int? nextCursor,
    @Default(false) bool hasNext,
  }) = _SafeDictionaryPageDto;

  factory SafeDictionaryPageDto.fromJson(Map<String, dynamic> json) =>
      _$SafeDictionaryPageDtoFromJson(json);
}

extension SafeDictionaryPageDtoMapper on SafeDictionaryPageDto {
  DictionaryPage toEntity() => DictionaryPage(
        items: items.map((i) => i.toEntity()).toList(),
        nextCursor: nextCursor,
        hasNext: hasNext,
      );
}

// ---------------------------------------------------------------------------
// CautionRiskDictionaryPageDto — GET /dictionary/caution-risk
// ---------------------------------------------------------------------------

/// 주의·위험 도감 페이지 DTO (GET /dictionary/caution-risk result 대응).
@freezed
abstract class CautionRiskDictionaryPageDto
    with _$CautionRiskDictionaryPageDto {
  const factory CautionRiskDictionaryPageDto({
    @Default(<CautionRiskFoodItemDto>[]) List<CautionRiskFoodItemDto> items,
    int? nextCursor,
    @Default(false) bool hasNext,
  }) = _CautionRiskDictionaryPageDto;

  factory CautionRiskDictionaryPageDto.fromJson(Map<String, dynamic> json) =>
      _$CautionRiskDictionaryPageDtoFromJson(json);
}

extension CautionRiskDictionaryPageDtoMapper on CautionRiskDictionaryPageDto {
  DictionaryPage toEntity() => DictionaryPage(
        items: items.map((i) => i.toEntity()).toList(),
        nextCursor: nextCursor,
        hasNext: hasNext,
      );
}

// ---------------------------------------------------------------------------
// DictionaryCountDto — GET /dictionary/count
// ---------------------------------------------------------------------------

/// 도감 탭 카운트 DTO (GET /dictionary/count result 대응).
@freezed
abstract class DictionaryCountDto with _$DictionaryCountDto {
  const factory DictionaryCountDto({
    @Default(0) int safeCount,
    @Default(0) int cautionRiskCount,
  }) = _DictionaryCountDto;

  factory DictionaryCountDto.fromJson(Map<String, dynamic> json) =>
      _$DictionaryCountDtoFromJson(json);
}

extension DictionaryCountDtoMapper on DictionaryCountDto {
  DictionaryCount toEntity() => DictionaryCount(
        safeCount: safeCount,
        cautionRiskCount: cautionRiskCount,
      );
}
