import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/meal_repository_impl.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

part 'meal_log_providers.g.dart';

// ---------------------------------------------------------------------------
// MealRepository 공급자
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// TimelineController
// ---------------------------------------------------------------------------

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
@riverpod
class TimelineController extends _$TimelineController {
  @override
  Future<List<TimelineItem>> build(DateTime date) async {
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

// ---------------------------------------------------------------------------
// WeeklyController
// ---------------------------------------------------------------------------

/// 주간 도트 컨트롤러.
///
/// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
@riverpod
class WeeklyController extends _$WeeklyController {
  @override
  Future<List<WeeklyDay>> build(DateTime weekStart) async {
    final repo = ref.watch(mealRepositoryProvider);
    return repo.weekly(weekStart);
  }
}

// ---------------------------------------------------------------------------
// MealRecordDetailController
// ---------------------------------------------------------------------------

/// 식사 상세 컨트롤러.
///
/// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
/// 삭제 액션을 제공한다.
@riverpod
class MealRecordDetailController extends _$MealRecordDetailController {
  @override
  Future<MealRecord> build(String mealRecordId) async {
    final repo = ref.watch(mealRepositoryProvider);
    return repo.mealDetail(mealRecordId);
  }

  /// 식사를 삭제한다.
  Future<void> deleteMeal() async {
    await ref.read(mealRepositoryProvider).deleteMeal(mealRecordId);
  }
}

// ---------------------------------------------------------------------------
// MealFoodDetailController
// ---------------------------------------------------------------------------

/// 음식 상세 컨트롤러.
///
/// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
/// 제공한다.
@riverpod
class MealFoodDetailController extends _$MealFoodDetailController {
  @override
  Future<MealFood> build(String mealFoodId) async {
    final repo = ref.watch(mealRepositoryProvider);
    return repo.foodDetail(mealFoodId);
  }

  /// 음식을 삭제한다 (마지막 음식이면 서버가 식사도 함께 삭제).
  Future<void> deleteFood() async {
    await ref.read(mealRepositoryProvider).deleteFood(mealFoodId);
  }
}
