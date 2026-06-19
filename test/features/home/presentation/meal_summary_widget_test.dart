import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/meal_summary_widget.dart';

void main() {
  group('MealSummaryWidget', () {
    testWidgets("'오늘의 식사' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MealSummaryWidget())),
      );

      expect(find.text('오늘의 식사'), findsOneWidget);
    });

    testWidgets("'3회 기록됨' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MealSummaryWidget())),
      );

      expect(find.text('3회 기록됨'), findsOneWidget);
    });
  });
}
