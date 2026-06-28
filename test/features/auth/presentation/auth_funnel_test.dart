import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

import '../../../core/push/fcm_test_helpers.dart';

// ---------------------------------------------------------------------------
// 스파이 AnalyticsService
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

ProviderContainer makeContainer({
  required MockAuthRepository repo,
  required SpyAnalyticsService spy,
}) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      analyticsServiceProvider.overrideWithValue(spy),
      // FCM: 네이티브 플러그인 접근 차단 — noop으로 override.
      fcmLifecycleProvider.overrideWithValue(noopFcmLifecycle()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  // -------------------------------------------------------------------------
  // group 1: signInWithKakao 퍼널 배선 (US-SYS-2)
  // -------------------------------------------------------------------------
  group('signInWithKakao 퍼널 배선', () {
    test('signInWithKakao 성공 시 sign_up 이벤트가 발화된다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: MockAuthRepository.newUser(),
        spy: spy,
      );

      await container.read(authControllerProvider.notifier).signInWithKakao();

      expect(
        spy.calls.any((c) => c.name == FunnelEvent.signUp.eventName),
        isTrue,
      );
    });

    test('signInWithKakao 성공 시 provider 파라미터가 kakao 다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: MockAuthRepository.newUser(),
        spy: spy,
      );

      await container.read(authControllerProvider.notifier).signInWithKakao();

      final signUpCall = spy.calls.firstWhere(
        (c) => c.name == FunnelEvent.signUp.eventName,
      );
      expect(signUpCall.params['provider'], 'kakao');
    });

    test('signInWithKakao 호출 시 sign_up 이벤트가 정확히 1회 발화된다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: MockAuthRepository.newUser(),
        spy: spy,
      );

      await container.read(authControllerProvider.notifier).signInWithKakao();

      final signUpCount =
          spy.calls.where((c) => c.name == FunnelEvent.signUp.eventName).length;
      expect(signUpCount, 1);
    });
  });

  // -------------------------------------------------------------------------
  // group 2: signInWithApple 퍼널 배선 (US-SYS-2)
  // -------------------------------------------------------------------------
  group('signInWithApple 퍼널 배선', () {
    test('signInWithApple 성공 시 sign_up 이벤트가 발화된다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: MockAuthRepository.newUser(),
        spy: spy,
      );

      await container.read(authControllerProvider.notifier).signInWithApple();

      expect(
        spy.calls.any((c) => c.name == FunnelEvent.signUp.eventName),
        isTrue,
      );
    });

    test('signInWithApple 성공 시 provider 파라미터가 apple 다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: MockAuthRepository.newUser(),
        spy: spy,
      );

      await container.read(authControllerProvider.notifier).signInWithApple();

      final signUpCall = spy.calls.firstWhere(
        (c) => c.name == FunnelEvent.signUp.eventName,
      );
      expect(signUpCall.params['provider'], 'apple');
    });

    test('signInWithApple 호출 시 sign_up 이벤트가 정확히 1회 발화된다', () async {
      final spy = SpyAnalyticsService();
      final container = makeContainer(
        repo: MockAuthRepository.newUser(),
        spy: spy,
      );

      await container.read(authControllerProvider.notifier).signInWithApple();

      final signUpCount =
          spy.calls.where((c) => c.name == FunnelEvent.signUp.eventName).length;
      expect(signUpCount, 1);
    });
  });
}
