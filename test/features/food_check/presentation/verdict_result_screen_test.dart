import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';

const _kVerdict = EatVerdict(
  level: VerdictLevel.recommend,
  foodName: '두부',
);

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('VerdictResultScreen — 관련 음식 섹션', () {
    testWidgets("'관련 음식' 타이틀 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('관련 음식'), findsOneWidget);
    });

    testWidgets("목 데이터 '두부' 칩이 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.widgetWithText(ActionChip, '두부'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 영양 정보 섹션', () {
    testWidgets("'영양 정보' 타이틀이 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('영양 정보'), findsOneWidget);
    });

    testWidgets("'72 kcal' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('72 kcal'), findsOneWidget);
    });
  });
}
