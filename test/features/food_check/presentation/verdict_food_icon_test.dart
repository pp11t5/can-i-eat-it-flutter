import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';

Widget _wrap(Widget child) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
      ],
      child: MaterialApp(home: child),
    );

void main() {
  group('VerdictResultScreen — 음식 이미지 플레이스홀더', () {
    testWidgets('Icons.restaurant 아이콘이 판정 결과 화면에 표시된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      final restaurantIcons = tester
          .widgetList<Icon>(find.byType(Icon))
          .where((icon) => icon.icon == Icons.restaurant)
          .toList();
      expect(restaurantIcons, isNotEmpty);
    });
  });
}
