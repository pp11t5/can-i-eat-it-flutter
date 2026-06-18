import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_group_detail_screen.dart';

const _testGroup = MealGroup(
  mealGroupId: 'group-test',
  eatenAt: '2026-06-17T08:00:00+09:00',
  records: [
    MealRecord(
      mealId: 'meal-001',
      mealGroupId: 'group-test',
      eatenAt: '2026-06-17T08:00:00+09:00',
      food: FoodSummary(externalId: 'food-001', name: '두부'),
      judgedGrade: VerdictLevel.recommend,
    ),
    MealRecord(
      mealId: 'meal-002',
      mealGroupId: 'group-test',
      eatenAt: '2026-06-17T08:05:00+09:00',
      food: FoodSummary(externalId: 'food-002', name: '커피'),
      judgedGrade: VerdictLevel.risk,
    ),
  ],
);

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  group('MealGroupDetailScreen — 기본 렌더', () {
    testWidgets('음식 행 목록 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealGroupDetailScreen(group: _testGroup)),
      );
      await tester.pumpAndSettle();

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('커피'), findsOneWidget);
    });

    testWidgets('TopBar 제목 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealGroupDetailScreen(group: _testGroup)),
      );
      await tester.pumpAndSettle();

      expect(find.text('식사 상세 정보'), findsOneWidget);
    });

    testWidgets('헤더 시각 문구 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealGroupDetailScreen(group: _testGroup)),
      );
      await tester.pumpAndSettle();

      // "HH:mm 시간에 먹은 음식이에요" 형태 포함
      expect(find.textContaining('시간에 먹은 음식이에요'), findsOneWidget);
    });
  });

  group('MealGroupDetailScreen — 음식 행 탭 → 단일상세 진입', () {
    testWidgets('두부 행 탭 시 /meal/meal-001 경로로 push', (tester) async {
      final router = GoRouter(
        initialLocation: '/group',
        routes: [
          GoRoute(
            path: '/group',
            builder: (_, __) => const MealGroupDetailScreen(group: _testGroup),
          ),
          GoRoute(
            path: '/meal/:mealId',
            builder: (_, __) => const Scaffold(body: Text('상세')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('두부'));
      await tester.pumpAndSettle();

      // 단일상세 화면으로 이동됨
      expect(find.text('상세'), findsOneWidget);
    });
  });
}
