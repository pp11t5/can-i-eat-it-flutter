import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/recognition_candidate_card.dart';

void main() {
  const labels = ['김치찌개', '된장찌개', '순두부찌개'];

  Widget host({
    int? selectedIndex,
    ValueChanged<int>? onSelect,
    VoidCallback? onDiagnose,
    VoidCallback? onSearch,
    VoidCallback? onRetake,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: RecognitionCandidateCard(
            labels: labels,
            selectedIndex: selectedIndex,
            onSelect: onSelect ?? (_) {},
            onDiagnose: onDiagnose ?? () {},
            onSearch: onSearch ?? () {},
            onRetake: onRetake ?? () {},
          ),
        ),
      ),
    );
  }

  AppButton diagnoseButton(WidgetTester tester) =>
      tester.widget<AppButton>(find.widgetWithText(AppButton, '음식 진단하기'));

  testWidgets('선택 전에는 음식 진단하기가 비활성', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('검색하려는 음식을 아래 중 선택해주세요.'), findsOneWidget);
    expect(diagnoseButton(tester).onPressed, isNull);
  });

  testWidgets('후보 탭 시 onSelect(index)', (tester) async {
    int? selected;
    await tester.pumpWidget(host(onSelect: (i) => selected = i));

    await tester.tap(find.text('된장찌개'));

    expect(selected, 1);
  });

  testWidgets('선택 후 진단 탭 시 onDiagnose', (tester) async {
    var diagnosed = 0;
    await tester.pumpWidget(
      host(selectedIndex: 0, onDiagnose: () => diagnosed++),
    );

    expect(diagnoseButton(tester).onPressed, isNotNull);
    await tester.tap(find.text('음식 진단하기'));

    expect(diagnosed, 1);
  });

  testWidgets('검색하기 / 다시 찍기 콜백', (tester) async {
    var searched = 0;
    var retaken = 0;
    await tester.pumpWidget(
      host(onSearch: () => searched++, onRetake: () => retaken++),
    );

    await tester.tap(find.text('검색하기'));
    await tester.tap(find.text('다시 찍기'));

    expect(searched, 1);
    expect(retaken, 1);
  });

  testWidgets('Figma 치수: 버튼 높이 52, 후보 라벨 16 (선택 Bold / 미선택 Medium)',
      (tester) async {
    await tester.pumpWidget(host(selectedIndex: 1));

    for (final label in ['음식 진단하기', '검색하기', '다시 찍기']) {
      expect(
        tester.getSize(find.widgetWithText(AppButton, label)).height,
        52,
        reason: label,
      );
    }
    final selected = tester.widget<Text>(find.text('된장찌개')).style!;
    final unselected = tester.widget<Text>(find.text('김치찌개')).style!;
    expect(selected.fontSize, 16);
    expect(unselected.fontSize, 16);
    expect(selected.fontWeight, FontWeight.w700);
    expect(unselected.fontWeight, FontWeight.w500);
  });
}
