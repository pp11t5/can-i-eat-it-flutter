import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/diet_tip_widget.dart';

void main() {
  group('DietTipWidget', () {
    testWidgets("'오늘의 식단 팁' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DietTipWidget())),
      );

      expect(find.text('오늘의 식단 팁'), findsOneWidget);
    });

    testWidgets('Icons.lightbulb_outline 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DietTipWidget())),
      );

      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });

    testWidgets("'역류성 식도염에는 저지방 식품을 선택하세요.' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DietTipWidget())),
      );

      expect(find.text('역류성 식도염에는 저지방 식품을 선택하세요.'), findsOneWidget);
    });
  });
}
