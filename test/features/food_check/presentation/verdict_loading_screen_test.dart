import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';

void main() {
  group('VerdictLoadingScreen — 스켈레톤', () {
    testWidgets('로딩 안내 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: VerdictLoadingScreen()),
      );

      expect(find.text('내 몸에 맞는지\n확인하고 있어요'), findsOneWidget);
    });

    testWidgets('스켈레톤 블록(color 0xFFE0E0E0)이 3개 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: VerdictLoadingScreen()),
      );

      // color가 0xFFE0E0E0인 Container 3개 확인
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
            final decoration = c.decoration;
            if (decoration is BoxDecoration) {
              return decoration.color == const Color(0xFFE0E0E0);
            }
            return false;
          })
          .toList();

      expect(containers.length, 3);
    });
  });
}
