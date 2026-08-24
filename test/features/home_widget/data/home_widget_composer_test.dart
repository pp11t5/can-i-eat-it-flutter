import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/home/data/repositories/mock_home_repository.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_composer.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

void main() {
  final now = DateTime(2026, 8, 24, 16);

  HomeWidgetComposer composer({
    MockHomeRepository? home,
    MockMealRepository? meals,
  }) {
    return HomeWidgetComposer(
      homeRepository: home ?? MockHomeRepository.empty(),
      mealRepository: meals ?? MockMealRepository.empty(),
      now: () => now,
    );
  }

  test('로그아웃이면 API를 기다리지 않고 loggedOut이다', () async {
    final snapshot = await composer().compose(isLoggedIn: false);
    expect(snapshot.kind, HomeWidgetKind.loggedOut);
  });

  test('오늘 single 판정을 권장/주의/위험으로 센다', () async {
    final meals = MockMealRepository(
      initialTimeline: [
        TimelineItem.single(
          mealRecordId: 'm1',
          mealRecordDateTime: '2026-08-24T08:00:00+09:00',
          mealFoodName: '샐러드',
          grade: VerdictLevel.recommend,
        ),
        TimelineItem.single(
          mealRecordId: 'm2',
          mealRecordDateTime: '2026-08-24T12:00:00+09:00',
          mealFoodName: '비빔밥',
          grade: VerdictLevel.caution,
        ),
        TimelineItem.single(
          mealRecordId: 'm3',
          mealRecordDateTime: '2026-08-24T19:00:00+09:00',
          mealFoodName: '라면',
          grade: VerdictLevel.risk,
        ),
      ],
    );

    final snapshot = await composer(meals: meals).compose(isLoggedIn: true);

    expect(snapshot.kind, HomeWidgetKind.allRecordedComfortable);
    expect(snapshot.counts.recommend, 1);
    expect(snapshot.counts.caution, 1);
    expect(snapshot.counts.risk, 1);
  });

  test('미기록 후보가 있으면 가장 최근 식사로 증상 유도를 만든다', () async {
    final meals = MockMealRepository(
      initialTimeline: [
        TimelineItem.single(
          mealRecordId: 'm1',
          mealRecordDateTime: '2026-08-24T12:00:00+09:00',
          mealFoodName: '비빔밥',
          grade: VerdictLevel.recommend,
        ),
      ],
      initialCandidates: [
        MealCandidatesDay(
          date: '2026-08-24',
          meals: const [
            MealCandidate(
              mealRecordId: 'm1',
              representativeFoodName: '비빔밥',
              eatenAt: '2026-08-24T12:00:00+09:00',
            ),
          ],
        ),
      ],
    );

    final snapshot = await composer(meals: meals).compose(isLoggedIn: true);

    expect(snapshot.kind, HomeWidgetKind.promptSymptom);
    expect(snapshot.subtitle, '비빔밥 먹은지 4시간');
    expect(snapshot.prompt?.mealRecordId, 'm1');
  });

  test('오늘 불편 증상이 있으면 표시 스트릭 0이다', () async {
    final home = MockHomeRepository(streak: 12);
    final meals = MockMealRepository(
      initialTimeline: [
        TimelineItem.single(
          mealRecordId: 'm1',
          mealRecordDateTime: '2026-08-24T12:00:00+09:00',
          mealFoodName: '라면',
          grade: VerdictLevel.risk,
          connectedSymptoms: const ConnectedSymptoms(
            symptomId: 's1',
            symptomState: SymptomState.uncomfortable,
            afterMealMinutes: 120,
          ),
        ),
      ],
    );

    final snapshot =
        await composer(home: home, meals: meals).compose(isLoggedIn: true);

    expect(snapshot.kind, HomeWidgetKind.allRecordedUncomfortable);
    expect(snapshot.streakDays, 0);
  });
}
