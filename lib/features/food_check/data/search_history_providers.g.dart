// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchHistoryRepositoryHash() =>
    r'aedd3e34bfd28f4c4a58e929d65f44efc53f0eed';

/// [SearchHistoryRepository] 공급자.
///
/// 기본값: [MockSearchHistoryRepository.empty] (빈 검색 기록).
/// 실 구현(로컬 persistence/서버) 교체 지점: ProviderScope override로 실 구현을 주입한다.
///
/// Copied from [searchHistoryRepository].
@ProviderFor(searchHistoryRepository)
final searchHistoryRepositoryProvider =
    AutoDisposeProvider<SearchHistoryRepository>.internal(
  searchHistoryRepository,
  name: r'searchHistoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchHistoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchHistoryRepositoryRef
    = AutoDisposeProviderRef<SearchHistoryRepository>;
String _$searchHistoryControllerHash() =>
    r'4f8a38a678ec54a09b6f04e432299b1bdb88360f';

/// 검색 기록 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [SearchHistoryRepository.recentSearches]를 호출해 초기 목록을 로드한다.
/// [addTerm]: 검색어를 추가하고 상태를 갱신한다.
/// [removeTerm]: 검색어를 제거하고 상태를 갱신한다.
/// [clear]: 모든 검색 기록을 삭제하고 상태를 갱신한다.
///
/// Copied from [SearchHistoryController].
@ProviderFor(SearchHistoryController)
final searchHistoryControllerProvider = AutoDisposeAsyncNotifierProvider<
    SearchHistoryController, List<String>>.internal(
  SearchHistoryController.new,
  name: r'searchHistoryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchHistoryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchHistoryController = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
