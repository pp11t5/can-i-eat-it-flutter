import '../../domain/entities/health_profile.dart';
import '../../domain/repositories/health_profile_repository.dart';

/// [HealthProfileRepository] 인메모리 Mock 구현.
///
/// 실 구현(retrofit datasource)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 테스트에서 시나리오별 named factory를 사용해 의도를 명확히 표현할 수 있다.
class MockHealthProfileRepository implements HealthProfileRepository {
  /// [initialProfile]: [currentProfile]이 최초 반환할 프로필(null = 온보딩 미완료).
  MockHealthProfileRepository({HealthProfile? initialProfile})
      : _profile = initialProfile;

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 신규 사용자. [currentProfile]이 null을 반환한다(온보딩 필요).
  factory MockHealthProfileRepository.noProfile() =>
      MockHealthProfileRepository(initialProfile: null);

  /// 온보딩 완료 사용자. [currentProfile]이 [HealthProfile.sampleGerd]를 반환한다.
  factory MockHealthProfileRepository.completed() =>
      MockHealthProfileRepository(initialProfile: HealthProfile.sampleGerd());

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  HealthProfile? _profile;
  HealthProfile? _lastSubmittedProfile;

  /// 마지막으로 제출된 프로필. 테스트 검증용.
  HealthProfile? get lastSubmittedProfile => _lastSubmittedProfile;

  // ---------------------------------------------------------------------------
  // HealthProfileRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<HealthProfile?> currentProfile() async => _profile;

  @override
  Future<void> submitProfile(HealthProfile profile) async {
    _lastSubmittedProfile = profile;
    _profile = profile;
  }
}
