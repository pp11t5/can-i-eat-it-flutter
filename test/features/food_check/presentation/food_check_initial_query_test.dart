import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// initialQuery를 라우트 쿼리 파라미터로 전달하는 테스트 라우터.
GoRouter _routerWithQuery(String query) => GoRouter(
      initialLocation: '/check?initialQuery=$query',
      routes: [
        GoRoute(
          path: '/check',
          builder: (context, state) {
            final q = state.uri.queryParameters['initialQuery'];
            return FoodCheckScreen(initialQuery: q);
          },
        ),
        GoRoute(
          path: '/verdict',
          builder: (_, __) =>
              const Scaffold(body: Text('verdict stub')),
        ),
      ],
    );

/// `initialQuery` 없이 직접 위젯으로 마운트하는 래퍼.
Widget _wrapDirect(String initialQuery) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider
            .overrideWithValue(MockFoodRepository.empty()),
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider
            .overrideWithValue(MockMealRepository.empty()),
      ],
      child: MaterialApp(
        home: FoodCheckScreen(initialQuery: initialQuery),
      ),
    );

Widget _wrapRouter(String query) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider
            .overrideWithValue(MockFoodRepository.empty()),
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider
            .overrideWithValue(MockMealRepository.empty()),
      ],
      child: MaterialApp.router(routerConfig: _routerWithQuery(query)),
    );

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('FoodCheckScreen — initialQuery', () {
    testWidgets('initialQuery 전달 시 검색창에 해당 텍스트가 입력된 상태로 표시된다',
        (tester) async {
      await tester.pumpWidget(_wrapDirect('두부'));
      // initState postFrameCallback 실행 대기
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 검색창(TextField)에 '두부'가 입력돼 있어야 함
      expect(find.text('두부'), findsOneWidget);
    });

    testWidgets('라우트 쿼리 파라미터 initialQuery가 FoodCheckScreen에 전달된다',
        (tester) async {
      await tester.pumpWidget(_wrapRouter('된장찌개'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 검색창에 '된장찌개' 입력 확인
      expect(find.text('된장찌개'), findsOneWidget);
    });
  });
}
