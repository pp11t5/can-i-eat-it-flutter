import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/food_check/data/repositories/local_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/favorite_item.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/favorite_repository.dart';

part 'favorite_providers.g.dart';

/// [FavoriteRepository] 공급자.
///
/// 기본값: [LocalFavoriteRepository] (shared_preferences).
/// 테스트 override:
///   ProviderScope overrides: [favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository())]
@riverpod
FavoriteRepository favoriteRepository(Ref ref) => LocalFavoriteRepository();

/// 즐겨찾기 전체 목록 provider.
///
/// `ref.invalidate(favoriteListProvider)` 로 삭제 후 갱신한다.
@riverpod
Future<List<FavoriteItem>> favoriteList(Ref ref) =>
    ref.watch(favoriteRepositoryProvider).getAll();

/// 즐겨찾기 토글 컨트롤러.
///
/// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
/// toggle: 즐겨찾기 추가 ↔ 제거 전환.
@riverpod
class FavoriteController extends _$FavoriteController {
  @override
  Future<bool> build(String foodName) =>
      ref.read(favoriteRepositoryProvider).isFavorite(foodName);

  /// 즐겨찾기 토글.
  ///
  /// 현재 상태가 즐겨찾기 없음이면 [verdict]를 저장, 있으면 제거한다.
  Future<void> toggle(EatVerdict verdict) async {
    final repo = ref.read(favoriteRepositoryProvider);
    final current = state.valueOrNull ?? false;

    state = const AsyncLoading();
    try {
      if (current) {
        await repo.remove(verdict.foodName);
        state = const AsyncData(false);
      } else {
        await repo.save(
          FavoriteItem(
            foodName: verdict.foodName,
            level: verdict.level,
            savedAt: DateTime.now(),
            foodExternalId: verdict.foodExternalId,
          ),
        );
        state = const AsyncData(true);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
