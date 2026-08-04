import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/option_card.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/widgets/onboarding_step_body.dart';

/// 온보딩 Step 1/4: 질환 선택 본문 (Figma 365:1555).
///
/// 탑바·[StepProgress]는 [OnboardingShell]이 고정 렌더한다.
class OnboardingConditionScreen extends ConsumerWidget {
  const OnboardingConditionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return OnboardingStepBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      ? () => notifier.toggleCondition(entry.code)
                      : null,
                );
              },
            ),
          ),
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
    );
  }
}
