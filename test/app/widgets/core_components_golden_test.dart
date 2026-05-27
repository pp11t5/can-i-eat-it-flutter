import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_card.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  group('AppButton 골든 테스트', () {
    testWidgets('AppButton.primary enabled 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 280,
            child: AppButton.primary(
              label: '확인하기',
              onPressed: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_primary_enabled.png'),
      );
    });

    testWidgets('AppButton.primary disabled 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 280,
            child: AppButton.primary(
              label: '확인하기',
              // ignore: avoid_redundant_argument_values
              onPressed: null,
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_primary_disabled.png'),
      );
    });

    testWidgets('AppButton.secondary enabled 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 280,
            child: AppButton.secondary(
              label: '다음에 하기',
              onPressed: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_secondary_enabled.png'),
      );
    });
  });

  group('AppCard 골든 테스트', () {
    testWidgets('AppCard 비선택 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 280,
            child: AppCard(
              // ignore: avoid_redundant_argument_values
              selected: false,
              child: Text('카드 내용'),
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(AppCard),
        matchesGoldenFile('goldens/app_card_unselected.png'),
      );
    });

    testWidgets('AppCard 선택 상태를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 280,
            child: AppCard(
              selected: true,
              child: Text('카드 내용'),
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(AppCard),
        matchesGoldenFile('goldens/app_card_selected.png'),
      );
    });
  });

  group('StepProgress 골든 테스트', () {
    testWidgets('StepProgress 2/4 단계를 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 280,
            child: StepProgress(currentStep: 2, totalSteps: 4),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(StepProgress),
        matchesGoldenFile('goldens/step_progress_2_of_4.png'),
      );
    });
  });

  group('VerdictBadge 골든 테스트 — 4상태', () {
    testWidgets('VerdictBadge 4상태를 Column으로 모아 골든과 일치하게 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerdictBadge(level: VerdictLevel.recommend),
              SizedBox(height: 8),
              VerdictBadge(level: VerdictLevel.caution),
              SizedBox(height: 8),
              VerdictBadge(level: VerdictLevel.danger),
              SizedBox(height: 8),
              VerdictBadge(level: VerdictLevel.unknown),
            ],
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(Column).first,
        matchesGoldenFile('goldens/verdict_badge_all_states.png'),
      );
    });
  });
}
