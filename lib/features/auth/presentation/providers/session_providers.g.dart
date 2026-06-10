// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionStatusHash() => r'18ca41ddb51adbb9d4349e58dba95a82f433eeab';

/// [AuthController] + [onboardedStatusProvider] 상태로부터 파생된 세션 상태.
///
/// 미인증/약관 미동의 단계에서는 health_profile을 watch하지 않는다(불필요 로딩 회피).
/// 게이트 소스: `currentProfile() != null` → `onboardedStatus()` (ADR-0007 §3-1 (6-D)).
///
/// Copied from [sessionStatus].
@ProviderFor(sessionStatus)
final sessionStatusProvider = AutoDisposeProvider<SessionStatus>.internal(
  sessionStatus,
  name: r'sessionStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionStatusRef = AutoDisposeProviderRef<SessionStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
