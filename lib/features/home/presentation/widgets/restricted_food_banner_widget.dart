import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

/// 섭취 제한 음식 경고 배너 위젯.
class RestrictedFoodBannerWidget extends StatelessWidget {
  const RestrictedFoodBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.danger.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.danger),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '오늘 섭취 제한 음식이 포함되어 있어요.',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
