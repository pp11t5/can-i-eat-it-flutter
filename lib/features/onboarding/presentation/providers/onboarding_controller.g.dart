// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingControllerHash() =>
    r'43b326d023c4edee69dea51d8f3b108e45a4bfe9';

/// 온보딩 입력 드래프트를 관리하는 컨트롤러.
///
/// 각 스텝의 입력을 불변 copyWith로 누적한다.
/// 제출은 [OnboardingSubmit]이 담당하므로 이 컨트롤러의 state는 항상 보존된다.
///
/// Copied from [OnboardingController].
@ProviderFor(OnboardingController)
final onboardingControllerProvider =
    AutoDisposeNotifierProvider<OnboardingController, OnboardingDraft>.internal(
  OnboardingController.new,
  name: r'onboardingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnboardingController = AutoDisposeNotifier<OnboardingDraft>;
String _$onboardingSubmitHash() => r'b8ae01afff194e2cac4a28542f6e7d9739d28615';

/// 온보딩 완료 제출을 담당하는 AsyncNotifier.
///
/// 드래프트는 [OnboardingController]가 소유하므로 제출 실패 시에도 입력이 보존된다.
/// 성공 시 [healthProfileControllerProvider] 게이트를 플립하고
/// [FunnelEvent.onboardingCompleted]를 발화한다.
///
/// Copied from [OnboardingSubmit].
@ProviderFor(OnboardingSubmit)
final onboardingSubmitProvider =
    AutoDisposeNotifierProvider<OnboardingSubmit, AsyncValue<void>>.internal(
  OnboardingSubmit.new,
  name: r'onboardingSubmitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingSubmitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnboardingSubmit = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
