import '../entities/auth_session.dart';
import '../entities/terms_agreement.dart';

/// 인증 저장소 인터페이스.
///
/// 실 구현(카카오 SDK + 서버 JWT)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// W1에서는 [MockAuthRepository]가 주입된다.
abstract interface class AuthRepository {
  /// 현재 세션을 반환한다. 미인증 상태이면 null.
  Future<AuthSession?> currentSession();

  /// 카카오 계정으로 로그인한다.
  Future<AuthSession> signInWithKakao();

  /// Apple 계정으로 로그인한다.
  Future<AuthSession> signInWithApple();

  /// 약관 동의 이력을 저장하고 세션의 [AuthSession.hasAgreedTerms]를 true로 갱신한다.
  ///
  /// 세션이 없는 상태에서 호출하면 [StateError]를 던진다.
  Future<void> recordTermsAgreement(TermsAgreement agreement);

  /// 삭제 유예 계정을 복구한다(02a 플로우).
  ///
  /// [AuthSession.accountStatus]를 [AccountStatus.active]로 갱신하고 반환한다.
  Future<AuthSession> recoverAccount();

  /// 로그아웃한다. 세션을 null로 초기화한다.
  Future<void> signOut();
}
