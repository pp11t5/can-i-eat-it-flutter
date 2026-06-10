import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_summary.freezed.dart';

/// 음식 검색 결과 항목 엔티티 (GET /foods/search 대응).
///
/// 검색 결과 목록에서 각 항목을 표현한다.
/// analyze 진입 시 [externalId]를 이용한다.
@freezed
abstract class FoodSummary with _$FoodSummary {
  const factory FoodSummary({
    /// 서버측 음식 식별자.
    required String externalId,

    /// 음식 표시 이름.
    required String name,

    /// 음식 카테고리. 예: '한식'. 서버가 없으면 null.
    String? category,
  }) = _FoodSummary;
}
