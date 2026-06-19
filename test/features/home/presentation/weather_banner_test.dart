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
      expect(find.text('맑은 날엔 산책 후 가벼운 식사가 좋아요.'), findsOneWidget);
    });

    testWidgets('sunny — 맑은 날 문구가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WeatherBanner(weatherCondition: 'sunny')),
        ),
      );

      expect(find.text('맑은 날엔 산책 후 가벼운 식사가 좋아요.'), findsOneWidget);
    });

    testWidgets('rainy — 비 오는 날 문구가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WeatherBanner(weatherCondition: 'rainy')),
        ),
      );

      expect(find.text('비 오는 날엔 따뜻한 국물 요리가 좋아요.'), findsOneWidget);
    });

    testWidgets('cloudy — 흐린 날 문구가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WeatherBanner(weatherCondition: 'cloudy')),
        ),
      );

      expect(find.text('흐린 날엔 소화가 잘 되는 음식을 드세요.'), findsOneWidget);
    });
  });
}
