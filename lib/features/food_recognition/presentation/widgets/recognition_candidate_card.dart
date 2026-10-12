import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/option_card.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/beta_badge.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/recognition_modal_card.dart';

const _buttonHeight = 52.0;

/// 인식 후보 선택 카드. [selectedIndex] 가 null 이면 '음식 진단하기' 는 비활성이다.
class RecognitionCandidateCard extends StatelessWidget {
  const RecognitionCandidateCard({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
    required this.onDiagnose,
    required this.onSearch,
    required this.onRetake,
  });

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onDiagnose;
  final VoidCallback onSearch;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return RecognitionModalCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(alignment: Alignment.centerLeft, child: BetaBadge()),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '검색하려는 음식을 아래 중 선택해주세요.',
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.itemGap),
            OptionCard(
              label: labels[i],
              size: OptionCardSize.compact,
              selected: selectedIndex == i,
              labelStyle: selectedIndex == i
                  ? AppTextStyles.body1Bold
                  : AppTextStyles.body1Medium,
              onTap: () => onSelect(i),
            ),
          ],
          const SizedBox(height: AppSpacing.sectionGap),
          AppButton.primary(
            label: '음식 진단하기',
            isExpanded: true,
            height: _buttonHeight,
            onPressed: selectedIndex == null ? null : onDiagnose,
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Row(
            children: [
              Expanded(
                child: AppButton.tertiary(
                  label: '검색하기',
                  isExpanded: true,
                  height: _buttonHeight,
                  onPressed: onSearch,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: AppButton.tertiary(
                  label: '다시 찍기',
                  isExpanded: true,
                  height: _buttonHeight,
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
