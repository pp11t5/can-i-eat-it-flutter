import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';

void main() {
  group('VerdictDetailCard — 대체 음식 아이콘', () {
    testWidgets('대체 음식이 있을 때 Icons.restaurant 아이콘이 항목 수만큼 표시된다',
        (tester) async {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      // EatVerdict.caution 샘플은 substitutes 2개 포함

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: VerdictDetailCard(verdict: verdict),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Icons.restaurant 아이콘이 substitutes 수만큼 표시돼야 한다
      final restaurantIcons = tester
          .widgetList<Icon>(find.byType(Icon))
          .where((icon) => icon.icon == Icons.restaurant)
          .toList();

      expect(restaurantIcons.length, verdict.substitutes.length);
    });
  });
}
