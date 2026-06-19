import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/recent_search_chip.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

void main() {
  group('RecentSearchChip', () {
    testWidgets('텍스트와 X 버튼을 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          RecentSearchChip(
            label: '두부',
            onSearch: () {},
            onDelete: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('두부'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('칩 탭 시 onSearch 콜백이 호출된다', (tester) async {
      var searchCalled = false;
      await tester.pumpWidget(
        _wrap(
          RecentSearchChip(
            label: '두부',
            onSearch: () => searchCalled = true,
            onDelete: () {},
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('두부'));
      await tester.pump();

      expect(searchCalled, isTrue);
    });

    testWidgets('X 버튼 탭 시 onDelete 콜백이 호출된다', (tester) async {
      var deleteCalled = false;
      await tester.pumpWidget(
        _wrap(
          RecentSearchChip(
            label: '두부',
            onSearch: () {},
            onDelete: () => deleteCalled = true,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });
  });
}
