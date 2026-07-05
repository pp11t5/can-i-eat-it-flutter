// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodCategoryRepositoryHash() =>
    r'39ccc89d09290f80d2cced71f785741558eca8bd';

/// [FoodCategoryRepository] 공급자.
///
/// 기본값: [FoodCategoryRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodCategoryRepositoryProvider.overrideWithValue(MockFoodCategoryRepository.seeded())]
///
/// Copied from [foodCategoryRepository].
@ProviderFor(foodCategoryRepository)
final foodCategoryRepositoryProvider =
    AutoDisposeProvider<FoodCategoryRepository>.internal(
  foodCategoryRepository,
  name: r'foodCategoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodCategoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodCategoryRepositoryRef
    = AutoDisposeProviderRef<FoodCategoryRepository>;
String _$foodCategoriesHash() => r'dc0a37ab3b682b968edeeab9a5a9539099fdfb6c';

/// 음식 카테고리 전체 목록을 조회한다.
///
/// `category_icon.dart` 하드코딩 매핑 대체 예정 — 현재 구독처 없음.
///
/// Copied from [foodCategories].
@ProviderFor(foodCategories)
final foodCategoriesProvider =
    AutoDisposeFutureProvider<List<FoodCategory>>.internal(
  foodCategories,
  name: r'foodCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodCategoriesRef = AutoDisposeFutureProviderRef<List<FoodCategory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
