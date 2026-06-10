@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';

// 마스터 Figma 정합 검증용 골든 — 검색결과 패널(554-5322) + 직접분석(365-1849).
GoRouter _router() => GoRouter(
      initialLocation: '/check',
      routes: [
        GoRoute(path: '/check', builder: (_, __) => const FoodCheckScreen()),
        GoRoute(
          path: '/verdict',
          builder: (_, s) => Scaffold(body: Text('verdict:${s.extra}')),
        ),
      ],
    );

Widget _wrap(MockFoodRepository repo) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: [foodRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: _router()),
    );

FoodSummary _f(String id, String name, [String? cat]) =>
    FoodSummary(externalId: id, name: name, category: cat);

void main() {
  testWidgets('검색결과 패널 골든 (Figma 554-5322)', (tester) async {
    final repo = MockFoodRepository.withSearchResults([
      _f('f-1', '된장찌개', '한식'),
      _f('f-2', '된장국', '한식'),
      _f('f-3', '청국장찌개', '한식'),
    ]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '된장');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(FoodCheckScreen),
      matchesGoldenFile('goldens/search_results.png'),
    );
  });

  testWidgets('직접분석(매칭없음) 골든 (Figma 365-1849)', (tester) async {
    final repo = MockFoodRepository.withSearchResults([]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '간장 닭갈비 정식');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(FoodCheckScreen),
      matchesGoldenFile('goldens/search_no_result.png'),
    );
  });
}
