import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/goal_progress_widget.dart';

Widget _wrap() {
  return const MaterialApp(home: Scaffold(body: GoalProgressWidget()));
}

void main() {
  group('GoalProgressWidget', () {
    testWidgets('LinearProgressIndicator가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets("'60% 달성' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('60% 달성'), findsOneWidget);
    });
  });
}
