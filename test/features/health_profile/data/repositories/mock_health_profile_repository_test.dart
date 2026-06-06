import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

import '../../repository_contract.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 계약 테스트 — noProfile 팩토리로 실행
  // ---------------------------------------------------------------------------
  group('MockHealthProfileRepository — 저장소 계약', () {
    healthProfileRepositoryContract(MockHealthProfileRepository.noProfile);
  });

  // ---------------------------------------------------------------------------
  group('noProfile 팩토리', () {
    test('noProfile 팩토리는 currentProfile이 null이다', () async {
      final repo = MockHealthProfileRepository.noProfile();
      expect(await repo.currentProfile(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('completed 팩토리', () {
    test('completed 팩토리는 currentProfile이 sampleGerd 프로필을 반환한다', () async {
      final repo = MockHealthProfileRepository.completed();
      final profile = await repo.currentProfile();
      expect(profile, isNotNull);
      expect(profile!.conditions, contains('GERD'));
      expect(profile.diagnosed, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  group('submitProfile — Mock 전용 검증', () {
    test('submitProfile 후 lastSubmittedProfile에 마지막 제출 프로필이 기록된다', () async {
      final repo = MockHealthProfileRepository.noProfile();
      final profile = HealthProfile.sampleGerd();
      await repo.submitProfile(profile);
      expect(repo.lastSubmittedProfile, equals(profile));
    });

    test('submitProfile을 두 번 호출하면 lastSubmittedProfile이 마지막 것으로 갱신된다', () async {
      final repo = MockHealthProfileRepository.noProfile();
      final first = HealthProfile.sampleGerd();
      final second = first.copyWith(conditions: ['GERD', 'Gastritis']);
      await repo.submitProfile(first);
      await repo.submitProfile(second);
      expect(repo.lastSubmittedProfile, equals(second));
    });

    test('submitProfile 전 lastSubmittedProfile은 null이다', () {
      final repo = MockHealthProfileRepository.noProfile();
      expect(repo.lastSubmittedProfile, isNull);
    });
  });
}
