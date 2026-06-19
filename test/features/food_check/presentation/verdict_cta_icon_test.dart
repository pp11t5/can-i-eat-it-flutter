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
  group('VerdictResultScreen — CTA 버튼 아이콘', () {
    late Widget screen;

    setUp(() {
      final verdict = EatVerdict.recommend(foodName: '두부');
      screen = _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {}));
    });

    testWidgets('공유하기 버튼에 Icons.share 아이콘이 표시된다', (tester) async {
      await tester.pumpWidget(screen);
      await tester.pump();

      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('다시 검색 버튼에 Icons.search 아이콘이 표시된다', (tester) async {
      await tester.pumpWidget(screen);
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
