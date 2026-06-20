import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/health_goal_widget.dart';

void main() {
  group('HealthGoalWidget', () {
    testWidgets("'이번 주 건강 목표' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthGoalWidget())),
      );

      expect(find.text('이번 주 건강 목표'), findsOneWidget);
    });

    testWidgets("'3/5 달성' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthGoalWidget())),
      );

      expect(find.text('3/5 달성'), findsOneWidget);
    });

    testWidgets("'60%' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthGoalWidget())),
      );

      expect(find.text('60%'), findsOneWidget);
    });
  });
}
