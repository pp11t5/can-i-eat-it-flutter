import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/quick_access_buttons.dart';

void main() {
  group('QuickAccessButtons', () {
    testWidgets("'음식 검색' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QuickAccessButtons())),
      );

      expect(find.text('음식 검색'), findsOneWidget);
    });

    testWidgets("'판정 이력' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QuickAccessButtons())),
      );

      expect(find.text('판정 이력'), findsOneWidget);
    });

    testWidgets("'마이페이지' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: QuickAccessButtons())),
      );

      expect(find.text('마이페이지'), findsOneWidget);
    });
  });
}
