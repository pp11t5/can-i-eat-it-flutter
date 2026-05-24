// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conditionRepositoryHash() =>
    r'9996d89303e9be718f6d2c2351de6492e245beb9';

/// See also [conditionRepository].
@ProviderFor(conditionRepository)
final conditionRepositoryProvider =
    AutoDisposeProvider<ConditionRepository>.internal(
  conditionRepository,
  name: r'conditionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conditionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConditionRepositoryRef = AutoDisposeProviderRef<ConditionRepository>;
String _$availableConditionsHash() =>
    r'1319094675366251b3b065a2614acdca7d57536c';

/// See also [availableConditions].
@ProviderFor(availableConditions)
final availableConditionsProvider =
    AutoDisposeFutureProvider<List<HealthCondition>>.internal(
  availableConditions,
  name: r'availableConditionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableConditionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableConditionsRef
    = AutoDisposeFutureProviderRef<List<HealthCondition>>;
String _$selectedConditionsHash() =>
    r'14d6a257c61371d5ddbae09beeee6e119e514df7';

/// 사용자가 선택한 기저질환 집합. 데모는 메모리 보관 — 추후 로컬 저장/서버 동기화.
///
/// Copied from [SelectedConditions].
@ProviderFor(SelectedConditions)
final selectedConditionsProvider = AutoDisposeNotifierProvider<
    SelectedConditions, List<HealthCondition>>.internal(
  SelectedConditions.new,
  name: r'selectedConditionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedConditionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedConditions = AutoDisposeNotifier<List<HealthCondition>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
