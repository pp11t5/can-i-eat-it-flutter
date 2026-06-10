import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';

part 'food_check_providers.g.dart';

/// [FoodRepository] 공급자.
///
/// 기본값: [MockFoodRepository.empty] (서버 API 미확정, W3 Mock 단계).
/// 실 구현 교체 지점: 티켓 6에서 retrofit 구현 완성 시
///   ProviderScope overrides로 실제 datasource 구현을 주입한다.
///   이 인터페이스(FoodRepository)는 불변 — 교체 시 이 줄만 변경한다.
@riverpod
FoodRepository foodRepository(Ref ref) => MockFoodRepository.empty();

/// 판정 컨트롤러.
///
/// [analyze] 호출 → [FoodRepository.analyze] → [AsyncValue<EatVerdict>].
/// - 로딩 중: [AsyncLoading] → VerdictLoadingScreen.
/// - [VerdictLevel.unknown]: VerdictUnknownScreen.
/// - 그 외: VerdictResultScreen.
///
/// 성공 시 [FunnelEvent.firstVerdictChecked] 발화.
@riverpod
class VerdictController extends _$VerdictController {
  @override
  AsyncValue<EatVerdict> build() => const AsyncValue.data(
        // 초기 상태: 판정 전(idle). 빈 unknown은 화면 진입 전 상태라 직접 표시되지 않는다.
        EatVerdict(level: VerdictLevel.unknown, foodName: ''),
      );

  /// [text] 를 분석해 판정 결과를 [state] 에 반영한다.
  ///
  /// 로딩 → 성공/에러 순서로 state가 갱신된다.
  Future<void> analyze(String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(foodRepositoryProvider);
      final verdict = await repo.analyze(text);

      // 성공 시 퍼널 이벤트 발화 (unknown 포함 — 응답 자체가 성공)
      final analytics = ref.read(analyticsServiceProvider);
      await analytics.logFunnel(
        FunnelEvent.firstVerdictChecked,
        params: {'food_name': text, 'level': verdict.level.name},
      );

      return verdict;
    });
  }

  /// 상태를 초기(idle)로 리셋한다. "다시 검색" 탭 시 사용.
  void reset() {
    state = const AsyncValue.data(
      EatVerdict(level: VerdictLevel.unknown, foodName: ''),
    );
  }
}
