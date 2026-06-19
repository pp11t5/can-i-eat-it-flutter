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
  group('VerdictResultScreen — category 표시', () {
    testWidgets('category가 있으면 화면에 표시된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부').copyWith(
        category: '콩류',
      );
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('콩류'), findsOneWidget);
    });

    testWidgets('category가 null이면 표시되지 않는다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      // category 기본값은 null
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      // category 텍스트가 없어야 한다
      expect(find.text('콩류'), findsNothing);
    });
  });
}
