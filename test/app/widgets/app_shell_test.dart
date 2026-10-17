import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/app_shell.dart';
import 'package:can_i_eat_it/features/home/data/home_providers.dart';
import 'package:can_i_eat_it/features/home/data/repositories/mock_home_repository.dart';
import 'package:can_i_eat_it/features/home/domain/entities/user_streak.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_controller.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_providers.dart';

class _CountingHomeRepository extends MockHomeRepository {
  int calls = 0;

  @override
  Future<UserStreak> myStreak() async => UserStreak(
        streak: ++calls,
        characterStatus:
            calls == 1 ? CharacterStatus.statisfied : CharacterStatus.grateful,
      );
}

class _NoopHomeWidgetController implements HomeWidgetController {
  @override
  Future<void> sync() async {}
}

void main() {
  testWidgets('홈 탭 재진입·재선택·시스템 뒤로가기에서 UserStreak를 갱신한다', (tester) async {
    final repository = _CountingHomeRepository();
    final router = GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, __, shell) => AppShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/timeline',
                builder: (_, __) => const Scaffold(body: Text('timeline-stub')),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/mypage',
                builder: (_, __) => const Scaffold(body: Text('mypage-stub')),
              ),
            ]),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          homeRepositoryProvider.overrideWithValue(repository),
          // ignore: scoped_providers_should_specify_dependencies
          homeWidgetControllerProvider
              .overrideWithValue(_NoopHomeWidgetController()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(repository.calls, 1);

    await tester.tap(find.text('타임라인'));
    await tester.pumpAndSettle();
    expect(repository.calls, 1);

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    expect(repository.calls, 2);
    expect(find.textContaining('2일'), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/illustrations/character_grateful.png'),
      findsOneWidget,
    );

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    expect(repository.calls, 3);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(repository.calls, 4);
    expect(find.textContaining('4일'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
