import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_repository_impl.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';

part 'food_check_providers.g.dart';

/// [FoodRepository] 공급자.
///
/// 기본값: [FoodRepositoryImpl] — 실 서버 연동 (ADR-0007 §3-1 (5), 티켓 6).
/// - search / recent CRUD: 실 `/foods/*` 엔드포인트.
/// - analyze: [MockFoodRepository] 위임 (서버 미출시, W3 Mock 유지).
///   // TODO(server): analyze 서버 출시 시 FoodRepositoryImpl 내부에서 교체.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty())]
@riverpod
FoodRepository foodRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return FoodRepositoryImpl(dio: dio);
}

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
