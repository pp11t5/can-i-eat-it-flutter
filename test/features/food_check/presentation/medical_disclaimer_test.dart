import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';

Widget _wrap() => const MaterialApp(
      home: Scaffold(body: MedicalDisclaimer()),
    );

void main() {
  group('MedicalDisclaimer', () {
    testWidgets('Icons.info_outline 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
