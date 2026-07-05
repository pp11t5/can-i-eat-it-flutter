import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart' show clampMealName;
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 인메모리 Mock 구현. UI 선개발·테스트용 (신 계약).
///
/// - [MockMealRepository.seeded()]: single 1 + group 1 + symptom 1 타임라인,
///   mealDetail/foodDetail 캐시, weekly·candidates 시드.
/// - [MockMealRepository.empty()]: 빈 타임라인.
class MockMealRepository implements MealRepository {
  MockMealRepository({
    List<TimelineItem>? initialTimeline,
    Map<String, MealRecord>? initialMealDetails,
    Map<String, MealFood>? initialFoodDetails,
    List<WeeklyDay>? initialWeekly,
    List<MealCandidatesDay>? initialCandidates,
  })  : _timeline =
            initialTimeline != null ? List.from(initialTimeline) : [],
        _mealDetails = {...?initialMealDetails},
        _foodDetails = {...?initialFoodDetails},
        _weekly = initialWeekly != null ? List.from(initialWeekly) : [],
        _candidates =
            initialCandidates != null ? List.from(initialCandidates) : [];

  /// 빈 상태.
  factory MockMealRepository.empty() => MockMealRepository();

  /// 샘플 데이터.
  factory MockMealRepository.seeded() => MockMealRepository(
        initialTimeline: _seedTimeline,
        initialMealDetails: _seedMealDetails,
        initialFoodDetails: _seedFoodDetails,
        initialWeekly: _seedWeekly,
        initialCandidates: _seedCandidates,
      );

  final List<TimelineItem> _timeline;
  final Map<String, MealRecord> _mealDetails;
  final Map<String, MealFood> _foodDetails;
  final List<WeeklyDay> _weekly;
  final List<MealCandidatesDay> _candidates;

  int _seq = 0;

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async {
    return List<TimelineItem>.unmodifiable(_timeline);
  }

  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async {
    return List<WeeklyDay>.unmodifiable(_weekly);
  }

  /// [appendFood]/[appendFoodByText] 공통 로직 — 음식 생성 + 식사 상세 캐시 반영.
  MealFood _appendFood({
    required String name,
    DateTime? eatenAt,
    String? mealRecordId,
  }) {
    final now = eatenAt ?? DateTime.now();
    final iso = now.toIso8601String();
    _seq++;
    final foodId = 'mock-food-$_seq';
    final recordId = mealRecordId ?? 'mock-record-$_seq';

    final food = MealFood(
      mealFoodId: foodId,
      name: name,
      eatenAt: iso,
      mealRecordExternalId: recordId,
      analysis: const MealAnalysis(judgmentGrade: VerdictLevel.unknown),
    );
    _foodDetails[foodId] = food;

    // 식사 상세 캐시에 음식 추가(append) 또는 신규 식사 생성.
    final existing = _mealDetails[recordId];
    if (existing != null) {
      _mealDetails[recordId] = existing.copyWith(
        foods: [...existing.foods, food],
      );
    } else {
      _mealDetails[recordId] = MealRecord(
        mealRecordId: recordId,
        eatenAt: iso,
        foods: [food],
      );
    }
    return food;
  }

  @override
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async =>
      _appendFood(
        name: foodExternalId,
        eatenAt: eatenAt,
        mealRecordId: mealRecordId,
      );

  @override
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async =>
      _appendFood(
        // 실구현(meal_repository_impl.dart)과 동일하게 서버 name 제약(≤100자,
        // grapheme 기준)을 적용한다 — 계약 정합(pr-review 소소 수정 ③).
        name: clampMealName(foodTextInput),
        eatenAt: eatenAt,
        mealRecordId: mealRecordId,
      );

  @override
  Future<MealRecord> mealDetail(String mealRecordId) async {
    final d = _mealDetails[mealRecordId];
    if (d == null) {
      throw Exception('MockMealRepository: mealRecordId $mealRecordId 없음');
    }
    return d;
  }

  @override
  Future<MealFood> foodDetail(String mealFoodId) async {
    final f = _foodDetails[mealFoodId];
    if (f == null) {
      throw Exception('MockMealRepository: mealFoodId $mealFoodId 없음');
    }
    return f;
  }

  @override
  Future<void> deleteMeal(String mealRecordId) async {
    _mealDetails.remove(mealRecordId);
    _timeline.removeWhere((item) => switch (item) {
          TimelineSingle(mealRecordId: final id) => id == mealRecordId,
          TimelineGroup(mealRecordId: final id) => id == mealRecordId,
          TimelineSymptom() => false,
        });
  }

  @override
  Future<void> deleteFood(String mealFoodId) async {
    _foodDetails.remove(mealFoodId);
    // 캐시된 식사에서 해당 음식 제거. 빈 식사는 함께 삭제(서버 계약).
    final emptied = <String>[];
    _mealDetails.updateAll((id, record) {
      final filtered =
          record.foods.where((f) => f.mealFoodId != mealFoodId).toList();
      if (filtered.isEmpty) emptied.add(id);
      return record.copyWith(foods: filtered);
    });
    for (final id in emptied) {
      _mealDetails.remove(id);
    }
  }

  @override
  Future<List<MealCandidatesDay>> candidates() async {
    return List<MealCandidatesDay>.unmodifiable(_candidates);
  }
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

const _kEatenMorning = '2026-06-17T08:00:00+09:00';
const _kEatenLunch = '2026-06-17T12:30:00+09:00';
const _kEatenSymptom = '2026-06-17T14:30:00+09:00';

final _seedTimeline = <TimelineItem>[
  // single: 음식 1개짜리 식사
  const TimelineItem.single(
    mealRecordId: 'record-001',
    mealRecordDateTime: _kEatenMorning,
    mealFoodName: '두부',
    grade: VerdictLevel.recommend,
  ),
  // group: 음식 2개 이상짜리 식사
  const TimelineItem.group(
    mealRecordId: 'record-002',
    mealRecordDateTime: _kEatenLunch,
    representativeFoods: ['된장찌개', '커피'],
    etcCount: 1,
  ),
  // symptom: 증상 기록
  const TimelineItem.symptom(
    symptomState: SymptomState.uncomfortable,
    afterMealMinutes: 120,
    occurredAt: _kEatenSymptom,
  ),
];

final _seedMealDetails = <String, MealRecord>{
  'record-001': const MealRecord(
    mealRecordId: 'record-001',
    eatenAt: _kEatenMorning,
    foods: [
      MealFood(
        mealFoodId: 'food-001',
        name: '두부',
        category: '두류',
        eatenAt: _kEatenMorning,
      ),
    ],
  ),
  'record-002': const MealRecord(
    mealRecordId: 'record-002',
    eatenAt: _kEatenLunch,
    foods: [
      MealFood(
        mealFoodId: 'food-002',
        name: '된장찌개',
        category: '한식',
        eatenAt: _kEatenLunch,
      ),
      MealFood(
        mealFoodId: 'food-003',
        name: '커피',
        category: '음료',
        eatenAt: _kEatenLunch,
      ),
      MealFood(
        mealFoodId: 'food-004',
        name: '공기밥',
        category: '한식',
        eatenAt: _kEatenLunch,
      ),
    ],
    stateRecords: [
      StateRecord(
        stateRecordId: 'state-001',
        label: '속쓰림',
        date: '2026-06-17',
        timingMinutes: 30,
      ),
    ],
  ),
};

final _seedFoodDetails = <String, MealFood>{
  'food-001': const MealFood(
    mealFoodId: 'food-001',
    name: '두부',
    category: '두류',
    eatenAt: _kEatenMorning,
    mealRecordExternalId: 'record-001',
    analysis: MealAnalysis(
      judgmentGrade: VerdictLevel.recommend,
      trigger: AnalysisSection(
        ment: '트리거/증상 분석',
        content: '역류 트리거에 해당하지 않아요.',
      ),
      allergy: AnalysisSection(
        ment: '알레르기/복용약 분석',
        content: '알레르기·복용약 충돌이 없어요.',
      ),
    ),
  ),
  'food-002': const MealFood(
    mealFoodId: 'food-002',
    name: '된장찌개',
    category: '한식',
    eatenAt: _kEatenLunch,
    mealRecordExternalId: 'record-002',
    analysis: MealAnalysis(
      judgmentGrade: VerdictLevel.caution,
      trigger: AnalysisSection(
        ment: '트리거/증상 분석',
        content: '나트륨 함량이 높아 위산 역류를 악화할 수 있어요.',
      ),
      allergy: AnalysisSection(
        ment: '알레르기/복용약 분석',
        content: '알레르기·복용약 충돌은 없어요.',
      ),
    ),
  ),
};

final _seedWeekly = <WeeklyDay>[
  const WeeklyDay(
    date: '2026-06-17',
    dayOfWeek: 'WED',
    judgements: [
      VerdictLevel.recommend,
      VerdictLevel.caution,
      VerdictLevel.risk,
    ],
  ),
];

final _seedCandidates = <MealCandidatesDay>[
  const MealCandidatesDay(
    date: '2026-06-17',
    meals: [
      MealCandidate(
        mealRecordId: 'record-002',
        representativeFoodName: '된장찌개',
        representativeFoodCategory: '한식',
        otherFoodCount: 2,
        eatenAt: _kEatenLunch,
      ),
    ],
  ),
];
