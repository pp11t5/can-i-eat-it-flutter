import 'package:can_i_eat_it/core/error/failure.dart';
import 'auth_session.dart';

/// 로그인 결과 sealed 타입 (ADR-0007 §3-1 (6-A)).
///
/// 서버 HTTP 상태와 1:1 대응:
/// - 200 → [Authenticated]
/// - 400 (약관 미동의) → [NeedsTerms]   // ASSUMPTION(be-confirm): 신규=로그인400. 백엔드 확인 후 제거.
/// - 403 (복구 가능) → [Recoverable]
///
/// [login_screen._handlePostSignIn] 에서 exhaustive switch 로 분기한다.
sealed class SignInOutcome {
  const SignInOutcome();
}

/// 인증 성공 (HTTP 200).
///
/// [session]: 발급된 세션.
/// [onboarded]: `GET /onboarding/status` 결과. repo 내부에서 채워진다.
final class Authenticated extends SignInOutcome {
  const Authenticated({required this.session, required this.onboarded});

  final AuthSession session;
  final bool onboarded;
}

/// 약관 동의 필요 (HTTP 400).
///
/// [requirements]: 어떤 항목의 동의가 필요한지.
///
/// // ASSUMPTION(be-confirm): 신규=로그인400. 백엔드 확인 후 제거.
final class NeedsTerms extends SignInOutcome {
  const NeedsTerms({required this.requirements});

  final Set<TermsRequirement> requirements;
}

/// 복구 가능한 계정 (HTTP 403).
///
/// [reason]: 복구 사유 (탈퇴처리중 / 비활성).
/// [provider]: 로그인 시도한 소셜 제공자.
///   403 경로는 토큰 미발급(_session=null)이므로 provider 를 여기서 운반한다.
///   dialog 가 `recoverAccount(provider)` 에 전달한다.
final class Recoverable extends SignInOutcome {
  const Recoverable({required this.reason, required this.provider});

  final RecoverReason reason;
  final AuthProvider provider;
}
