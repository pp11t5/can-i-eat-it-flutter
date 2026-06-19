import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';

void main() {
  group('VerdictDetailCard — 근거 텍스트 info 아이콘', () {
    testWidgets('items가 있을 때 Icons.info_outline 아이콘이 표시된다', (tester) async {
      // EatVerdict.recommend 샘플은 items 2개 포함
      final verdict = EatVerdict.recommend(foodName: '두부');

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

      expect(find.byIcon(Icons.info_outline), findsWidgets);
    });
  });
}
