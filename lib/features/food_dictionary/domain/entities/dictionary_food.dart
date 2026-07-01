import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

part 'dictionary_food.freezed.dart';

// ---------------------------------------------------------------------------
// DictionaryFoodItem — 도감 음식 단건
// ---------------------------------------------------------------------------

/// 도감(내 음식 히스토리) 음식 단건 엔티티.
///
/// GET /dictionary/safe · /dictionary/caution-risk 목록 항목을 표현한다.
/// safe 목록은 항상 [VerdictLevel.recommend], caution-risk 목록은 서버
/// `type`(safe|caution|risk) → [VerdictLevel] 매핑 결과.
@freezed
abstract class DictionaryFoodItem with _$DictionaryFoodItem {
  const factory DictionaryFoodItem({
    /// 음식 식별자 (서버 foodId).
    required String foodId,

    /// 음식 표시 이름.
    required String name,

    /// 음식 카테고리 코드. 서버 미제공 시 null.
    String? categoryCode,

    /// 신호등 판정.
    required VerdictLevel verdict,
  }) = _DictionaryFoodItem;
}

// ---------------------------------------------------------------------------
// DictionaryPage — 커서 페이지네이션
// ---------------------------------------------------------------------------

/// 도감 페이지 엔티티 (safe·caution-risk 공용).
@freezed
abstract class DictionaryPage with _$DictionaryPage {
  const factory DictionaryPage({
    /// 이번 페이지 항목 목록.
    @Default(<DictionaryFoodItem>[]) List<DictionaryFoodItem> items,

    /// 다음 페이지 커서. null 이면 더 없음.
    int? nextCursor,

    /// 다음 페이지 존재 여부.
    @Default(false) bool hasNext,
  }) = _DictionaryPage;
}

// ---------------------------------------------------------------------------
// DictionaryCount — 탭 카운트
// ---------------------------------------------------------------------------

/// 도감 탭 카운트 엔티티 (GET /dictionary/count 대응).
@freezed
abstract class DictionaryCount with _$DictionaryCount {
  const factory DictionaryCount({
    /// 권장(안전) 음식 수.
    required int safeCount,

    /// 주의·위험 음식 수.
    required int cautionRiskCount,
  }) = _DictionaryCount;
}
