import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 오늘의 건강 점수 위젯 (목 데이터).
class HealthScoreWidget extends StatelessWidget {
  const HealthScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘의 건강 점수',
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '85',
                    style: AppTextStyles.header2Bold.copyWith(
                      color: AppColors.primary,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    ' / 100',
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '매우 좋음',
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          const CircularProgressIndicator(
            value: 0.85,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }
}
