@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/fab_action_sheet.dart';

/// 골든 테스트 — FAB 액션시트 펼침 + 식사기록 화면.
///
/// 생성 경로:
/// - test/features/meal_log/presentation/goldens/fab_action_sheet_open.png
/// - test/features/meal_log/presentation/goldens/meal_record_screen_default.png
///
/// 재생성:
///   flutter test --update-goldens --tags golden \
///     test/features/meal_log/presentation/fab_meal_record_golden_test.dart
void main() {
  group('골든 — FAB 액션시트 펼침', () {
    testWidgets('fab_action_sheet_open', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        initialLocation: '/timeline',
        routes: [
          GoRoute(
            path: '/timeline',
            pageBuilder: (context, state) => MaterialPage(
              child: Builder(
                builder: (ctx) => Scaffold(
                  backgroundColor: const Color(0xFFF5F5F5),
                  body: const Center(child: Text('타임라인')),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => showFabActionSheet(ctx),
                    backgroundColor: const Color(0xFF00BF72),
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/meal/record',
            pageBuilder: (_, __) => const MaterialPage(
              child: Scaffold(body: Text('meal/record')),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // FAB 탭으로 시트 열기
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/fab_action_sheet_open.png'),
      );
    });
  });

  group('골든 — 식사기록 화면', () {
    testWidgets('meal_record_screen_default', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        initialLocation: '/meal/record',
        routes: [
          GoRoute(
            path: '/meal/record',
            pageBuilder: (_, state) => const MaterialPage(
              child: MealRecordScreen(),
            ),
          ),
          GoRoute(
            path: '/check',
            pageBuilder: (_, __) => const MaterialPage(
              child: Scaffold(body: Text('check')),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/meal_record_screen_default.png'),
      );
    });
  });
}
