import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/home/domain/repositories/home_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

/// [HomeRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockHomeRepository.seeded()]: 현실적인 값(미기록 카운트>0, 최근 식사 존재).
/// - [MockHomeRepository.empty()]: 미기록 0, 최근 식사 없음.
class MockHomeRepository implements HomeRepository {
  MockHomeRepository({
    int? unrecordedCount,
    List<RecentMeal>? recentFoods,
  })  : _unrecordedCount = unrecordedCount ?? 0,
        _recentFoods = recentFoods ?? const [];

  /// 빈 상태.
  factory MockHomeRepository.empty() => MockHomeRepository();

  /// 샘플 데이터.
  factory MockHomeRepository.seeded() => MockHomeRepository(
        unrecordedCount: 2,
        recentFoods: _seededRecentFoods,
      );

  final int _unrecordedCount;
  final List<RecentMeal> _recentFoods;

  @override
  Future<int> unrecordedMealCount() async => _unrecordedCount;

  @override
  Future<List<RecentMeal>> recentFoods() async => _recentFoods;
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

// 홈 화면 제안 칩 라벨(된장찌개·아메리카노·김치볶음밥)과 겹치지 않는 이름 사용
// (home_screen_test.dart find.text 충돌 방지).
const _seededRecentFoods = [
  RecentMeal(
    foodName: '계란찜',
    category: 'steam_boil',
    eatenAt: '2026-07-05T12:30:00+09:00',
    symptomState: SymptomState.comfortable,
  ),
  RecentMeal(
    foodName: '카페라떼',
    category: 'beverage',
    eatenAt: '2026-07-05T09:00:00+09:00',
  ),
];
