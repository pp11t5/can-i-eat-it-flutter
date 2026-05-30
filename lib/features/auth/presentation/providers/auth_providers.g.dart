// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'da88ebfc6e94d877d49243d72c3ab02063a6c5de';

/// [AuthRepository] 공급자.
///
/// 기본값은 미인증 mock — 앱이 /login에서 시작한다.
/// 실 구현(카카오 SDK + 서버 JWT) 교체 시 ProviderScope override로 주입한다.
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$authControllerHash() => r'11954530c3ca47f7f44309d6247716193b2437aa';

/// 인증 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [AuthRepository.currentSession]을 호출해 초기 세션을 로드한다.
/// 공개 메서드로 로그인·약관 동의·계정 복구·로그아웃을 처리한다.
///
/// Copied from [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, AuthSession?>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AutoDisposeAsyncNotifier<AuthSession?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
