import '../entities/health_profile.dart';

/// 건강 프로필 저장소 인터페이스.
///
/// 실 구현([HealthProfileRepositoryImpl])은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// W2에서는 [MockHealthProfileRepository]가 주입된다.
abstract interface class HealthProfileRepository {
  /// 현재 사용자 프로필을 반환한다.
  ///
  /// 온보딩 미완료(프로필 없음)이면 null을 반환한다.
  /// 실서버에 전체 프로필 GET 엔드포인트가 없으므로 W3에서 Mock 유지.
  /// 게이트 판정에는 [onboardedStatus]를 사용한다 (ADR-0007 §3-1 (6-D)).
  Future<HealthProfile?> currentProfile();

  /// 온보딩 완료 여부를 boolean으로 반환한다 (`GET /onboarding/status`).
  ///
  /// 게이트(`sessionStatus` provider)가 이 값을 `hasProfile`로 사용한다.
  /// Mock 구현: noProfile→false, completed→true.
  Future<bool> onboardedStatus();

  /// 온보딩 완료 시 프로필을 일괄 저장한다 (`POST /onboarding`).
  ///
  /// 실 구현은 [HealthProfileRepositoryImpl]로 교체, 인터페이스 불변.
  Future<void> submitProfile(HealthProfile profile);
}
