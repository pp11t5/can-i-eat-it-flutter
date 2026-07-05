// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_page_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myPageRepositoryHash() => r'd67a888550d963ced2b13c8eaa5ba8e2a2a1f714';

/// [MyPageRepository] 공급자.
///
/// 기본값: [MyPageRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [myPageRepositoryProvider.overrideWithValue(MockMyPageRepository.seeded())]
///
/// Copied from [myPageRepository].
@ProviderFor(myPageRepository)
final myPageRepositoryProvider = AutoDisposeProvider<MyPageRepository>.internal(
  myPageRepository,
  name: r'myPageRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myPageRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyPageRepositoryRef = AutoDisposeProviderRef<MyPageRepository>;
String _$mySummaryHash() => r'26f974c01bbe309f58cc3bbdbbed42b7d8a41e6d';

/// 마이페이지 요약을 조회한다. 홈 화면(인사말 streak·미기록 배지)과
/// 마이페이지(음식 히스토리·주간 기록 카드)가 공유 구독.
///
/// Copied from [mySummary].
@ProviderFor(mySummary)
final mySummaryProvider = AutoDisposeFutureProvider<MyPageSummary>.internal(
  mySummary,
  name: r'mySummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mySummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MySummaryRef = AutoDisposeFutureProviderRef<MyPageSummary>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
