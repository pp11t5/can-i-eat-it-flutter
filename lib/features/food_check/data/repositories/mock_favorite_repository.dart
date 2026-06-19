import 'package:can_i_eat_it/features/food_check/domain/entities/favorite_item.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/favorite_repository.dart';

/// 테스트용 인메모리 [FavoriteRepository].
class MockFavoriteRepository implements FavoriteRepository {
  MockFavoriteRepository({List<FavoriteItem>? initial})
      : _items = initial != null ? List.of(initial) : [];

  final List<FavoriteItem> _items;

  @override
  Future<List<FavoriteItem>> getAll() async =>
      List.unmodifiable(_items.reversed.toList());

  @override
  Future<void> save(FavoriteItem item) async {
    // 동일 foodName이 이미 있으면 교체
    _items.removeWhere((e) => e.foodName == item.foodName);
    _items.add(item);
  }

  @override
  Future<void> remove(String foodName) async {
    _items.removeWhere((e) => e.foodName == foodName);
  }

  @override
  Future<bool> isFavorite(String foodName) async =>
      _items.any((e) => e.foodName == foodName);
}
