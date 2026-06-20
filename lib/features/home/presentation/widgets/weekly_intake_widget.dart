import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 이번 주 섭취 통계 위젯 (목 데이터).
class WeeklyIntakeWidget extends StatelessWidget {
  const WeeklyIntakeWidget({super.key});

  static const _days = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이번 주 섭취 통계',
          style: AppTextStyles.header3Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _days
              .map(
                (day) => Column(
                  children: [
                    Container(
                      width: 24,
                      height: 40,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day,
                      style: AppTextStyles.caption1Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
