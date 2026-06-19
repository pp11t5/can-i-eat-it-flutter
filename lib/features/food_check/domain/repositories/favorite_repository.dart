import 'package:can_i_eat_it/features/food_check/domain/entities/favorite_item.dart';

/// 즐겨찾기 저장소 인터페이스.
///
/// 프로덕션: [LocalFavoriteRepository] (shared_preferences).
/// 테스트: [MockFavoriteRepository] (in-memory).
abstract class FavoriteRepository {
  /// 저장된 즐겨찾기 전체 반환. 저장 순 역순 (최신 먼저).
  Future<List<FavoriteItem>> getAll();

  /// 즐겨찾기 저장.
  Future<void> save(FavoriteItem item);

  /// [foodName] 기준으로 즐겨찾기 제거.
  Future<void> remove(String foodName);

  /// [foodName]이 즐겨찾기에 있는지 여부.
  Future<bool> isFavorite(String foodName);
}
