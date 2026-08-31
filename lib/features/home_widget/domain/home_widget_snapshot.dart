import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

/// Android(향후 iOS) 홈 위젯이 그리는 상태.
enum HomeWidgetKind {
  loggedOut,
  recordMeal,
  promptSymptom,
  allRecordedComfortable,
  allRecordedUncomfortable,
}

/// 위젯 오른쪽 거북이 에셋.
enum HomeWidgetTurtle { none, happy, curious, frown }

/// 오늘 먹은 음식의 신호등 건수. 그룹 끼니 등 grade 없는 항목은 세지 않는다.
class HomeWidgetCounts {
  const HomeWidgetCounts({
    this.recommend = 0,
    this.caution = 0,
    this.risk = 0,
  });

  final int recommend;
  final int caution;
  final int risk;

  static const empty = HomeWidgetCounts();
}

/// 증상 미기록 식사 한 건 — 위젯 카피용.
class HomeWidgetPrompt {
  const HomeWidgetPrompt({
    required this.mealRecordId,
    required this.foodName,
    required this.hoursSinceEaten,
  });

  final String mealRecordId;
  final String foodName;
  final int hoursSinceEaten;
}

/// reducer 입력. 네트워크/저장소는 호출부가 채운다.
class HomeWidgetInputs {
  const HomeWidgetInputs({
    required this.isLoggedIn,
    required this.streakDays,
    required this.counts,
    required this.todayHasMeals,
    this.prompt,
    this.worstTodaySymptom,
  });

  final bool isLoggedIn;
  final int streakDays;
  final HomeWidgetCounts counts;
  final bool todayHasMeals;
  final HomeWidgetPrompt? prompt;

  /// 오늘 기록된 증상 중 가장 나쁜 상태. 없으면 null.
  final SymptomState? worstTodaySymptom;
}

/// 네이티브 위젯에 넘기는 표시 스냅샷.
class HomeWidgetSnapshot {
  const HomeWidgetSnapshot({
    required this.kind,
    required this.counts,
    required this.streakDays,
    required this.headline,
    required this.subtitle,
    required this.ctaLabel,
    required this.turtle,
    this.prompt,
  });

  final HomeWidgetKind kind;
  final HomeWidgetCounts counts;
  final int streakDays;
  final String headline;
  final String subtitle;
  final String ctaLabel;
  final HomeWidgetTurtle turtle;
  final HomeWidgetPrompt? prompt;

  /// Android SharedPreferences는 타입 드리프트(int/long)가 있어 문자열로만 저장한다.
  Map<String, String> toPrefs() => {
        'kind': kind.name,
        'recommendCount': '${counts.recommend}',
        'cautionCount': '${counts.caution}',
        'riskCount': '${counts.risk}',
        'streakDays': '$streakDays',
        'headline': headline,
        'subtitle': subtitle,
        'ctaLabel': ctaLabel,
        'turtle': turtle.name,
        'mealRecordId': prompt?.mealRecordId ?? '',
      };
}
