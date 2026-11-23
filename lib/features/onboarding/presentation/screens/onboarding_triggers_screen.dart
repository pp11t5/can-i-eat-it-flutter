import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/medical_sources_link.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/features/mypage/domain/medical_sources_catalog.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/widgets/onboarding_step_body.dart';

/// 하단 플로팅 CTA 가 차지하는 높이(바닥 32 + 버튼 56 + 간격 16 + 안내 링크) + 여유.
const double _ctaScrollPadding = 168;

/// 온보딩 Step 3/4: 트리거 음식 선택 본문 (Figma 365:1553).
///
/// 탑바·[StepProgress]는 [OnboardingShell]이 고정 렌더한다.
/// 제목·칩·기타 입력(+ 추가)은 스크롤하고, 안내 링크·«다음» 버튼은 그 위에 떠 있다.
class OnboardingTriggersScreen extends ConsumerStatefulWidget {
  const OnboardingTriggersScreen({super.key});

  @override
  ConsumerState<OnboardingTriggersScreen> createState() =>
      _OnboardingTriggersScreenState();
}

class _OnboardingTriggersScreenState
    extends ConsumerState<OnboardingTriggersScreen>
    with WidgetsBindingObserver {
  final _customController = TextEditingController();
  bool _keyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // 키보드가 떠 있으면 플로팅 CTA가 입력란을 가리므로 숨긴다.
    // Scaffold가 body MediaQuery에서 키보드 inset을 지우므로 View에서 직접 읽는다.
    final open = View.of(context).viewInsets.bottom > 0;
    if (open != _keyboardOpen) setState(() => _keyboardOpen = open);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                // 플로팅 CTA(안내 링크 + 버튼)에 마지막 입력 영역이 가려지지 않게.
                padding: const EdgeInsets.only(bottom: _ctaScrollPadding),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                                onTap: () => notifier.toggleTrigger(entry.code),
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
                          // TextField 우측 인라인 + 버튼.
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
                  ],
                ),
              ),
            ),
            // CTA — 스크롤 영역 위에 떠 있고 뒤는 투명 (Figma p3: bottom32).
            if (!_keyboardOpen)
              Positioned(
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
                bottom: 32,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MedicalSourcesLink.guideline(
                      sourceUrl: MedicalSourcesCatalog.acg2022Url,
                    ),
                    const SizedBox(height: AppSpacing.cardPadding),
                    AppButton.primary(
                      label: '다음',
                      onPressed: () => context.push('/onboarding/medications'),
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
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.primary,
              ),
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
