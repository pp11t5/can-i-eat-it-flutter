import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';

/// LoginScreen 이 sign-in 후 `context.push('/terms')` 를 호출하므로
/// 테스트도 GoRouter 컨텍스트가 필요. 최소 라우트만 등록한다.
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

      expect(find.text('카카오로 시작하기'), findsOneWidget);
      expect(find.text('Apple로 계속하기'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('iOS 에서는 카카오와 Apple 버튼이 모두 보인다', (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 시작하기'), findsOneWidget);
      expect(find.text('Apple로 계속하기'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });

  group('LoginScreen 로그인 동작', () {
    testWidgets('신규 사용자가 카카오로 로그인하면 /terms 로 push 된다', (tester) async {
      final repo = MockAuthRepository.newUser();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 시작하기'));
      await tester.pumpAndSettle();

      // 세션 생성됨 + /terms 스텁으로 push 됨.
      expect(await repo.currentSession(), isNotNull);
      expect(find.text('terms stub'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('삭제유예 계정으로 로그인하면 복구 다이얼로그가 뜬다 (push 없음)',
        (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.deletionGrace()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 시작하기'));
      await tester.pumpAndSettle();

      expect(find.text('탈퇴를 진행 중인 계정이에요'), findsOneWidget);
      // 다이얼로그 분기라 /terms 로 push 되지 않음.
      expect(find.text('terms stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
