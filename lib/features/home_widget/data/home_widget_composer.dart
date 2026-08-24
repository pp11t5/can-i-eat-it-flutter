import 'package:characters/characters.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/home/domain/repositories/home_repository.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_reducer.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// 기존 API를 묶어 [HomeWidgetSnapshot]을 만든다.
class HomeWidgetComposer {
  const HomeWidgetComposer({
    required HomeRepository homeRepository,
    required MealRepository mealRepository,
    DateTime Function()? now,
  })  : _homeRepository = homeRepository,
        _mealRepository = mealRepository,
        _now = now ?? nowKst;

  final HomeRepository _homeRepository;
  final MealRepository _mealRepository;
  final DateTime Function() _now;

  Future<HomeWidgetSnapshot> compose({required bool isLoggedIn}) async {
    if (!isLoggedIn) {
      return reduceHomeWidget(
        const HomeWidgetInputs(
          isLoggedIn: false,
          streakDays: 0,
          counts: HomeWidgetCounts.empty,
          todayHasMeals: false,
        ),
      );
    }

    final now = _now();
    final today = DateTime(now.year, now.month, now.day);

    final streak = await _homeRepository.myStreak();
    final candidates = await _mealRepository.candidates();
    final timeline = await _mealRepository.timeline(today);

    return reduceHomeWidget(
      HomeWidgetInputs(
        isLoggedIn: true,
        streakDays: streak,
        counts: _countsFrom(timeline),
        todayHasMeals: _hasMeals(timeline),
        prompt: _latestPrompt(candidates, now),
        worstTodaySymptom: _worstSymptom(timeline),
      ),
    );
  }

  HomeWidgetCounts _countsFrom(List<TimelineItem> items) {
    var recommend = 0;
    var caution = 0;
    var risk = 0;
    for (final item in items) {
      if (item is! TimelineSingle) continue;
      switch (item.grade) {
        case VerdictLevel.recommend:
          recommend++;
        case VerdictLevel.caution:
          caution++;
        case VerdictLevel.risk:
          risk++;
        case VerdictLevel.unknown:
          break;
      }
    }
    return HomeWidgetCounts(
      recommend: recommend,
      caution: caution,
      risk: risk,
    );
  }

  bool _hasMeals(List<TimelineItem> items) {
    for (final item in items) {
      if (item is TimelineSingle || item is TimelineGroup) return true;
    }
    return false;
  }

  HomeWidgetPrompt? _latestPrompt(
    List<MealCandidatesDay> days,
    DateTime now,
  ) {
    MealCandidate? latest;
    DateTime? latestAt;
    for (final day in days) {
      for (final meal in day.meals) {
        DateTime eatenAt;
        try {
          eatenAt = parseKst(meal.eatenAt);
        } catch (_) {
          continue;
        }
        if (latestAt == null || eatenAt.isAfter(latestAt)) {
          latest = meal;
          latestAt = eatenAt;
        }
      }
    }
    if (latest == null || latestAt == null) return null;
    return HomeWidgetPrompt(
      mealRecordId: latest.mealRecordId,
      foodName: _clampFoodName(latest.representativeFoodName),
      hoursSinceEaten: hoursSinceEaten(latestAt, now),
    );
  }

  SymptomState? _worstSymptom(List<TimelineItem> items) {
    SymptomState? worst;
    for (final item in items) {
      final states = <SymptomState>[];
      switch (item) {
        case TimelineSymptom(:final symptomState):
          states.add(symptomState);
        case TimelineSingle(:final connectedSymptoms):
          if (connectedSymptoms != null) {
            states.add(connectedSymptoms.symptomState);
          }
        case TimelineGroup(:final connectedSymptoms):
          if (connectedSymptoms != null) {
            states.add(connectedSymptoms.symptomState);
          }
      }
      for (final state in states) {
        if (worst == null || _rank(state) > _rank(worst)) {
          worst = state;
        }
      }
    }
    return worst;
  }

  static int _rank(SymptomState state) => switch (state) {
        SymptomState.comfortable => 0,
        SymptomState.good => 1,
        SymptomState.normal => 2,
        SymptomState.uncomfortable => 3,
        SymptomState.severe => 4,
      };

  static String _clampFoodName(String name) {
    final chars = name.trim().characters;
    if (chars.length <= 10) return chars.toString();
    return '${chars.take(10)}…';
  }
}
