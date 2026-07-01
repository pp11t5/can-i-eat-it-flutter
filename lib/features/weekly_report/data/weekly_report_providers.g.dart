// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weeklyReportRepositoryHash() =>
    r'd520cccceb843ba7dad84d5a9d38d1ef77a05bfb';

/// [WeeklyReportRepository] 공급자.
///
/// 기본값: [WeeklyReportRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [weeklyReportRepositoryProvider.overrideWithValue(MockWeeklyReportRepository.seeded())]
///
/// Copied from [weeklyReportRepository].
@ProviderFor(weeklyReportRepository)
final weeklyReportRepositoryProvider =
    AutoDisposeProvider<WeeklyReportRepository>.internal(
  weeklyReportRepository,
  name: r'weeklyReportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklyReportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyReportRepositoryRef
    = AutoDisposeProviderRef<WeeklyReportRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
