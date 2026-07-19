import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';

/// 판정 오케스트레이션 화면.
///
/// [args] 에 따라 진입 경로를 선택한다:
/// - [VerdictArgs.isById] → [VerdictController.judgeById] (검색 결과 셀 탭)
/// - 아니면 → [VerdictController.judgeByText] (raw text 직접 분석)
///
/// 상태에 따라 하위 화면을 스위칭한다:
/// - [AsyncLoading]              → [VerdictLoadingScreen]
/// - [AsyncError]                → 에러 메시지 + 재시도 (분석실패)
/// - [VerdictLevel.unknown] (성공) → [VerdictUnknownScreen]
/// - 그 외 (recommend/caution/risk) → [VerdictResultScreen]
///
/// ⚠️ grade=UNKNOWN은 AsyncData(성공) — AsyncError(분석실패)와 구별(D1, R3).
///
/// 진입 경로: `/verdict` (present fullscreenDialog).
/// extra: [VerdictArgs].
class VerdictScreen extends ConsumerStatefulWidget {
  const VerdictScreen({super.key, required this.args});

  final VerdictArgs args;

  @override
  ConsumerState<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends ConsumerState<VerdictScreen> {
  /// 도감(최근검색) 자동추가 one-shot 가드. by-id 진입 + 분류된 판정에서
  /// 한 번만 [FoodRepository.addRecent] 를 호출하도록 막는다.
  bool _savedToDictionary = false;

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 즉시 분석 시작.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(verdictControllerProvider.notifier);
      if (widget.args.isById) {
        controller.judgeById(
          widget.args.externalId!,
          displayName: widget.args.text,
        );
      } else {
        controller.judgeByText(widget.args.text);
      }
    });
  }

  void _handleRetry() {
    // 판정 화면 닫고 FoodCheckScreen으로 복귀.
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/check');
    }
  }

  /// 도감 자동추가 one-shot 훅.
  ///
  /// by-id 진입 + 판정 성공 + 분류된 결과(unknown 제외)일 때만
  /// [FoodRepository.addRecent] 를 fire-and-forget 호출하고 토스트를 띄운다.
  /// by-text 진입·unknown 판정·판정 실패(AsyncError)에는 아무 것도 하지 않는다.
  void _maybeAutoAddToDictionary(
    AsyncValue<EatVerdict>? previous,
    AsyncValue<EatVerdict> next,
  ) {
    if (_savedToDictionary || !widget.args.isById) return;

    final verdict = next.valueOrNull;
    if (verdict == null ||
        verdict.level == VerdictLevel.unknown ||
        verdict.foodName.isEmpty) {
      return;
    }

    _savedToDictionary = true;
    unawaited(
      ref
          .read(foodRepositoryProvider)
          .addRecent(widget.args.externalId!)
          .catchError((_) {}),
    );
    if (mounted) {
      showAppToast(context, '내 도감에 담았어요');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<EatVerdict>>(
      verdictControllerProvider,
      _maybeAutoAddToDictionary,
    );
    final verdictAsync = ref.watch(verdictControllerProvider);

    return verdictAsync.when(
      loading: () => const VerdictLoadingScreen(),
      error: (error, _) => _ErrorScreen(
        message: error is Failure
            ? error.message
            : '분석 중 오류가 발생했어요.',
        onRetry: _handleRetry,
      ),
      data: (verdict) {
        if (verdict.level == VerdictLevel.unknown &&
            verdict.foodName.isEmpty) {
          // 초기 idle 상태 — 로딩으로 표시.
          return const VerdictLoadingScreen();
        }
        if (verdict.level == VerdictLevel.unknown) {
          // grade=UNKNOWN은 성공 응답 → VerdictUnknownScreen (D1).
          return VerdictUnknownScreen(onRetry: _handleRetry);
        }
        // addToDietHandler가 주입돼 있으면 항상 배선.
        // recordContext가 없으면 now(KST)를 컨텍스트로 사용 (홈→검색→판정 경로).
        final handler = ref.read(addToDietHandlerProvider);
        VoidCallback? onAddToDiet;
        if (handler != null) {
          final ctx = widget.args.recordContext ??
              MealRecordContext(eatenAt: nowKst());
          // 식사 기록 저장(API mutation) — 전역 로딩 오버레이로 중복 탭 방지.
          onAddToDiet = () => ref
              .read(globalLoadingControllerProvider.notifier)
              .run(() => handler(context, verdict, ctx));
        }
        return VerdictResultScreen(
          verdict: verdict,
          onRetry: _handleRetry,
          onAddToDiet: onAddToDiet,
        );
      },
    );
  }

}

// ---------------------------------------------------------------------------
// 에러 화면 (분석실패 — FOOD400_1/FOOD404_1/통신오류)
// ---------------------------------------------------------------------------

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
