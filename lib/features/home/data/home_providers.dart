import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/home/data/repositories/home_repository_impl.dart';
import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/home/domain/repositories/home_repository.dart';

part 'home_providers.g.dart';

// ---------------------------------------------------------------------------
// HomeRepository 공급자
// ---------------------------------------------------------------------------

/// [HomeRepository] 공급자.
///
/// 기본값: [HomeRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [homeRepositoryProvider.overrideWithValue(MockHomeRepository.seeded())]
@riverpod
HomeRepository homeRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return HomeRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// 미기록 식단 카운트 (홈 "증상 기록하기" 카드 배지)
// ---------------------------------------------------------------------------

/// 미기록 식단 개수를 조회한다. [HomeScreen] _HomeEntryCard 배지가 구독.
@riverpod
Future<int> unrecordedMealCount(Ref ref) =>
    ref.watch(homeRepositoryProvider).unrecordedMealCount();

// ---------------------------------------------------------------------------
// 최근 식사 목록 (홈 "최근 식사" 섹션)
// ---------------------------------------------------------------------------

/// 최근 식사 목록을 조회한다. [HomeScreen] "최근 식사" 섹션이 구독.
@riverpod
Future<List<RecentMeal>> recentMeals(Ref ref) =>
    ref.watch(homeRepositoryProvider).recentFoods();
