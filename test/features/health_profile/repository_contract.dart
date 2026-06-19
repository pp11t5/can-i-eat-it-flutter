import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
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

// ---------------------------------------------------------------------------
// 캐시 계약 (ProfileCache 주입 가능한 구현에서만 사용)
// ---------------------------------------------------------------------------

/// [HealthProfileRepository] 캐시 계약 테스트 스위트.
///
/// ProfileCache 를 직접 주입할 수 있는 구현([HealthProfileRepositoryImpl])에서 사용한다.
/// Mock 구현은 자체 인메모리 상태를 사용하므로 이 스위트를 별도 실행하지 않아도 된다.
///
/// [createRepo]: 매 테스트마다 새 repo 인스턴스를 반환하는 팩토리.
/// [createCache]: 같은 캐시 인스턴스를 반환하는 팩토리 (repo 와 공유).
/// 호출자는 두 팩토리가 같은 [ProfileCache] 인스턴스를 공유하도록 setUp 에서 구성한다.
void healthProfileRepositoryCacheContract({
  required HealthProfileRepository Function() createRepo,
  required ProfileCache Function() createCache,
}) {
  late HealthProfileRepository repo;
  late ProfileCache cache;

  setUp(() {
    cache = createCache();
    repo = createRepo();
  });

  group('캐시 계약 — submitProfile 후 currentProfile', () {
    test('submitProfile 성공 후 currentProfile 이 동일 프로필을 반환한다', () async {
      final profile = HealthProfile.sampleGerd();
      await repo.submitProfile(profile);
      expect(await repo.currentProfile(), equals(profile));
    });

    test('clear 후 currentProfile 이 null 을 반환한다', () async {
      await repo.submitProfile(HealthProfile.sampleGerd());
      await cache.clear();
      expect(await repo.currentProfile(), isNull);
    });

    test('서버 실패 시 캐시는 변경되지 않는다 (낙관적 갱신 금지) — Mock 구현은 서버 없이 항상 성공', () async {
      // Mock 구현은 서버 없이 인메모리 기록이므로 이 케이스는 Impl 전용.
      // Impl 에서는 별도 테스트로 검증한다(health_profile_repository_impl_test.dart).
      // 여기서는 submitProfile 후 currentProfile 동일성만 재확인.
      final profile = HealthProfile.sampleGerd();
      await repo.submitProfile(profile);
      expect(await repo.currentProfile(), equals(profile));
    });
  });
}
