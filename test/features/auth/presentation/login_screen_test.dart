import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';

/// LoginScreen 이 sign-in 후 SignInOutcome switch 로 분기하는 것을 검증한다.
/// GoRouter 컨텍스트가 필요해 최소 라우트만 등록한다.
GoRouter _testRouter() => GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(
          path: '/terms',
          builder: (_, __) => const Scaffold(body: Text('terms stub')),
        ),
        GoRoute(
          path: '/onboarding/condition',
          builder: (_, __) => const Scaffold(body: Text('onboarding stub')),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('home stub')),
        ),
      ],
    );

Widget _wrap(MockAuthRepository repo) => ProviderScope(
      // 테스트 루트 ProviderScope override — dependencies 불필요.
      // ignore: scoped_providers_should_specify_dependencies
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('LoginScreen 플랫폼 분기', () {
    testWidgets('Android 에서는 카카오 버튼만 보이고 Apple 버튼은 없다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 로그인'), findsOneWidget);
      expect(find.text('Apple로 로그인'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('iOS 에서는 카카오와 Apple 버튼이 모두 보인다', (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 로그인'), findsOneWidget);
      expect(find.text('Apple로 로그인'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });

  group('LoginScreen 로그인 동작 — SignInOutcome 분기', () {
    testWidgets(
        'NeedsTerms(newUser) — 카카오 로그인 시 /terms 로 push 된다',
        (tester) async {
      final repo = MockAuthRepository.newUser();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      // /terms stub 이 보인다.
      expect(find.text('terms stub'), findsOneWidget);
      // home 이나 onboarding 으로 이동하지 않는다.
      expect(find.text('home stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'Authenticated(onboarded=true) — 카카오 로그인 시 / 로 이동한다',
        (tester) async {
      final repo = MockAuthRepository.existing(onboarded: true);
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('home stub'), findsOneWidget);
      expect(find.text('terms stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'Authenticated(onboarded=false) — 카카오 로그인 시 /onboarding/condition 으로 이동한다',
        (tester) async {
      final repo = MockAuthRepository.existing(onboarded: false);
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('onboarding stub'), findsOneWidget);
      expect(find.text('home stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'Recoverable(deletionGrace) — 카카오 로그인 시 복구 다이얼로그가 뜬다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.deletionGrace()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('탈퇴를 진행 중인 계정이에요'), findsOneWidget);
      // 다이얼로그 분기라 /terms 로 push 되지 않음.
      expect(find.text('terms stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
