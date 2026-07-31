import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 온보딩 공통 셸 — 탑바·구분선·[StepProgress]를 페이지 전환과 무관하게 고정한다.
///
/// [ShellRoute] builder에서 [child]로 스텝 본문만 받는다. 본문 전환 시에도
/// 뒤로가기·프로그레스 위치는 유지되고, [StepProgress] 세그먼트만 200ms로 갱신된다.
class OnboardingShell extends ConsumerWidget {
  const OnboardingShell({super.key, required this.child});

  final Widget child;

  static const int totalSteps = 4;

  /// 경로 → 1-based 스텝.
  static int stepFromLocation(String location) {
    if (location.contains('/medications')) return 4;
    if (location.contains('/triggers')) return 3;
    if (location.contains('/frequency')) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final currentStep = stepFromLocation(location);
    final isFirstStep = currentStep == 1;

    // 1페이지 뒤로가기 = 온보딩 이탈 → 로그인. pop 직후 signOut 지연은
    // 가드가 pop 을 가로채지 못하게 하기 위함(기존 condition 화면과 동일).
    void exitToLogin() {
      if (context.canPop()) {
        context.pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(authControllerProvider.notifier).signOut();
        });
      } else {
        ref.read(authControllerProvider.notifier).signOut();
      }
    }

    void onBack() {
      if (isFirstStep) {
        exitToLogin();
        return;
      }
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/onboarding/condition');
      }
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        // 하드웨어/스와이프 백으로 1스텝에서 이탈할 때만 signOut.
        if (didPop && isFirstStep) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(authControllerProvider.notifier).signOut();
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 탑바 (Figma — 64px-high TopBar, chevron 세로 중앙) ─────────
              SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBack,
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: SvgPicture.asset(
                          'assets/figma_extracted/chevron_left.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ── TopBar 하단 구분선 (Figma gray/30 #F5F5F5) ─────────────────
              Container(height: 1, color: const Color(0xFFF5F5F5)),
              // ── StepProgress (0px gap after TopBar per Figma) ───────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: StepProgress(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                ),
              ),
              // 본문만 전환 (크롬 고정)
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
