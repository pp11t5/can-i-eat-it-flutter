import '../../domain/entities/health_profile.dart';
import '../../domain/repositories/health_profile_repository.dart';

/// [HealthProfileRepository] 인메모리 Mock 구현.
///
/// 실 구현(retrofit datasource)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 테스트에서 시나리오별 named factory를 사용해 의도를 명확히 표현할 수 있다.
class MockHealthProfileRepository implements HealthProfileRepository {
  /// [initialProfile]: [currentProfile]이 최초 반환할 프로필(null = 온보딩 미완료).
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentProfile] 반환 전 대기 시간.
  ///   기본값 [Duration.zero]이므로 기존 동작/테스트에 영향 없음.
  MockHealthProfileRepository({
    HealthProfile? initialProfile,
    Duration delay = Duration.zero,
  })  : _profile = initialProfile,
        _delay = delay;

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 신규 사용자. [currentProfile]이 null을 반환한다(온보딩 필요).
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentProfile] 반환 전 대기 시간.
  factory MockHealthProfileRepository.noProfile({
    Duration delay = Duration.zero,
  }) =>
      MockHealthProfileRepository(initialProfile: null, delay: delay);

  /// 온보딩 완료 사용자. [currentProfile]이 [HealthProfile.sampleGerd]를 반환한다.
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentProfile] 반환 전 대기 시간.
  factory MockHealthProfileRepository.completed({
    Duration delay = Duration.zero,
  }) =>
      MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd(),
        delay: delay,
      );

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  HealthProfile? _profile;
  final Duration _delay;
  HealthProfile? _lastSubmittedProfile;

  /// 마지막으로 제출된 프로필. 테스트 검증용.
  HealthProfile? get lastSubmittedProfile => _lastSubmittedProfile;

  // ---------------------------------------------------------------------------
  // HealthProfileRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<HealthProfile?> currentProfile() async {
    if (_delay > Duration.zero) await Future.delayed(_delay);
    return _profile;
  }

  @override
  Future<void> submitProfile(HealthProfile profile) async {
    _lastSubmittedProfile = profile;
    _profile = profile;
  }
}
