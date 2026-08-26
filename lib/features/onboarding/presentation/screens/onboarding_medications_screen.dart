import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/widgets/onboarding_step_body.dart';

/// 온보딩 Step 4/4: 알레르기 선택 본문.
///
/// 완료 버튼이 onboardingSubmitProvider.submit()을 호출하고
/// [sessionStatus]가 [SessionStatus.ready]가 된 뒤에만 홈(/)으로 이동한다.
/// (submit 직후 즉시 go 하면 needsOnboarding 가드가 condition 화면으로 튕김)
/// 건너뛰기 없음. 탑바·[StepProgress]는 [OnboardingShell]이 고정 렌더한다.
class OnboardingMedicationsScreen extends ConsumerWidget {
  const OnboardingMedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // submit 직후 go('/') 금지 — onboardedStatus 재조회 전 needsOnboarding이면
    // 가드가 /onboarding/condition 으로 튕겨 첫 화면이 깜빡인다.
    // sessionStatus가 ready로 전이된 뒤에만 홈으로 이동한다.
    ref.listen<SessionStatus>(sessionStatusProvider, (previous, next) {
      if (next == SessionStatus.ready && previous != SessionStatus.ready) {
        if (context.mounted) context.go('/');
      }
    });

    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);
    final submitState = ref.watch(onboardingSubmitProvider);
    final isLoading = submitState is AsyncLoading;
    final hasError = submitState is AsyncError;

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
                      const SizedBox(height: AppSpacing.sectionGap),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '알레르기가 있나요?',
                              style: AppTextStyles.header1Bold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '없으면 완료를 눌러주세요. 지금까지 입력한 내용은\n'
                              '마이페이지에서 수정할 수 있어요.',
                              style: AppTextStyles.body1Medium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.contentGap),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '알레르기',
                              style: AppTextStyles.body1Bold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: AppSpacing.itemGap,
                              runSpacing: AppSpacing.itemGap,
                              children: allergyOptions.map((entry) {
                                final isSelected =
                                    draft.allergies.contains(entry.code);
                                return SelectableChip(
                                  label: entry.label,
                                  selected: isSelected,
                                  onTap: () =>
                                      notifier.toggleAllergy(entry.code),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: AppSpacing.sectionGap),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.screenPadding,
                          right: AppSpacing.screenPadding,
                          top: 16,
                          bottom: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasError) ...[
                              Container(
                                padding: const EdgeInsets.all(
                                  AppSpacing.cardPadding,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusCard,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const AppIcon(
                                      AppIcons.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppSpacing.itemGap),
                                    Expanded(
                                      child: Text(
                                        '저장 중 오류가 발생했어요. 다시 시도해 주세요.',
                                        style:
                                            AppTextStyles.body2Regular.copyWith(
                                          color: AppColors.verdictDanger,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.itemGap),
                            ],
                            const MedicalDisclaimer(),
                            const SizedBox(height: AppSpacing.itemGap),
                            AppButton.primary(
                              label: '완료',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      ref
                                          .read(
                                            onboardingSubmitProvider.notifier,
                                          )
                                          .submit();
                                    },
                              isLoading: isLoading,
                              isExpanded: true,
                            ),
                          ],
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
