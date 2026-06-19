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

RecentFood _recentFood(String id, String name) => RecentFood(
      foodExternalId: id,
      name: name,
      searchedAt: DateTime(2026, 6, 20),
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
  group('FoodCheckScreen — 전체 삭제 확인 다이얼로그', () {
    testWidgets('"전체 삭제" 탭 시 확인 다이얼로그가 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrapWithRecent([_recentFood('food-1', '두부')]),
      );
      await _settle(tester);

      await tester.tap(find.text('전체 삭제'));
      await _settle(tester);

      expect(find.text('최근 검색 삭제'), findsOneWidget);
      expect(find.text('최근 검색 기록을 모두 삭제하시겠어요?'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
      expect(find.text('삭제'), findsOneWidget);
    });
  });
}
