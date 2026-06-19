import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';

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
  bool _historyAdded = false;

  /// [VerdictLevel] → 이력 저장용 verdict 문자열.
  ///
  /// unknown은 이 메서드에 도달하기 전에 early-return되므로 매핑 불필요.
  String _verdictString(VerdictLevel level) => switch (level) {
        VerdictLevel.recommend => 'safe',
        VerdictLevel.caution => 'caution',
        VerdictLevel.risk => 'avoid',
        VerdictLevel.unknown => 'unknown', // 실제론 저장 전 필터됨
      };

  Future<void> _maybeAddHistory(EatVerdict verdict) async {
    // unknown 판정은 판정 불가 상태이므로 이력에 저장하지 않는다.
    if (verdict.level == VerdictLevel.unknown) return;

    // foodName이 비어있으면 idle 상태이므로 저장 불필요.
    if (_historyAdded || verdict.foodName.isEmpty) return;

    // _historyAdded 플래그는 이 State 인스턴스 수명 내 1회만 저장한다.
    // GoRouter가 화면을 pop 후 다시 push하면 새 인스턴스가 생성되어 플래그가
    // 리셋되지만, 이는 새 판정 결과이므로 저장하는 것이 올바른 동작이다.
    _historyAdded = true;

    try {
      await ref.read(verdictHistoryControllerProvider.notifier).add(
            VerdictHistoryItem(
              foodName: verdict.foodName,
              verdict: _verdictString(verdict.level),
              checkedAt: DateTime.now(),
            ),
          );
    } catch (e) {
      // 이력 저장 실패는 판정 화면 UX에 영향을 주지 않는다.
      debugPrint('[VerdictScreen] 이력 저장 실패 (무시): $e');
    }
  }

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

  /// API 재시도 — provider를 invalidate 후 판정을 다시 요청한다.
  void _handleApiRetry() {
    ref.invalidate(verdictControllerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final verdictAsync = ref.watch(verdictControllerProvider);

    return verdictAsync.when(
      loading: () => const VerdictLoadingScreen(),
      error: (error, _) => _ErrorScreen(
        message: error is Failure
            ? error.message
            : '분석 중 오류가 발생했어요.',
        onRetry: _handleRetry,
        onApiRetry: _handleApiRetry,
      ),
      data: (verdict) {
        if (verdict.level == VerdictLevel.unknown &&
            verdict.foodName.isEmpty) {
          // 초기 idle 상태 — 로딩으로 표시.
          return const VerdictLoadingScreen();
        }
        // 판정 완료 시 이력 저장 (1회).
        unawaited(_maybeAddHistory(verdict));
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
          onAddToDiet = () => handler(context, verdict, ctx);
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
  const _ErrorScreen({
    required this.message,
    required this.onRetry,
    required this.onApiRetry,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onApiRetry;

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
              FilledButton(
                onPressed: onApiRetry,
                child: const Text('다시 시도'),
              ),
              const SizedBox(height: 8),
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
