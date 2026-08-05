import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/core/push/push_route_navigator.dart';

void main() {
  group('needsHomeBaseline', () {
    test('pre-auth 경로만 true', () {
      expect(needsHomeBaseline('/splash'), isTrue);
      expect(needsHomeBaseline('/login'), isTrue);
      expect(needsHomeBaseline('/terms'), isTrue);
      expect(needsHomeBaseline('/onboarding/condition'), isTrue);
      expect(needsHomeBaseline('/'), isFalse);
      expect(needsHomeBaseline('/weekly-report'), isFalse);
      expect(needsHomeBaseline('/symptom/record'), isFalse);
    });
  });

  group('navigateFromPush', () {
    late GoRouter router;

    tearDown(() {
      router.dispose();
    });

    GoRouter buildRouter({required String initialLocation}) {
      return GoRouter(
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            path: '/splash',
            builder: (_, __) => const SizedBox(key: Key('splash')),
          ),
          GoRoute(
            path: '/',
            builder: (_, __) => const SizedBox(key: Key('home')),
          ),
          GoRoute(
            path: '/login',
            builder: (_, __) => const SizedBox(key: Key('login')),
          ),
          GoRoute(
            path: '/weekly-report',
            builder: (_, __) => const SizedBox(key: Key('weekly')),
          ),
          GoRoute(
            path: '/symptom/record',
            builder: (_, __) => const SizedBox(key: Key('symptom')),
          ),
        ],
      );
    }

    Future<void> pumpRouter(WidgetTester tester, GoRouter r) async {
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: r),
      );
      await tester.pump();
    }

    /// 테스트 환경에서 프레임을 진행시켜 go_router 전환을 반영한다.
    Future<void> Function() pumpWait(WidgetTester tester) {
      return () async {
        await tester.pump();
      };
    }

    testWidgets('홈에 있으면 바로 목적지를 push한다', (tester) async {
      router = buildRouter(initialLocation: '/');
      await pumpRouter(tester, router);

      await navigateFromPush(
        router: router,
        location: '/weekly-report',
        waitFrame: pumpWait(tester),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('weekly')), findsOneWidget);
    });

    testWidgets('splash면 홈 baseline 후 목적지를 push한다', (tester) async {
      router = buildRouter(initialLocation: '/splash');
      await pumpRouter(tester, router);

      await navigateFromPush(
        router: router,
        location: '/weekly-report',
        waitFrame: pumpWait(tester),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('weekly')), findsOneWidget);
      expect(find.byKey(const Key('splash')), findsNothing);
    });

    testWidgets('식후 증상 경로도 cold baseline 후 push된다', (tester) async {
      router = buildRouter(initialLocation: '/splash');
      await pumpRouter(tester, router);

      await navigateFromPush(
        router: router,
        location: '/symptom/record?mealRecordId=42',
        waitFrame: pumpWait(tester),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('symptom')), findsOneWidget);
    });
  });
}
