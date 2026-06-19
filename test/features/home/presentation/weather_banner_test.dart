import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/weather_banner.dart';

void main() {
  group('WeatherBanner', () {
    testWidgets('"맑음 · 23°C" 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherBanner())),
      );

      expect(find.text('맑음 · 23°C'), findsOneWidget);
      expect(find.text('오늘은 속이 편안한 날씨예요'), findsOneWidget);
    });
  });
}
