import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home_widget/domain/home_widget_reducer.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

HomeWidgetInputs _inputs({
  bool isLoggedIn = true,
  int streakDays = 12,
  int recommend = 2,
  int caution = 1,
  int risk = 0,
  HomeWidgetPrompt? prompt,
  bool todayHasMeals = true,
  SymptomState? worstTodaySymptom,
}) {
  return HomeWidgetInputs(
    isLoggedIn: isLoggedIn,
    streakDays: streakDays,
    counts: HomeWidgetCounts(
      recommend: recommend,
      caution: caution,
      risk: risk,
    ),
    prompt: prompt,
    todayHasMeals: todayHasMeals,
    worstTodaySymptom: worstTodaySymptom,
  );
}

void main() {
  group('reduceHomeWidget', () {
    test('로그아웃이면 loggedOut이고 개인 수치가 0이다', () {
      final snapshot = reduceHomeWidget(
        _inputs(isLoggedIn: false, streakDays: 12, recommend: 2),
      );

      expect(snapshot.kind, HomeWidgetKind.loggedOut);
      expect(snapshot.counts.recommend, 0);
      expect(snapshot.counts.caution, 0);
      expect(snapshot.counts.risk, 0);
      expect(snapshot.streakDays, 0);
      expect(snapshot.headline, '로그인하고\n위젯을 사용해보세요');
      expect(snapshot.ctaLabel, '앱 열기');
    });

    test('미기록 식사가 있으면 증상 유도 상태다', () {
      final snapshot = reduceHomeWidget(
        _inputs(
          prompt: const HomeWidgetPrompt(
            mealRecordId: 'mr-1',
            foodName: '비빔밥',
            hoursSinceEaten: 4,
          ),
        ),
      );

      expect(snapshot.kind, HomeWidgetKind.promptSymptom);
      expect(snapshot.headline, '속이 불편한지 궁금해요..');
      expect(snapshot.subtitle, '비빔밥 먹은지 4시간');
      expect(snapshot.ctaLabel, '증상 기록하기 +');
      expect(snapshot.turtle, HomeWidgetTurtle.curious);
    });

    test('경과 0시간이면 1시간 미만으로 표시한다', () {
      final snapshot = reduceHomeWidget(
        _inputs(
          prompt: const HomeWidgetPrompt(
            mealRecordId: 'mr-1',
            foodName: '비빔밥',
            hoursSinceEaten: 0,
          ),
        ),
      );

      expect(snapshot.subtitle, '비빔밥 먹은지 1시간 미만');
    });

    test('오늘 식사가 없고 미기록도 없으면 음식 기록 CTA다', () {
      final snapshot = reduceHomeWidget(
        _inputs(todayHasMeals: false, recommend: 0, caution: 0, risk: 0),
      );

      expect(snapshot.kind, HomeWidgetKind.recordMeal);
      expect(snapshot.ctaLabel, '음식 기록하기 +');
      expect(snapshot.turtle, HomeWidgetTurtle.none);
    });

    test('오늘 식사를 모두 기록하고 편안 계열이면 스트릭을 보여준다', () {
      final snapshot = reduceHomeWidget(
        _inputs(worstTodaySymptom: SymptomState.good),
      );

      expect(snapshot.kind, HomeWidgetKind.allRecordedComfortable);
      expect(snapshot.headline, '연속 편안한 날\n12일째');
      expect(snapshot.subtitle, '');
      expect(snapshot.streakDays, 12);
      expect(snapshot.ctaLabel, '음식 히스토리 보기');
      expect(snapshot.turtle, HomeWidgetTurtle.happy);
    });

    test('오늘 불편·심각 기록이 있으면 표시 스트릭은 0이다', () {
      final snapshot = reduceHomeWidget(
        _inputs(worstTodaySymptom: SymptomState.severe, streakDays: 12),
      );

      expect(snapshot.kind, HomeWidgetKind.allRecordedUncomfortable);
      expect(snapshot.headline, '연속 편안한 날\n0일째');
      expect(snapshot.subtitle, '');
      expect(snapshot.streakDays, 0);
      expect(snapshot.turtle, HomeWidgetTurtle.frown);
    });

    test('미기록이 있으면 완료 상태보다 증상 유도가 우선한다', () {
      final snapshot = reduceHomeWidget(
        _inputs(
          prompt: const HomeWidgetPrompt(
            mealRecordId: 'mr-1',
            foodName: '라면',
            hoursSinceEaten: 2,
          ),
          worstTodaySymptom: SymptomState.comfortable,
        ),
      );

      expect(snapshot.kind, HomeWidgetKind.promptSymptom);
    });
  });

  group('hoursSinceEaten', () {
    test('같은 시각이면 0이다', () {
      final now = DateTime(2026, 8, 24, 16);
      expect(hoursSinceEaten(now, now), 0);
    });

    test('4시간 전이면 4이다', () {
      final now = DateTime(2026, 8, 24, 16);
      final eaten = DateTime(2026, 8, 24, 12);
      expect(hoursSinceEaten(eaten, now), 4);
    });

    test('미래 시각은 0으로 클램프한다', () {
      final now = DateTime(2026, 8, 24, 12);
      final eaten = DateTime(2026, 8, 24, 16);
      expect(hoursSinceEaten(eaten, now), 0);
    });
  });
}
