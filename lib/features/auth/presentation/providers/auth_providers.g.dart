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
String _$googleAuthServiceHash() => r'02cdadc479800895642ddcff51ff65a504f71e80';

/// [GoogleAuthService] 공급자.
///
/// 테스트에서는 `ProviderScope(overrides: [googleAuthServiceProvider.overrideWithValue(...)])` 로
/// stub 을 주입한다.
///
/// Copied from [googleAuthService].
@ProviderFor(googleAuthService)
final googleAuthServiceProvider =
    AutoDisposeProvider<GoogleAuthService>.internal(
  googleAuthService,
  name: r'googleAuthServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleAuthServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleAuthServiceRef = AutoDisposeProviderRef<GoogleAuthService>;
String _$authRepositoryHash() => r'a79dc22eb8b0b770f925f18002cceaeb65fb96ea';

/// [AuthRepository] 공급자.
///
/// 기본값: 실 [AuthRepositoryImpl] (카카오/애플/구글 SDK + 서버 JWT).
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
String _$consentTermsHash() => r'd6bb528385d8243e230c404b80e9a5204b8c71f2';

/// 서버 최신 약관을 시안 순서로 정렬해 제공한다.
///
/// 필수 항목을 먼저 두고, 알려진 코드는 tos → privacy → marketing 순서를
/// 사용한다. 미지 코드는 같은 필수 그룹 안에서 서버 순서를 유지한다.
///
/// Copied from [consentTerms].
@ProviderFor(consentTerms)
final consentTermsProvider =
    AutoDisposeFutureProvider<List<ConsentTerm>>.internal(
  consentTerms,
  name: r'consentTermsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$consentTermsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsentTermsRef = AutoDisposeFutureProviderRef<List<ConsentTerm>>;
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
String _$consentNavigationTransitionHash() =>
    r'37211e3b39db8b7cf95c693134ebd5f141dd26d7';

/// 약관 제출 성공 후 `/terms`에서 온보딩으로 교체 이동하는 짧은 전환 상태.
///
/// 이 상태가 true인 동안에만 `needsOnboarding`의 `/terms` 체류를 가드가
/// 허용한다. 직접 딥링크는 항상 온보딩 첫 화면으로 보낸다.
///
/// Copied from [ConsentNavigationTransition].
@ProviderFor(ConsentNavigationTransition)
final consentNavigationTransitionProvider =
    NotifierProvider<ConsentNavigationTransition, bool>.internal(
  ConsentNavigationTransition.new,
  name: r'consentNavigationTransitionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consentNavigationTransitionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConsentNavigationTransition = Notifier<bool>;
String _$authControllerHash() => r'122f4e2a2176391b294db682d5206154b53d6c5a';

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
    AsyncNotifierProvider<AuthController, AuthSession?>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AsyncNotifier<AuthSession?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
