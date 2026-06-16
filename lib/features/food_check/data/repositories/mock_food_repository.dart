import '../../domain/entities/eat_verdict.dart';
import '../../domain/entities/food_summary.dart';
import '../../domain/entities/recent_food.dart';
import '../../domain/repositories/food_repository.dart';

/// [FoodRepository] 인메모리 Mock 구현.
///
/// [judgeByText] 는 입력 텍스트 기반으로 4상태를 결정론적으로 반환한다:
///   - 'risk'·'커피'·'위험' 포함 → risk
///   - 'caution'·'된장'·'주의' 포함 → caution
///   - 'unknown'·'모름'·'확인어려움' 포함 → unknown
///   - 그 외 → recommend
///
/// [judgeById] 는 externalId를 foodName처럼 취급해 같은 결정론적 로직을 적용한다.
class MockFoodRepository implements FoodRepository {
  /// [initialRecent]: 초기 최근검색 목록 (최신순). null이면 빈 목록.
  /// [searchResults]: [search] 호출 시 반환할 고정 목록. null이면 빈 목록.
  MockFoodRepository({
    List<RecentFood>? initialRecent,
    List<FoodSummary>? searchResults,
  })  : _recent = List<RecentFood>.from(initialRecent ?? []),
        _searchResults = searchResults ?? [];

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 빈 상태. recentSearches 빈 목록, search 빈 목록.
  factory MockFoodRepository.empty() => MockFoodRepository();

  /// 초기 최근검색 항목 있음.
  factory MockFoodRepository.withRecent(List<RecentFood> items) =>
      MockFoodRepository(initialRecent: items);

  /// 검색 결과 고정값 있음.
  factory MockFoodRepository.withSearchResults(List<FoodSummary> results) =>
      MockFoodRepository(searchResults: results);

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  final List<RecentFood> _recent;
  final List<FoodSummary> _searchResults;

  // ---------------------------------------------------------------------------
  // FoodRepository 구현
  // ---------------------------------------------------------------------------

  /// 텍스트 기반 결정론적 판정 (by-text).
  ///
  /// 키워드 우선순위: risk > caution > unknown > recommend.
  @override
  Future<EatVerdict> judgeByText(String foodTextInput) async {
    return _judgeByKeyword(foodTextInput);
  }

  /// externalId 기반 판정 (by-id).
  ///
  /// Mock에서는 externalId를 foodName처럼 취급해 동일 결정론적 로직 적용.
  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    return _judgeByKeyword(foodExternalId);
  }

  /// 키워드 기반 결정론적 판정 내부 로직.
  EatVerdict _judgeByKeyword(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('risk') ||
        lower.contains('커피') ||
        lower.contains('위험')) {
      return EatVerdict.risk(foodName: text);
    }
    if (lower.contains('caution') ||
        lower.contains('된장') ||
        lower.contains('주의')) {
      return EatVerdict.caution(foodName: text);
    }
    if (lower.contains('unknown') ||
        lower.contains('모름') ||
        lower.contains('확인어려움')) {
      return EatVerdict.unknown(foodName: text);
    }
    return EatVerdict.recommend(foodName: text);
  }

  @override
  Future<List<FoodSummary>> search(String q, {int size = 20}) async {
    if (q.trim().isEmpty) return [];
    return _searchResults.take(size).toList();
  }

  @override
  Future<List<RecentFood>> recentSearches({
    int size = kRecentFoodMaxCount,
  }) async {
    return List<RecentFood>.unmodifiable(_recent.take(size).toList());
  }

  @override
  Future<void> addRecent(String foodExternalId) async {
    // 중복 제거 후 맨 앞에 삽입
    _recent.removeWhere((r) => r.foodExternalId == foodExternalId);
    _recent.insert(
      0,
      RecentFood(
        foodExternalId: foodExternalId,
        name: foodExternalId, // Mock에서는 name = externalId
        searchedAt: DateTime.now(),
      ),
    );
    // 최대 개수 초과 시 오래된 항목 잘라내기
    if (_recent.length > kRecentFoodMaxCount) {
      _recent.removeRange(kRecentFoodMaxCount, _recent.length);
    }
  }

  @override
  Future<void> removeRecent(String foodExternalId) async {
    _recent.removeWhere((r) => r.foodExternalId == foodExternalId);
  }

  @override
  Future<void> clearRecent() async {
    _recent.clear();
  }
}
