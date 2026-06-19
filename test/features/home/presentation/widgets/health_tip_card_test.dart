import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/health_tip_card.dart';

Widget _wrap() => const MaterialApp(home: Scaffold(body: HealthTipCard()));

void main() {
  group('HealthTipCard', () {
    testWidgets('카드가 렌더된다 — "오늘의 건강 팁" 제목 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('오늘의 건강 팁'), findsOneWidget);
    });

    testWidgets('카드 탭 시 바텀 시트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(
        find.text('건강한 식습관을 위한 팁이에요. 매일 조금씩 실천해보세요.'),
        findsOneWidget,
      );
    });
  });
}
