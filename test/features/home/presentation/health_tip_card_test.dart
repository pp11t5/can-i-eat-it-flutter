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

const _tips = [
  '식사 후 바로 눕지 않고 30분 이상 앉아 있으면 역류 증상을 줄일 수 있어요.',
  '물은 식사 중보다 식사 30분 전이나 후에 마시는 것이 소화에 도움이 돼요.',
  '취침 3시간 전에는 음식 섭취를 피하면 수면 중 역류를 예방할 수 있어요.',
  '작은 양을 자주 먹는 것이 한 번에 많이 먹는 것보다 위에 부담이 덜해요.',
  '카페인과 알코올은 하부식도괄약근을 느슨하게 해 역류를 유발할 수 있어요.',
];

void main() {
  group('HomeScreen — 건강 팁 카드', () {
    testWidgets('"오늘의 건강 팁" 텍스트가 홈 화면에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('오늘의 건강 팁'), findsOneWidget);
    });

    testWidgets('5개 팁 문자열 중 하나가 홈 화면에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final anyFound = _tips.any(
        (tip) => find.text(tip).evaluate().isNotEmpty,
      );
      expect(anyFound, isTrue);
    });
  });
}
