import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';

part 'food_search_result.freezed.dart';

/// 음식 검색 응답 전체.
///
/// 서버는 결과 목록과 검색어의 정확 일치 여부를 함께 반환한다. 정확 일치가
/// 없을 때만 사용자가 입력한 텍스트로 직접 판정할 수 있다.
@freezed
abstract class FoodSearchResult with _$FoodSearchResult {
  const factory FoodSearchResult({
    @Default(<FoodSummary>[]) List<FoodSummary> foods,
    @Default(false) bool hasExactMatch,
  }) = _FoodSearchResult;
}
