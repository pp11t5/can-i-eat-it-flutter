@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_food_detail_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_detail_screen.dart';

/// 골든 테스트 — 신 상세 화면 (식사 상세 / 음식 상세).
///
/// 생성된 PNG 경로:
/// - test/features/meal_log/presentation/goldens/meal_record_detail.png
/// - test/features/meal_log/presentation/goldens/meal_food_detail_with_analysis.png
///
/// 재생성:
///   flutter test --update-goldens --tags golden \
///     test/features/meal_log/presentation/meal_detail_golden_test.dart

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: child,
    ),
  );
}

void main() {
  group('식사·음식 상세 골든 테스트', () {
    testWidgets('식사 상세 — record-002(음식 3건 + 상태기록)', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(const MealRecordDetailScreen(mealRecordId: 'record-002')),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MealRecordDetailScreen),
        matchesGoldenFile('goldens/meal_record_detail.png'),
      );
    });

    testWidgets('음식 상세 — food-001(analysis 2섹션)', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(const MealFoodDetailScreen(mealFoodId: 'food-001')),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MealFoodDetailScreen),
        matchesGoldenFile('goldens/meal_food_detail_with_analysis.png'),
      );
    });
  });
}
