// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionStatusHash() => r'1b00efe516d8bb85ee2806154b13e067c378f72a';

/// [AuthController] 상태에서 파생된 세션 상태.
/// 로딩 중 valueOrNull == null → unauthenticated(W1 mock은 즉시 resolve).
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
