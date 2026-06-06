import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

void main() {
  // ---------------------------------------------------------------------------
  // resolveRedirect 가드 테스트
  // ---------------------------------------------------------------------------

  group('resolveRedirect — 로딩(loading)', () {
    test('loading 상태에서는 어떤 location에서도 redirect 하지 않는다 (/splash)', () {
      final result = resolveRedirect(
        status: SessionStatus.loading,
        location: '/splash',
      );
      expect(result, isNull);
    });

    test('loading 상태에서 보호 화면(/)에서도 redirect 하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.loading,
        location: '/',
      );
      expect(result, isNull);
    });
  });

  group('resolveRedirect — 미인증(unauthenticated)', () {
    test('미인증 상태에서 보호 화면 진입 시 /login 으로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.unauthenticated,
        location: '/',
      );
      expect(result, '/login');
    });

    test('미인증 상태에서 이미 /login 이면 리다이렉트하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.unauthenticated,
        location: '/login',
      );
      expect(result, isNull);
    });
  });

  group('resolveRedirect — 약관 미동의(needsTerms)', () {
    // 가드는 needsTerms 에서 절대 redirect 하지 않는다 (모든 location 허용).
    // 진입은 LoginScreen 이 imperative push 로만 관리.

    test('약관 미동의 상태에서 / 진입은 그대로 둔다(가드 미관여)', () {
      final result = resolveRedirect(
        status: SessionStatus.needsTerms,
        location: '/',
      );
      expect(result, isNull);
    });

    test('약관 미동의 상태에서 /terms 도 그대로 둔다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsTerms,
        location: '/terms',
      );
      expect(result, isNull);
    });

    test('약관 미동의 상태에서 /login 도 그대로 둔다 (pop 후 재진입 차단)', () {
      // LoginScreen 이 push 로 /terms 진입을 관리하므로 가드가 강제하지 않음.
      // 이로써 pop 후 /login 에 있을 때 가드가 /terms 로 재push 하지 않는다.
      final result = resolveRedirect(
        status: SessionStatus.needsTerms,
        location: '/login',
      );
      expect(result, isNull);
    });
  });

  group('resolveRedirect — 온보딩 미완료(needsOnboarding)', () {
    test('인증됐지만 온보딩 미완료면 /onboarding/condition 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsOnboarding,
        location: '/',
      );
      expect(result, '/onboarding/condition');
    });

    test('온보딩 미완료 상태에서 이미 /onboarding/condition 이면 리다이렉트하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsOnboarding,
        location: '/onboarding/condition',
      );
      expect(result, isNull);
    });

    test('온보딩 미완료 상태에서 /onboarding 하위 경로는 리다이렉트하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsOnboarding,
        location: '/onboarding/step2',
      );
      expect(result, isNull);
    });
  });

  group('resolveRedirect — 인증+온보딩 완료(ready)', () {
    test('인증+온보딩 완료 상태에서 /splash 진입 시 / 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.ready,
        location: '/splash',
      );
      expect(result, '/');
    });

    test('인증+온보딩 완료 상태에서 /login 진입 시 / 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.ready,
        location: '/login',
      );
      expect(result, '/');
    });

    test('인증+온보딩 완료 상태에서 /terms 진입 시 / 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.ready,
        location: '/terms',
      );
      expect(result, '/');
    });

    test('인증+온보딩 완료 상태에서 보호 화면(/timeline)은 리다이렉트하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.ready,
        location: '/timeline',
      );
      expect(result, isNull);
    });

    test('인증+온보딩 완료 상태에서 /onboarding 경로는 / 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.ready,
        location: '/onboarding/condition',
      );
      expect(result, '/');
    });
  });

  // ---------------------------------------------------------------------------
  // sessionStatusFrom 순수 함수 단위 테스트
  // ---------------------------------------------------------------------------

  group('sessionStatusFrom — (authSession, hasProfile) → SessionStatus 파생', () {
    test('authSession == null 이면 unauthenticated 를 반환한다 (hasProfile 무관)', () {
      expect(
        sessionStatusFrom(authSession: null, hasProfile: false),
        SessionStatus.unauthenticated,
      );
      expect(
        sessionStatusFrom(authSession: null, hasProfile: true),
        SessionStatus.unauthenticated,
      );
      expect(
        sessionStatusFrom(authSession: null, hasProfile: null),
        SessionStatus.unauthenticated,
      );
    });

    test('신규 사용자(hasAgreedTerms=false)이면 needsTerms 를 반환한다', () {
      const session = AuthSession(
        userId: 'new-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: false,
      );
      expect(
        sessionStatusFrom(authSession: session, hasProfile: false),
        SessionStatus.needsTerms,
      );
    });

    test('약관 동의 + hasProfile==null 이면 loading 을 반환한다', () {
      const session = AuthSession(
        userId: 'agreed-loading',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      expect(
        sessionStatusFrom(authSession: session, hasProfile: null),
        SessionStatus.loading,
      );
    });

    test('약관 동의 + hasProfile==false 이면 needsOnboarding 을 반환한다', () {
      const session = AuthSession(
        userId: 'existing-not-onboarded',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      expect(
        sessionStatusFrom(authSession: session, hasProfile: false),
        SessionStatus.needsOnboarding,
      );
    });

    test('약관 동의 + hasProfile==true 이면 ready 를 반환한다', () {
      const session = AuthSession(
        userId: 'existing-onboarded',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      expect(
        sessionStatusFrom(authSession: session, hasProfile: true),
        SessionStatus.ready,
      );
    });

    test('삭제유예 상태는 (약관·hasProfile 무관하게) unauthenticated 로 취급된다', () {
      // 이유: 가드가 ready 로 보고 / 로 redirect 하면 02a 다이얼로그가 가려진다.
      // LoginScreen 이 다이얼로그를 띄울 때까지 사용자를 /login 에 머물게 한다.
      const session = AuthSession(
        userId: 'mock-deletion-grace',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.deletionGrace,
      );
      expect(
        sessionStatusFrom(authSession: session, hasProfile: true),
        SessionStatus.unauthenticated,
      );
    });
  });
}
