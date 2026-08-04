import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/widgets/onboarding_step_body.dart';

/// 온보딩 Step 3/4: 트리거 음식 선택 본문 (Figma 365:1553).
///
/// 탑바·[StepProgress]는 [OnboardingShell]이 고정 렌더한다.
/// 제목·칩·기타 입력(+ 추가)·CTA를 한 스크롤로 묶어 키보드 시 입력란과 버튼이
/// 붙지 않도록 한다 (medications 화면과 동일 패턴).
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

  void _addCustomTrigger() {
    final text = _customController.text.trim();
    if (text.isEmpty) return;
    ref.read(onboardingControllerProvider.notifier).addCustomTrigger(text);
    _customController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return OnboardingStepBody(
      child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                            '불편함이 유발되는\n음식이 있나요?',
                            style: AppTextStyles.header1Bold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '평소 먹고 나면 속이 불편했던 음식을 선택해 주세요',
                            style: AppTextStyles.body1Medium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.contentGap),
                          Wrap(
                            spacing: AppSpacing.itemGap,
                            runSpacing: AppSpacing.itemGap,
                            children: triggerFoodOptions.map((entry) {
                              final isSelected =
                                  draft.triggerFoods.contains(entry.code);
                              return SelectableChip(
                                label: entry.label,
                                selected: isSelected,
                                onTap: () =>
                                    notifier.toggleTrigger(entry.code),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppSpacing.contentGap),
                          Text(
                            '해당하는 음식이 없나요?',
                            style: AppTextStyles.body1Bold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 복용약 입력과 동일: TextField 우측 인라인 + 버튼.
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
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.itemGap,
                                ),
                                child: GestureDetector(
                                  onTap: _addCustomTrigger,
                                  child: const AppIcon(
                                    AppIcons.plusCircle,
                                    size: 24,
                                  ),
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
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
                            onSubmitted: (_) => _addCustomTrigger(),
                          ),
                          if (draft.customTriggers.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sectionGap),
                            Wrap(
                              spacing: AppSpacing.itemGap,
                              runSpacing: AppSpacing.itemGap,
                              children: draft.customTriggers.map((item) {
                                return _CustomTriggerChip(
                                  label: item,
                                  onRemove: () =>
                                      notifier.removeCustomTrigger(item),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.sectionGap),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // CTA (Figma p3: top16/bottom32) — 스크롤 안, 입력과 간격 유지
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.screenPadding,
                        right: AppSpacing.screenPadding,
                        top: 16,
                        bottom: 32,
                      ),
                      child: AppButton.primary(
                        label: '다음',
                        onPressed: () =>
                            context.push('/onboarding/medications'),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}

class _CustomTriggerChip extends StatelessWidget {
  const _CustomTriggerChip({
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
            child: const AppIcon(
              AppIcons.closeSmall,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
