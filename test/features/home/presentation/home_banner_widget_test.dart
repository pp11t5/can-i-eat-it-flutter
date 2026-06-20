import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/home_banner_widget.dart';

void main() {
  group('HomeBannerWidget', () {
    testWidgets("'오늘도 건강하게!' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomeBannerWidget())),
      );

      expect(find.text('오늘도 건강하게!'), findsOneWidget);
    });

    testWidgets("'내 질환에 맞는 음식을 확인해보세요' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomeBannerWidget())),
      );

      expect(find.text('내 질환에 맞는 음식을 확인해보세요'), findsOneWidget);
    });

    testWidgets('Icons.health_and_safety_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomeBannerWidget())),
      );

      expect(find.byIcon(Icons.health_and_safety_outlined), findsOneWidget);
    });
  });
}
