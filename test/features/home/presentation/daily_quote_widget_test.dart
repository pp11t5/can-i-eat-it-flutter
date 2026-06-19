import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/daily_quote_widget.dart';

void main() {
  group('DailyQuoteWidget', () {
    testWidgets("'오늘의 한마디' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DailyQuoteWidget())),
      );

      expect(find.text('오늘의 한마디'), findsOneWidget);
    });

    testWidgets('명언 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DailyQuoteWidget())),
      );

      expect(find.text('"식사는 천천히, 소화는 여유롭게."'), findsOneWidget);
    });
  });
}
