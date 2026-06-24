import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_timeline_list.dart';

Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: child),
      ),
    );

// ---------------------------------------------------------------------------
// 픽스처: single(아침 08:00) / group(점심 12:30) / symptom / single(저녁 19:00)
// ---------------------------------------------------------------------------

const _kSingleMorning = TimelineItem.single(
  mealRecordId: 'mr-morning',
  mealRecordDateTime: '2026-06-17T08:00:00+09:00',
  mealFoodName: '두부',
  grade: VerdictLevel.recommend,
);

const _kGroupLunch = TimelineItem.group(
  mealRecordId: 'mr-lunch',
  mealRecordDateTime: '2026-06-17T12:30:00+09:00',
  representativeFoods: ['된장찌개', '커피'],
  etcCount: 1,
);

const _kSingleEvening = TimelineItem.single(
  mealRecordId: 'mr-evening',
  mealRecordDateTime: '2026-06-17T19:00:00+09:00',
  mealFoodName: '샐러드',
  grade: VerdictLevel.caution,
);

const _kSymptom = TimelineItem.symptom(
  symptomState: SymptomState.uncomfortable,
  afterMealMinutes: 120,
  occurredAt: '2026-06-17T14:30:00+09:00',
);

void main() {
  group('MealTimelineList — 변형별 렌더링', () {
    testWidgets('single 타일은 음식명과 grade 라벨을 표시한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleMorning])),
      );
      expect(find.text('두부'), findsOneWidget);
      expect(find.text('권장'), findsOneWidget);
    });

    testWidgets('group 타일은 대표음식 + "외 N개"를 표시한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kGroupLunch])),
      );
      expect(find.textContaining('된장찌개, 커피'), findsOneWidget);
      expect(find.textContaining('외 1개'), findsOneWidget);
    });

    testWidgets('symptom 타일은 증상 라벨을 표시한다 (크래시 없이 렌더)', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSymptom])),
      );
      expect(find.text('불편함'), findsOneWidget);
      expect(find.textContaining('식후 2시간'), findsOneWidget);
    });

    testWidgets('혼합 목록(single+group+symptom)이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MealTimelineList(
            items: [_kSingleMorning, _kGroupLunch, _kSymptom],
          ),
        ),
      );
      expect(find.text('두부'), findsOneWidget);
      expect(find.textContaining('된장찌개'), findsOneWidget);
      expect(find.text('불편함'), findsOneWidget);
    });
  });

  group('MealTimelineList — 시간대 아이콘 매핑', () {
    testWidgets('아침(hour<12) → wb_sunny_outlined', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleMorning])),
      );
      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    });

    testWidgets('점심(12≤hour<18) → wb_twilight_outlined', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kGroupLunch])),
      );
      expect(find.byIcon(Icons.wb_twilight_outlined), findsOneWidget);
    });

    testWidgets('저녁(hour≥18) → nights_stay_outlined', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleEvening])),
      );
      expect(find.byIcon(Icons.nights_stay_outlined), findsOneWidget);
    });
  });

  group('MealTimelineList — 콜백 전달', () {
    testWidgets('onTapMeal이 single 타일 탭 시 mealRecordId와 함께 호출된다',
        (tester) async {
      String? tappedId;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            items: const [_kSingleMorning],
            onTapMeal: (id) => tappedId = id,
          ),
        ),
      );
      await tester.tap(find.text('두부'));
      await tester.pump();
      expect(tappedId, 'mr-morning');
    });

    testWidgets('onAddFood가 "같이 먹은 음식" 행 탭 시 호출된다', (tester) async {
      String? addedId;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            items: const [_kSingleMorning],
            onAddFood: (id) => addedId = id,
          ),
        ),
      );
      await tester.tap(find.text('같이 먹은 음식이 있나요?'));
      await tester.pump();
      expect(addedId, 'mr-morning');
    });
  });
}
