import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/capture_button.dart';

Widget _wrap(VoidCallback? onPressed) => MaterialApp(
      home: Scaffold(body: Center(child: CaptureButton(onPressed: onPressed))),
    );

void main() {
  testWidgets('탭 시 onPressed 호출', (tester) async {
    var count = 0;
    await tester.pumpWidget(_wrap(() => count++));

    await tester.tap(find.byType(CaptureButton));
    expect(count, 1);
  });

  testWidgets('onPressed null 이면 탭해도 예외 없이 무시', (tester) async {
    await tester.pumpWidget(_wrap(null));

    await tester.tap(find.byType(CaptureButton));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Semantics 라벨 "사진 찍기"', (tester) async {
    await tester.pumpWidget(_wrap(() {}));

    expect(find.bySemanticsLabel('사진 찍기'), findsOneWidget);
  });

  testWidgets('안쪽 원은 지름 68로 링(6)에 틈 없이 붙는다 (Figma 4137:20758)',
      (tester) async {
    await tester.pumpWidget(_wrap(() {}));

    final inner = find.descendant(
      of: find.byType(CaptureButton),
      matching: find.byType(DecoratedBox),
    );
    expect(tester.getSize(find.byType(CaptureButton)), const Size(80, 80));
    expect(tester.getSize(inner.last), const Size(68, 68));
  });
}
