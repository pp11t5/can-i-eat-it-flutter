// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$symptomRepositoryHash() => r'dab7764b040a7f80f2805c4eeabdeb5ae1df3baa';

/// [SymptomRepository] 공급자.
///
/// 기본값: [SymptomRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [symptomRepositoryProvider.overrideWithValue(MockSymptomRepository.seeded())]
///
/// Copied from [symptomRepository].
@ProviderFor(symptomRepository)
final symptomRepositoryProvider =
    AutoDisposeProvider<SymptomRepository>.internal(
  symptomRepository,
  name: r'symptomRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$symptomRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SymptomRepositoryRef = AutoDisposeProviderRef<SymptomRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
