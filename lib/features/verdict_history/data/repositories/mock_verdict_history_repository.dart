import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/repositories/verdict_history_repository.dart';

/// 테스트·UI 개발용 인메모리 [VerdictHistoryRepository].
class MockVerdictHistoryRepository implements VerdictHistoryRepository {
  MockVerdictHistoryRepository({List<VerdictHistoryItem>? initialItems})
      : _items = initialItems != null ? List.of(initialItems) : [];

  final List<VerdictHistoryItem> _items;

  static const _maxItems = 50;

  @override
  Future<List<VerdictHistoryItem>> getHistory() async => List.unmodifiable(_items);

  @override
  Future<void> addItem(VerdictHistoryItem item) async {
    _items.insert(0, item);
    if (_items.length > _maxItems) _items.removeLast();
  }

  @override
  Future<void> clearHistory() async => _items.clear();

  @override
  Future<void> removeAt(int index) async {
    if (index >= 0 && index < _items.length) _items.removeAt(index);
  }
}
