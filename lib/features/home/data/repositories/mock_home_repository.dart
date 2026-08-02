import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/home/domain/repositories/home_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

/// [HomeRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockHomeRepository.seeded()]: 현실적인 값(미기록 카운트>0, 최근 식사 존재).
/// - [MockHomeRepository.empty()]: 미기록 0, 최근 식사 없음.
class MockHomeRepository implements HomeRepository {
  MockHomeRepository({
    int? streak,
    int? unrecordedCount,
    List<RecentMeal>? recentFoods,
    List<FoodSummary>? topSearchedFoods,
  })  : _streak = streak ?? 0,
        _unrecordedCount = unrecordedCount ?? 0,
        _recentFoods = recentFoods ?? const [],
        _topSearchedFoods = topSearchedFoods ?? const [];

  /// 빈 상태.
  factory MockHomeRepository.empty() => MockHomeRepository();

  /// 샘플 데이터.
  factory MockHomeRepository.seeded() => MockHomeRepository(
        streak: 4,
        unrecordedCount: 2,
        recentFoods: _seededRecentFoods,
        topSearchedFoods: _seededTopSearchedFoods,
      );

  final int _streak;
  final int _unrecordedCount;
  final List<RecentMeal> _recentFoods;
  final List<FoodSummary> _topSearchedFoods;

  @override
  Future<int> myStreak() async => _streak;

  @override
  Future<int> unrecordedMealCount() async => _unrecordedCount;

  @override
  Future<List<RecentMeal>> recentFoods() async => _recentFoods;

  @override
  Future<List<FoodSummary>> topSearchedFoods() async => _topSearchedFoods;
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

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

const _seededTopSearchedFoods = [
  FoodSummary(
    externalId: 'food-top-1',
    name: '닭갈비',
    category: 'stirfry_braise',
  ),
  FoodSummary(
    externalId: 'food-top-2',
    name: '아메리카노',
    category: 'beverage',
  ),
  FoodSummary(
    externalId: 'food-top-3',
    name: '비빔밥',
    category: 'rice_porridge',
  ),
];
