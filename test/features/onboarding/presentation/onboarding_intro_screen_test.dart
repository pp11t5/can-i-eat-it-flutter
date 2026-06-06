import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_intro_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/intro',
      routes: [
        GoRoute(
          path: '/onboarding/intro',
          builder: (_, __) => const OnboardingIntroScreen(),
        ),
        GoRoute(
          path: '/onboarding/condition',
          builder: (_, __) =>
              const Scaffold(body: Text('condition stub')),
        ),
      ],
    );

Widget _wrap() => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('OnboardingIntroScreen', () {
    testWidgets('타이틀 "맞춤 판별을 위해"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('맞춤 판별을 위해'), findsOneWidget);
    });

    testWidgets('서브타이틀 "약 1분이면 충분해요"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('약 1분이면 충분해요'), findsOneWidget);
    });

    testWidgets('"시작하기" 버튼이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('시작하기'), findsOneWidget);
    });

    testWidgets('"시작하기" 버튼 탭 시 /onboarding/condition으로 이동한다',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('시작하기'));
      await tester.pumpAndSettle();

      expect(find.text('condition stub'), findsOneWidget);
    });
  });
}
