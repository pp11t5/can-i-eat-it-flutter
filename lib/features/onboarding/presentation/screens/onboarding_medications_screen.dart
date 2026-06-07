import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 Step 4/4: 알레르기 + 복용약 결합 화면 (Figma 1064:12268).
///
/// 완료 버튼이 onboardingSubmitProvider.submit()을 호출하고
/// 성공 시 홈(/)으로 이동한다. 건너뛰기 없음.
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
    // 제출 성공 시 홈으로 이동
    ref.listen<AsyncValue<void>>(onboardingSubmitProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        if (context.mounted) context.go('/');
      }
    });

    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);
    final submitState = ref.watch(onboardingSubmitProvider);
    final isLoading = submitState is AsyncLoading;
    final hasError = submitState is AsyncError;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 탑바 (Figma — 64px-high TopBar, chevron 세로 중앙) ────────────
            SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.pop(),
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
                  const StepProgress(currentStep: 4, totalSteps: 4),
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text(
                    '알레르기와 복용 중인 약을\n알려주세요',
                    style: AppTextStyles.header1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '없으면 완료를 눌러주세요',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.contentGap),
                ],
              ),
            ),
            // ── 스크롤 영역 ───────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        return SelectableChip(
                          label: entry.label,
                          selected: isSelected,
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
                    TextField(
                      controller: _medController,
                      style: AppTextStyles.body1Regular.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'PPI, 제산제',
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
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusCard,
                          ),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onSubmitted: (_) => _addMedication(),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    AppButton.secondary(
                      label: '＋ 복용약 추가',
                      onPressed: _addMedication,
                      isExpanded: true,
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
            // ── 에러 + 면책 고지 + CTA ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sectionGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasError) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.cardPadding),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.verdictDanger,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.itemGap),
                          Expanded(
                            child: Text(
                              '저장 중 오류가 발생했어요. 다시 시도해 주세요.',
                              style: AppTextStyles.body2Regular.copyWith(
                                color: AppColors.verdictDanger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                  ],
                  if (isLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                  ],
                  const MedicalDisclaimer(message: kOnboardingDisclaimerText),
                  const SizedBox(height: AppSpacing.itemGap),
                  AppButton.primary(
                    label: '완료',
                    onPressed: isLoading
                        ? null
                        : () => ref
                            .read(onboardingSubmitProvider.notifier)
                            .submit(),
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
