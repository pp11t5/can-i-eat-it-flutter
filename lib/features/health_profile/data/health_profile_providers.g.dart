// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthProfileRepositoryHash() =>
    r'2dd062fc130b3585abe75cc4fc00bc78cca14267';

/// [HealthProfileRepository] 공급자.
///
/// 기본값: [MockHealthProfileRepository.noProfile] (테스트·오프라인 안전).
/// 실 앱에서는 main.dart ProviderScope override 로 [HealthProfileRepositoryImpl] 을 주입한다.
/// (ADR-0007 §3-1 (6-D): 서버 API 계약 기반 실연동)
///
/// Copied from [healthProfileRepository].
@ProviderFor(healthProfileRepository)
final healthProfileRepositoryProvider =
    AutoDisposeProvider<HealthProfileRepository>.internal(
  healthProfileRepository,
  name: r'healthProfileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthProfileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HealthProfileRepositoryRef
    = AutoDisposeProviderRef<HealthProfileRepository>;
String _$onboardedStatusHash() => r'261b515f4f604aed6b2062c6ad180acde41d874d';

/// 온보딩 완료 여부 AsyncNotifier (ADR-0007 §3-1 (6-D)).
///
/// [sessionStatus] provider가 이 값을 `hasProfile` 소스로 사용한다.
/// [HealthProfileRepository.onboardedStatus]를 호출해 boolean을 반환한다.
/// 로딩 중에는 hasProfile=null → SessionStatus.loading 유지.
///
/// Copied from [onboardedStatus].
@ProviderFor(onboardedStatus)
final onboardedStatusProvider = AutoDisposeFutureProvider<bool>.internal(
  onboardedStatus,
  name: r'onboardedStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardedStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OnboardedStatusRef = AutoDisposeFutureProviderRef<bool>;
String _$healthProfileControllerHash() =>
    r'709031e73cbdd7c1d137a09bdf41050b6fa04925';

/// 건강 프로필 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [HealthProfileRepository.currentProfile]을 호출해 초기 프로필을 로드한다.
/// [submit]: 온보딩 완료 시 프로필을 저장하고 상태를 갱신한다.
/// 다음 Phase의 온보딩 컨트롤러가 [submit]을 호출한다.
///
/// Copied from [HealthProfileController].
@ProviderFor(HealthProfileController)
final healthProfileControllerProvider = AutoDisposeAsyncNotifierProvider<
    HealthProfileController, HealthProfile?>.internal(
  HealthProfileController.new,
  name: r'healthProfileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthProfileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HealthProfileController = AutoDisposeAsyncNotifier<HealthProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
