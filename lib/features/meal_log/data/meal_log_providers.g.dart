// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealRepositoryHash() => r'7becc2405cb492ff1b0e459fd20c7152b999ccdd';

/// [MealRepository] 공급자.
///
/// 기본값: [MealRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())]
///
/// Copied from [mealRepository].
@ProviderFor(mealRepository)
final mealRepositoryProvider = AutoDisposeProvider<MealRepository>.internal(
  mealRepository,
  name: r'mealRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealRepositoryRef = AutoDisposeProviderRef<MealRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
