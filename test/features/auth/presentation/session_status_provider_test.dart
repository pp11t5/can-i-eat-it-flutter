import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';

/// [sessionStatusProvider] 합성 검증.
///
/// auth + health_profile 두 override를 조합해 sessionStatusProvider가 올바른
/// SessionStatus를 반환하는지 검증한다.

// ADR-0006 §4 폴백 검증용: onboardedStatus()가 throw하는 최소 가짜 저장소.
class _ThrowingHealthProfileRepository implements HealthProfileRepository {
  @override
  Future<HealthProfile?> currentProfile() async => null;

  @override
  Future<bool> onboardedStatus() async =>
      throw Exception('onboarded status fetch failed');

  @override
  Future<void> submitProfile(HealthProfile profile) async {}
}

void main() {
  // 헬퍼: ProviderContainer 생성 + addTearDown 등록.
  ProviderContainer makeContainer({
    required MockAuthRepository authRepo,
    required MockHealthProfileRepository profileRepo,
  }) {
    final container = ProviderContainer(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        authRepositoryProvider.overrideWithValue(authRepo),
        // ignore: scoped_providers_should_specify_dependencies
        healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('sessionStatusProvider 합성 검증', () {
    test('auth 미인증이면 unauthenticated 를 반환한다', () async {
      final container = makeContainer(
        authRepo: MockAuthRepository.signedOut(),
        profileRepo: MockHealthProfileRepository.noProfile(),
      );

      // AsyncNotifier build 완료 대기.
      await container.read(authControllerProvider.future);

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.unauthenticated);
    });

    test('기존 사용자(약관 동의) + health_profile 없음 → needsOnboarding', () async {
      final container = makeContainer(
        authRepo: MockAuthRepository.existing(),
        profileRepo: MockHealthProfileRepository.noProfile(),
      );

      // existing()은 initialSession=null이므로 signIn 후 상태 확인.
      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).signInWithKakao();
      // sessionStatus는 onboardedStatusProvider를 watch하므로 그 완료를 기다린다.
      await container.read(onboardedStatusProvider.future);

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.needsOnboarding);
    });

    test('기존 사용자(약관 동의) + health_profile 완료 → ready', () async {
      final container = makeContainer(
        authRepo: MockAuthRepository.existing(),
        profileRepo: MockHealthProfileRepository.completed(),
      );

      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).signInWithKakao();
      // sessionStatus는 onboardedStatusProvider를 watch하므로 그 완료를 기다린다.
      await container.read(onboardedStatusProvider.future);

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.ready);
    });

    test('약관 미동의(newUser 로그인 후) → needsTerms', () async {
      final container = makeContainer(
        authRepo: MockAuthRepository.newUser(),
        profileRepo: MockHealthProfileRepository.noProfile(),
      );

      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).signInWithKakao();

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.needsTerms);
    });

    // -------------------------------------------------------------------------
    // Medium-2: loading 단계 관찰 (delay affordance 검증)
    // -------------------------------------------------------------------------

    test(
        'onboardedStatus 로드 지연 중에는 loading, 완료 후에는 ready를 반환한다 '
        '(short-circuit 제거 시 이 테스트가 실패해야 의미 있음)', () async {
      // delay: 50ms — signInWithKakao() 이후 onboardedStatusProvider가
      // watch되기 시작하고, 그 future가 50ms 뒤에 완료된다.
      // sessionStatus short-circuit이 그동안 loading을 반환한다.
      final container = makeContainer(
        authRepo: MockAuthRepository.existing(),
        profileRepo: MockHealthProfileRepository.completed(
          delay: const Duration(milliseconds: 50),
        ),
      );

      // sessionStatusProvider를 구독 상태로 유지해야 Riverpod이 의존 그래프를
      // 살아있게 유지하고 비동기 완료 시 재계산을 트리거한다.
      // listen 없이 read만 하면 one-shot 계산으로 업데이트를 받지 못한다.
      final observed = <SessionStatus>[];
      final sub = container.listen(
        sessionStatusProvider,
        (_, next) => observed.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);

      // auth를 먼저 완료시켜 세션을 확보한다(health_profile 분기로 진입하기 위해).
      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).signInWithKakao();

      // signInWithKakao() 직후: onboardedStatusProvider가 delay=50ms로 로딩 중
      // → sessionStatus는 loading이어야 한다.
      final statusDuringLoad = container.read(sessionStatusProvider);
      expect(
        statusDuringLoad,
        SessionStatus.loading,
        reason: 'onboardedStatus 로드가 완료되기 전에는 loading이어야 한다',
      );

      // 지연(50ms)보다 넉넉하게 기다려 onboardedStatus future가 완료되고
      // Riverpod이 sessionStatusProvider를 재계산할 시간을 준다.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final statusAfterLoad = container.read(sessionStatusProvider);
      expect(
        statusAfterLoad,
        SessionStatus.ready,
        reason: 'onboardedStatus 로드 완료 후에는 ready가 돼야 한다',
      );
    });

    // -------------------------------------------------------------------------
    // 콜드스타트 시나리오 (커밋3 TDD)
    // -------------------------------------------------------------------------

    test('콜드스타트 토큰有+getMe200(onboarded=true) → ready', () async {
      // MockAuthRepository.existing() 을 initialSession 있는 형태로 직접 구성.
      // coldStart 시나리오: currentSession() 이 바로 세션을 반환하는 상황.
      const sessionFixture = AuthSession(
        userId: 'cold-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.active,
      );
      final container = ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository(initialSession: sessionFixture),
          ),
          // ignore: scoped_providers_should_specify_dependencies
          healthProfileRepositoryProvider.overrideWithValue(
            MockHealthProfileRepository.completed(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      await container.read(onboardedStatusProvider.future);

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.ready);
    });

    test('콜드스타트 토큰有+getMe200(onboarded=false) → needsOnboarding', () async {
      const sessionFixture = AuthSession(
        userId: 'cold-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.active,
      );
      final container = ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository(initialSession: sessionFixture),
          ),
          // ignore: scoped_providers_should_specify_dependencies
          healthProfileRepositoryProvider.overrideWithValue(
            MockHealthProfileRepository.noProfile(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      await container.read(onboardedStatusProvider.future);

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.needsOnboarding);
    });

    test('콜드스타트 오프라인 → unauthenticated', () async {
      // 오프라인 시 currentSession() 은 null 을 반환(토큰 보존, 세션 null).
      final container = ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository.signedOut(), // currentSession=null
          ),
          // ignore: scoped_providers_should_specify_dependencies
          healthProfileRepositoryProvider.overrideWithValue(
            MockHealthProfileRepository.noProfile(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);

      final status = container.read(sessionStatusProvider);
      expect(status, SessionStatus.unauthenticated);
    });

    // -------------------------------------------------------------------------
    // Low-1: AsyncError → needsOnboarding 폴백 (ADR-0006 §4)
    // -------------------------------------------------------------------------

    test(
        'health_profile 로드 실패(throw)는 needsOnboarding으로 폴백한다 '
        '(ADR-0006 §4 — 에러가 throw로 전파되지 않음)', () async {
      final container = ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository.existing(),
          ),
          // ignore: scoped_providers_should_specify_dependencies
          healthProfileRepositoryProvider.overrideWithValue(
            _ThrowingHealthProfileRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      // auth 완료 후 signIn으로 세션 확보.
      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).signInWithKakao();

      // onboardedStatus 로드가 에러 상태로 정착할 때까지 기다린다.
      // future는 throw하지만 sessionStatus는 needsOnboarding으로 처리해야 한다.
      await expectLater(
        container.read(onboardedStatusProvider.future),
        throwsException,
      );

      final status = container.read(sessionStatusProvider);
      expect(
        status,
        SessionStatus.needsOnboarding,
        reason: 'onboardedStatus 로드 에러는 needsOnboarding으로 안전하게 폴백해야 한다(ADR-0006 §4)',
      );
    });
  });
}
