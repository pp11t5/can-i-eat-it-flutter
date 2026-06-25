import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/symptom/data/repositories/symptom_repository_impl.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';

part 'symptom_providers.g.dart';

// ---------------------------------------------------------------------------
// SymptomRepository 공급자
// ---------------------------------------------------------------------------

/// [SymptomRepository] 공급자.
///
/// 기본값: [SymptomRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [symptomRepositoryProvider.overrideWithValue(MockSymptomRepository.seeded())]
@riverpod
SymptomRepository symptomRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return SymptomRepositoryImpl(dio: dio);
}
