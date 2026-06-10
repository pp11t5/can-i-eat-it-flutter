/// 도메인/데이터 레이어 공통 실패 타입. UI는 이 타입으로 분기한다.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

/// 네트워크/서버 통신 실패.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크 오류가 발생했어요.']);
}

/// 그 외 예기치 못한 실패.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = '알 수 없는 오류가 발생했어요.']);
}

// ---------------------------------------------------------------------------
// 인증 관련 Failure 계층 (ADR-0007 §3-1 (2))
// ---------------------------------------------------------------------------

/// 인증 의미를 가진 Failure 공통 추상 부모.
///
/// UI는 이 타입 또는 구체 서브타입으로 exhaustive switch 한다.
sealed class AuthFailure extends Failure {
  const AuthFailure([super.message = '인증 오류가 발생했어요.']);
}

/// 약관 동의가 필요한 경우 (HTTP 400: AUTH400_1 이메일, AUTH400_3 닉네임).
///
/// [requirements] 로 어떤 항목의 약관 동의가 필요한지 전달된다.
///
/// // ASSUMPTION(be-confirm): 신규=로그인400. 백엔드 확인 후 제거.
class TermsRequiredFailure extends AuthFailure {
  const TermsRequiredFailure({
    required this.requirements,
    String message = '서비스 이용을 위해 약관 동의가 필요해요.',
  }) : super(message);

  final Set<TermsRequirement> requirements;
}

/// 복구 가능한 계정 상태 (HTTP 403: AUTH403_5 탈퇴처리중, AUTH403_2 비활성).
///
/// UI는 [reason] 에 따라 복구 팝업/다이얼로그를 분기한다.
class RecoverableAccountFailure extends AuthFailure {
  const RecoverableAccountFailure({
    required this.reason,
    String message = '계정 복구가 필요해요.',
  }) : super(message);

  final RecoverReason reason;
}

/// 토큰이 유효하지 않음 (HTTP 401, refresh 불가 / refresh 자체 실패).
class InvalidTokenFailure extends AuthFailure {
  const InvalidTokenFailure([super.message = '인증 토큰이 유효하지 않아요.']);
}

/// refresh 실패로 세션이 만료됨 → 자동 로그아웃 트리거.
class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([super.message = '세션이 만료됐어요. 다시 로그인해 주세요.']);
}

// ---------------------------------------------------------------------------
// 열거형
// ---------------------------------------------------------------------------

/// 약관 동의가 필요한 항목.
enum TermsRequirement {
  /// 이메일 수신 동의 (AUTH400_1)
  email,

  /// 닉네임 설정 (AUTH400_3)
  nickname,
}

/// 계정 복구 필요 사유.
enum RecoverReason {
  /// 탈퇴 처리 중 (AUTH403_5)
  deletionInProgress,

  /// 비활성 계정 (AUTH403_2)
  inactive,
}
