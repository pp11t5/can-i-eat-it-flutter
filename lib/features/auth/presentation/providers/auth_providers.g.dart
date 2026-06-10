// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$kakaoAuthServiceHash() => r'9758f86e51a63228dfad03c9ef145f6ca1b7b731';

/// [KakaoAuthService] 공급자.
///
/// 테스트에서는 `ProviderScope(overrides: [kakaoAuthServiceProvider.overrideWithValue(...)])` 로
/// stub 을 주입한다.
///
/// Copied from [kakaoAuthService].
@ProviderFor(kakaoAuthService)
final kakaoAuthServiceProvider = AutoDisposeProvider<KakaoAuthService>.internal(
  kakaoAuthService,
  name: r'kakaoAuthServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$kakaoAuthServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef KakaoAuthServiceRef = AutoDisposeProviderRef<KakaoAuthService>;
String _$authRepositoryHash() => r'168be4e7cf75eb13be117e59d3fedaf5bba8dcbd';

/// [AuthRepository] 공급자.
///
/// 기본값: 실 [AuthRepositoryImpl] (카카오 SDK + 서버 JWT).
/// 테스트 / 오프라인 환경에서는 [MockAuthRepository] 를 override 로 주입한다.
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
String _$authControllerHash() => r'a0fe1dad7fb051f26232b3450d6ecd1b04be2762';

/// 인증 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [AuthRepository.currentSession]을 호출해 초기 세션을 로드한다.
///
/// ## onSessionExpired seam 배선 (ADR-0007 §3-1 (4))
/// [build] 시점에 [dioProvider] 의 [AuthInterceptor.onSessionExpired] 를
/// [_onSessionExpired] 로 배선한다.
/// 순환참조 없음: dioProvider → AuthInterceptor(seam=null) 먼저 생성 →
/// AuthController.build() 가 post-init 으로 seam 주입.
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
