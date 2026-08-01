import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/sources/timeline_guide_store.dart';

part 'timeline_fab_guide_provider.g.dart';

/// 타임라인 FAB 최초 가이드 "이미 봄" 여부 (계정 단위).
///
/// - `true`: 가이드 숨김 (본 적 있음 / 세션 없음)
/// - `false`: empty 시 가이드 노출
///
/// 닫힘 처리: [dismiss] — 가이드 영역·empty 영역·FAB 등 **아무 탭**에서 호출.
@riverpod
class TimelineFabGuide extends _$TimelineFabGuide {
  @override
  Future<bool> build() async {
    final userId = ref.watch(authControllerProvider).valueOrNull?.userId;
    if (userId == null || userId.isEmpty) {
      // 세션 없으면 가이드 미노출 (empty 기본 UI).
      return true;
    }
    return ref.watch(timelineGuideStoreProvider).hasSeenFabGuide(userId);
  }

  /// 일회성 가이드를 닫는다 (아무 탭).
  Future<void> dismiss() async {
    final userId = ref.read(authControllerProvider).valueOrNull?.userId;
    if (userId == null || userId.isEmpty) return;
    await ref.read(timelineGuideStoreProvider).markFabGuideSeen(userId);
    state = const AsyncData(true);
  }
}
