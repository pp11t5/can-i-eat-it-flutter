import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/recent_verdict_preview_widget.dart';

void main() {
  group('RecentVerdictPreviewWidget', () {
    testWidgets("'최근 판정' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RecentVerdictPreviewWidget()),
        ),
      );

      expect(find.text('최근 판정'), findsOneWidget);
    });

    testWidgets("'두부' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RecentVerdictPreviewWidget()),
        ),
      );

      expect(find.text('두부'), findsOneWidget);
    });

    testWidgets("'커피' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RecentVerdictPreviewWidget()),
        ),
      );

      expect(find.text('커피'), findsOneWidget);
    });
  });
}
