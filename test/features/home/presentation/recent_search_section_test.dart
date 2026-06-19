import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/recent_search_chip.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('RecentSearchChip — ActionChip 기반', () {
    testWidgets('ActionChip이 최소 1개 렌더된다', (tester) async {
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

      expect(find.byType(ActionChip), findsAtLeastNWidgets(1));
    });

    testWidgets('ActionChip 탭 시 onTap(onSearch)이 호출된다', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          RecentSearchChip(
            label: '두부',
            onSearch: () => tapped = true,
            onDelete: () {},
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ActionChip));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
