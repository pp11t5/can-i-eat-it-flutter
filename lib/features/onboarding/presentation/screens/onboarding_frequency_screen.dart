import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 Step 2/4: 증상 빈도 + 진단 여부 선택 화면.
class OnboardingFrequencyScreen extends ConsumerWidget {
  const OnboardingFrequencyScreen({super.key});

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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sectionGap),
                  const StepProgress(currentStep: 2, totalSteps: 4),
                  const SizedBox(height: AppSpacing.contentGap),
                  Text(
                    '최근 4주간 어떤 불편함이\n있었나요?',
                    style: AppTextStyles.header1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
                  Text(
                    '해당되는 항목을 모두 선택해 주세요',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 증상 빈도 목록 (multi-select)
                    ...symptomFrequencyOptions.map((entry) {
                      final isSelected =
                          draft.symptomFrequency.contains(entry.code);
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.itemGap,
                        ),
                        child: _SelectableTile(
                          label: entry.label,
                          isSelected: isSelected,
                          onTap: () => notifier.toggleSymptom(entry.code),
                        ),
                      );
                    }),
                    // 진단 여부 단일 선택 타일 (섹션 갭으로 구분)
                    const SizedBox(height: AppSpacing.sectionGap),
                    _SelectableTile(
                      label: diagnosedLabel,
                      isSelected: draft.diagnosed,
                      onTap: () => notifier.setDiagnosed(!draft.diagnosed),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 면책 고지
                    const MedicalDisclaimer(message: kOnboardingDisclaimerText),
                    const SizedBox(height: AppSpacing.sectionGap),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sectionGap,
              ),
              child: AppButton.primary(
                label: '다음',
                onPressed: () => context.go('/onboarding/triggers'),
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
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
                style: AppTextStyles.body2Regular.copyWith(
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
