// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_food_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentFoodControllerHash() =>
    r'389df54e03585e38b5697aa8bb1b675dc3c801f4';

/// 최근 검색 상태 컨트롤러 (ADR-0007 §3-1 (C), 티켓 6).
///
/// [SearchHistoryController] (String 기반)를 [RecentFood] 엔티티 기반으로 대체한다.
/// [FoodRepository.recentSearches] / [addRecent] / [removeRecent] / [clearRecent]
/// 를 단일 [FoodRepository]를 통해 호출한다.
///
/// 테스트 override:
///   foodRepositoryProvider.overrideWithValue(MockFoodRepository.withRecent([...]))
///
/// Copied from [RecentFoodController].
@ProviderFor(RecentFoodController)
final recentFoodControllerProvider = AutoDisposeAsyncNotifierProvider<
    RecentFoodController, List<RecentFood>>.internal(
  RecentFoodController.new,
  name: r'recentFoodControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentFoodControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentFoodController = AutoDisposeAsyncNotifier<List<RecentFood>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
