import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/restricted_food_banner_widget.dart';

Widget _wrap() {
  return const MaterialApp(
    home: Scaffold(body: RestrictedFoodBannerWidget()),
  );
}

void main() {
  group('RestrictedFoodBannerWidget', () {
    testWidgets('Icons.warning_amber_rounded 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets("'오늘 섭취 제한 음식이 포함되어 있어요.' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('오늘 섭취 제한 음식이 포함되어 있어요.'), findsOneWidget);
    });
  });
}
