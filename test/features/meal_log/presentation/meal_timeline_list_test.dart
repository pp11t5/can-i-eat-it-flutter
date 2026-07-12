import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
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

/// 스파인 배지(AppIcon) 에셋 경로로 찾는 finder.
Finder _badge(String asset) =>
    find.byWidgetPredicate((w) => w is AppIcon && w.asset == asset);

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

const _kSymptomWithId = TimelineItem.symptom(
  symptomState: SymptomState.uncomfortable,
  afterMealMinutes: 120,
  occurredAt: '2026-06-17T14:30:00+09:00',
  symptomId: 'sym-42',
);

// timeIcon=moon 이 아침 시각(hour=8, 휴리스틱상 sun)보다 우선해야 함을 검증.
const _kSingleMorningWithMoonIcon = TimelineItem.single(
  mealRecordId: 'mr-moon',
  mealRecordDateTime: '2026-06-17T08:00:00+09:00',
  mealFoodName: '두부',
  grade: VerdictLevel.recommend,
  timeIcon: TimeIcon.moon,
);

const _kSingleWithSymptom = TimelineItem.single(
  mealRecordId: 'mr-symptom',
  mealRecordDateTime: '2026-06-17T08:00:00+09:00',
  mealFoodName: '두부',
  grade: VerdictLevel.recommend,
  connectedSymptoms: ConnectedSymptoms(
    symptomId: 'sym-1',
    symptomState: SymptomState.uncomfortable,
    afterMealMinutes: 90,
    representativeSymptoms: ['속쓰림'],
    etcCount: 1,
  ),
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

  group('MealTimelineList — 시간대 배지 매핑', () {
    testWidgets('아침(hour<18) → mealSun 배지', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleMorning])),
      );
      expect(_badge(AppIcons.mealSun), findsOneWidget);
    });

    testWidgets('점심(12≤hour<18) → mealSun 배지(주간)', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kGroupLunch])),
      );
      expect(_badge(AppIcons.mealSun), findsOneWidget);
    });

    testWidgets('저녁(hour≥18) → mealMoon 배지', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleEvening])),
      );
      expect(_badge(AppIcons.mealMoon), findsOneWidget);
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
            onAddFood: (id, _) => addedId = id,
          ),
        ),
      );
      await tester.tap(find.text('같이 먹은 음식이 있나요?'));
      await tester.pump();
      expect(addedId, 'mr-morning');
    });
  });

  group('MealTimelineList — timeIcon 우선 (P1)', () {
    testWidgets('timeIcon이 있으면 hour 휴리스틱보다 우선한다 (아침 시각이어도 moon 배지)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleMorningWithMoonIcon])),
      );
      expect(_badge(AppIcons.mealMoon), findsOneWidget);
      expect(_badge(AppIcons.mealSun), findsNothing);
    });

    testWidgets('symptom 행은 timeIcon 유무와 무관하게 항상 checklist 배지를 표시한다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSymptom])),
      );
      expect(_badge(AppIcons.recordChecklist), findsOneWidget);
    });
  });

  group('MealTimelineList — 연결증상 칩 (P1)', () {
    testWidgets('connectedSymptoms가 있으면 대표증상+외N개+식후N분 칩을 표시한다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleWithSymptom])),
      );
      expect(find.textContaining('속쓰림 외 1개'), findsOneWidget);
      expect(find.textContaining('식후 1시간 30분'), findsOneWidget);
    });

    testWidgets('connectedSymptoms가 없으면 칩이 표시되지 않는다', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealTimelineList(items: [_kSingleMorning])),
      );
      expect(find.textContaining('식후'), findsNothing);
    });

    testWidgets('연결증상 칩 탭 시 onTapSymptom이 symptomId와 함께 호출된다',
        (tester) async {
      String? tappedSymptomId;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            items: const [_kSingleWithSymptom],
            onTapSymptom: (id) => tappedSymptomId = id,
          ),
        ),
      );
      await tester.tap(find.textContaining('속쓰림'));
      await tester.pump();
      expect(tappedSymptomId, 'sym-1');
    });
  });

  group('MealTimelineList — 증상 행 탭 (P1)', () {
    testWidgets('symptomId가 있으면 증상 행 탭 시 onTapSymptom이 호출된다', (tester) async {
      String? tappedSymptomId;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            items: const [_kSymptomWithId],
            onTapSymptom: (id) => tappedSymptomId = id,
          ),
        ),
      );
      await tester.tap(find.text('불편함'));
      await tester.pump();
      expect(tappedSymptomId, 'sym-42');
    });

    testWidgets('symptomId가 없으면 증상 행 탭이 무시된다 (크래시 없음)', (tester) async {
      String? tappedSymptomId;
      await tester.pumpWidget(
        _wrap(
          MealTimelineList(
            items: const [_kSymptom],
            onTapSymptom: (id) => tappedSymptomId = id,
          ),
        ),
      );
      await tester.tap(find.text('불편함'));
      await tester.pump();
      expect(tappedSymptomId, isNull);
    });
  });
}
