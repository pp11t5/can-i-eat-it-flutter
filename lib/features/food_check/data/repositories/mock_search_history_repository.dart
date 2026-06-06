import '../../domain/repositories/search_history_repository.dart';

/// [SearchHistoryRepository] 인메모리 Mock 구현.
///
/// 실 구현(로컬 persistence/서버)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 테스트에서 시나리오별 named factory를 사용해 의도를 명확히 표현할 수 있다.
class MockSearchHistoryRepository implements SearchHistoryRepository {
  /// [initial]: 초기 검색 기록 (최신순). null이면 빈 목록으로 시작한다.
  MockSearchHistoryRepository({List<String>? initial})
      : _history = List<String>.from(initial ?? []);

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 빈 검색 기록. [recentSearches]가 빈 목록을 반환한다.
  factory MockSearchHistoryRepository.empty() =>
      MockSearchHistoryRepository(initial: []);

  /// 초기 검색 기록 있음. [recentSearches]가 [terms]를 최신순으로 반환한다.
  factory MockSearchHistoryRepository.withHistory(List<String> terms) =>
      MockSearchHistoryRepository(initial: List<String>.from(terms));

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  final List<String> _history;

  // ---------------------------------------------------------------------------
  // SearchHistoryRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<List<String>> recentSearches() async {
    return List<String>.unmodifiable(_history);
  }

  @override
  Future<void> add(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;

    // 중복 제거 후 맨 앞에 삽입
    _history.remove(trimmed);
    _history.insert(0, trimmed);

    // 최대 개수 초과 시 오래된 항목 잘라내기
    if (_history.length > kSearchHistoryMaxCount) {
      _history.removeRange(kSearchHistoryMaxCount, _history.length);
    }
  }

  @override
  Future<void> remove(String term) async {
    _history.remove(term);
  }

  @override
  Future<void> clearAll() async {
    _history.clear();
  }
}
