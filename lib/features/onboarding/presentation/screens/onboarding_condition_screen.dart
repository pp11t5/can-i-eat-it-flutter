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
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 Step 1/4: 질환 선택 화면 (Figma 365:1555).
class OnboardingConditionScreen extends ConsumerWidget {
  const OnboardingConditionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
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
                  // 뒤로 가기: push 진입이면 pop → /terms, guard-replace 진입이면 go('/terms')
                  child: GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/terms');
                      }
                    },
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
                    style: AppTextStyles.body1Regular.copyWith(
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
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.itemGap),
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
            // ── CTA ───────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sectionGap,
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
    );
  }
}
