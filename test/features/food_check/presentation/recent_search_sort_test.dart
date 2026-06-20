import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';

GoRouter _testRouter() => GoRouter(
      initialLocation: '/check',
      routes: [
        GoRoute(
          path: '/check',
          builder: (_, __) => const FoodCheckScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('home stub')),
        ),
        GoRoute(
          path: '/verdict',
          builder: (_, __) => const Scaffold(body: Text('verdict stub')),
        ),
      ],
    );

Widget _wrapWithRecent(List<RecentFood> items) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider
            .overrideWithValue(MockFoodRepository.withRecent(items)),
      ],
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('FoodCheckScreen — 최근 검색어 최신순 정렬', () {
    testWidgets('searchedAt이 늦은 항목이 목록 상단에 먼저 표시된다', (tester) async {
      final items = [
        RecentFood(
          foodExternalId: 'old',
          name: '오래된음식',
          searchedAt: DateTime(2026, 6, 1),
        ),
        RecentFood(
          foodExternalId: 'new',
          name: '최신음식',
          searchedAt: DateTime(2026, 6, 20),
        ),
      ];
      await tester.pumpWidget(_wrapWithRecent(items));
      await _settle(tester);

      // 두 항목 모두 화면에 있어야 한다
      expect(find.text('최신음식'), findsOneWidget);
      expect(find.text('오래된음식'), findsOneWidget);

      // 최신음식이 오래된음식보다 위에 위치해야 한다
      final newOffset = tester.getTopLeft(find.text('최신음식')).dy;
      final oldOffset = tester.getTopLeft(find.text('오래된음식')).dy;
      expect(newOffset, lessThanOrEqualTo(oldOffset));
    });
  });
}
