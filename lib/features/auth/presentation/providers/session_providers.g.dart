// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionStatusHash() => r'3655d4fd45fefd1c0e4239ad486afd84b3d56912';

/// [AuthController] + [HealthProfileController] 상태로부터 파생된 세션 상태.
///
/// 미인증/약관 미동의 단계에서는 health_profile을 watch하지 않는다(불필요 로딩 회피).
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
