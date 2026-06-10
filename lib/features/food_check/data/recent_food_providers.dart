import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';

part 'recent_food_providers.g.dart';

/// 최근 검색 상태 컨트롤러 (ADR-0007 §3-1 (C), 티켓 6).
///
/// [SearchHistoryController] (String 기반)를 [RecentFood] 엔티티 기반으로 대체한다.
/// [FoodRepository.recentSearches] / [addRecent] / [removeRecent] / [clearRecent]
/// 를 단일 [FoodRepository]를 통해 호출한다.
///
/// 테스트 override:
///   foodRepositoryProvider.overrideWithValue(MockFoodRepository.withRecent([...]))
@riverpod
class RecentFoodController extends _$RecentFoodController {
  @override
  Future<List<RecentFood>> build() async {
    return ref.watch(foodRepositoryProvider).recentSearches();
  }

  /// 최근 검색 항목을 추가하고 목록을 갱신한다.
  ///
  /// [foodExternalId]: 서버측 음식 식별자 (POST /foods/recent).
  Future<void> addRecent(String foodExternalId) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.addRecent(foodExternalId);
    state = AsyncData(await repo.recentSearches());
  }

  /// 특정 최근 검색 항목을 제거하고 목록을 갱신한다.
  ///
  /// [foodExternalId]: 제거할 항목의 서버측 식별자 (DELETE /foods/recent/{id}).
  Future<void> removeRecent(String foodExternalId) async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.removeRecent(foodExternalId);
    state = AsyncData(await repo.recentSearches());
  }

  /// 모든 최근 검색 항목을 삭제하고 목록을 갱신한다 (DELETE /foods/recent).
  Future<void> clear() async {
    final repo = ref.read(foodRepositoryProvider);
    await repo.clearRecent();
    state = const AsyncData([]);
  }
}
