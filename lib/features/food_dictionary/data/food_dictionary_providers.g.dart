// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_dictionary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dictionaryRepositoryHash() =>
    r'e01c517aee523b3f3c740b5409ce9f570e9d2e8a';

/// [DictionaryRepository] 공급자.
///
/// 기본값: [DictionaryRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [dictionaryRepositoryProvider.overrideWithValue(MockDictionaryRepository.seeded())]
///
/// Copied from [dictionaryRepository].
@ProviderFor(dictionaryRepository)
final dictionaryRepositoryProvider =
    AutoDisposeProvider<DictionaryRepository>.internal(
  dictionaryRepository,
  name: r'dictionaryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dictionaryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DictionaryRepositoryRef = AutoDisposeProviderRef<DictionaryRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
