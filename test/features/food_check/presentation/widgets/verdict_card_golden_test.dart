@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_card.dart';

Widget _wrap(VerdictLevel level) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 343,
          child: VerdictCard(level: level, foodName: '아메리카노'),
        ),
      ),
    ),
  );
}

void main() {
  group('VerdictCard 골든 테스트 — 4상태', () {
    testWidgets('VerdictCard recommend 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(VerdictLevel.recommend));
      await tester.pump(); // 애니메이션 초기 프레임
      await expectLater(
        find.byType(VerdictCard),
        matchesGoldenFile('goldens/verdict_card_recommend.png'),
      );
    });

    testWidgets('VerdictCard caution 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(VerdictLevel.caution));
      await tester.pump();
      await expectLater(
        find.byType(VerdictCard),
        matchesGoldenFile('goldens/verdict_card_caution.png'),
      );
    });

    testWidgets('VerdictCard danger 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(VerdictLevel.danger));
      await tester.pump();
      await expectLater(
        find.byType(VerdictCard),
        matchesGoldenFile('goldens/verdict_card_danger.png'),
      );
    });

    testWidgets('VerdictCard unknown 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(VerdictLevel.unknown));
      await tester.pump();
      await expectLater(
        find.byType(VerdictCard),
        matchesGoldenFile('goldens/verdict_card_unknown.png'),
      );
    });
  });
}
