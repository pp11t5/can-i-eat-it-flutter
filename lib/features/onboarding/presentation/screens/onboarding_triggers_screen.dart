import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 Step 3/4: 트리거 음식 선택 화면 (Figma 365:1553).
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
  void initState() {
    super.initState();
    // 뒤로 돌아왔을 때 드래프트에 저장된 기타 입력을 복원한다.
    _customController.text =
        ref.read(onboardingControllerProvider).customTriggers ?? '';
  }

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
                  const StepProgress(currentStep: 3, totalSteps: 4),
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text(
                    '불편함이 유발되는\n음식이 있나요?',
                    style: AppTextStyles.header1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '평소 먹고 나면 속이 불편했던 음식을 선택해 주세요',
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
                    // 트리거 음식 칩 (Wrap)
                    Wrap(
                      spacing: AppSpacing.itemGap,
                      runSpacing: AppSpacing.itemGap,
                      children: triggerFoodOptions.map((entry) {
                        final isSelected =
                            draft.triggerFoods.contains(entry.code);
                        return SelectableChip(
                          label: entry.label,
                          selected: isSelected,
                          onTap: () => notifier.toggleTrigger(entry.code),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 기타 섹션
                    Text(
                      '해당하는 음식이 없나요?',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    TextField(
                      controller: _customController,
                      style: AppTextStyles.body1Regular.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '오렌지주스, 라면',
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
                          borderSide:
                              const BorderSide(color: AppColors.border),
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
            // ── CTA ───────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sectionGap,
              ),
              child: AppButton.primary(
                label: '다음',
                onPressed: () => context.push('/onboarding/medications'),
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
