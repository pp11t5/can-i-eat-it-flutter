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
String _$appleAuthServiceHash() => r'd36bf205ecfab1387babde805e367c0f679566e3';

/// [AppleAuthService] 공급자.
///
/// 테스트에서는 `ProviderScope(overrides: [appleAuthServiceProvider.overrideWithValue(...)])` 로
/// stub 을 주입한다.
///
/// Copied from [appleAuthService].
@ProviderFor(appleAuthService)
final appleAuthServiceProvider = AutoDisposeProvider<AppleAuthService>.internal(
  appleAuthService,
  name: r'appleAuthServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appleAuthServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppleAuthServiceRef = AutoDisposeProviderRef<AppleAuthService>;
String _$authRepositoryHash() => r'5e6ad1c9554f83dc25313ff51199f52423451a1e';

/// [AuthRepository] 공급자.
///
/// 기본값: 실 [AuthRepositoryImpl] (카카오/애플 SDK + 서버 JWT).
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
String _$coldStartOfflineHash() => r'0465748031e5b0c25e7a655f68622e61e6152293';

/// 콜드스타트 시 오프라인 복원 플래그를 소비해 반환하는 provider.
///
/// true 이면 LoginScreen 이 T1 토스트를 표시한다.
/// [AuthRepository.consumeOfflineRestoreFlag] 를 1회 소비(읽으면 false 로 리셋).
///
/// Copied from [coldStartOffline].
@ProviderFor(coldStartOffline)
final coldStartOfflineProvider = AutoDisposeProvider<bool>.internal(
  coldStartOffline,
  name: r'coldStartOfflineProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$coldStartOfflineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ColdStartOfflineRef = AutoDisposeProviderRef<bool>;
String _$authControllerHash() => r'2ab836920ad523ce37b599a32c0d08cad15cb499';

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
