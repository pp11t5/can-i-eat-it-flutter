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

/// 온보딩 Step 3/4: 트리거 음식 선택 화면.
///
/// // TODO(figma): 07 헤더 카피 collapsed — 디자이너 확정 시 정합.
class OnboardingTriggersScreen extends ConsumerStatefulWidget {
  const OnboardingTriggersScreen({super.key});

  @override
  ConsumerState<OnboardingTriggersScreen> createState() =>
      _OnboardingTriggersScreenState();
}

class _OnboardingTriggersScreenState
    extends ConsumerState<OnboardingTriggersScreen> {
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 바: 스텝 진행 + 건너뛰기
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sectionGap),
                  Row(
                    children: [
                      const Expanded(
                        child: StepProgress(currentStep: 3, totalSteps: 4),
                      ),
                      const SizedBox(width: AppSpacing.sectionGap),
                      GestureDetector(
                        onTap: () => context.go('/onboarding/medications'),
                        child: Text(
                          '건너뛰기',
                          style: AppTextStyles.body2Regular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.contentGap),
                  Text(
                    '어떤 음식이 증상을\n악화시키나요?',
                    style: AppTextStyles.header1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
                  Text(
                    '해당하는 음식을 모두 선택해 주세요 (선택)',
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
                    // 트리거 음식 칩 (Wrap)
                    Wrap(
                      spacing: AppSpacing.itemGap,
                      runSpacing: AppSpacing.itemGap,
                      children: triggerFoodOptions.map((entry) {
                        final isSelected =
                            draft.triggerFoods.contains(entry.code);
                        return _TriggerChip(
                          label: entry.label,
                          isSelected: isSelected,
                          onTap: () => notifier.toggleTrigger(entry.code),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 기타 자유 입력 필드
                    TextField(
                      controller: _customController,
                      style: AppTextStyles.body1Regular.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: '기타',
                        hintText: '직접 입력해 주세요',
                        labelStyle: AppTextStyles.body2Regular.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        hintStyle: AppTextStyles.body1Regular.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.cardPadding,
                          vertical: AppSpacing.cardPadding,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusCard),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusCard),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onChanged: (value) {
                        final trimmed = value.trim();
                        notifier.setCustomTriggers(
                          trimmed.isEmpty ? null : trimmed,
                        );
                      },
                    ),
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
                onPressed: () => context.go('/onboarding/medications'),
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TriggerChip extends StatelessWidget {
  const _TriggerChip({
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.chipPaddingH,
          vertical: AppSpacing.chipPaddingV,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(
            color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
