import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart' show clampMealName;
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 인메모리 Mock 구현. UI 선개발·테스트용 (신 계약).
///
/// - [MockMealRepository.seeded()]: single 1 + group 1 + symptom 1 타임라인,
///   mealDetail/foodDetail 캐시, weekly·candidates 시드. 실 API처럼
///   **날짜 인식**(date-aware) — `timeline`/`weekly` 는 조회 날짜에 맞춰
///   필터링된다. [seeded]의 `anchor` 로 시드 기준일을 이동할 수 있다.
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

  /// 샘플 데이터. [anchor] 를 넘기면 시드 기준일(Y/M/D)을 이동한다(미지정 시
  /// [_kSeedAnchor]).
  factory MockMealRepository.seeded({DateTime? anchor}) {
    final base = anchor ?? _kSeedAnchor;
    return MockMealRepository(
      initialTimeline: _buildSeedTimeline(base),
      initialMealDetails: _buildSeedMealDetails(base),
      initialFoodDetails: _buildSeedFoodDetails(base),
      initialWeekly: _buildSeedWeekly(base),
      initialCandidates: _buildSeedCandidates(base),
    );
  }

  final List<TimelineItem> _timeline;
  final Map<String, MealRecord> _mealDetails;
  final Map<String, MealFood> _foodDetails;
  final List<WeeklyDay> _weekly;
  final List<MealCandidatesDay> _candidates;

  int _seq = 0;

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async {
    final items = _timeline.where((item) {
      final iso = switch (item) {
        TimelineSingle(mealRecordDateTime: final dt) => dt,
        TimelineGroup(mealRecordDateTime: final dt) => dt,
        TimelineSymptom(occurredAt: final dt) => dt,
      };
      final parsed = _tryParseKst(iso);
      if (parsed == null) return false;
      return parsed.year == date.year &&
          parsed.month == date.month &&
          parsed.day == date.day;
    }).toList();
    return List<TimelineItem>.unmodifiable(items);
  }

  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 7));
    final items = _weekly.where((day) {
      final parsed = _tryParseDate(day.date);
      if (parsed == null) return false;
      return !parsed.isBefore(start) && parsed.isBefore(end);
    }).toList();
    return List<WeeklyDay>.unmodifiable(items);
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

/// [iso] 를 [parseKst] 로 파싱한다. 실패 시 null(호출부가 필터링 대상에서 제외).
DateTime? _tryParseKst(String iso) {
  try {
    return parseKst(iso);
  } catch (_) {
    return null;
  }
}

/// 'YYYY-MM-DD' 문자열을 [DateTime] 으로 파싱한다. 실패 시 null.
DateTime? _tryParseDate(String ymd) {
  try {
    return DateTime.parse(ymd);
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// 시드 데이터 — anchor(base) 기준 날짜로 생성되는 빌더 함수들
// ---------------------------------------------------------------------------

/// 시드 기본 기준일. [MockMealRepository.seeded] 호출 시 `anchor` 를 넘기지
/// 않으면 이 날짜(Y/M/D)로 모든 시드 datetime 이 생성된다.
final DateTime _kSeedAnchor = DateTime(2026, 6, 17);

/// [base] 의 Y/M/D + ([hour]:[minute]) 를 서버 offset 포맷
/// ('YYYY-MM-DDTHH:mm:00+09:00')으로 직렬화한다.
String _isoAt(DateTime base, int hour, int minute) =>
    toServerOffset(DateTime(base.year, base.month, base.day, hour, minute));

/// [base] 의 Y/M/D 를 'YYYY-MM-DD' 로 직렬화한다.
String _ymd(DateTime base) => toServerDate(base);

List<TimelineItem> _buildSeedTimeline(DateTime base) {
  final eatenMorning = _isoAt(base, 8, 0);
  final eatenLunch = _isoAt(base, 12, 30);
  final eatenSymptom = _isoAt(base, 14, 30);

  return <TimelineItem>[
    // single: 음식 1개짜리 식사
    TimelineItem.single(
      mealRecordId: 'record-001',
      mealRecordDateTime: eatenMorning,
      mealFoodName: '두부',
      grade: VerdictLevel.recommend,
    ),
    // group: 음식 2개 이상짜리 식사 (연결증상 보유)
    TimelineItem.group(
      mealRecordId: 'record-002',
      mealRecordDateTime: eatenLunch,
      representativeFoods: const ['된장찌개', '커피'],
      etcCount: 1,
      connectedSymptoms: const ConnectedSymptoms(
        symptomId: 'symptom-001',
        symptomState: SymptomState.uncomfortable,
        afterMealMinutes: 120,
        representativeSymptoms: ['속쓰림'],
        etcCount: 0,
      ),
    ),
    // symptom: 증상 기록 (탭 가능하도록 symptomId 보유)
    TimelineItem.symptom(
      symptomState: SymptomState.uncomfortable,
      afterMealMinutes: 120,
      occurredAt: eatenSymptom,
      symptomId: 'symptom-001',
    ),
  ];
}

Map<String, MealRecord> _buildSeedMealDetails(DateTime base) {
  final eatenMorning = _isoAt(base, 8, 0);
  final eatenLunch = _isoAt(base, 12, 30);

  return <String, MealRecord>{
    'record-001': MealRecord(
      mealRecordId: 'record-001',
      eatenAt: eatenMorning,
      foods: [
        MealFood(
          mealFoodId: 'food-001',
          name: '두부',
          category: '두류',
          eatenAt: eatenMorning,
        ),
      ],
    ),
    'record-002': MealRecord(
      mealRecordId: 'record-002',
      eatenAt: eatenLunch,
      foods: [
        MealFood(
          mealFoodId: 'food-002',
          name: '된장찌개',
          category: '한식',
          eatenAt: eatenLunch,
        ),
        MealFood(
          mealFoodId: 'food-003',
          name: '커피',
          category: '음료',
          eatenAt: eatenLunch,
        ),
        MealFood(
          mealFoodId: 'food-004',
          name: '공기밥',
          category: '한식',
          eatenAt: eatenLunch,
        ),
      ],
      stateRecords: [
        StateRecord(
          stateRecordId: 'state-001',
          label: '속쓰림',
          date: _ymd(base),
          timingMinutes: 30,
        ),
      ],
    ),
  };
}

Map<String, MealFood> _buildSeedFoodDetails(DateTime base) {
  final eatenMorning = _isoAt(base, 8, 0);
  final eatenLunch = _isoAt(base, 12, 30);

  return <String, MealFood>{
    'food-001': MealFood(
      mealFoodId: 'food-001',
      name: '두부',
      category: '두류',
      eatenAt: eatenMorning,
      mealRecordExternalId: 'record-001',
      analysis: const MealAnalysis(
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
    'food-002': MealFood(
      mealFoodId: 'food-002',
      name: '된장찌개',
      category: '한식',
      eatenAt: eatenLunch,
      mealRecordExternalId: 'record-002',
      analysis: const MealAnalysis(
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
}

List<WeeklyDay> _buildSeedWeekly(DateTime base) {
  // 신호등 dots 는 타임라인 데이터가 존재하는 날(base)에만 부여한다 — dots 가
  // 있는데 탭하면 빈 타임라인이 나오는 불일치를 막기 위함(실 API 는 dots·타임라인이
  // 같은 날짜 데이터에서 나온다). base 하루에 최대 3개 판정색 dots.
  return <WeeklyDay>[
    WeeklyDay(
      date: _ymd(base),
      dayOfWeek: 'WED',
      judgements: const [
        VerdictLevel.recommend,
        VerdictLevel.caution,
        VerdictLevel.risk,
      ],
    ),
  ];
}

List<MealCandidatesDay> _buildSeedCandidates(DateTime base) {
  final eatenLunch = _isoAt(base, 12, 30);

  return <MealCandidatesDay>[
    MealCandidatesDay(
      date: _ymd(base),
      meals: [
        MealCandidate(
          mealRecordId: 'record-002',
          representativeFoodName: '된장찌개',
          representativeFoodCategory: '한식',
          otherFoodCount: 2,
          eatenAt: eatenLunch,
        ),
      ],
    ),
  ];
}
