// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_fab_guide_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineFabGuideHash() => r'46bd5beee26977be1f1bfad190ad4ad125b0144f';

/// 타임라인 FAB 최초 가이드 "이미 봄" 여부 (계정 단위).
///
/// - `true`: 가이드 숨김 (본 적 있음 / 세션 없음)
/// - `false`: empty 시 가이드 노출
///
/// 닫힘 처리: [dismiss] — **FAB 탭 시에만** 호출한다.
///
/// Copied from [TimelineFabGuide].
@ProviderFor(TimelineFabGuide)
final timelineFabGuideProvider =
    AutoDisposeAsyncNotifierProvider<TimelineFabGuide, bool>.internal(
  TimelineFabGuide.new,
  name: r'timelineFabGuideProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineFabGuideHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimelineFabGuide = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
