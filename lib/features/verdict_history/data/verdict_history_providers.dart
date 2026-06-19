import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/verdict_history/data/repositories/verdict_history_repository_impl.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/repositories/verdict_history_repository.dart';

part 'verdict_history_providers.g.dart';

/// 판정 이력 저장소 provider.
@Riverpod(keepAlive: true)
VerdictHistoryRepository verdictHistoryRepository(Ref ref) =>
    VerdictHistoryRepositoryImpl();

/// 판정 이력 컨트롤러.
///
/// [build]: 저장된 이력 목록 로드.
/// [add]: 항목 추가 후 상태 갱신.
/// [clear]: 전체 삭제 후 상태 갱신.
@riverpod
class VerdictHistoryController extends _$VerdictHistoryController {
  @override
  Future<List<VerdictHistoryItem>> build() =>
      ref.watch(verdictHistoryRepositoryProvider).getHistory();

  Future<void> add(VerdictHistoryItem item) async {
    await ref.read(verdictHistoryRepositoryProvider).addItem(item);
    ref.invalidateSelf();
  }

  Future<void> clear() async {
    await ref.read(verdictHistoryRepositoryProvider).clearHistory();
    ref.invalidateSelf();
  }

  Future<void> removeAt(int index) async {
    // 낙관적 업데이트: 현재 상태에서 즉시 제거 후 저장소 반영
    final current = state.valueOrNull;
    if (current != null && index >= 0 && index < current.length) {
      state = AsyncData(List.of(current)..removeAt(index));
    }
    await ref.read(verdictHistoryRepositoryProvider).removeAt(index);
  }
}
