import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/beta_badge.dart';

void main() {
  testWidgets('Beta 텍스트 렌더', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: BetaBadge()))),
    );

    expect(find.text('Beta'), findsOneWidget);
  });
}
