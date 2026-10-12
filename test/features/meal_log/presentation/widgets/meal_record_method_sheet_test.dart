import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_record_method_sheet.dart';

Future<void> _openSheet(
  WidgetTester tester, {
  VoidCallback? onManual,
  VoidCallback? onPhoto,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (ctx) => Scaffold(
          body: TextButton(
            onPressed: () => showMealRecordMethodSheet(
              ctx,
              onManual: onManual ?? () {},
              onPhoto: onPhoto ?? () {},
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Figma 치수: 카드 높이 ≈122, 아이콘 칸 32 (4251:13793)', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _openSheet(tester);

    final card = find
        .ancestor(of: find.text('직접 입력'), matching: find.byType(Container))
        .first;
    expect(tester.getSize(card).height, moreOrLessEquals(121.6, epsilon: 0.5));
    expect(
      tester.getSize(find.bySemanticsLabel('닫기')),
      const Size(32, 32),
    );
  });

  testWidgets('제목과 두 카드 렌더', (tester) async {
    await _openSheet(tester);

    expect(find.text('식단 기록을 어떻게 남길까요?'), findsOneWidget);
    expect(find.text('직접 입력'), findsOneWidget);
    expect(find.text('사진으로 기록'), findsOneWidget);
  });

  testWidgets('직접 입력 탭 → 시트 닫힘 + onManual 호출', (tester) async {
    var manual = 0;
    var photo = 0;
    await _openSheet(tester, onManual: () => manual++, onPhoto: () => photo++);

    await tester.tap(find.text('직접 입력'));
    await tester.pumpAndSettle();

    expect(manual, 1);
    expect(photo, 0);
    expect(find.text('식단 기록을 어떻게 남길까요?'), findsNothing);
  });

  testWidgets('사진으로 기록 탭 → 시트 닫힘 + onPhoto 호출', (tester) async {
    var manual = 0;
    var photo = 0;
    await _openSheet(tester, onManual: () => manual++, onPhoto: () => photo++);

    await tester.tap(find.text('사진으로 기록'));
    await tester.pumpAndSettle();

    expect(photo, 1);
    expect(manual, 0);
    expect(find.text('식단 기록을 어떻게 남길까요?'), findsNothing);
  });

  testWidgets('X 탭 → 시트 닫힘, 콜백 미호출', (tester) async {
    var calls = 0;
    await _openSheet(tester, onManual: () => calls++, onPhoto: () => calls++);

    await tester.tap(find.bySemanticsLabel('닫기'));
    await tester.pumpAndSettle();

    expect(calls, 0);
    expect(find.text('식단 기록을 어떻게 남길까요?'), findsNothing);
  });
}
