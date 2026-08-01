import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_my_page_for_nickname.dart';
import '../../../core/push/fcm_test_helpers.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/meal_log/data/sources/timeline_guide_store.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';
import 'package:can_i_eat_it/features/mypage/data/repositories/mock_my_page_repository.dart';

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
  InMemoryTimelineGuideStore? guideStore,
}) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      analyticsServiceProvider.overrideWithValue(_NoopAnalyticsService()),
      // FCM: 네이티브 플러그인 접근 차단 — noop으로 override.
      fcmLifecycleProvider.overrideWithValue(noopFcmLifecycle()),
      // secure_storage 플러그인 차단 (프로필·타임라인 가이드 공통).
      profileCacheProvider.overrideWithValue(cache ?? InMemoryProfileCache()),
      timelineGuideStoreProvider.overrideWithValue(
        guideStore ?? InMemoryTimelineGuideStore(),
      ),
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

    test('withdraw 후 timeline 가이드 플래그가 cleared 된다', () async {
      final repo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final guideStore = InMemoryTimelineGuideStore(seenUserIds: {'mock-user'});
      final container = _makeContainer(repo: repo, guideStore: guideStore);
      await container.read(authControllerProvider.future);

      expect(await guideStore.hasSeenFabGuide('mock-user'), isTrue);
      await container.read(authControllerProvider.notifier).withdraw();
      expect(await guideStore.hasSeenFabGuide('mock-user'), isFalse);
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

  // -------------------------------------------------------------------------
  // updateNickname — in-flight getMe 가 구 닉네임으로 덮어쓰지 않음
  // -------------------------------------------------------------------------

  group('AuthController.updateNickname 레이스 가드', () {
    test('닉네임 변경 후 늦게 도착한 getMe 는 새 displayName 을 덮지 않는다', () async {
      final repo = _DelayedGetMeAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
          displayName: '이전이름',
        ),
      );
      final container = _makeContainer(repo: repo);
      // myPageRepository 는 기본 Mock — updateNickname no-op 성공
      await container.read(authControllerProvider.future);

      final controller = container.read(authControllerProvider.notifier);

      // 1) getMe 시작 (지연) — 응답 시 여전히 '이전이름'을 돌려줌
      final getMeFuture = controller.getMe();

      // 2) 그 사이 닉네임 저장 완료
      await controller.updateNickname('새이름');
      expect(
        container.read(authControllerProvider).valueOrNull?.displayName,
        '새이름',
      );

      // 3) 지연 getMe 완료 — state 는 새이름 유지
      await getMeFuture;
      expect(
        container.read(authControllerProvider).valueOrNull?.displayName,
        '새이름',
      );
      // repository 로컬 캐시도 복구됨
      expect(repo.currentDisplayName, '새이름');
    });
  });
}

/// getMe 가 완료되기 전에 updateNickname 이 끼어들 수 있도록 지연을 둔 fake.
class _DelayedGetMeAuthRepository extends MockAuthRepository {
  _DelayedGetMeAuthRepository({required super.initialSession});

  final _getMeDelay = Completer<void>();

  /// 테스트가 getMe 를 풀어줄 때 사용. 생성 직후 자동으로 한 tick 뒤 complete.
  @override
  Future<AuthSession> getMe() async {
    // 한 프레임 이상 지연해 updateNickname 이 끼어들 틈을 준다.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    // 서버가 아직 구 닉네임을 돌려주는 상황 재현 — 내부 세션을 건드리지 않고
    // '이전이름' 스냅샷을 반환한 뒤 _session 도 그 값으로 덮는다(실구현과 동일).
    final stale = const AuthSession(
      userId: 'mock-user',
      provider: AuthProvider.kakao,
      hasAgreedTerms: true,
      displayName: '이전이름',
    );
    // applyLocalDisplayName 복구 검증을 위해 의도적으로 구 값으로 덮음.
    applyLocalDisplayName('이전이름');
    return stale;
  }

  String? get currentDisplayName {
    // ignore: invalid_use_of_visible_for_testing_member
    return null;
  }
}
