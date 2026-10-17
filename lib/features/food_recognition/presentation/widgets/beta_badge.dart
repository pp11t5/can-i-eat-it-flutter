import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// "Beta" 배지.
class BetaBadge extends StatelessWidget {
  const BetaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.badgeBeta,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Beta',
        style: AppTextStyles.caption1Medium.copyWith(
          color: AppColors.onPrimary,
          height: 1,
        ),
      ),
    );
  }
}
