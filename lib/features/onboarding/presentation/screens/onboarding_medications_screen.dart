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

/// 온보딩 Step 4/4: 알레르기 + 복용약 결합 화면.
class OnboardingMedicationsScreen extends ConsumerStatefulWidget {
  const OnboardingMedicationsScreen({super.key});

  @override
  ConsumerState<OnboardingMedicationsScreen> createState() =>
      _OnboardingMedicationsScreenState();
}

class _OnboardingMedicationsScreenState
    extends ConsumerState<OnboardingMedicationsScreen> {
  final _medController = TextEditingController();

  @override
  void dispose() {
    _medController.dispose();
    super.dispose();
  }

  void _addMedication() {
    final text = _medController.text.trim();
    if (text.isEmpty) return;
    ref.read(onboardingControllerProvider.notifier).addMedication(text);
    _medController.clear();
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sectionGap),
                    const StepProgress(currentStep: 4, totalSteps: 4),
                    const SizedBox(height: AppSpacing.contentGap),
                    Text(
                      '알레르기와 복용 중인 약을\n알려주세요',
                      style: AppTextStyles.header1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    Text(
                      '없으면 완료를 눌러주세요',
                      style: AppTextStyles.body1Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    // ── 알레르기 섹션 ─────────────────────────────────────────
                    Text(
                      '알레르기',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    Wrap(
                      spacing: AppSpacing.itemGap,
                      runSpacing: AppSpacing.itemGap,
                      children: allergyOptions.map((entry) {
                        final isSelected =
                            draft.allergies.contains(entry.code);
                        return _SelectableChip(
                          label: entry.label,
                          isSelected: isSelected,
                          onTap: () => notifier.toggleAllergy(entry.code),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    // ── 복용약 섹션 ───────────────────────────────────────────
                    Text(
                      '복용 중인 약',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    // 입력 필드 + 추가 버튼
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _medController,
                              style: AppTextStyles.body1Regular.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: '예: 오메프라졸',
                                hintStyle: AppTextStyles.body1Regular.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.cardPadding,
                                  vertical: AppSpacing.cardPadding,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusCard,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusCard,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              onSubmitted: (_) => _addMedication(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.itemGap),
                          AppButton.primary(
                            label: '＋ 복용약 추가',
                            onPressed: _addMedication,
                          ),
                        ],
                      ),
                    ),
                    // 추가된 약 목록
                    if (draft.medications.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sectionGap),
                      Wrap(
                        spacing: AppSpacing.itemGap,
                        runSpacing: AppSpacing.itemGap,
                        children: draft.medications.map((med) {
                          return _MedicationChip(
                            label: med,
                            onRemove: () => notifier.removeMedication(med),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sectionGap),
                  ],
                ),
              ),
            ),
            // 하단 버튼 영역: 건너뛰기 + 완료
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sectionGap,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/onboarding/done'),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.itemGap,
                      ),
                      child: Text(
                        '건너뛰기',
                        style: AppTextStyles.body2Regular.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  AppButton.primary(
                    label: '완료',
                    onPressed: () => context.go('/onboarding/done'),
                    isExpanded: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
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

class _MedicationChip extends StatelessWidget {
  const _MedicationChip({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.chipPaddingH,
        vertical: AppSpacing.chipPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSelected,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
