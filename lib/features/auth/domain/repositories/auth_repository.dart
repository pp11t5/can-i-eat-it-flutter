import '../entities/auth_session.dart';
import '../entities/sign_in_outcome.dart';
import '../entities/terms_agreement.dart';

/// 인증 저장소 인터페이스 (ADR-0007 §3-1 (6-A)).
///
/// 실 구현([AuthRepositoryImpl])은 카카오 OIDC + 서버 JWT 를 사용한다.
/// 테스트 / 오프라인 환경에서는 [MockAuthRepository] 를 override 로 주입한다.
abstract interface class AuthRepository {
  // ---------------------------------------------------------------------------
  // 세션 조회
  // ---------------------------------------------------------------------------

  /// 현재 세션을 반환한다. 미인증 상태이면 null.
  ///
  /// 콜드스타트 시 토큰이 있으면 GET /auth/me 로 재수화를 시도한다.
  /// - 토큰 없음 → null.
  /// - getMe 성공 → 세션 반환.
  /// - NetworkFailure(연결오류) → null 반환, 토큰 보존, 오프라인 플래그 set.
  /// - SessionExpiredFailure / AuthFailure → 토큰 clear, null 반환.
  Future<AuthSession?> currentSession();

  /// 콜드스타트 오프라인 복원 플래그를 소비한다.
  ///
  /// true 이면 콜드스타트 시 오프라인으로 토큰 보존 상태임을 의미한다.
  /// 읽으면 false 로 리셋된다.
  bool consumeOfflineRestoreFlag();

  // ---------------------------------------------------------------------------
  // 소셜 로그인
  // ---------------------------------------------------------------------------

  /// 카카오 계정으로 로그인한다.
  ///
  /// 성공 시 [SignInOutcome.Authenticated] (200),
  /// 약관 미동의 시 [NeedsTerms] (400),
  /// 복구 가능 계정 시 [Recoverable] (403) 를 반환한다.
  Future<SignInOutcome> signInWithKakao();

  /// Apple 계정으로 로그인한다.
  ///
  /// 베타는 카카오 단독(ADR-0003 §7). Apple Mock 경로는 유지.
  Future<SignInOutcome> signInWithApple();

  // ---------------------------------------------------------------------------
  // 약관 동의 — 티켓 4 에서 POST /consent 실연동 예정
  // ---------------------------------------------------------------------------

  /// 약관 동의 이력을 저장하고 세션의 [AuthSession.hasAgreedTerms]를 true로 갱신한다.
  ///
  /// 세션이 없는 상태에서 호출하면 [StateError]를 던진다.
  ///
  /// TODO(티켓 4): POST /consent 실연동. 현재는 Mock/로컬 갱신.
  Future<void> recordTermsAgreement(TermsAgreement agreement);

  // ---------------------------------------------------------------------------
  // 계정 복구
  // ---------------------------------------------------------------------------

  /// 삭제 유예 계정을 복구한다.
  ///
  /// `POST /auth/{provider}/recover` 를 호출한다.
  /// [provider]: 복구할 소셜 제공자. [Recoverable.provider] 에서 전달받는다.
  /// [idToken]: 로그인 시 획득한 OIDC idToken. 카카오 SDK 재인증 없이 재사용한다.
  Future<AuthSession> recoverAccount(AuthProvider provider, {required String idToken});

  // ---------------------------------------------------------------------------
  // 토큰 관리
  // ---------------------------------------------------------------------------

  /// 액세스 토큰을 갱신한다 (`POST /auth/refresh`).
  Future<void> refresh();

  // ---------------------------------------------------------------------------
  // 사용자 정보
  // ---------------------------------------------------------------------------

  /// 현재 인증된 사용자 정보를 반환한다 (`GET /auth/me`).
  Future<AuthSession> getMe();

  // ---------------------------------------------------------------------------
  // 로그아웃 / 탈퇴
  // ---------------------------------------------------------------------------

  /// 서버에 로그아웃 요청 후 로컬 세션을 초기화한다 (`DELETE /auth/logout`).
  Future<void> logout();

  /// 계정을 탈퇴한다 (`DELETE /auth/withdraw`).
  Future<void> withdraw();

  /// 로컬 세션만 초기화한다 (서버 호출 없음 — 오프라인 signOut 용).
  Future<void> signOut();
}
