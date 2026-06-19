import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/diet_recommendation_widget.dart';

void main() {
  group('DietRecommendationWidget', () {
    testWidgets("'오늘의 식단 추천' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DietRecommendationWidget())),
      );

      expect(find.text('오늘의 식단 추천'), findsOneWidget);
    });

    testWidgets("'맑은 날씨에는 신선한 샐러드를 추천해요' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DietRecommendationWidget())),
      );

      expect(find.text('맑은 날씨에는 신선한 샐러드를 추천해요'), findsOneWidget);
    });
  });
}
