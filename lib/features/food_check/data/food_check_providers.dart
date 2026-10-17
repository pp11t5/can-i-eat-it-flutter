import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/funnel_once_store.dart';
import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_repository_impl.dart';

part 'food_check_providers.g.dart';

/// [FoodRepository] 공급자.
///
/// 기본값: [FoodRepositoryImpl] — 실 서버 연동 (ADR-0007 §3-1 (5), W3-3).
/// - search / recent 조회·삭제: 실 `/foods/*` 엔드포인트.
/// - judgeByText / judgeById: 실 `/foods/judgment` 엔드포인트 (W3-3 충실 정합).
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
/// 진입 경로에 따라 2메서드를 선택한다:
/// - [judgeByText]: 자유 텍스트 진입 (검색 결과 없음 → raw text 직접 분석).
/// - [judgeById]: 등록 음식 진입 (검색 결과 셀 탭, externalId 보유).
///
/// 상태 분기:
/// - 로딩 중: [AsyncLoading] → VerdictLoadingScreen.
/// - grade=UNKNOWN (성공): [AsyncData(EatVerdict(level:unknown))] → VerdictUnknownScreen.
/// - recommend/caution/risk: [AsyncData(EatVerdict)] → VerdictResultScreen.
/// - FOOD400_1/FOOD404_1/통신오류: [AsyncError(Failure)] → 분석실패 에러화면.
///
/// ⚠️ grade=UNKNOWN 은 성공(AsyncData) — 분석실패(AsyncError)와 절대 혼동 금지(D1, R3).
@Riverpod(dependencies: [])
class VerdictController extends _$VerdictController {
  @override
  AsyncValue<EatVerdict> build() => const AsyncValue.data(
        // 초기 상태: 판정 전(idle). 빈 unknown은 화면 진입 전 상태라 직접 표시되지 않는다.
        EatVerdict(
          level: VerdictLevel.unknown,
          foodName: '',
          personalTitle: '',
        ),
      );

  /// 자유 텍스트로 판정한다 (by-text, 검색 결과 없음 경로).
  ///
  /// GET /foods/judgment?name=<text>
  Future<void> judgeByText(String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(foodRepositoryProvider);
      final verdict = await repo.judgeByText(text);

      await _logVerdict(verdict, text);

      return verdict;
    });
  }

  /// 등록 음식 externalId 로 판정한다 (by-id, 검색 결과 셀 탭 경로).
  ///
  /// GET /foods/{foodExternalId}/judgment
  /// [displayName]: 로딩 중 표시용 음식명 (substitutes 등 서버 응답 전 임시값).
  Future<void> judgeById(String foodExternalId, {String? displayName}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(foodRepositoryProvider);
      final verdict = await repo.judgeById(foodExternalId);

      await _logVerdict(verdict, displayName ?? foodExternalId);

      return verdict;
    });
  }

  /// 성공 판정마다 [FunnelEvent.firstVerdictChecked]를 보낸다.
  /// 이 계정의 첫 성공만 [FunnelEvent.accountFirstVerdictChecked]를 추가로 보낸다.
  /// unknown 등급도 성공 응답이면 대상이다.
  Future<void> _logVerdict(EatVerdict verdict, String foodLabel) async {
    final params = {
      'food_name': foodLabel,
      'level': verdict.level.name,
    };
    final analytics = ref.read(analyticsServiceProvider);
    await analytics.logFunnel(
      FunnelEvent.firstVerdictChecked,
      params: params,
    );
    if (!await claimFunnelOnce(ref, FunnelEvent.accountFirstVerdictChecked)) {
      return;
    }
    await analytics.logFunnel(
      FunnelEvent.accountFirstVerdictChecked,
      params: params,
    );
  }

  /// 상태를 초기(idle)로 리셋한다. "다시 검색" 탭 시 사용.
  void reset() {
    state = const AsyncValue.data(
      EatVerdict(
        level: VerdictLevel.unknown,
        foodName: '',
        personalTitle: '',
      ),
    );
  }
}
