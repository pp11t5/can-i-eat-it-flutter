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
