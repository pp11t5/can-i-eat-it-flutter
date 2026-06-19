import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';

// 최근 검색 항목이 있어야 헤더가 렌더됨
MockFoodRepository _repoWithRecent() => MockFoodRepository.withRecent([
      RecentFood(
        foodExternalId: 'tofu',
        name: '두부',
        searchedAt: DateTime(2026, 6, 20),
      ),
    ]);

String _lastLocation = '/';

GoRouter _testRouter() => GoRouter(
      initialLocation: '/',
      observers: [],
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/check',
          builder: (context, state) {
            _lastLocation = '/check';
            return const Scaffold(body: Text('check stub'));
          },
        ),
        GoRoute(
          path: '/verdict',
          builder: (_, __) => const Scaffold(body: Text('verdict stub')),
        ),
      ],
    );

Widget _wrap() => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider.overrideWithValue(_repoWithRecent()),
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
      ],
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() => _lastLocation = '/');

  group('HomeScreen — 최근 검색 섹션 헤더', () {
    testWidgets('"전체보기" 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('전체보기'), findsOneWidget);
    });

    testWidgets('"전체보기" 탭 시 /check 라우트로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // 홈 화면 콘텐츠가 길어져 스크롤 필요
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await _settle(tester);
      await tester.tap(find.text('전체보기').first);
      await _settle(tester);

      expect(_lastLocation, '/check');
    });
  });
}
