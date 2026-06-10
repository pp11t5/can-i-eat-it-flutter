// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_check_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodRepositoryHash() => r'e664a8ae03fdc1a3d465d915680ac8021c06d376';

/// [FoodRepository] 공급자.
///
/// 기본값: [FoodRepositoryImpl] — 실 서버 연동 (ADR-0007 §3-1 (5), 티켓 6).
/// - search / recent CRUD: 실 `/foods/*` 엔드포인트.
/// - analyze: [MockFoodRepository] 위임 (서버 미출시, W3 Mock 유지).
///   // TODO(server): analyze 서버 출시 시 FoodRepositoryImpl 내부에서 교체.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty())]
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
