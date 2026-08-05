import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
/// 로딩 화면은 캐릭터 GIF가 한 바퀴 이상 보이도록
/// [minLoadingDuration] 동안 최소 유지한다(API가 더 빨라도 대기).
///
/// ⚠️ grade=UNKNOWN은 AsyncData(성공) — AsyncError(분석실패)와 구별(D1, R3).
///
/// 진입 경로: `/verdict` (present fullscreenDialog).
/// extra: [VerdictArgs].
class VerdictScreen extends ConsumerStatefulWidget {
  const VerdictScreen({super.key, required this.args});

  final VerdictArgs args;

  /// 로딩 화면 최소 표시 시간 (캐릭터 GIF 노출 보장).
  ///
  /// 테스트에서 [Duration.zero] 로 줄여 즉시 결과 화면을 볼 수 있다.
  @visibleForTesting
  static Duration minLoadingDuration = const Duration(seconds: 5);

  @override
  ConsumerState<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends ConsumerState<VerdictScreen> {
  /// 최소 로딩 시간이 지났는지. false면 API 완료/에러여도 로딩 유지.
  bool _minDurationElapsed = false;
  Timer? _minDurationTimer;

  @override
  void initState() {
    super.initState();
    _minDurationTimer = Timer(VerdictScreen.minLoadingDuration, () {
      if (!mounted) return;
      setState(() => _minDurationElapsed = true);
    });
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

  @override
  void dispose() {
    _minDurationTimer?.cancel();
    super.dispose();
  }

  void _handleRetry() {
    // 판정 화면 닫고 FoodCheckScreen으로 복귀.
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/check');
    }
  }

  void _handleSubstituteTap(VerdictSubstitute substitute) {
    context.push(
      '/verdict',
      extra: VerdictArgs(
        externalId: substitute.foodExternalId,
        text: substitute.name,
        recordContext: widget.args.recordContext,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verdictAsync = ref.watch(verdictControllerProvider);

    return verdictAsync.when(
      loading: () => const VerdictLoadingScreen(),
      error: (error, _) {
        // API가 빨라도 GIF 최소 노출 시간까지 로딩 유지.
        if (!_minDurationElapsed) return const VerdictLoadingScreen();
        return _ErrorScreen(
          message: error is Failure ? error.message : '분석 중 오류가 발생했어요.',
          onRetry: _handleRetry,
        );
      },
      data: (verdict) {
        if (verdict.level == VerdictLevel.unknown && verdict.foodName.isEmpty) {
          // 초기 idle 상태 — 로딩으로 표시.
          return const VerdictLoadingScreen();
        }
        if (!_minDurationElapsed) {
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
          final ctx =
              widget.args.recordContext ?? MealRecordContext(eatenAt: nowKst());
          // 식사 기록 저장(API mutation) — 전역 로딩 오버레이로 중복 탭 방지.
          onAddToDiet = () => ref
              .read(globalLoadingControllerProvider.notifier)
              .run(() => handler(context, verdict, ctx));
        }
        return VerdictResultScreen(
          verdict: verdict,
          onRetry: _handleRetry,
          onAddToDiet: onAddToDiet,
          onSubstituteTap: _handleSubstituteTap,
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
