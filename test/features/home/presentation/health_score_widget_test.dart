import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/health_score_widget.dart';

void main() {
  group('HealthScoreWidget', () {
    testWidgets("'오늘의 건강 점수' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthScoreWidget())),
      );

      expect(find.text('오늘의 건강 점수'), findsOneWidget);
    });

    testWidgets("'85점' 텍스트 대신 '85' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthScoreWidget())),
      );

      expect(find.text('85'), findsOneWidget);
    });

    testWidgets('CircularProgressIndicator가 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthScoreWidget())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("'85' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthScoreWidget())),
      );

      expect(find.text('85'), findsOneWidget);
    });

    testWidgets("'매우 좋음' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HealthScoreWidget())),
      );

      expect(find.text('매우 좋음'), findsOneWidget);
    });
  });
}
