import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/quick_search_widget.dart';

void main() {
  group('QuickSearchWidget', () {
    testWidgets("'빠른 재검색' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QuickSearchWidget())),
      );

      expect(find.text('빠른 재검색'), findsOneWidget);
    });

    testWidgets("'두부' ActionChip이 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QuickSearchWidget())),
      );

      expect(find.widgetWithText(ActionChip, '두부'), findsOneWidget);
    });

    testWidgets("'바나나' ActionChip이 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QuickSearchWidget())),
      );

      expect(find.widgetWithText(ActionChip, '바나나'), findsOneWidget);
    });
  });
}
