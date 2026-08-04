import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/network/auth_interceptor.dart';
import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:can_i_eat_it/features/auth/data/services/apple_auth_service.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/meal_log/data/sources/timeline_guide_store.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';

part 'auth_providers.g.dart';

// ---------------------------------------------------------------------------
// KakaoAuthService provider
// ---------------------------------------------------------------------------

/// [KakaoAuthService] 공급자.
///
/// 테스트에서는 `ProviderScope(overrides: [kakaoAuthServiceProvider.overrideWithValue(...)])` 로
/// stub 을 주입한다.
@riverpod
KakaoAuthService kakaoAuthService(Ref ref) => KakaoAuthServiceImpl();

// ---------------------------------------------------------------------------
// AppleAuthService provider
// ---------------------------------------------------------------------------

/// [AppleAuthService] 공급자.
///
/// 테스트에서는 `ProviderScope(overrides: [appleAuthServiceProvider.overrideWithValue(...)])` 로
/// stub 을 주입한다.
@riverpod
AppleAuthService appleAuthService(Ref ref) => AppleAuthServiceImpl();

// ---------------------------------------------------------------------------
// AuthRepository provider
// ---------------------------------------------------------------------------

/// [AuthRepository] 공급자.
///
/// 기본값: 실 [AuthRepositoryImpl] (카카오/애플 SDK + 서버 JWT).
/// 테스트 / 오프라인 환경에서는 [MockAuthRepository] 를 override 로 주입한다.
@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      dio: ref.watch(dioProvider),
      tokenStore: ref.watch(tokenStoreProvider),
      kakaoAuthService: ref.watch(kakaoAuthServiceProvider),
      appleAuthService: ref.watch(appleAuthServiceProvider),
    );

// ---------------------------------------------------------------------------
// coldStartOfflineProvider
// ---------------------------------------------------------------------------

/// 콜드스타트 시 오프라인 복원 플래그를 소비해 반환하는 provider.
///
/// true 이면 LoginScreen 이 T1 토스트를 표시한다.
/// [AuthRepository.consumeOfflineRestoreFlag] 를 1회 소비(읽으면 false 로 리셋).
@riverpod
bool coldStartOffline(Ref ref) =>
    ref.watch(authRepositoryProvider).consumeOfflineRestoreFlag();

// ---------------------------------------------------------------------------
// AuthController
// ---------------------------------------------------------------------------

/// 인증 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [AuthRepository.currentSession]을 호출해 초기 세션을 로드한다.
///
/// ## onSessionExpired seam 배선 (ADR-0007 §3-1 (4))
/// [build] 시점에 [dioProvider] 의 [AuthInterceptor.onSessionExpired] 를
/// [_onSessionExpired] 로 배선한다.
/// 순환참조 없음: dioProvider → AuthInterceptor(seam=null) 먼저 생성 →
/// AuthController.build() 가 post-init 으로 seam 주입.
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthSession?> build() async {
    _wireSessionExpiredSeam();
    return ref.watch(authRepositoryProvider).currentSession();
  }

  /// 카카오 계정으로 로그인하고 [SignInOutcome]을 반환한다.
  ///
  /// [Authenticated] 또는 [NeedsTerms] 시 [FunnelEvent.signUp] 퍼널 이벤트를 발화한다 (US-SYS-2).
  /// [Recoverable](복구 필요)은 가입 퍼널 진입으로 보지 않아 발화하지 않는다.
  ///
  /// [Authenticated] 시 [getMe]로 displayName 등 식별정보를 채운 뒤 반환한다
  /// (로그인 DTO에는 nickname이 없어 마이페이지가 '사용자'로 뜨던 문제 방지).
  Future<SignInOutcome> signInWithKakao() async {
    final outcome = await ref.read(authRepositoryProvider).signInWithKakao();
    _applyOutcomeToState(outcome, AuthProvider.kakao);
    if (outcome is Authenticated) {
      // FCM 토큰 등록 — fire-and-forget(로그인 UX 블로킹 제거).
      // 실패해도 로그인 흐름을 막지 않는다(graceful).
      unawaited(ref.read(fcmLifecycleProvider).registerCurrentToken());
      await _hydrateSessionAfterAuth();
    }
    if (outcome is! Recoverable) {
      await ref
          .read(analyticsServiceProvider)
          .logFunnel(FunnelEvent.signUp, params: {'provider': 'kakao'});
    }
    return outcome;
  }

  /// Apple 계정으로 로그인하고 [SignInOutcome]을 반환한다.
  ///
  /// [Authenticated] 또는 [NeedsTerms] 시 [FunnelEvent.signUp] 퍼널 이벤트를 발화한다 (US-SYS-2).
  /// [Recoverable](복구 필요)은 가입 퍼널 진입으로 보지 않아 발화하지 않는다.
  ///
  /// [Authenticated] 시 [getMe]로 displayName 등 식별정보를 채운 뒤 반환한다
  /// (로그인 DTO에는 nickname이 없어 마이페이지가 '사용자'로 뜨던 문제 방지).
  Future<SignInOutcome> signInWithApple() async {
    final outcome = await ref.read(authRepositoryProvider).signInWithApple();
    _applyOutcomeToState(outcome, AuthProvider.apple);
    if (outcome is Authenticated) {
      // FCM 토큰 등록 — fire-and-forget(로그인 UX 블로킹 제거).
      // 실패해도 로그인 흐름을 막지 않는다(graceful).
      unawaited(ref.read(fcmLifecycleProvider).registerCurrentToken());
      await _hydrateSessionAfterAuth();
    }
    if (outcome is! Recoverable) {
      await ref
          .read(analyticsServiceProvider)
          .logFunnel(FunnelEvent.signUp, params: {'provider': 'apple'});
    }
    return outcome;
  }

  /// 로그인 직후 [getMe]로 세션 식별정보를 채운다.
  ///
  /// 로그인 응답에는 nickname/email/profileImage가 없고, 마이페이지 등은
  /// [AuthSession.displayName]을 쓰므로 라우팅 전에 채워야 한다.
  /// getMe 실패해도 로그인은 유지한다(토큰·게이트 세션은 이미 적용됨).
  Future<void> _hydrateSessionAfterAuth() async {
    try {
      await getMe();
    } catch (_) {
      // 네트워크 등 — displayName 은 이후 프로필/콜드스타트 getMe 로 보완 가능.
    }
  }

  /// 약관 동의를 기록하고 세션 상태를 갱신한다.
  Future<void> agreeToTerms(TermsAgreement agreement) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.recordTermsAgreement(agreement);
    state = AsyncValue.data(await repo.currentSession());
  }

  /// 계정 삭제 유예 상태를 복구하고 세션 상태를 갱신한다.
  ///
  /// [provider]: [Recoverable.provider] 에서 전달받는다.
  /// [idToken]: [Recoverable.idToken] 에서 전달받는다. 카카오 SDK 재인증 없이 재사용.
  /// 실패 시 예외를 그대로 rethrow 하여 호출자(dialog)가 UI 에러를 표시하도록 한다.
  Future<void> recoverAccount(AuthProvider provider, {required String idToken}) async {
    final repo = ref.read(authRepositoryProvider);
    final session = await repo.recoverAccount(provider, idToken: idToken);
    state = AsyncValue.data(session);
    // 복구 성공 후 세션이 생겼으므로 FCM 토큰 등록 — fire-and-forget.
    // 실패해도 복구 흐름을 막지 않는다(graceful).
    unawaited(ref.read(fcmLifecycleProvider).registerCurrentToken());
  }

  /// in-flight [getMe] 를 무효화하기 위한 요청 세대.
  ///
  /// 프로필 진입 시 [getMe] 가 떠 있는 동안 닉네임을 저장하면, 늦게 도착한
  /// 구 응답이 새 displayName 을 덮어쓰는 레이스가 난다. [updateNickname] 성공
  /// 시 세대를 올려 그 이전 요청 결과를 버린다.
  int _meGeneration = 0;

  /// GET /auth/me 를 호출해 계정 식별정보(displayName·email·profileImageUrl)를 갱신한다.
  ///
  /// 성공 시 state 를 갱신된 세션으로 교체한다.
  /// 실패 시 예외를 그대로 rethrow 하여 호출자가 처리하도록 한다.
  ///
  /// [updateNickname] 이후 도착한 stale 응답은 state·로컬 캐시를 덮어쓰지 않는다.
  Future<AuthSession> getMe() async {
    final requestId = ++_meGeneration;
    final previous = state.valueOrNull;
    final session = await ref.read(authRepositoryProvider).getMe();
    if (requestId != _meGeneration) {
      // 닉네임 변경 등으로 무효화된 stale 응답.
      // repository._session 은 이미 구 값으로 덮였을 수 있어 현재 state 로 복구.
      final current = state.valueOrNull;
      final keepName = current?.displayName;
      if (keepName != null && keepName.isNotEmpty) {
        ref.read(authRepositoryProvider).applyLocalDisplayName(keepName);
      }
      return current ?? session;
    }
    // UserMe 가 email/profileImage 를 생략하면 기존 세션 값 유지.
    final merged = session.copyWith(
      email: session.email ?? previous?.email,
      profileImageUrl: session.profileImageUrl ?? previous?.profileImageUrl,
    );
    state = AsyncValue.data(merged);
    return merged;
  }

  /// 닉네임을 변경한다 (D3, `PATCH /my-page/nickname`).
  ///
  /// [myPageRepositoryProvider]를 호출해 서버 성공을 확인한 뒤에만 세션의
  /// [AuthSession.displayName]을 갱신한다(낙관적 갱신 금지 — updateHealthInfo와 동일 원칙).
  /// 실패(400/401/409/500)는 예외를 그대로 rethrow하여 호출자(NameEditScreen)가
  /// Failure 타입별로 에러 문구를 분기하도록 한다.
  Future<void> updateNickname(String nickname) async {
    await ref.read(myPageRepositoryProvider).updateNickname(nickname);
    // in-flight getMe 가 구 닉네임으로 state 를 덮지 못하게 무효화.
    _meGeneration++;
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(displayName: nickname));
    }
    // AuthRepositoryImpl._session 도 같이 맞춰 currentSession() 재빌드 시 유지.
    ref.read(authRepositoryProvider).applyLocalDisplayName(nickname);
  }

  /// 계정 탈퇴: 서버 withdraw + 로컬 세션·프로필 캐시·타임라인 가이드 플래그 초기화.
  Future<void> withdraw() async {
    // 세션 null 되기 전에 userId 확보 — 동일 userId 재가입 시 가이드 재노출.
    final userId = state.valueOrNull?.userId;
    // FCM 토큰 삭제 — authRepository.withdraw() 전(Bearer 유효 시점).
    // 실패해도 탈퇴 흐름을 막지 않는다(graceful).
    await ref.read(fcmLifecycleProvider).deleteToken();
    await ref.read(authRepositoryProvider).withdraw();
    await ref.read(profileCacheProvider).clear();
    // 가이드 플래그 삭제 실패해도 탈퇴 완료는 막지 않는다
    // (테스트 환경 MissingPluginException · 스토리지 오류 등).
    if (userId != null && userId.isNotEmpty) {
      try {
        await ref.read(timelineGuideStoreProvider).clearFabGuideSeen(userId);
      } catch (_) {}
    }
    state = const AsyncValue.data(null);
  }

  /// 서버 로그아웃 + 로컬 세션·프로필 캐시 초기화.
  Future<void> logout() async {
    // FCM 토큰 삭제 — authRepository.logout() 전(Bearer 유효 시점).
    // 실패해도 로그아웃 흐름을 막지 않는다(graceful).
    await ref.read(fcmLifecycleProvider).deleteToken();
    await ref.read(authRepositoryProvider).logout();
    await ref.read(profileCacheProvider).clear();
    state = const AsyncValue.data(null);
  }

  /// 로컬 세션만 초기화 (오프라인 signOut) + 프로필 캐시 초기화.
  ///
  /// 오프라인이므로 서버 호출(deleteToken) 없이 구독만 정리한다.
  Future<void> signOut() async {
    // 오프라인: 서버 DELETE 불가, 구독만 정리.
    ref.read(fcmLifecycleProvider).cancelRefreshSubscription();
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(profileCacheProvider).clear();
    state = const AsyncValue.data(null);
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  /// [SignInOutcome] 에 따라 컨트롤러 상태를 갱신한다.
  void _applyOutcomeToState(SignInOutcome outcome, AuthProvider provider) {
    switch (outcome) {
      case Authenticated(:final session):
        state = AsyncValue.data(session);
      case NeedsTerms():
        // 약관 미동의 — sessionStatusFrom 이 needsTerms 로 평가하도록
        // hasAgreedTerms=false 인 임시 세션을 설정한다.
        state = AsyncValue.data(
          AuthSession(
            userId: 'pending-terms',
            provider: provider,
            hasAgreedTerms: false,
          ),
        );
      case Recoverable():
        // 복구 가능 계정 — 토큰 미발급, 세션 없음 유지.
        state = const AsyncValue.data(null);
    }
  }

  /// AuthInterceptor.onSessionExpired seam 배선.
  ///
  /// [dioProvider] 의 Dio 인스턴스 interceptors 에서 [AuthInterceptor] 를 찾아
  /// [setOnSessionExpired] 로 [_onSessionExpired] 를 주입한다.
  void _wireSessionExpiredSeam() {
    final dio = ref.read(dioProvider);
    for (final interceptor in dio.interceptors) {
      if (interceptor is AuthInterceptor) {
        interceptor.setOnSessionExpired(_onSessionExpired);
        return;
      }
    }
  }

  /// [AuthInterceptor] 가 refresh 실패로 세션 만료를 알릴 때 호출된다.
  ///
  /// 세션을 null 로 전이시켜 sessionStatusProvider 가 unauthenticated 를 반환하도록 한다.
  void _onSessionExpired() {
    state = const AsyncValue.data(null);
  }
}
