@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_detail_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_group_detail_screen.dart';

/// 골든 테스트 — 식사 상세 화면 (F3-3).
///
/// 생성된 PNG 경로:
/// - test/features/meal_log/presentation/goldens/meal_detail_with_state_records.png
/// - test/features/meal_log/presentation/goldens/meal_group_detail.png
///
/// 재생성:
///   flutter test --update-goldens --tags golden \
///     test/features/meal_log/presentation/meal_detail_golden_test.dart

Widget _wrapDetail(String mealId) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: MealDetailScreen(mealId: mealId),
    ),
  );
}

const _testGroup = MealGroup(
  mealGroupId: 'group-001',
  eatenAt: '2026-06-17T08:00:00+09:00',
  records: [
    MealRecord(
      mealId: 'meal-001',
      mealGroupId: 'group-001',
      eatenAt: '2026-06-17T08:00:00+09:00',
      food: FoodSummary(externalId: 'food-001', name: '두부'),
      judgedGrade: VerdictLevel.recommend,
    ),
    MealRecord(
      mealId: 'meal-002',
      mealGroupId: 'group-001',
      eatenAt: '2026-06-17T08:05:00+09:00',
      food: FoodSummary(externalId: 'food-002', name: '커피'),
      judgedGrade: VerdictLevel.risk,
    ),
  ],
);

Widget _wrapGroup() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MealGroupDetailScreen(group: _testGroup),
    ),
  );
}

void main() {
  group('식사 상세 골든 테스트', () {
    testWidgets('단일 상세 — 상태기록 있는 meal-002(커피)', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapDetail('meal-002'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MealDetailScreen),
        matchesGoldenFile('goldens/meal_detail_with_state_records.png'),
      );
    });

    testWidgets('그룹 상세 — 2개 음식 행', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapGroup());
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MealGroupDetailScreen),
        matchesGoldenFile('goldens/meal_group_detail.png'),
      );
    });
  });
}
