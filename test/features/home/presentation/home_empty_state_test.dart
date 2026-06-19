import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';

Widget _wrap({List<RecentFood> recentFoods = const []}) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider.overrideWithValue(
          recentFoods.isEmpty
              ? MockFoodRepository.empty()
              : MockFoodRepository.withRecent(recentFoods),
        ),
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('HomeScreen — 빈 상태 위젯', () {
    testWidgets('최근 검색 기록이 없을 때 빈 상태 타이틀이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('오늘 뭐 먹을지 고민되나요?'), findsOneWidget);
    });

    testWidgets('최근 검색 기록이 있을 때 빈 상태 위젯이 표시되지 않는다', (tester) async {
      final recentFoods = [
        RecentFood(
          foodExternalId: 'food-1',
          name: '두부',
          searchedAt: DateTime(2026, 6, 20),
        ),
      ];
      await tester.pumpWidget(_wrap(recentFoods: recentFoods));
      await _settle(tester);

      expect(find.text('오늘 뭐 먹을지 고민되나요?'), findsNothing);
    });
  });
}
