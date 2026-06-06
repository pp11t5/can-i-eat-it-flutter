// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthProfileRepositoryHash() =>
    r'2dd062fc130b3585abe75cc4fc00bc78cca14267';

/// [HealthProfileRepository] 공급자.
///
/// 기본값: [MockHealthProfileRepository.noProfile] (신규 사용자, 온보딩 필요).
/// 실 구현 교체 지점: ProviderScope override로 retrofit 구현을 주입한다.
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
String _$healthProfileControllerHash() =>
    r'10eb3601ff2a37f005f8020ce4a4b65f4cf226e7';

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
