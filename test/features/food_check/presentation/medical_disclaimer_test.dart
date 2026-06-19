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

    testWidgets("초기 상태에서 '접기' 텍스트가 렌더된다 (기본 펼침)", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('접기'), findsOneWidget);
    });

    testWidgets("'접기' 탭 시 '더 보기' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.text('접기'));
      await tester.pump();

      expect(find.text('더 보기'), findsOneWidget);
    });
  });

  group('MedicalDisclaimer — 자세히 보기 링크', () {
    testWidgets("초기 펼침 상태에서 '자세히 보기' 텍스트가 표시된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('자세히 보기'), findsOneWidget);
    });

    testWidgets("접힌 상태에서 '자세히 보기' 텍스트가 표시되지 않는다", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.text('접기'));
      await tester.pump();

      expect(find.text('자세히 보기'), findsNothing);
    });
  });
}
