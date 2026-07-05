import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_symptom_repository_impl.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_symptom_repository.dart';

part 'food_symptom_providers.g.dart';

// ---------------------------------------------------------------------------
// FoodSymptomRepository 공급자
// ---------------------------------------------------------------------------

/// [FoodSymptomRepository] 공급자.
///
/// 기본값: [FoodSymptomRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodSymptomRepositoryProvider.overrideWithValue(MockFoodSymptomRepository.seeded())]
@riverpod
FoodSymptomRepository foodSymptomRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return FoodSymptomRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// 음식별 증상 이력 조회 (W7 minor EP, UI 배선 defer)
// ---------------------------------------------------------------------------

/// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
///
/// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
@riverpod
Future<List<FoodSymptom>> foodSymptoms(Ref ref, String foodExternalId) =>
    ref.watch(foodSymptomRepositoryProvider).getSymptoms(foodExternalId);
