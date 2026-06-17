import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/meal_repository_impl.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
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

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
///
/// - 기본 선택일: 오늘(KST).
/// - [changeDate]: 선택일 변경 → 즉시 재조회.
/// - [refresh]: 현재 선택일 강제 재조회.
///
/// ProviderScope override 예시 (테스트):
///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
@riverpod
class TimelineController extends _$TimelineController {
  @override
  Future<List<MealGroup>> build(DateTime date) async {
    final repo = ref.watch(mealRepositoryProvider);
    return repo.timeline(date);
  }

  /// 선택일을 변경하고 해당 날짜의 타임라인을 재조회한다.
  Future<void> changeDate(DateTime newDate) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(mealRepositoryProvider).timeline(newDate),
    );
  }

  /// 현재 선택일의 타임라인을 강제 재조회한다.
  Future<void> refresh(DateTime currentDate) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(mealRepositoryProvider).timeline(currentDate),
    );
  }
}
