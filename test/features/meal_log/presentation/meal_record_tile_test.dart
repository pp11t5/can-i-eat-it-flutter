import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_record_tile.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

MealRecord _record({VerdictLevel? grade, String name = '두부'}) => MealRecord(
      mealId: 'meal-1',
      mealGroupId: 'group-1',
      eatenAt: '2026-06-17T08:00:00+09:00',
      food: FoodSummary(externalId: 'food-1', name: name),
      judgedGrade: grade,
    );

void main() {
  group('MealRecordTile — 렌더링', () {
    testWidgets('음식명이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MealRecordTile(record: _record())));
      expect(find.text('두부'), findsOneWidget);
    });

    testWidgets('chevron 아이콘이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MealRecordTile(record: _record())));
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });

  group('MealRecordTile — 판정 라벨', () {
    testWidgets('grade null이면 판정 라벨이 없다', (tester) async {
      await tester.pumpWidget(_wrap(MealRecordTile(record: _record())));
      expect(find.text('권장'), findsNothing);
      expect(find.text('주의'), findsNothing);
      expect(find.text('위험'), findsNothing);
      expect(find.text('확인어려움'), findsNothing);
    });

    testWidgets('권장(recommend) 라벨과 색이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MealRecordTile(record: _record(grade: VerdictLevel.recommend))),
      );
      final text = tester.widget<Text>(find.text('권장'));
      expect(text.style?.color, AppColors.verdictRecommend);
    });

    testWidgets('주의(caution) 라벨과 색이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MealRecordTile(record: _record(grade: VerdictLevel.caution))),
      );
      final text = tester.widget<Text>(find.text('주의'));
      expect(text.style?.color, AppColors.verdictCaution);
    });

    testWidgets('위험(risk) 라벨과 색이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MealRecordTile(record: _record(grade: VerdictLevel.risk))),
      );
      final text = tester.widget<Text>(find.text('위험'));
      expect(text.style?.color, AppColors.verdictDanger);
    });

    testWidgets('확인어려움(unknown) 라벨과 색이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MealRecordTile(record: _record(grade: VerdictLevel.unknown))),
      );
      final text = tester.widget<Text>(find.text('확인어려움'));
      expect(text.style?.color, AppColors.verdictUnknown);
    });
  });

  group('MealRecordTile — onTap 콜백', () {
    testWidgets('탭 시 onTap 콜백이 호출된다', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(MealRecordTile(record: _record(), onTap: () => tapped = true)),
      );
      await tester.tap(find.byType(MealRecordTile));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('onTap이 null이면 탭해도 에러 없다', (tester) async {
      await tester.pumpWidget(_wrap(MealRecordTile(record: _record())));
      await tester.tap(find.byType(MealRecordTile));
      await tester.pump();
      // 예외 없음 — 테스트 통과
    });
  });
}
