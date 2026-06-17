import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_group_card.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_timeline_list.dart';

Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: child),
      ),
    );

// ---------------------------------------------------------------------------
// 픽스처: 아침(08:00) / 점심(12:30) / 저녁(19:00) 그룹
// ---------------------------------------------------------------------------

const _kGroupMorning = MealGroup(
  mealGroupId: 'g-morning',
  eatenAt: '2026-06-17T08:00:00+09:00',
  records: [
    MealRecord(
      mealId: 'm-1',
      mealGroupId: 'g-morning',
      eatenAt: '2026-06-17T08:00:00+09:00',
      food: FoodSummary(externalId: 'f-1', name: '두부'),
      judgedGrade: VerdictLevel.recommend,
    ),
  ],
);

const _kGroupLunch = MealGroup(
  mealGroupId: 'g-lunch',
  eatenAt: '2026-06-17T12:30:00+09:00',
  records: [
    MealRecord(
      mealId: 'm-2',
      mealGroupId: 'g-lunch',
      eatenAt: '2026-06-17T12:30:00+09:00',
      food: FoodSummary(externalId: 'f-2', name: '된장찌개'),
      judgedGrade: VerdictLevel.caution,
    ),
  ],
);

const _kGroupEvening = MealGroup(
  mealGroupId: 'g-evening',
  eatenAt: '2026-06-17T19:00:00+09:00',
  records: [
    MealRecord(
      mealId: 'm-3',
      mealGroupId: 'g-evening',
      eatenAt: '2026-06-17T19:00:00+09:00',
      food: FoodSummary(externalId: 'f-3', name: '샐러드'),
    ),
  ],
);

void main() {
  group('MealTimelineList — 렌더링', () {
    testWidgets('그룹 수만큼 MealGroupCard가 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MealTimelineList(
            groups: [_kGroupMorning, _kGroupLunch],
          ),
        ),
      );
      expect(find.byType(MealGroupCard), findsNWidgets(2));
    });

    testWidgets('단일 그룹도 MealGroupCard 1개 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(groups: [_kGroupMorning])),
      );
      expect(find.byType(MealGroupCard), findsOneWidget);
    });
  });

  group('MealTimelineList — 시간대 아이콘 매핑', () {
    testWidgets('아침(hour<12) → wb_sunny_outlined 아이콘', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(groups: [_kGroupMorning])),
      );
      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    });

    testWidgets('점심(12≤hour<18) → wb_twilight_outlined 아이콘', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(groups: [_kGroupLunch])),
      );
      expect(find.byIcon(Icons.wb_twilight_outlined), findsOneWidget);
    });

    testWidgets('저녁(hour≥18) → nights_stay_outlined 아이콘', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(groups: [_kGroupEvening])),
      );
      expect(find.byIcon(Icons.nights_stay_outlined), findsOneWidget);
    });

    testWidgets('3개 그룹 — 아침/점심/저녁 아이콘이 각 1개씩 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MealTimelineList(
            groups: [_kGroupMorning, _kGroupLunch, _kGroupEvening],
          ),
        ),
      );
      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
      expect(find.byIcon(Icons.wb_twilight_outlined), findsOneWidget);
      expect(find.byIcon(Icons.nights_stay_outlined), findsOneWidget);
    });
  });

  group('MealTimelineList — 콜백 전달', () {
    testWidgets('onTapRecord가 MealGroupCard까지 전달된다', (tester) async {
      MealRecord? tapped;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            groups: const [_kGroupMorning],
            onTapRecord: (r) => tapped = r,
          ),
        ),
      );
      // MealRecordTile 탭
      await tester.tap(find.text('두부'));
      await tester.pump();
      expect(tapped?.mealId, 'm-1');
    });

    testWidgets('onAddFood가 MealGroupCard까지 전달된다', (tester) async {
      MealGroup? addedGroup;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            groups: const [_kGroupMorning],
            onAddFood: (g) => addedGroup = g,
          ),
        ),
      );
      await tester.tap(find.text('같이 먹은 음식이 있나요?'));
      await tester.pump();
      expect(addedGroup?.mealGroupId, 'g-morning');
    });
  });
}
