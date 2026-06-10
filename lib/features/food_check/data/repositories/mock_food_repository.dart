import '../../domain/entities/eat_verdict.dart';
import '../../domain/entities/food_summary.dart';
import '../../domain/entities/recent_food.dart';
import '../../domain/repositories/food_repository.dart';

/// [FoodRepository] 인메모리 Mock 구현.
///
/// 실 구현(dio datasource)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// [analyze] 는 입력 텍스트 기반으로 4상태를 결정론적으로 반환한다:
///   - '두부'·'unknown' 이외 + '커피'·'danger' 포함 → danger
///   - '된장'·'caution' 포함 → caution
///   - 'unknown'·'모름' 포함 → unknown
///   - 그 외 → recommend
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

  /// 텍스트 기반 결정론적 판정.
  ///
  /// 키워드 우선순위: danger > caution > unknown > recommend.
  @override
  Future<EatVerdict> analyze(String text) async {
    final lower = text.toLowerCase();
    if (lower.contains('danger') ||
        lower.contains('커피') ||
        lower.contains('위험')) {
      return EatVerdict.danger(foodName: text);
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
