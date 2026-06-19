// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verdict_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$verdictHistoryRepositoryHash() =>
    r'69638a994d8efd90dea1926768bf33a0cfd0bdf6';

/// 판정 이력 저장소 provider.
///
/// Copied from [verdictHistoryRepository].
@ProviderFor(verdictHistoryRepository)
final verdictHistoryRepositoryProvider =
    Provider<VerdictHistoryRepository>.internal(
  verdictHistoryRepository,
  name: r'verdictHistoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verdictHistoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerdictHistoryRepositoryRef = ProviderRef<VerdictHistoryRepository>;
String _$verdictHistoryControllerHash() =>
    r'667fe20f8280841308489d9b2b1471b63ebc795c';

/// 판정 이력 컨트롤러.
///
/// [build]: 저장된 이력 목록 로드.
/// [add]: 항목 추가 후 상태 갱신.
/// [clear]: 전체 삭제 후 상태 갱신.
///
/// Copied from [VerdictHistoryController].
@ProviderFor(VerdictHistoryController)
final verdictHistoryControllerProvider = AutoDisposeAsyncNotifierProvider<
    VerdictHistoryController, List<VerdictHistoryItem>>.internal(
  VerdictHistoryController.new,
  name: r'verdictHistoryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verdictHistoryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VerdictHistoryController
    = AutoDisposeAsyncNotifier<List<VerdictHistoryItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
