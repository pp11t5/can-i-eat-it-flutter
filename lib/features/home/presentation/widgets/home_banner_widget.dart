import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 상단 배너 위젯.
class HomeBannerWidget extends StatelessWidget {
  const HomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '오늘도 건강하게!',
                    style: AppTextStyles.header3Bold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '내 질환에 맞는 음식을 확인해보세요',
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.health_and_safety_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
