import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 Step 1/4: 질환 선택 화면.
class OnboardingConditionScreen extends ConsumerWidget {
  const OnboardingConditionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sectionGap),
              const StepProgress(currentStep: 1, totalSteps: 4),
              const SizedBox(height: AppSpacing.contentGap),
              Text(
                '어떤 건강 고민이 있으세요?',
                style: AppTextStyles.header1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                '현재는 역류성 식도염만 지원해요\n향후 다른 질환도 추가될 예정이에요',
                style: AppTextStyles.body1Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Expanded(
                child: ListView.separated(
                  itemCount: conditionOptions.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.itemGap),
                  itemBuilder: (context, index) {
                    final entry = conditionOptions[index];
                    final isSelected =
                        draft.conditions.contains(entry.code);
                    return _ConditionCard(
                      label: entry.label,
                      isSelected: isSelected,
                      onTap: () {
                        // Single-select: tapping sets [entry.code] as the only selection.
                        notifier.setConditions([entry.code]);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              AppButton.primary(
                label: '다음',
                onPressed: draft.conditions.isNotEmpty
                    ? () => context.go('/onboarding/frequency')
                    : null,
                isExpanded: true,
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceSelected : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            _CheckIcon(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  const _CheckIcon({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.checkboxBorder,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: AppColors.onPrimary)
          : null,
    );
  }
}
