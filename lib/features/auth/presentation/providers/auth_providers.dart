import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/network/auth_interceptor.dart';
import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';

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
// AuthRepository provider
// ---------------------------------------------------------------------------

/// [AuthRepository] 공급자.
///
/// 기본값: 실 [AuthRepositoryImpl] (카카오 SDK + 서버 JWT).
/// 테스트 / 오프라인 환경에서는 [MockAuthRepository] 를 override 로 주입한다.
@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      dio: ref.watch(dioProvider),
      tokenStore: ref.watch(tokenStoreProvider),
      kakaoAuthService: ref.watch(kakaoAuthServiceProvider),
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
  Future<SignInOutcome> signInWithKakao() async {
    final outcome = await ref.read(authRepositoryProvider).signInWithKakao();
    _applyOutcomeToState(outcome, AuthProvider.kakao);
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
  Future<SignInOutcome> signInWithApple() async {
    final outcome = await ref.read(authRepositoryProvider).signInWithApple();
    _applyOutcomeToState(outcome, AuthProvider.apple);
    if (outcome is! Recoverable) {
      await ref
          .read(analyticsServiceProvider)
          .logFunnel(FunnelEvent.signUp, params: {'provider': 'apple'});
    }
    return outcome;
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
  }

  /// 서버 로그아웃 + 로컬 세션 초기화.
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }

  /// 로컬 세션만 초기화 (오프라인 signOut).
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
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
