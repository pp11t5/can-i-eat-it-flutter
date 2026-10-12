import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/recognition_modal_card.dart';

/// 인식 실패 카드.
class RecognitionFailureCard extends StatelessWidget {
  const RecognitionFailureCard({
    super.key,
    required this.onSearch,
    required this.onRetake,
  });

  final VoidCallback onSearch;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return RecognitionModalCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '음식을 확인하기 어려워요.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            '한 번에 하나의 음식만 찍고\n흔들리지 않게 찍어주세요.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: [
              Expanded(
                child: AppButton.tertiary(
                  label: '검색하기',
                  isExpanded: true,
                  height: 52,
                  onPressed: onSearch,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: AppButton.primary(
                  label: '다시 찍기',
                  isExpanded: true,
                  height: 52,
                  onPressed: onRetake,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
