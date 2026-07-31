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

/// 온보딩 Step 2/4: 증상 빈도 선택 본문 (Figma 365:1554).
///
/// MedicalDisclaimer 와 diagnosedLabel 타일은 Figma에 없으므로 제거됨.
/// 탑바·[StepProgress]는 [OnboardingShell]이 고정 렌더한다.
class OnboardingFrequencyScreen extends ConsumerWidget {
  const OnboardingFrequencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return Column(
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
                '최근 4주간 어떤 불편함이\n있었나요?',
                style: AppTextStyles.header1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '해당되는 항목을 모두 선택해 주세요',
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              24,
            ),
            itemCount: symptomFrequencyOptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final entry = symptomFrequencyOptions[index];
              final isSelected = draft.symptomFrequency.contains(entry.code);
              return OptionCard(
                label: entry.label,
                selected: isSelected,
                size: OptionCardSize.compact,
                onTap: () => notifier.toggleSymptom(entry.code),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            bottom: 32,
          ),
          child: AppButton.primary(
            label: '다음',
            onPressed: draft.symptomFrequency.isNotEmpty
                ? () => context.push('/onboarding/triggers')
                : null,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
