/// 최대 보관 검색어 개수.
const int kSearchHistoryMaxCount = 10;

/// 검색 기록 저장소 인터페이스.
///
/// 실 구현(로컬 persistence/서버)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// W2에서는 [MockSearchHistoryRepository]가 주입된다.
abstract interface class SearchHistoryRepository {
  /// 최신순(most-recent-first)으로 검색 기록을 반환한다.
  Future<List<String>> recentSearches();

  /// 검색어를 추가한다.
  ///
  /// - 공백 제거 후 빈 문자열이면 무시한다.
  /// - 동일 검색어가 이미 존재하면 제거 후 맨 앞에 삽입한다 (중복 제거).
  /// - 최대 [kSearchHistoryMaxCount]개를 초과하면 오래된 항목을 잘라낸다.
  Future<void> add(String term);

  /// 검색어를 제거한다. 존재하지 않으면 무시한다.
  Future<void> remove(String term);

  /// 모든 검색 기록을 삭제한다.
  Future<void> clearAll();
}
