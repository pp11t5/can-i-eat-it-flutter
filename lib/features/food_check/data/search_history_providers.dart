import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/repositories/search_history_repository.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_search_history_repository.dart';

part 'search_history_providers.g.dart';

/// [SearchHistoryRepository] 공급자.
///
/// 기본값: 삭제 버튼 동작 확인용 더미 최근 검색어.
/// 실 구현(로컬 persistence/서버) 교체 지점: ProviderScope override로 실 구현을 주입한다.
/// TODO(temp): 서버 데이터 연동 시 [MockSearchHistoryRepository.empty]로 복귀.
@riverpod
SearchHistoryRepository searchHistoryRepository(Ref ref) =>
    MockSearchHistoryRepository.withHistory(const [
      '된장찌개',
      '오렌지주스',
      '초콜릿',
      '매운 떡볶이',
    ]);

/// 검색 기록 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [SearchHistoryRepository.recentSearches]를 호출해 초기 목록을 로드한다.
/// [addTerm]: 검색어를 추가하고 상태를 갱신한다.
/// [removeTerm]: 검색어를 제거하고 상태를 갱신한다.
/// [clear]: 모든 검색 기록을 삭제하고 상태를 갱신한다.
@riverpod
class SearchHistoryController extends _$SearchHistoryController {
  @override
  Future<List<String>> build() async {
    return ref.watch(searchHistoryRepositoryProvider).recentSearches();
  }

  /// 검색어를 추가하고 상태를 최신 목록으로 갱신한다.
  Future<void> addTerm(String term) async {
    final repo = ref.read(searchHistoryRepositoryProvider);
    await repo.add(term);
    state = AsyncData(await repo.recentSearches());
  }

  /// 검색어를 제거하고 상태를 최신 목록으로 갱신한다.
  Future<void> removeTerm(String term) async {
    final repo = ref.read(searchHistoryRepositoryProvider);
    await repo.remove(term);
    state = AsyncData(await repo.recentSearches());
  }

  /// 모든 검색 기록을 삭제하고 상태를 갱신한다.
  Future<void> clear() async {
    final repo = ref.read(searchHistoryRepositoryProvider);
    await repo.clearAll();
    state = AsyncData(await repo.recentSearches());
  }
}
