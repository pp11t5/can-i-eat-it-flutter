// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRepositoryHash() => r'f0b6d66174484b7c9d6f8e8aff1be12e4011efb0';

/// [HomeRepository] 공급자.
///
/// 기본값: [HomeRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [homeRepositoryProvider.overrideWithValue(MockHomeRepository.seeded())]
///
/// Copied from [homeRepository].
@ProviderFor(homeRepository)
final homeRepositoryProvider = AutoDisposeProvider<HomeRepository>.internal(
  homeRepository,
  name: r'homeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeRepositoryRef = AutoDisposeProviderRef<HomeRepository>;
String _$myStreakHash() => r'cca7d2d6d0d7fb42a92902ffab4864c5a39dd3ed';

/// 현재 사용자의 편안한 증상 기록 연속일을 조회한다.
///
/// [HomeScreen] 인사말이 구독한다. 오류 시 화면은 `—`로 폴백한다.
///
/// Copied from [myStreak].
@ProviderFor(myStreak)
final myStreakProvider = AutoDisposeFutureProvider<int>.internal(
  myStreak,
  name: r'myStreakProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyStreakRef = AutoDisposeFutureProviderRef<int>;
String _$unrecordedMealCountHash() =>
    r'923c9eafcd0d063d97f90fca4787015cd1109d45';

/// 미기록 식단 개수를 조회한다. [HomeScreen] _HomeEntryCard 배지가 구독.
///
/// Copied from [unrecordedMealCount].
@ProviderFor(unrecordedMealCount)
final unrecordedMealCountProvider = AutoDisposeFutureProvider<int>.internal(
  unrecordedMealCount,
  name: r'unrecordedMealCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unrecordedMealCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnrecordedMealCountRef = AutoDisposeFutureProviderRef<int>;
String _$recentMealsHash() => r'9630af328c78b6ebaf74d75a39e0aced71cd9180';

/// 최근 식사 목록을 조회한다. [HomeScreen] "최근 식사" 섹션이 구독.
///
/// Copied from [recentMeals].
@ProviderFor(recentMeals)
final recentMealsProvider =
    AutoDisposeFutureProvider<List<RecentMeal>>.internal(
  recentMeals,
  name: r'recentMealsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recentMealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentMealsRef = AutoDisposeFutureProviderRef<List<RecentMeal>>;
String _$topSearchedFoodsHash() => r'8161ad84ef5209bed55bfaaf7391e0bf848aebcd';

/// 전체 사용자의 인기 검색 음식 목록을 조회한다.
///
/// [HomeScreen]이 제안 칩 행을 구독한다. 빈 목록·오류에서는 행을 숨긴다.
///
/// Copied from [topSearchedFoods].
@ProviderFor(topSearchedFoods)
final topSearchedFoodsProvider =
    AutoDisposeFutureProvider<List<FoodSummary>>.internal(
  topSearchedFoods,
  name: r'topSearchedFoodsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$topSearchedFoodsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TopSearchedFoodsRef = AutoDisposeFutureProviderRef<List<FoodSummary>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
