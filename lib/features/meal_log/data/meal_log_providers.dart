import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/meal_repository_impl.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

part 'meal_log_providers.g.dart';

/// [MealRepository] 공급자.
///
/// 기본값: [MealRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())]
@riverpod
MealRepository mealRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MealRepositoryImpl(dio: dio);
}
