import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

void main() {
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
}
