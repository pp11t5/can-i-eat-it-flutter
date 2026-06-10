// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_check_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodRepositoryHash() => r'6e65ecf198a55e4b72370bc58bedd101642d18a9';

/// [FoodRepository] 공급자.
///
/// 기본값: [MockFoodRepository.empty] (서버 API 미확정, W3 Mock 단계).
/// 실 구현 교체 지점: 티켓 6에서 retrofit 구현 완성 시
///   ProviderScope overrides로 실제 datasource 구현을 주입한다.
///   이 인터페이스(FoodRepository)는 불변 — 교체 시 이 줄만 변경한다.
///
/// Copied from [foodRepository].
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
String _$verdictControllerHash() => r'8e99ee70fad44cf55339e27eb4083d9befac0300';

/// 판정 컨트롤러.
///
/// [analyze] 호출 → [FoodRepository.analyze] → [AsyncValue<EatVerdict>].
/// - 로딩 중: [AsyncLoading] → VerdictLoadingScreen.
/// - [VerdictLevel.unknown]: VerdictUnknownScreen.
/// - 그 외: VerdictResultScreen.
///
/// 성공 시 [FunnelEvent.firstVerdictChecked] 발화.
///
/// Copied from [VerdictController].
@ProviderFor(VerdictController)
final verdictControllerProvider = AutoDisposeNotifierProvider<VerdictController,
    AsyncValue<EatVerdict>>.internal(
  VerdictController.new,
  name: r'verdictControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verdictControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VerdictController = AutoDisposeNotifier<AsyncValue<EatVerdict>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
