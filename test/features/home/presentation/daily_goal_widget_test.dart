import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/daily_goal_widget.dart';

void main() {
  group('DailyGoalWidget', () {
    testWidgets("'오늘의 목표' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DailyGoalWidget())),
      );

      expect(find.text('오늘의 목표'), findsOneWidget);
    });

    testWidgets("'자극적인 음식 피하기' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DailyGoalWidget())),
      );

      expect(find.text('자극적인 음식 피하기'), findsOneWidget);
    });

    testWidgets('LinearProgressIndicator가 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DailyGoalWidget())),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
