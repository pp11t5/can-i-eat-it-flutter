import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/weather_diet_widget.dart';

Widget _wrap() {
  return const MaterialApp(home: Scaffold(body: WeatherDietWidget()));
}

void main() {
  group('WeatherDietWidget', () {
    testWidgets('Icons.wb_sunny_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    });

    testWidgets("'맑음 · 27°C' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('맑음 · 27°C'), findsOneWidget);
    });
  });
}
