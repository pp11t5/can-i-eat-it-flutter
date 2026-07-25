import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_food.freezed.dart';

/// 최근 검색 항목 엔티티 (GET /foods/recent 대응).
///
/// String 기반 [SearchHistoryRepository]를 대체한다(W3 #5).
/// 정렬 순서는 서버 [searchedAt] 순서를 신뢰하고 클라이언트는 재정렬하지 않는다.
@freezed
abstract class RecentFood with _$RecentFood {
  const factory RecentFood({
    /// 최근 검색 기록 식별자. 단건 삭제 시 사용.
    required int id,

    /// 사용자가 검색한 원문.
    required String query,

    /// 검색(저장)된 시각.
    required DateTime searchedAt,
  }) = _RecentFood;
}
