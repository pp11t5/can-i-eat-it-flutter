import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

/// 마이페이지 건강 프로필 요약 섹션.
///
/// conditions·triggerFoods·medications·allergies를 칩 형태로 표시한다.
/// [profile]이 null이면 "프로필 없음" 안내 문구를 표시한다.
class HealthProfileSummaryWidget extends StatelessWidget {
  const HealthProfileSummaryWidget({super.key, required this.profile});

  final HealthProfile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          '아직 건강 프로필이 없어요.',
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 질환: 빈 목록이어도 섹션 표시 (빈 목록 → '없음')
        _ProfileSection(
          label: '질환',
          items: profile!.conditions,
          chipColor: AppColors.surfaceSelected,
          chipTextColor: AppColors.primary,
        ),
        // 트리거 음식: 빈 목록이어도 섹션 표시 (빈 목록 → '없음')
        _ProfileSection(
          label: '트리거 음식',
          items: profile!.triggerFoods,
          chipColor: const Color(0xFFFFF3F3),
          chipTextColor: AppColors.danger,
        ),
        if (profile!.medications.isNotEmpty)
          _ProfileSection(
            label: '복용약',
            items: profile!.medications,
            chipColor: AppColors.surfaceMuted,
            chipTextColor: AppColors.textSecondary,
          ),
        if (profile!.allergies.isNotEmpty)
          _ProfileSection(
            label: '알레르기',
            items: profile!.allergies,
            chipColor: const Color(0xFFFFF8ED),
            chipTextColor: AppColors.textStrong,
          ),
        if (profile!.customTriggers != null &&
            profile!.customTriggers!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '직접 입력: ${profile!.customTriggers}',
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.label,
    required this.items,
    required this.chipColor,
    required this.chipTextColor,
  });

  final String label;
  final List<String> items;
  final Color chipColor;
  final Color chipTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption1Bold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (items.isEmpty)
            Text(
              '없음',
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: items
                  .map((item) => _Chip(
                        label: item,
                        bgColor: chipColor,
                        textColor: chipTextColor,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.chipPaddingH,
        vertical: AppSpacing.chipPaddingV,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption1Medium.copyWith(color: textColor),
      ),
    );
  }
}
