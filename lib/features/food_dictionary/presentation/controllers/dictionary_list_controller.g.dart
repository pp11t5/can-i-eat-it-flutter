// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dictionaryCountHash() => r'9671db56a4caa372710cd2991e630edd5ff28231';

/// 도감 탭 카운트 조회. 대응 API: GET /dictionary/count.
///
/// Copied from [dictionaryCount].
@ProviderFor(dictionaryCount)
final dictionaryCountProvider =
    AutoDisposeFutureProvider<DictionaryCount>.internal(
  dictionaryCount,
  name: r'dictionaryCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dictionaryCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DictionaryCountRef = AutoDisposeFutureProviderRef<DictionaryCount>;
String _$safeDictionaryControllerHash() =>
    r'bd8c8b4a98c099844d9095f43b4a63f0ca8ed5a9';

/// 권장(safe) 음식 도감 목록 컨트롤러.
///
/// build()에서 첫 페이지를 로드하고, [loadMore]로 다음 페이지를 누적한다.
/// 대응 API: GET /dictionary/safe?cursor&size.
///
/// Copied from [SafeDictionaryController].
@ProviderFor(SafeDictionaryController)
final safeDictionaryControllerProvider = AutoDisposeAsyncNotifierProvider<
    SafeDictionaryController, DictionaryListState>.internal(
  SafeDictionaryController.new,
  name: r'safeDictionaryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$safeDictionaryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SafeDictionaryController
    = AutoDisposeAsyncNotifier<DictionaryListState>;
String _$cautionRiskDictionaryControllerHash() =>
    r'5e49fa0ffcc7da1c7594ae13e35b7f8a8e1ef62b';

/// 주의·위험(caution-risk) 음식 도감 목록 컨트롤러.
///
/// build()에서 첫 페이지를 로드하고, [loadMore]로 다음 페이지를 누적한다.
/// 대응 API: GET /dictionary/caution-risk?cursor&size.
///
/// Copied from [CautionRiskDictionaryController].
@ProviderFor(CautionRiskDictionaryController)
final cautionRiskDictionaryControllerProvider =
    AutoDisposeAsyncNotifierProvider<CautionRiskDictionaryController,
        DictionaryListState>.internal(
  CautionRiskDictionaryController.new,
  name: r'cautionRiskDictionaryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cautionRiskDictionaryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CautionRiskDictionaryController
    = AutoDisposeAsyncNotifier<DictionaryListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
