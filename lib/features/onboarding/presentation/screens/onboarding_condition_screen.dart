import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/option_card.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 Step 1/4: 질환 선택 화면 (Figma 365:1555).
class OnboardingConditionScreen extends ConsumerWidget {
  const OnboardingConditionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    // 1페이지 뒤로가기 = 온보딩 이탈 → 로그인 화면. 온보딩은 다음 로그인 시 재개되는
    // 단계라 약관이 아닌 로그인으로 복귀한다.
    // 스택 아래 /login 으로 실제 pop(역방향 애니메이션)한 뒤, signOut 은 pop 직후
    // post-frame 으로 지연해 가드가 pop 을 가로채지 못하게 한다(약관 화면과 동일 패턴).
    // pop 순간엔 아직 needsOnboarding 이므로 가드가 /login 을 허용해야 한다(auth_guard 참조).
    void exitToLogin() {
      if (context.canPop()) {
        context.pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(authControllerProvider.notifier).signOut();
        });
      } else {
        // 스택 루트(복귀 사용자, guard-replace 진입)면 signOut → 가드가 /login 으로.
        ref.read(authControllerProvider.notifier).signOut();
      }
    }

    return PopScope(
      canPop: true,
      // 스와이프/하드웨어 백으로 pop 될 때도 동일하게 signOut 지연 처리.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(authControllerProvider.notifier).signOut();
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 탑바 (Figma 365:1555 — 64px-high TopBar, chevron 세로 중앙) ───
              SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: exitToLogin,
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
              // ── TopBar 하단 구분선 (Figma gray/30 #F5F5F5) ────────────────────
              Container(height: 1, color: const Color(0xFFF5F5F5)),
              // ── StepProgress (0px gap after TopBar per Figma) ────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepProgress(currentStep: 1, totalSteps: 4),
                    const SizedBox(height: AppSpacing.sectionGap),
                    Text(
                      '어떤 건강 고민이 있으세요?',
                      style: AppTextStyles.header1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '현재는 역류성 식도염만 지원해요\n향후 다른 질환도 추가될 예정이에요',
                      style: AppTextStyles.body1Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.contentGap),
                  ],
                ),
              ),
              // ── 질환 목록 ─────────────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  itemCount: conditionOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final entry = conditionOptions[index];
                    final isSelected = draft.conditions.contains(entry.code);
                    return OptionCard(
                      label: entry.label,
                      caption: entry.caption,
                      selected: isSelected,
                      enabled: entry.enabled,
                      onTap: entry.enabled
                          ? () => notifier.setConditions([entry.code])
                          : null,
                    );
                  },
                ),
              ),
              // ── CTA (Figma p1: top16/bottom32) ───────────────────────────────
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.screenPadding,
                  right: AppSpacing.screenPadding,
                  top: 16,
                  bottom: 32,
                ),
                child: AppButton.primary(
                  label: '다음',
                  onPressed: draft.conditions.isNotEmpty
                      ? () => context.push('/onboarding/frequency')
                      : null,
                  isExpanded: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
