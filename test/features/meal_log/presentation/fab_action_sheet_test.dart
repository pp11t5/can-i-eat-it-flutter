import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/fab_action_sheet.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// GoRouter 기반 앱 — showGeneralDialog가 go_router context에서 실행된다.
Widget _makeApp({
  VoidCallback? onMealRecordPush,
  VoidCallback? onSymptomRecordPush,
}) {
  final router = GoRouter(
    initialLocation: '/timeline',
    routes: [
      GoRoute(
        path: '/timeline',
        pageBuilder: (context, state) => MaterialPage(
          child: Builder(
            builder: (ctx) => Scaffold(
              body: const Text('timeline'),
              floatingActionButton: FloatingActionButton(
                // ctx는 GoRouter의 라우트 컨텍스트 — Navigator 포함
                onPressed: () => showFabActionSheet(ctx),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/meal/record',
        pageBuilder: (context, state) {
          onMealRecordPush?.call();
          return const MaterialPage(
            child: Scaffold(body: Text('meal/record')),
          );
        },
      ),
      GoRoute(
        path: '/symptom/record',
        pageBuilder: (context, state) {
          onSymptomRecordPush?.call();
          return const MaterialPage(
            child: Scaffold(body: Text('symptom/record')),
          );
        },
      ),
    ],
  );

  return MaterialApp.router(
    theme: AppTheme.light,
    routerConfig: router,
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('FabActionSheet — 표시', () {
    testWidgets('FAB 탭 시 액션시트가 나타난다', (tester) async {
      await tester.pumpWidget(_makeApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('🥗 식단 기록'), findsOneWidget);
      expect(find.text('✏️ 증상 일기'), findsOneWidget);
    });

    testWidgets('X 버튼 탭 시 시트가 닫힌다', (tester) async {
      await tester.pumpWidget(_makeApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('🥗 식단 기록'), findsOneWidget);

      // X(close) 아이콘 FAB 탭으로 닫기
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('🥗 식단 기록'), findsNothing);
    });
  });

  group('FabActionSheet — 식단 기록 탭', () {
    testWidgets('"식단 기록" 탭 → /meal/record로 이동한다', (tester) async {
      var navigated = false;
      await tester.pumpWidget(_makeApp(onMealRecordPush: () => navigated = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🥗 식단 기록'));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
      expect(find.text('meal/record'), findsOneWidget);
    });
  });

  group('FabActionSheet — 증상 일기 활성', () {
    testWidgets('"증상 일기" 탭 → /symptom/record로 이동한다', (tester) async {
      var navigated = false;
      await tester.pumpWidget(
        _makeApp(onSymptomRecordPush: () => navigated = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('✏️ 증상 일기'));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
      expect(find.text('symptom/record'), findsOneWidget);
    });
  });
}
