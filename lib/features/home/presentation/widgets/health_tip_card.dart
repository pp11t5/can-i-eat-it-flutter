import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 건강 팁 카드 (목 데이터).
///
/// 아이콘 + 제목 Row + 내용 텍스트 구조.
class HealthTipCard extends StatelessWidget {
  const HealthTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 + 제목 Row
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 24,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 건강 팁',
                style: AppTextStyles.body1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 내용 텍스트
          Text(
            '식사 후 바로 눕지 않고 30분 이상 앉아 있으면 역류 증상을 줄일 수 있어요.',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
