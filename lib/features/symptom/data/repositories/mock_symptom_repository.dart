import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';

/// [SymptomRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockSymptomRepository.seeded()]: linkedMeal 有/無, analysis 有/無 케이스 포함.
/// - [MockSymptomRepository.empty()]: 빈 저장소.
class MockSymptomRepository implements SymptomRepository {
  MockSymptomRepository({
    Map<String, Symptom>? initialStore,
  }) : _store = {...?initialStore};

  /// 빈 상태.
  factory MockSymptomRepository.empty() => MockSymptomRepository();

  /// 샘플 데이터 (linkedMeal 有/無, analysis 有/無 케이스 포함).
  factory MockSymptomRepository.seeded() =>
      MockSymptomRepository(initialStore: _seedStore);

  final Map<String, Symptom> _store;
  int _seq = 0;

  @override
  Future<Symptom> create(SymptomDraft draft) async {
    _seq++;
    final id = 'mock-symptom-$_seq';
    final symptom = Symptom(
      symptomId: id,
      symptomState: draft.symptomState,
      stateTitle: _stateTitleFor(draft.symptomState),
      symptomTypes: List.unmodifiable(draft.symptomTypes),
      occurredAt: draft.occurredAt != null
          ? _formatKst(draft.occurredAt!)
          : _formatKst(DateTime.now()),
      linkedMeal: null,
      analysisItems: const [],
    );
    _store[id] = symptom;
    return symptom;
  }

  @override
  Future<Symptom> detail(String symptomId) async {
    final s = _store[symptomId];
    if (s == null) {
      throw Exception('MockSymptomRepository: symptomId $symptomId 없음');
    }
    return s;
  }

  @override
  Future<void> update(String symptomId, SymptomDraft draft) async {
    final existing = _store[symptomId];
    if (existing == null) {
      throw Exception('MockSymptomRepository: symptomId $symptomId 없음');
    }
    _store[symptomId] = existing.copyWith(
      symptomState: draft.symptomState,
      stateTitle: _stateTitleFor(draft.symptomState),
      symptomTypes: List.unmodifiable(draft.symptomTypes),
      occurredAt: draft.occurredAt != null
          ? _formatKst(draft.occurredAt!)
          : existing.occurredAt,
    );
  }

  @override
  Future<void> updateMemo(String symptomId, String? memo) async {
    final existing = _store[symptomId];
    if (existing == null) {
      throw Exception('MockSymptomRepository: symptomId $symptomId 없음');
    }
    // memo는 Symptom 엔티티에 포함되지 않으므로 (서버가 보관) 존재만 확인.
  }

  @override
  Future<void> delete(String symptomId) async {
    _store.remove(symptomId);
  }
}

// ---------------------------------------------------------------------------
// 내부 헬퍼
// ---------------------------------------------------------------------------

String _stateTitleFor(SymptomState state) => switch (state) {
      SymptomState.comfortable => '편안한 하루예요',
      SymptomState.good => '컨디션이 좋아요',
      SymptomState.normal => '보통이에요',
      SymptomState.uncomfortable => '조금 불편해요',
      SymptomState.severe => '많이 힘드셨군요',
    };

String _formatKst(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final mi = dt.minute.toString().padLeft(2, '0');
  final s = dt.second.toString().padLeft(2, '0');
  return '$y-$mo-${d}T$h:$mi:$s+09:00';
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

const _kOccurredWithMeal = '2026-06-17T14:30:00+09:00';
const _kOccurredNoMeal = '2026-06-18T09:00:00+09:00';

final _seedStore = <String, Symptom>{
  // 케이스 1: linkedMeal 有, analysis 有
  'symptom-001': const Symptom(
    symptomId: 'symptom-001',
    symptomState: SymptomState.uncomfortable,
    stateTitle: '조금 불편해요',
    symptomTypes: [SymptomType.acidReflux, SymptomType.cough],
    occurredAt: _kOccurredWithMeal,
    linkedMeal: SymptomLinkedMeal(
      mealRecordId: 'record-002',
      foods: [
        SymptomLinkedFood(
          mealFoodId: 'food-002',
          name: '된장찌개',
          category: '한식',
        ),
        SymptomLinkedFood(
          mealFoodId: 'food-003',
          name: '커피',
          category: '음료',
        ),
      ],
    ),
    analysisItems: [
      SymptomAnalysisItem(
        emphasis: '카페인이 위산을 자극해요',
        body: '커피는 하부식도괄약근을 이완시켜 역류를 악화할 수 있어요.',
      ),
      SymptomAnalysisItem(
        emphasis: '나트륨 함량 주의',
        body: '된장찌개의 높은 나트륨 함량이 위 점막을 자극할 수 있어요.',
      ),
    ],
  ),
  // 케이스 2: linkedMeal 無, analysis 無
  'symptom-002': const Symptom(
    symptomId: 'symptom-002',
    symptomState: SymptomState.good,
    stateTitle: '컨디션이 좋아요',
    symptomTypes: [],
    occurredAt: _kOccurredNoMeal,
    linkedMeal: null,
    analysisItems: [],
  ),
};
