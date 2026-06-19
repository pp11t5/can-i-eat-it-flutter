import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';

Widget _wrap() => MaterialApp(
      home: Scaffold(
        body: HomeSearchBar(onTap: () {}),
      ),
    );

void main() {
  group('HomeSearchBar', () {
    testWidgets('Icons.search 아이콘이 홈 검색 바에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('"이 음식 먹어도 돼?" 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('이 음식 먹어도 돼?'), findsOneWidget);
    });

    testWidgets('탭 시 onTap 콜백이 호출된다', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeSearchBar(onTap: () => tapped = true),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('이 음식 먹어도 돼?'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
