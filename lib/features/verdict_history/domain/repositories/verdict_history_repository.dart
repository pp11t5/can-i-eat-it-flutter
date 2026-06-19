import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';

/// 판정 이력 저장소 인터페이스.
abstract interface class VerdictHistoryRepository {
  /// 저장된 판정 이력 목록을 반환한다 (최신 순).
  Future<List<VerdictHistoryItem>> getHistory();

  /// 판정 이력에 항목을 추가한다. 50건 초과 시 가장 오래된 항목 제거(FIFO).
  Future<void> addItem(VerdictHistoryItem item);

  /// 판정 이력 전체를 삭제한다.
  Future<void> clearHistory();
}
