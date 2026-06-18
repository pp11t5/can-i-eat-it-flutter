import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_group_card.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_record_tile.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

// ---------------------------------------------------------------------------
// 테스트 픽스처
// ---------------------------------------------------------------------------

const _kGroupSingle = MealGroup(
  mealGroupId: 'g-1',
  eatenAt: '2026-06-17T08:02:00+09:00',
  records: [
    MealRecord(
      mealId: 'm-1',
      mealGroupId: 'g-1',
      eatenAt: '2026-06-17T08:02:00+09:00',
      food: FoodSummary(externalId: 'f-1', name: '두부'),
      judgedGrade: VerdictLevel.recommend,
    ),
  ],
);

const _kGroupMulti = MealGroup(
  mealGroupId: 'g-2',
  eatenAt: '2026-06-17T12:30:00+09:00',
  records: [
    MealRecord(
      mealId: 'm-2',
      mealGroupId: 'g-2',
      eatenAt: '2026-06-17T12:30:00+09:00',
      food: FoodSummary(externalId: 'f-2', name: '커피'),
      judgedGrade: VerdictLevel.risk,
    ),
    MealRecord(
      mealId: 'm-3',
      mealGroupId: 'g-2',
      eatenAt: '2026-06-17T12:35:00+09:00',
      food: FoodSummary(externalId: 'f-3', name: '된장찌개'),
      judgedGrade: VerdictLevel.caution,
    ),
  ],
);

const _kGroupNoGrade = MealGroup(
  mealGroupId: 'g-3',
  eatenAt: '2026-06-17T18:00:00+09:00',
  records: [
    MealRecord(
      mealId: 'm-4',
      mealGroupId: 'g-3',
      eatenAt: '2026-06-17T18:00:00+09:00',
      food: FoodSummary(externalId: 'f-4', name: '샐러드'),
    ),
  ],
);

// ---------------------------------------------------------------------------
// MealGroupCard 테스트
// ---------------------------------------------------------------------------

void main() {
  group('MealGroupCard — 렌더링', () {
    testWidgets('상단 라벨에 "먹은 음식 · HH:mm" 형식이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupSingle)));
      // 08:02 KST → eatenAt 파싱 결과
      expect(find.textContaining('먹은 음식 ·'), findsOneWidget);
    });

    testWidgets('record 1건: MealRecordTile 1개 렌더', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupSingle)));
      expect(find.byType(MealRecordTile), findsOneWidget);
      expect(find.text('두부'), findsOneWidget);
    });

    testWidgets('record 2건: MealRecordTile 2개 렌더', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupMulti)));
      expect(find.byType(MealRecordTile), findsNWidgets(2));
      expect(find.text('커피'), findsOneWidget);
      expect(find.text('된장찌개'), findsOneWidget);
    });

    testWidgets('"같이 먹은 음식이 있나요?" 행이 항상 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupSingle)));
      expect(find.text('같이 먹은 음식이 있나요?'), findsOneWidget);
    });
  });

  group('MealGroupCard — 판정 상태 텍스트 및 색상', () {
    testWidgets('권장(recommend) 라벨이 verdictRecommend 색으로 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupSingle)));
      final richText = tester.widget<Text>(find.text('권장'));
      expect(richText.style?.color, AppColors.verdictRecommend);
    });

    testWidgets('위험(risk) 라벨이 verdictDanger 색으로 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupMulti)));
      final richText = tester.widget<Text>(find.text('위험'));
      expect(richText.style?.color, AppColors.verdictDanger);
    });

    testWidgets('주의(caution) 라벨이 verdictCaution 색으로 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupMulti)));
      final richText = tester.widget<Text>(find.text('주의'));
      expect(richText.style?.color, AppColors.verdictCaution);
    });

    testWidgets('grade null이면 판정 라벨이 없다', (tester) async {
      await tester.pumpWidget(_wrap(const MealGroupCard(group: _kGroupNoGrade)));
      expect(find.text('권장'), findsNothing);
      expect(find.text('주의'), findsNothing);
      expect(find.text('위험'), findsNothing);
      expect(find.text('확인어려움'), findsNothing);
    });
  });

  group('MealGroupCard — 콜백', () {
    testWidgets('onAddFood 콜백이 추가 행 탭 시 호출된다', (tester) async {
      MealGroup? tappedGroup;
      await tester.pumpWidget(
        _wrap(
          MealGroupCard(
            group: _kGroupSingle,
            onAddFood: (g) => tappedGroup = g,
          ),
        ),
      );
      await tester.tap(find.text('같이 먹은 음식이 있나요?'));
      await tester.pump();
      expect(tappedGroup, _kGroupSingle);
    });

    testWidgets('onTapRecord 콜백이 타일 탭 시 호출된다', (tester) async {
      MealRecord? tappedRecord;
      await tester.pumpWidget(
        _wrap(
          MealGroupCard(
            group: _kGroupSingle,
            onTapRecord: (r) => tappedRecord = r,
          ),
        ),
      );
      await tester.tap(find.byType(MealRecordTile));
      await tester.pump();
      expect(tappedRecord, _kGroupSingle.records.first);
    });
  });
}
