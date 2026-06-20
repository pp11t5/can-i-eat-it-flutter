import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/recent_verdict_card_widget.dart';

void main() {
  group('RecentVerdictCardWidget', () {
    testWidgets("'최근 판정' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RecentVerdictCardWidget())),
      );

      expect(find.text('최근 판정'), findsOneWidget);
    });

    testWidgets("'두부' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RecentVerdictCardWidget())),
      );

      expect(find.text('두부'), findsOneWidget);
    });

    testWidgets("'권장' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RecentVerdictCardWidget())),
      );

      expect(find.text('권장'), findsOneWidget);
    });
  });
}
