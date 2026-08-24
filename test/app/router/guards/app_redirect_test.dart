import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/router/guards/app_redirect.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

void main() {
  group('resolveAppRedirect', () {
    test('ready면 위젯 URI를 앱 경로로 보낸다', () {
      expect(
        resolveAppRedirect(
          status: SessionStatus.ready,
          uri: Uri.parse('canieatit://widget/meal-record'),
          matchedLocation: '/meal-record',
        ),
        '/meal/record',
      );
    });

    test('loading이면 위젯 URI를 splash에 둔다', () {
      expect(
        resolveAppRedirect(
          status: SessionStatus.loading,
          uri: Uri.parse('canieatit://widget/symptom-record?mealRecordId=mr-1'),
          matchedLocation: '/symptom-record',
        ),
        '/splash',
      );
    });

    test('미인증이면 로그인으로 보낸다', () {
      expect(
        resolveAppRedirect(
          status: SessionStatus.unauthenticated,
          uri: Uri.parse('canieatit://widget/food-history'),
          matchedLocation: '/food-history',
        ),
        '/login',
      );
    });

    test('일반 경로는 세션 가드만 탄다', () {
      expect(
        resolveAppRedirect(
          status: SessionStatus.ready,
          uri: Uri.parse('/timeline'),
          matchedLocation: '/timeline',
        ),
        isNull,
      );
    });
  });

  testWidgets('위젯 별칭 경로는 Page Not Found가 아니다', (tester) async {
    final router = GoRouter(
      initialLocation: '/meal-record',
      redirect: (context, state) => resolveAppRedirect(
        status: SessionStatus.ready,
        uri: state.uri,
        matchedLocation: state.matchedLocation,
      ),
      routes: [
        GoRoute(
          path: '/meal/record',
          builder: (_, __) => const Text('meal-record-ok'),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Text('home'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Page Not Found'), findsNothing);
    expect(find.text('meal-record-ok'), findsOneWidget);
  });
}
