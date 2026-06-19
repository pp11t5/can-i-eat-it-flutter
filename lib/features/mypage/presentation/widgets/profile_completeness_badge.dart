import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/health_profile/presentation/providers/profile_completeness_provider.dart';

/// 프로필 완성도 배지 위젯.
///
/// [profileCompleteProvider]를 watch해 완성/미완성 상태를 표시한다.
/// - 완성: 초록 체크 아이콘 + "프로필 완성"
/// - 미완성: 회색 원 + "프로필 미완성"
class ProfileCompletenessBadge extends ConsumerWidget {
  const ProfileCompletenessBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(profileCompleteProvider);
    final completeness = ref.watch(profileCompletenessPercentageProvider);

    return Semantics(
      label: isComplete ? '프로필 완성' : '프로필 미완성',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color: isComplete ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                isComplete ? '프로필 완성' : '프로필 미완성',
                style: AppTextStyles.caption1Medium.copyWith(
                  color: isComplete ? AppColors.primary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '프로필 완성도 $completeness%',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: completeness / 100.0,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
