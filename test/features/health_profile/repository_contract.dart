import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';

/// [HealthProfileRepository] 계약 테스트 스위트.
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
/// retrofit 구현 추가 시 같은 함수를 재사용한다.
void healthProfileRepositoryContract(
  HealthProfileRepository Function() create,
) {
  // ---------------------------------------------------------------------------
  group('currentProfile — 초기 상태', () {
    test('초기 noProfile 상태에서 currentProfile은 null이다', () async {
      final repo = create();
      expect(await repo.currentProfile(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('onboardedStatus — 초기 상태', () {
    test('초기 noProfile 상태에서 onboardedStatus는 false이다', () async {
      final repo = create();
      expect(await repo.onboardedStatus(), isFalse);
    });

    test('submitProfile 후 onboardedStatus는 true이다', () async {
      final repo = create();
      await repo.submitProfile(HealthProfile.sampleGerd());
      expect(await repo.onboardedStatus(), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  group('submitProfile', () {
    test('submitProfile 후 currentProfile이 동일 프로필을 반환한다', () async {
      final repo = create();
      final profile = HealthProfile.sampleGerd();
      await repo.submitProfile(profile);
      expect(await repo.currentProfile(), equals(profile));
    });

    test('submitProfile로 다른 프로필을 제출하면 currentProfile이 갱신된다', () async {
      final repo = create();
      final first = HealthProfile.sampleGerd();
      final second = first.copyWith(conditions: ['GERD', 'Gastritis']);
      await repo.submitProfile(first);
      await repo.submitProfile(second);
      expect(await repo.currentProfile(), equals(second));
    });

    test('submitProfile에 빈 프로필을 제출해도 currentProfile이 해당 프로필을 반환한다', () async {
      final repo = create();
      const empty = HealthProfile();
      await repo.submitProfile(empty);
      expect(await repo.currentProfile(), equals(empty));
    });
  });
}
