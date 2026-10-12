import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';

void main() {
  Future<({List<String> taps})> pump(WidgetTester tester) async {
    final taps = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSearchBar(
            onTap: () => taps.add('search'),
            onCameraTap: () => taps.add('camera'),
          ),
        ),
      ),
    );
    return (taps: taps);
  }

  testWidgets('카메라 아이콘 탭은 onCameraTap만 호출한다', (tester) async {
    final r = await pump(tester);

    await tester.tap(find.bySemanticsLabel('사진으로 음식 확인'));

    expect(r.taps, ['camera']);
  });

  testWidgets('나머지 영역 탭은 onTap(검색)을 호출한다', (tester) async {
    final r = await pump(tester);

    await tester.tap(find.text('이 음식 먹어도 돼?'));

    expect(r.taps, ['search']);
  });
}
