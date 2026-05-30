import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

void main() {
  // ---------------------------------------------------------------------------
  // resolveRedirect 가드 테스트
  // ---------------------------------------------------------------------------

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
    test('약관 미동의 상태에서 /terms 가 아닌 경로 진입 시 /terms 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsTerms,
        location: '/',
      );
      expect(result, '/terms');
    });

    test('약관 미동의 상태에서 이미 /terms 이면 리다이렉트하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsTerms,
        location: '/terms',
      );
      expect(result, isNull);
    });

    test('약관 미동의 상태에서 /login 은 허용된다 (LoginScreen 이 명시적 push 로 진입)', () {
      // 이유: redirect 로 /terms 강제 시 replace 가 되어 iOS pop 애니메이션 불가.
      // LoginScreen 이 signInWithKakao 후 명시적 context.push('/terms') 로 진입한다.
      final result = resolveRedirect(
        status: SessionStatus.needsTerms,
        location: '/login',
      );
      expect(result, isNull);
    });
  });

  group('resolveRedirect — 온보딩 미완료(needsOnboarding)', () {
    test('인증됐지만 온보딩 미완료면 /onboarding/intro 로 리다이렉트한다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsOnboarding,
        location: '/',
      );
      expect(result, '/onboarding/intro');
    });

    test('온보딩 미완료 상태에서 이미 /onboarding/intro 이면 리다이렉트하지 않는다', () {
      final result = resolveRedirect(
        status: SessionStatus.needsOnboarding,
        location: '/onboarding/intro',
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
        location: '/onboarding/intro',
      );
      expect(result, '/');
    });
  });

  // ---------------------------------------------------------------------------
  // sessionStatusFromSession 순수 함수 단위 테스트
  // ---------------------------------------------------------------------------

  group('sessionStatusFromSession — 세션 → SessionStatus 파생', () {
    test('session == null 이면 unauthenticated 를 반환한다', () {
      expect(
        sessionStatusFromSession(null),
        SessionStatus.unauthenticated,
      );
    });

    test('신규 사용자(hasAgreedTerms=false)이면 needsTerms 를 반환한다', () {
      const session = AuthSession(
        userId: 'new-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: false,
        hasCompletedOnboarding: false,
      );
      expect(sessionStatusFromSession(session), SessionStatus.needsTerms);
    });

    test('약관 동의했지만 온보딩 미완료(hasCompletedOnboarding=false)이면 needsOnboarding 을 반환한다',
        () {
      const session = AuthSession(
        userId: 'existing-not-onboarded',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        hasCompletedOnboarding: false,
      );
      expect(
        sessionStatusFromSession(session),
        SessionStatus.needsOnboarding,
      );
    });

    test('약관 동의+온보딩 완료이면 ready 를 반환한다', () {
      const session = AuthSession(
        userId: 'existing-onboarded',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        hasCompletedOnboarding: true,
      );
      expect(sessionStatusFromSession(session), SessionStatus.ready);
    });
  });
}
