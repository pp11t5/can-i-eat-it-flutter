import '../entities/health_profile.dart';

/// 건강 프로필 저장소 인터페이스.
///
/// 실 구현(retrofit datasource)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// W2에서는 [MockHealthProfileRepository]가 주입된다.
///
/// TODO: Swagger(can-i-eat-it.com) API 확정 시 필드 정합 재확인 후 retrofit 구현 교체.
abstract interface class HealthProfileRepository {
  /// 현재 사용자 프로필을 반환한다.
  ///
  /// 온보딩 미완료(프로필 없음)이면 null을 반환한다.
  Future<HealthProfile?> currentProfile();

  /// 온보딩 완료 시 프로필을 일괄 저장한다 (POST /v1/users/profile 대응).
  ///
  /// 실 구현은 retrofit datasource로 교체, 인터페이스 불변.
  Future<void> submitProfile(HealthProfile profile);
}
