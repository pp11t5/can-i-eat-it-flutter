import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../condition_profile/presentation/providers/condition_providers.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/eat_verdict.dart';
import '../../domain/repositories/food_repository.dart';

part 'food_check_providers.g.dart';

@riverpod
FoodRepository foodRepository(Ref ref) => const FoodRepositoryImpl();

/// 음식 판별 액션과 결과 상태를 보유하는 컨트롤러.
/// build()는 초기(미조회) 상태인 null 을 반환한다.
@riverpod
class FoodCheckController extends _$FoodCheckController {
  @override
  FutureOr<EatVerdict?> build() => null;

  Future<void> check(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    state = const AsyncLoading();
    final conditions = ref.read(selectedConditionsProvider);
    state = await AsyncValue.guard(
      () => ref.read(foodRepositoryProvider).checkFood(
            foodQuery: trimmed,
            conditions: conditions,
          ),
    );
  }
}
