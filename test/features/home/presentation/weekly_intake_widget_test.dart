import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/weekly_intake_widget.dart';

void main() {
  group('WeeklyIntakeWidget', () {
    testWidgets("'이번 주 섭취 통계' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeeklyIntakeWidget())),
      );

      expect(find.text('이번 주 섭취 통계'), findsOneWidget);
    });

    testWidgets("요일 '월' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeeklyIntakeWidget())),
      );

      expect(find.text('월'), findsOneWidget);
    });

    testWidgets("요일 '일' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeeklyIntakeWidget())),
      );

      expect(find.text('일'), findsOneWidget);
    });
  });
}
