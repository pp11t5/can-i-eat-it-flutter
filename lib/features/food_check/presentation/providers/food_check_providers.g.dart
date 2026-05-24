// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_check_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodRepositoryHash() => r'8df16829fa81c8fc929b47ba9b4de2a07674a571';

/// See also [foodRepository].
@ProviderFor(foodRepository)
final foodRepositoryProvider = AutoDisposeProvider<FoodRepository>.internal(
  foodRepository,
  name: r'foodRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodRepositoryRef = AutoDisposeProviderRef<FoodRepository>;
String _$foodCheckControllerHash() =>
    r'692e341474fcc77f3cb8eb946876dbb30d7fca92';

/// 음식 판별 액션과 결과 상태를 보유하는 컨트롤러.
/// build()는 초기(미조회) 상태인 null 을 반환한다.
///
/// Copied from [FoodCheckController].
@ProviderFor(FoodCheckController)
final foodCheckControllerProvider =
    AutoDisposeAsyncNotifierProvider<FoodCheckController, EatVerdict?>.internal(
  FoodCheckController.new,
  name: r'foodCheckControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodCheckControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FoodCheckController = AutoDisposeAsyncNotifier<EatVerdict?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
