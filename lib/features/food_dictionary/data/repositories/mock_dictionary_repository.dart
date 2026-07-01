import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/repositories/dictionary_repository.dart';

/// [DictionaryRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockDictionaryRepository.seeded()]: 권장 몇 개·주의/위험 몇 개, count 일치.
/// - [MockDictionaryRepository.empty()]: 빈 페이지·count 0.
///
/// 단일 페이지(hasNext=false)로 충분 — 결정론적 시드.
class MockDictionaryRepository implements DictionaryRepository {
  MockDictionaryRepository({
    List<DictionaryFoodItem>? initialSafe,
    List<DictionaryFoodItem>? initialCautionRisk,
  })  : _safe = initialSafe != null ? List.from(initialSafe) : [],
        _cautionRisk =
            initialCautionRisk != null ? List.from(initialCautionRisk) : [];

  /// 빈 상태.
  factory MockDictionaryRepository.empty() => MockDictionaryRepository();

  /// 샘플 데이터.
  factory MockDictionaryRepository.seeded() => MockDictionaryRepository(
        initialSafe: _seedSafe,
        initialCautionRisk: _seedCautionRisk,
      );

  final List<DictionaryFoodItem> _safe;
  final List<DictionaryFoodItem> _cautionRisk;

  @override
  Future<DictionaryPage> getSafe({int? cursor, int size = 20}) async {
    return DictionaryPage(
      items: List<DictionaryFoodItem>.unmodifiable(_safe),
      nextCursor: null,
      hasNext: false,
    );
  }

  @override
  Future<DictionaryPage> getCautionRisk({int? cursor, int size = 20}) async {
    return DictionaryPage(
      items: List<DictionaryFoodItem>.unmodifiable(_cautionRisk),
      nextCursor: null,
      hasNext: false,
    );
  }

  @override
  Future<DictionaryCount> getCount() async {
    return DictionaryCount(
      safeCount: _safe.length,
      cautionRiskCount: _cautionRisk.length,
    );
  }
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

final _seedSafe = <DictionaryFoodItem>[
  const DictionaryFoodItem(
    foodId: 'dict-food-001',
    name: '두부',
    categoryCode: 'BEAN',
    verdict: VerdictLevel.recommend,
  ),
  const DictionaryFoodItem(
    foodId: 'dict-food-002',
    name: '흰쌀밥',
    categoryCode: 'GRAIN',
    verdict: VerdictLevel.recommend,
  ),
  const DictionaryFoodItem(
    foodId: 'dict-food-003',
    name: '바나나',
    categoryCode: 'FRUIT',
    verdict: VerdictLevel.recommend,
  ),
];

final _seedCautionRisk = <DictionaryFoodItem>[
  const DictionaryFoodItem(
    foodId: 'dict-food-004',
    name: '된장찌개',
    categoryCode: 'KOREAN',
    verdict: VerdictLevel.caution,
  ),
  const DictionaryFoodItem(
    foodId: 'dict-food-005',
    name: '커피',
    categoryCode: 'BEVERAGE',
    verdict: VerdictLevel.risk,
  ),
];
