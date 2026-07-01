import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/repositories/dictionary_repository.dart';

part 'food_dictionary_providers.g.dart';

// ---------------------------------------------------------------------------
// DictionaryRepository 공급자
// ---------------------------------------------------------------------------

/// [DictionaryRepository] 공급자.
///
/// 기본값: [DictionaryRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [dictionaryRepositoryProvider.overrideWithValue(MockDictionaryRepository.seeded())]
@riverpod
DictionaryRepository dictionaryRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return DictionaryRepositoryImpl(dio: dio);
}
