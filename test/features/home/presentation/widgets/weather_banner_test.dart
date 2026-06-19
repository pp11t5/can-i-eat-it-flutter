import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/weather_banner.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('WeatherBanner — 날씨 아이콘', () {
    testWidgets("weatherCondition: 'sunny' 일 때 Icons.wb_sunny 아이콘이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(const WeatherBanner(weatherCondition: 'sunny')),
      );
      await tester.pump();

      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
    });

    testWidgets("weatherCondition: 'rainy' 일 때 Icons.umbrella 아이콘이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(const WeatherBanner(weatherCondition: 'rainy')),
      );
      await tester.pump();

      expect(find.byIcon(Icons.umbrella), findsOneWidget);
    });

    testWidgets("weatherCondition: 'cloudy' 일 때 Icons.cloud 아이콘이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(const WeatherBanner(weatherCondition: 'cloudy')),
      );
      await tester.pump();

      expect(find.byIcon(Icons.cloud), findsOneWidget);
    });

    testWidgets("weatherCondition: 'snowy' 일 때 Icons.ac_unit 아이콘이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(const WeatherBanner(weatherCondition: 'snowy')),
      );
      await tester.pump();

      expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    });
  });
}
