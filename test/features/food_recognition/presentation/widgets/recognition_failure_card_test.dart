import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/recognition_failure_card.dart';

void main() {
  testWidgets('문구 렌더와 두 버튼 콜백', (tester) async {
    var searched = 0;
    var retaken = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecognitionFailureCard(
            onSearch: () => searched++,
            onRetake: () => retaken++,
          ),
        ),
      ),
    );

    expect(find.text('음식을 확인하기 어려워요.'), findsOneWidget);
    expect(
      find.text('한 번에 하나의 음식만 찍고\n흔들리지 않게 찍어주세요.'),
      findsOneWidget,
    );

    await tester.tap(find.text('검색하기'));
    await tester.tap(find.text('다시 찍기'));

    expect(searched, 1);
    expect(retaken, 1);
  });
}
