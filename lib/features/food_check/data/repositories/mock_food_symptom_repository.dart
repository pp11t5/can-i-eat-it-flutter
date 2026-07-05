import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_symptom_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

/// [FoodSymptomRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockFoodSymptomRepository.seeded()]: 증상 이력 2건.
/// - [MockFoodSymptomRepository.empty()]: 이력 없음.
class MockFoodSymptomRepository implements FoodSymptomRepository {
  MockFoodSymptomRepository({List<FoodSymptom>? initial})
      : _symptoms = initial ?? const [];

  /// 빈 상태.
  factory MockFoodSymptomRepository.empty() => MockFoodSymptomRepository();

  /// 샘플 데이터.
  factory MockFoodSymptomRepository.seeded() =>
      MockFoodSymptomRepository(initial: _seededSymptoms);

  final List<FoodSymptom> _symptoms;

  @override
  Future<List<FoodSymptom>> getSymptoms(String foodExternalId) async =>
      _symptoms;
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

const _seededSymptoms = [
  FoodSymptom(
    symptomId: 'symptom-1',
    symptomState: SymptomState.uncomfortable,
    symptomTypes: ['heartburn_reflux'],
    occurredAt: '2026-06-20T20:30:00+09:00',
    mealRecordId: 'meal-1',
    afterMealMinutes: 30,
  ),
  FoodSymptom(
    symptomId: 'symptom-2',
    symptomState: SymptomState.normal,
    symptomTypes: ['post_meal_cough'],
    occurredAt: '2026-06-15T13:10:00+09:00',
    mealRecordId: 'meal-2',
    afterMealMinutes: 60,
  ),
];
