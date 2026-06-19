// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mypageSessionHash() => r'5e010dee04cb9320266ffa07011a8c4c2ae1ab46';

/// 마이페이지에서 사용하는 현재 [AuthSession]을 re-export 한다.
///
/// UI는 이 provider를 watch해 계정 식별정보(displayName·email·profileImageUrl)를 표시한다.
/// 실질적으로 [authControllerProvider]를 위임하므로 상태는 항상 동기화된다.
///
/// Copied from [mypageSession].
@ProviderFor(mypageSession)
final mypageSessionProvider =
    AutoDisposeProvider<AsyncValue<AuthSession?>>.internal(
  mypageSession,
  name: r'mypageSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mypageSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MypageSessionRef = AutoDisposeProviderRef<AsyncValue<AuthSession?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
