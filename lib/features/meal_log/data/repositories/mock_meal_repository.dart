import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockMealRepository.seeded()]: 끼니 2그룹·식사 3건·stateRecords 샘플.
/// - [MockMealRepository.empty()]: 빈 타임라인.
class MockMealRepository implements MealRepository {
  MockMealRepository({
    List<MealGroup>? initialGroups,
  }) : _groups = initialGroups != null
            ? List<MealGroup>.from(initialGroups)
            : [];

  // ---------------------------------------------------------------------------
  // Named factory
  // ---------------------------------------------------------------------------

  /// 빈 상태. timeline 빈 목록.
  factory MockMealRepository.empty() => MockMealRepository();

  /// 샘플 데이터 있음. 끼니 2그룹, 식사 3건, stateRecords 포함.
  factory MockMealRepository.seeded() => MockMealRepository(
        initialGroups: _seedGroups,
      );

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  final List<MealGroup> _groups;

  // 상세 캐시 — create/createByText 결과를 detail/updateMemo 에서 참조한다.
  final Map<String, MealDetail> _details = Map.fromEntries(
    _seedDetails.map((d) => MapEntry(d.mealId, d)),
  );

  // ---------------------------------------------------------------------------
  // MealRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<List<MealGroup>> timeline(DateTime date) async {
    return List<MealGroup>.unmodifiable(_groups);
  }

  @override
  Future<MealRecord> create({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  }) async {
    final now = eatenAt ?? DateTime.now();
    final mealId = 'mock-meal-${DateTime.now().millisecondsSinceEpoch}';
    final groupId = mealGroupId ?? 'mock-group-${DateTime.now().millisecondsSinceEpoch}';
    final record = MealRecord(
      mealId: mealId,
      mealGroupId: groupId,
      eatenAt: now.toIso8601String(),
      food: FoodSummary(externalId: foodExternalId, name: foodExternalId),
      judgedGrade: grade,
    );
    // 상세도 함께 등록
    _details[mealId] = MealDetail(
      mealId: mealId,
      mealGroupId: groupId,
      eatenAt: now.toIso8601String(),
      food: MealFood(externalId: foodExternalId, name: foodExternalId),
      judgedGrade: grade,
    );
    _upsertGroup(groupId, now.toIso8601String(), record);
    return record;
  }

  @override
  Future<MealRecord> createByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  }) async {
    return create(
      foodExternalId: foodTextInput,
      eatenAt: eatenAt,
      mealGroupId: mealGroupId,
      grade: grade,
    );
  }

  @override
  Future<MealDetail> detail(String mealId) async {
    final d = _details[mealId];
    if (d == null) {
      throw Exception('MockMealRepository: mealId $mealId 없음');
    }
    return d;
  }

  @override
  Future<MealDetail> updateMemo(String mealId, String? memo) async {
    final d = _details[mealId];
    if (d == null) {
      throw Exception('MockMealRepository: mealId $mealId 없음');
    }
    final updated = d.copyWith(memo: memo?.isEmpty ?? true ? null : memo);
    _details[mealId] = updated;
    return updated;
  }

  @override
  Future<void> delete(String mealId) async {
    _details.remove(mealId);
    for (var i = 0; i < _groups.length; i++) {
      final g = _groups[i];
      final filtered = g.records.where((r) => r.mealId != mealId).toList();
      if (filtered.length != g.records.length) {
        _groups[i] = g.copyWith(records: filtered);
      }
    }
    _groups.removeWhere((g) => g.records.isEmpty);
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  void _upsertGroup(String groupId, String eatenAt, MealRecord record) {
    final idx = _groups.indexWhere((g) => g.mealGroupId == groupId);
    if (idx >= 0) {
      _groups[idx] = _groups[idx].copyWith(
        records: [..._groups[idx].records, record],
      );
    } else {
      _groups.insert(
        0,
        MealGroup(mealGroupId: groupId, eatenAt: eatenAt, records: [record]),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

const _kFoodTofu = FoodSummary(externalId: 'food-001', name: '두부');
const _kFoodCoffee = FoodSummary(externalId: 'food-002', name: '커피');
const _kFoodMiso = FoodSummary(externalId: 'food-003', name: '된장찌개');

const _kMealFoodTofu = MealFood(externalId: 'food-001', name: '두부', category: '두류');
const _kMealFoodCoffee = MealFood(externalId: 'food-002', name: '커피', category: '음료');
const _kMealFoodMiso = MealFood(
  externalId: 'food-003',
  name: '된장찌개',
  category: '한식',
  description: '된장을 베이스로 한 한국 전통 찌개.',
);

final _seedGroups = [
  const MealGroup(
    mealGroupId: 'group-001',
    eatenAt: '2026-06-17T08:00:00+09:00',
    records: [
      MealRecord(
        mealId: 'meal-001',
        mealGroupId: 'group-001',
        eatenAt: '2026-06-17T08:00:00+09:00',
        food: _kFoodTofu,
        judgedGrade: VerdictLevel.recommend,
      ),
      MealRecord(
        mealId: 'meal-002',
        mealGroupId: 'group-001',
        eatenAt: '2026-06-17T08:05:00+09:00',
        food: _kFoodCoffee,
        judgedGrade: VerdictLevel.risk,
      ),
    ],
  ),
  const MealGroup(
    mealGroupId: 'group-002',
    eatenAt: '2026-06-17T12:30:00+09:00',
    records: [
      MealRecord(
        mealId: 'meal-003',
        mealGroupId: 'group-002',
        eatenAt: '2026-06-17T12:30:00+09:00',
        food: _kFoodMiso,
        judgedGrade: VerdictLevel.caution,
      ),
    ],
  ),
];

final _seedDetails = [
  const MealDetail(
    mealId: 'meal-001',
    mealGroupId: 'group-001',
    eatenAt: '2026-06-17T08:00:00+09:00',
    food: _kMealFoodTofu,
    judgedGrade: VerdictLevel.recommend,
    stateRecords: [],
  ),
  const MealDetail(
    mealId: 'meal-002',
    mealGroupId: 'group-001',
    eatenAt: '2026-06-17T08:05:00+09:00',
    food: _kMealFoodCoffee,
    judgedGrade: VerdictLevel.risk,
    stateRecords: [
      StateRecord(label: '속쓰림', date: '2026-06-10', timing: '식후 30분'),
      StateRecord(label: '위산역류', date: '2026-06-12', timing: '식후 1시간'),
    ],
  ),
  const MealDetail(
    mealId: 'meal-003',
    mealGroupId: 'group-002',
    eatenAt: '2026-06-17T12:30:00+09:00',
    memo: '소량만 먹었음',
    food: _kMealFoodMiso,
    judgedGrade: VerdictLevel.caution,
    stateRecords: [
      StateRecord(label: '속쓰림', date: '2026-06-15', timing: '식후 30분'),
    ],
  ),
];
