import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

/// [eatenAt]부터 [now]까지 경과 시간(시). 음수는 0.
int hoursSinceEaten(DateTime eatenAt, DateTime now) {
  final diff = now.difference(eatenAt);
  if (diff.isNegative) return 0;
  return diff.inHours;
}

bool isUncomfortableSymptom(SymptomState state) =>
    state == SymptomState.uncomfortable || state == SymptomState.severe;

/// 피그마 Small 위젯 4상태 + 로그아웃.
HomeWidgetSnapshot reduceHomeWidget(HomeWidgetInputs inputs) {
  if (!inputs.isLoggedIn) {
    return const HomeWidgetSnapshot(
      kind: HomeWidgetKind.loggedOut,
      counts: HomeWidgetCounts.empty,
      streakDays: 0,
      headline: '로그인하고\n위젯을 사용해보세요',
      subtitle: '',
      ctaLabel: '앱 열기',
      turtle: HomeWidgetTurtle.none,
    );
  }

  final prompt = inputs.prompt;
  if (prompt != null) {
    final hoursLabel = prompt.hoursSinceEaten == 0
        ? '${prompt.foodName} 먹은지 1시간 미만'
        : '${prompt.foodName} 먹은지 ${prompt.hoursSinceEaten}시간';
    return HomeWidgetSnapshot(
      kind: HomeWidgetKind.promptSymptom,
      counts: inputs.counts,
      streakDays: inputs.streakDays,
      headline: '속이 불편한지 궁금해요..',
      subtitle: hoursLabel,
      ctaLabel: '증상 기록하기 +',
      turtle: HomeWidgetTurtle.curious,
      prompt: prompt,
    );
  }

  if (!inputs.todayHasMeals) {
    return HomeWidgetSnapshot(
      kind: HomeWidgetKind.recordMeal,
      counts: inputs.counts,
      streakDays: inputs.streakDays,
      headline: '',
      subtitle: '',
      ctaLabel: '음식 기록하기 +',
      turtle: HomeWidgetTurtle.none,
    );
  }

  final worst = inputs.worstTodaySymptom;
  if (worst != null && isUncomfortableSymptom(worst)) {
    return HomeWidgetSnapshot(
      kind: HomeWidgetKind.allRecordedUncomfortable,
      counts: inputs.counts,
      streakDays: 0,
      headline: '연속 편안한 날\n0일째',
      subtitle: '',
      ctaLabel: '음식 히스토리 보기',
      turtle: HomeWidgetTurtle.frown,
    );
  }

  return HomeWidgetSnapshot(
    kind: HomeWidgetKind.allRecordedComfortable,
    counts: inputs.counts,
    streakDays: inputs.streakDays,
    headline: '연속 편안한 날\n${inputs.streakDays}일째',
    subtitle: '',
    ctaLabel: '음식 히스토리 보기',
    turtle: HomeWidgetTurtle.happy,
  );
}
