import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';

Widget _wrap() => MaterialApp(
      home: Scaffold(
        body: HomeSearchBar(onTap: () {}),
      ),
    );

void main() {
  group('HomeSearchBar — 배경색', () {
    testWidgets('빠른 검색 버튼 컨테이너의 배경색이 AppColors.surfaceMuted이다',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // HomeSearchBar의 외부 Container (배경색 적용 대상)
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasSurfaceMuted = containers.any((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.surfaceMuted;
        }
        return false;
      });
      expect(hasSurfaceMuted, isTrue);
    });
  });
}
