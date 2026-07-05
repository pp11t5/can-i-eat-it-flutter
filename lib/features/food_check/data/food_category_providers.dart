import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_category_repository_impl.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_category_repository.dart';

part 'food_category_providers.g.dart';

// ---------------------------------------------------------------------------
// FoodCategoryRepository 공급자
// ---------------------------------------------------------------------------

/// [FoodCategoryRepository] 공급자.
///
/// 기본값: [FoodCategoryRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodCategoryRepositoryProvider.overrideWithValue(MockFoodCategoryRepository.seeded())]
@riverpod
FoodCategoryRepository foodCategoryRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return FoodCategoryRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// 음식 카테고리 목록 조회 (W7 minor EP, UI 배선 defer)
// ---------------------------------------------------------------------------

/// 음식 카테고리 전체 목록을 조회한다.
///
/// `category_icon.dart` 하드코딩 매핑 대체 예정 — 현재 구독처 없음.
@riverpod
Future<List<FoodCategory>> foodCategories(Ref ref) =>
    ref.watch(foodCategoryRepositoryProvider).getCategories();
