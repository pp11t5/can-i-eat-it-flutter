import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';

Widget _wrap() => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty()),
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );

Widget _wrapGreeting({DateTime? nowOverride}) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty()),
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
      ],
      child: MaterialApp(
        home: HomeScreen(nowOverride: nowOverride),
      ),
    );

void main() {
  group('HomeScreen — 인사말 블록 날짜', () {
    testWidgets('현재 연도를 포함한 날짜 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final currentYear = DateTime.now().year.toString();
      expect(find.textContaining(currentYear), findsAtLeastNWidgets(1));
      // "년" 포함 날짜 포맷 확인
      expect(find.textContaining('년'), findsAtLeastNWidgets(1));
      expect(find.textContaining('요일'), findsOneWidget);
    });
  });

  group('HomeScreen — 인사말 블록 시간대별 문구', () {
    testWidgets('아침(hour=8) — 아침 인사말이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrapGreeting(nowOverride: DateTime(2026, 6, 20, 8)),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('좋은 아침이에요!'),
        findsOneWidget,
      );
    });

    testWidgets('점심(hour=12) — 점심 인사말이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrapGreeting(nowOverride: DateTime(2026, 6, 20, 12)),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('점심 시간이에요!'),
        findsOneWidget,
      );
    });

    testWidgets('저녁(hour=19) — 저녁 인사말이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrapGreeting(nowOverride: DateTime(2026, 6, 20, 19)),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('저녁 시간이에요!'),
        findsOneWidget,
      );
    });
  });
}
