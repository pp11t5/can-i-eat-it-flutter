import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/core/push/fcm_repository.dart';
import 'package:can_i_eat_it/core/push/fcm_token_service.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';

// ---------------------------------------------------------------------------
// Spy FcmLifecycle — register/delete 호출 순서 기록
// ---------------------------------------------------------------------------

/// noop FcmRepository (서버 호출 없음)
class _NoopFcmRepository implements FcmRepository {
  @override
  Future<void> register({required String token, required String platform}) async {}
  @override
  Future<void> delete() async {}
}

/// noop FcmTokenService (Firebase 접근 없음)
class _NoopFcmTokenService extends FcmTokenService {
  @override
  String? get platform => null;
  @override
  Future<void> requestPermission() async {}
  @override
  Future<String?> currentToken() async => null;
  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
}

/// Spy FcmLifecycle — register/delete 호출 횟수와 순서를 기록한다.
///
/// 호출 기록 형식: 'fcm.register' | 'fcm.delete'
class SpyFcmLifecycle extends FcmLifecycle {
  SpyFcmLifecycle()
      : super(
          repo: _NoopFcmRepository(),
          tokenService: _NoopFcmTokenService(),
        );

  /// 호출 순서 로그. 'fcm.register' | 'fcm.delete'
  final List<String> calls = [];

  int get registerCount => calls.where((c) => c == 'fcm.register').length;
  int get deleteCount => calls.where((c) => c == 'fcm.delete').length;

  @override
  Future<void> registerCurrentToken() async {
    calls.add('fcm.register');
  }

  @override
  Future<void> deleteToken() async {
    calls.add('fcm.delete');
  }

  @override
  void cancelRefreshSubscription() {
    // signOut 경로 — 서버 호출 없음, 순서 기록 불필요.
  }
}

/// Spy AuthRepository — logout/withdraw 호출 시 순서 로그에 기록한다.
///
/// [calls]는 SpyFcmLifecycle.calls 와 동일한 리스트를 공유해
/// fcm vs auth 호출 순서를 단일 타임라인으로 검증한다.
class _SpyAuthRepository implements AuthRepository {
  _SpyAuthRepository({
    required this.calls,
    required MockAuthRepository delegate,
  }) : _delegate = delegate;

  final List<String> calls;
  final MockAuthRepository _delegate;

  @override
  Future<AuthSession?> currentSession() => _delegate.currentSession();

  @override
  bool consumeOfflineRestoreFlag() => _delegate.consumeOfflineRestoreFlag();

  @override
  Future<SignInOutcome> signInWithKakao() => _delegate.signInWithKakao();

  @override
  Future<SignInOutcome> signInWithApple() => _delegate.signInWithApple();

  @override
  Future<void> recordTermsAgreement(TermsAgreement agreement) =>
      _delegate.recordTermsAgreement(agreement);

  @override
  Future<AuthSession> recoverAccount(
    AuthProvider provider, {
    required String idToken,
  }) =>
      _delegate.recoverAccount(provider, idToken: idToken);

  @override
  Future<void> refresh() => _delegate.refresh();

  @override
  Future<AuthSession> getMe() => _delegate.getMe();

  @override
  Future<void> logout() async {
    calls.add('auth.logout');
    await _delegate.logout();
  }

  @override
  Future<void> withdraw() async {
    calls.add('auth.withdraw');
    await _delegate.withdraw();
  }

  @override
  Future<void> signOut() => _delegate.signOut();
}

// ---------------------------------------------------------------------------
// Noop AnalyticsService
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

/// [SpyFcmLifecycle]과 [_SpyAuthRepository]가 공유 [calls] 리스트를 사용하는
/// ProviderContainer를 생성한다.
({
  ProviderContainer container,
  SpyFcmLifecycle fcmSpy,
  List<String> calls,
}) makeSpyContainer({required MockAuthRepository mockRepo}) {
  final spyFcm = SpyFcmLifecycle();
  final spyAuth = _SpyAuthRepository(calls: spyFcm.calls, delegate: mockRepo);

  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(spyAuth),
      analyticsServiceProvider.overrideWithValue(_NoopAnalyticsService()),
      fcmLifecycleProvider.overrideWithValue(spyFcm),
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
    ],
  );
  addTearDown(container.dispose);
  return (container: container, fcmSpy: spyFcm, calls: spyFcm.calls);
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // ① Authenticated 로그인 → registerCurrentToken 1회 호출
  // -------------------------------------------------------------------------
  group('AuthController FCM 배선 — 로그인 register 트리거', () {
    test(
        'signInWithKakao: Authenticated 결과 → registerCurrentToken 정확히 1회',
        () async {
      final (:container, fcmSpy: fcmSpy, calls: _) =
          makeSpyContainer(mockRepo: MockAuthRepository.existing());

      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signInWithKakao();

      // unawaited이므로 microtask flush 대기
      await Future<void>.delayed(Duration.zero);

      expect(fcmSpy.registerCount, 1,
          reason: 'Authenticated 로그인 시 register 1회');
    });

    test(
        'signInWithApple: Authenticated 결과 → registerCurrentToken 정확히 1회',
        () async {
      final (:container, fcmSpy: fcmSpy, calls: _) =
          makeSpyContainer(mockRepo: MockAuthRepository.existing());

      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signInWithApple();

      await Future<void>.delayed(Duration.zero);

      expect(fcmSpy.registerCount, 1,
          reason: 'Authenticated 로그인(Apple) 시 register 1회');
    });

    test(
        'recoverAccount: 복구 성공 → registerCurrentToken 정확히 1회',
        () async {
      final (:container, fcmSpy: fcmSpy, calls: _) =
          makeSpyContainer(mockRepo: MockAuthRepository.deletionGrace());

      await container.read(authControllerProvider.future);
      // Recoverable 결과로 signIn 먼저 (세션 없음 상태 설정)
      await container
          .read(authControllerProvider.notifier)
          .signInWithKakao();
      final registerBefore = fcmSpy.registerCount;

      await container
          .read(authControllerProvider.notifier)
          .recoverAccount(AuthProvider.kakao, idToken: 'mock-id-token');

      await Future<void>.delayed(Duration.zero);

      // recoverAccount에 의한 register 1회 추가
      expect(fcmSpy.registerCount - registerBefore, 1,
          reason: '복구 성공 후 register 1회');
    });
  });

  // -------------------------------------------------------------------------
  // ② NeedsTerms / Recoverable → registerCurrentToken 0회
  // -------------------------------------------------------------------------
  group('AuthController FCM 배선 — 비Authenticated 결과는 register 미호출', () {
    test('signInWithKakao: NeedsTerms 결과 → register 0회', () async {
      final (:container, fcmSpy: fcmSpy, calls: _) =
          makeSpyContainer(mockRepo: MockAuthRepository.newUser());

      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signInWithKakao();

      await Future<void>.delayed(Duration.zero);

      expect(fcmSpy.registerCount, 0,
          reason: 'NeedsTerms는 Authenticated 아님 → register 미호출');
    });

    test('signInWithKakao: Recoverable 결과 → register 0회', () async {
      final (:container, fcmSpy: fcmSpy, calls: _) =
          makeSpyContainer(mockRepo: MockAuthRepository.deletionGrace());

      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signInWithKakao();

      await Future<void>.delayed(Duration.zero);

      expect(fcmSpy.registerCount, 0,
          reason: 'Recoverable은 Authenticated 아님 → register 미호출');
    });
  });

  // -------------------------------------------------------------------------
  // ③ logout/withdraw → deleteToken 1회 + auth 호출 전 순서 검증
  // -------------------------------------------------------------------------
  group('AuthController FCM 배선 — 로그아웃/탈퇴 delete 순서', () {
    test('logout: deleteToken 1회 + authRepository.logout() 보다 먼저', () async {
      final mockRepo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final (:container, fcmSpy: fcmSpy, :calls) =
          makeSpyContainer(mockRepo: mockRepo);

      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).logout();

      expect(fcmSpy.deleteCount, 1, reason: 'logout 시 deleteToken 1회');
      expect(
        calls.indexOf('fcm.delete') < calls.indexOf('auth.logout'),
        isTrue,
        reason: 'fcm.delete가 auth.logout보다 먼저 기록되어야 한다',
      );
    });

    test('withdraw: deleteToken 1회 + authRepository.withdraw() 보다 먼저', () async {
      final mockRepo = MockAuthRepository(
        initialSession: const AuthSession(
          userId: 'mock-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
        ),
      );
      final (:container, fcmSpy: fcmSpy, :calls) =
          makeSpyContainer(mockRepo: mockRepo);

      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).withdraw();

      expect(fcmSpy.deleteCount, 1, reason: 'withdraw 시 deleteToken 1회');
      expect(
        calls.indexOf('fcm.delete') < calls.indexOf('auth.withdraw'),
        isTrue,
        reason: 'fcm.delete가 auth.withdraw보다 먼저 기록되어야 한다',
      );
    });
  });
}
