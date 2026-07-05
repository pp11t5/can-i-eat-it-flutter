import '../entities/health_profile.dart';

/// 건강 프로필 저장소 인터페이스.
///
/// 실 구현([HealthProfileRepositoryImpl])은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// W2에서는 [MockHealthProfileRepository]가 주입된다.
abstract interface class HealthProfileRepository {
  /// 현재 사용자 프로필을 반환한다.
  ///
  /// 온보딩 미완료(프로필 없음)이면 null을 반환한다.
  /// `GET /my-page/health-info` + `GET /my-page/profile` 병합으로 조회한다(W7 마이그레이션).
  /// 게이트 판정에는 이 메서드가 아닌 [onboardedStatus]를 사용한다 (ADR-0007 §3-1 (6-D)).
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

  /// 알레르기·복용약만 갱신한다 (`PATCH /my-page/health-info`, W7 마이그레이션).
  ///
  /// [submitProfile]과 달리 conditions/symptomFrequency 등 다른 필드는 전송하지 않는다
  /// (allergy_med_edit_screen의 전체 프로필 재제출 워크어라운드 대체).
  Future<void> updateHealthInfo({
    required List<String> allergies,
    required List<String> medications,
  });

  /// 편집 화면 전용 — 캐시 폴백 없이 서버 최신 allergies/medications를 조회한다
  /// (`GET /my-page/health-info`).
  ///
  /// [currentProfile]([HealthProfile]의 allergies/medications 필드만 채워 반환하며
  /// conditions 등 나머지 필드는 기본값)과 달리 실패 시 stale 캐시로 폴백하지 않고
  /// [Failure]를 그대로 throw한다. allergy_med_edit_screen이 stale 데이터를 편집
  /// 진실로 오인해 PATCH로 알레르기 정보를 덮어써 소실시키는 것을 방지한다
  /// (pr-review 의료안전 ②-1).
  Future<HealthProfile> fetchMedicalInfoStrict();
}
