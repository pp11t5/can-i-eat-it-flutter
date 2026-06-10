import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';

/// 판정 오케스트레이션 화면 (티켓 6 — 검색→판정 내비게이션 통합).
///
/// [foodName] 을 받아 [VerdictController.analyze] 를 호출하고,
/// 상태에 따라 하위 화면을 스위칭한다:
/// - [AsyncLoading]       → [VerdictLoadingScreen]
/// - [AsyncError]         → 에러 메시지 + 재시도
/// - [VerdictLevel.unknown] → [VerdictUnknownScreen]
/// - 그 외               → [VerdictResultScreen]
///
/// 진입 경로: `/verdict` (present fullscreenDialog).
/// extra: 분석할 음식명 String.
class VerdictScreen extends ConsumerStatefulWidget {
  const VerdictScreen({super.key, required this.foodName});

  final String foodName;

  @override
  ConsumerState<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends ConsumerState<VerdictScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 즉시 분석 시작.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(verdictControllerProvider.notifier).analyze(widget.foodName);
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

  @override
  Widget build(BuildContext context) {
    final verdictAsync = ref.watch(verdictControllerProvider);

    return verdictAsync.when(
      loading: () => const VerdictLoadingScreen(),
      error: (error, _) => _ErrorScreen(
        message: error.toString(),
        onRetry: _handleRetry,
      ),
      data: (verdict) {
        if (verdict.level == VerdictLevel.unknown &&
            verdict.foodName.isEmpty) {
          // 초기 idle 상태 — 로딩으로 표시.
          return const VerdictLoadingScreen();
        }
        if (verdict.level == VerdictLevel.unknown) {
          return VerdictUnknownScreen(onRetry: _handleRetry);
        }
        return VerdictResultScreen(
          verdict: verdict,
          onRetry: _handleRetry,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 에러 화면
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
                '분석 중 오류가 발생했어요.',
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
