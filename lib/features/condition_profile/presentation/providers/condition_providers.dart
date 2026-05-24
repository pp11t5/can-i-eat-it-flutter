import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/condition_repository_impl.dart';
import '../../domain/entities/health_condition.dart';
import '../../domain/repositories/condition_repository.dart';

part 'condition_providers.g.dart';

@riverpod
ConditionRepository conditionRepository(Ref ref) =>
    const ConditionRepositoryImpl();

@riverpod
Future<List<HealthCondition>> availableConditions(Ref ref) =>
    ref.watch(conditionRepositoryProvider).fetchAvailableConditions();

/// 사용자가 선택한 기저질환 집합. 데모는 메모리 보관 — 추후 로컬 저장/서버 동기화.
@riverpod
class SelectedConditions extends _$SelectedConditions {
  @override
  List<HealthCondition> build() => const [];

  void toggle(HealthCondition condition) {
    final exists = state.any((e) => e.id == condition.id);
    state = exists
        ? state.where((e) => e.id != condition.id).toList()
        : [...state, condition];
  }
}
