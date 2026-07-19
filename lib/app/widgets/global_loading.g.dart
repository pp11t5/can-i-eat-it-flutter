// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_loading.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalLoadingControllerHash() =>
    r'01be84733c4d90a575221540818512e8c96477f5';

/// 전역 차단형 로딩 카운터.
///
/// 값 > 0 이면 [GlobalLoadingOverlay]가 전체 화면 배리어 + 스피너를 띄운다.
/// 카운터 방식이므로 중첩/동시 API 호출에도 안전하다 — 모든 호출이 끝나야
/// (카운터가 0으로 돌아와야) 오버레이가 사라진다.
///
/// Copied from [GlobalLoadingController].
@ProviderFor(GlobalLoadingController)
final globalLoadingControllerProvider =
    AutoDisposeNotifierProvider<GlobalLoadingController, int>.internal(
  GlobalLoadingController.new,
  name: r'globalLoadingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalLoadingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalLoadingController = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
