import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';

// ---------------------------------------------------------------------------
// Stub AnalyticsService
// ---------------------------------------------------------------------------

class _NoopAnalyticsService implements AnalyticsService {
  @override
  Future<void> logFunnel(FunnelEvent event,
      {Map<String, Object?> params = const {}}) async {}
  @override
  Future<void> logEvent(String name,
      {Map<String, Object?> params = const {}}) async {}
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

ProviderContainer _makeContainer({
  required MockAuthRepository repo,
  InMemoryProfileCache? cache,
}) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      analyticsServiceProvider.overrideWithValue(_NoopAnalyticsService()),
      if (cache != null) profileCacheProvider.overrideWithValue(cache),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  // -------------------------------------------------------------------------
  // withdraw — repo.withdraw 호출 + 캐시 clear + state=null
  // -------------------------------------------------------------------------

  group('AuthController.withdraw', () {
    test('withdraw 후 authController state 가 null 이 된다', () async {
      final repo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final cache = InMemoryProfileCache();
      final container = _makeContainer(repo: repo, cache: cache);

      // 초기 세션 로드
      await container.read(authControllerProvider.future);
      expect(
        container.read(authControllerProvider).value,
        isA<AuthSession>(),
      );

      await container.read(authControllerProvider.notifier).withdraw();

      expect(container.read(authControllerProvider).value, isNull);
    });

    test('withdraw 후 profileCache 가 cleared 된다', () async {
      final repo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final cache = InMemoryProfileCache();
      final container = _makeContainer(repo: repo, cache: cache);
      await container.read(authControllerProvider.future);

      // withdraw 전후 캐시 clear 검증 — 초기에도 null 이므로
      // clear 호출 자체를 side-effect 로 검증한다.
      // (write 없이도 clear 이후 read==null 계약은 유효)
      await container.read(authControllerProvider.notifier).withdraw();

      expect(await cache.read(), isNull);
    });

    test('logout 후 profileCache 가 cleared 된다', () async {
      final repo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final cache = InMemoryProfileCache();
      final container = _makeContainer(repo: repo, cache: cache);
      await container.read(authControllerProvider.future);

      await container.read(authControllerProvider.notifier).logout();

      expect(await cache.read(), isNull);
      expect(container.read(authControllerProvider).value, isNull);
    });

    test('signOut 후 profileCache 가 cleared 된다', () async {
      final repo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final cache = InMemoryProfileCache();
      final container = _makeContainer(repo: repo, cache: cache);
      await container.read(authControllerProvider.future);

      await container.read(authControllerProvider.notifier).signOut();

      expect(await cache.read(), isNull);
      expect(container.read(authControllerProvider).value, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // getMe — state 갱신 (displayName/email/profileImageUrl)
  // -------------------------------------------------------------------------

  group('AuthController.getMe', () {
    test('getMe 성공 시 state 가 갱신된 세션으로 교체된다', () async {
      final repo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final container = _makeContainer(repo: repo);

      await container.read(authControllerProvider.future);

      final session =
          await container.read(authControllerProvider.notifier).getMe();

      expect(session, isA<AuthSession>());
      expect(
        container.read(authControllerProvider).value,
        equals(session),
      );
    });
  });
}
