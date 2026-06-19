import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/weather_banner.dart';

void main() {
  group('WeatherBanner', () {
    testWidgets('"오늘의 날씨" + "23°C" 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherBanner())),
      );

      expect(find.text('오늘의 날씨'), findsOneWidget);
      expect(find.text('23°C'), findsOneWidget);
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

    testWidgets('sunny 조건에서 날씨 아이콘(Icons.wb_sunny)이 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WeatherBanner(weatherCondition: 'sunny')),
        ),
      );

      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
    });
  });

  group('WeatherBanner — 날씨 식이 안내 바텀시트', () {
    testWidgets("배너 탭 시 '날씨 식이 안내' 텍스트가 바텀시트에 표시된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WeatherBanner()),
        ),
      );

      await tester.tap(find.byType(WeatherBanner));
      await tester.pumpAndSettle();

      expect(find.text('날씨 식이 안내'), findsOneWidget);
    });
  });
}
