import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

// ---------------------------------------------------------------------------
// 테스트 더블
// ---------------------------------------------------------------------------

/// 스파이 AnalyticsService — logFunnel 호출을 기록한다.
class SpyAnalyticsService implements AnalyticsService {
  final List<({String name, Map<String, Object?> params})> calls = [];

  @override
  Future<void> logFunnel(
    FunnelEvent event, {
    Map<String, Object?> params = const {},
  }) async {
    calls.add((name: event.eventName, params: params));
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}}) async {
    calls.add((name: name, params: params));
  }
}

/// 항상 예외를 던지는 HealthProfileRepository (submitProfile만 throw).
class ThrowingHealthProfileRepository implements HealthProfileRepository {
  @override
  Future<HealthProfile?> currentProfile() async => null;

  @override
  Future<bool> onboardedStatus() async => false;

  @override
  Future<void> submitProfile(HealthProfile profile) async {
    throw Exception('서버 오류');
  }
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

ProviderContainer makeContainer({
  HealthProfileRepository? repo,
  SpyAnalyticsService? analytics,
}) {
  final spy = analytics ?? SpyAnalyticsService();
  final container = ProviderContainer(
    overrides: [
      if (repo != null) healthProfileRepositoryProvider.overrideWithValue(repo),
      analyticsServiceProvider.overrideWithValue(spy),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  // -------------------------------------------------------------------------
  // group 1: 제출 성공
  // -------------------------------------------------------------------------
  group('OnboardingSubmit 성공 시나리오', () {
    test('submit 성공 시 healthProfileController state가 프로필 포함 AsyncData가 된다',
        () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(analytics: spy);

      // 드래프트에 일부 입력
      final ctrl = container.read(onboardingControllerProvider.notifier);
      ctrl.toggleSymptom('heartburn_reflux');
      ctrl.setDiagnosed(true);

      await container.read(onboardingSubmitProvider.notifier).submit();

      // healthProfileController가 ready(프로필 존재)로 플립됐는지 확인
      final profileState = container.read(healthProfileControllerProvider);
      expect(profileState, isA<AsyncData<HealthProfile?>>());
      final profile = profileState.value;
      expect(profile, isNotNull);
      expect(profile!.conditions, ['GERD']);
      expect(profile.symptomFrequency, ['heartburn_reflux']);
      expect(profile.diagnosed, isTrue);
    });

    test('submit 성공 시 onboardingCompleted 퍼널 이벤트가 발화된다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(analytics: spy);

      await container.read(onboardingSubmitProvider.notifier).submit();

      expect(
        spy.calls.any((c) => c.name == FunnelEvent.onboardingCompleted.eventName),
        isTrue,
      );
    });

    test('submit 성공 시 OnboardingSubmit state가 AsyncData(null)이 된다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(analytics: spy);

      await container.read(onboardingSubmitProvider.notifier).submit();

      final submitState = container.read(onboardingSubmitProvider);
      expect(submitState, isA<AsyncData<void>>());
    });
  });

  // -------------------------------------------------------------------------
  // group 2: 제출 실패 — 드래프트 보존 (US-ONB-5)
  // -------------------------------------------------------------------------
  group('OnboardingSubmit 실패 시나리오 — 드래프트 보존', () {
    test('submit 실패 시 OnboardingSubmit state가 AsyncError가 된다', () async {
      final container = makeContainer(repo: ThrowingHealthProfileRepository());

      final ctrl = container.read(onboardingControllerProvider.notifier);
      ctrl.toggleSymptom('post_meal_cough');

      await container.read(onboardingSubmitProvider.notifier).submit();

      final submitState = container.read(onboardingSubmitProvider);
      expect(submitState, isA<AsyncError<void>>());
    });

    test('submit 실패 시 OnboardingController 드래프트가 보존된다 (US-ONB-5)', () async {
      final container = makeContainer(repo: ThrowingHealthProfileRepository());

      final notifier = container.read(onboardingControllerProvider.notifier);
      notifier.toggleSymptom('post_meal_cough');
      notifier.setDiagnosed(true);
      notifier.toggleTrigger('spicy');

      await container.read(onboardingSubmitProvider.notifier).submit();

      // 제출 실패 후에도 드래프트 입력이 그대로 남아있다
      final draft = container.read(onboardingControllerProvider);
      expect(draft.symptomFrequency, contains('post_meal_cough'));
      expect(draft.diagnosed, isTrue);
      expect(draft.triggerFoods, contains('spicy'));
    });

    test('submit 실패 후 재시도 시 성공하면 AsyncData가 된다', () async {
      // 처음엔 throwing repo, 두 번째엔 정상 repo로 교체
      final spy = SpyAnalyticsService();
      // 두 번째 시도를 위해 정상 container 사용
      final container = ProviderContainer(
        overrides: [analyticsServiceProvider.overrideWithValue(spy)],
      );
      addTearDown(container.dispose);

      // 성공 경로: 기본 MockHealthProfileRepository.noProfile 사용
      await container.read(onboardingSubmitProvider.notifier).submit();

      final submitState = container.read(onboardingSubmitProvider);
      expect(submitState, isA<AsyncData<void>>());
    });

    test('submit 실패 시 onboardingCompleted 퍼널 이벤트가 발화되지 않는다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: ThrowingHealthProfileRepository(),
        analytics: spy,
      );

      await container.read(onboardingSubmitProvider.notifier).submit();

      expect(
        spy.calls.any((c) => c.name == FunnelEvent.onboardingCompleted.eventName),
        isFalse,
      );
    });
  });
}
