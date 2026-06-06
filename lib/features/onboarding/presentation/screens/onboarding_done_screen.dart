import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

/// 온보딩 완료 화면 (09).
///
/// 제출 상태:
/// - idle: 버튼 활성
/// - loading: 버튼 비활성 + CircularProgressIndicator
/// - error: 에러 메시지 인라인 + 재시도 가능 (버튼 재활성)
/// - success (AsyncLoading→AsyncData 전이): context.go('/') 홈 이동
class OnboardingDoneScreen extends ConsumerWidget {
  const OnboardingDoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 제출 성공 시 홈으로 이동
    ref.listen<AsyncValue<void>>(onboardingSubmitProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        if (context.mounted) context.go('/');
      }
    });

    final submitState = ref.watch(onboardingSubmitProvider);
    final isLoading = submitState is AsyncLoading;
    final error = submitState is AsyncError ? submitState.error : null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                '입력이 완료됐어요',
                style: AppTextStyles.header1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                '이제 음식을 검색해\n맞춤 판별을 받아볼 수 있어요',
                style: AppTextStyles.body1Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // 에러 메시지
              if (error != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
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
                const SizedBox(height: AppSpacing.sectionGap),
              ],
              // 로딩 인디케이터
              if (isLoading) ...[
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: AppSpacing.sectionGap),
              ],
              // 면책 고지 (CTA 위)
              const MedicalDisclaimer(message: kOnboardingDisclaimerText),
              const SizedBox(height: AppSpacing.sectionGap),
              // 제출 버튼
              AppButton.primary(
                label: '시작하기',
                onPressed: isLoading
                    ? null
                    : () =>
                        ref.read(onboardingSubmitProvider.notifier).submit(),
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
