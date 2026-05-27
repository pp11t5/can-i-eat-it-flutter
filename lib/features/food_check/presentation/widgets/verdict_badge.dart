import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 판정 상태 인라인 배지.
///
/// 신호등 색 원형 dot + 한국어 라벨을 가로로 표시한다.
/// 4상태 exhaustive switch — 상태 누락을 컴파일 타임에 방지.
///
/// 파라미터:
/// - [level]: 표시할 판정 상태.
class VerdictBadge extends StatelessWidget {
  const VerdictBadge({super.key, required this.level});

  final VerdictLevel level;

  static const double _dotSize = AppSpacing.itemGap; // 8

  Color _resolveColor() {
    return switch (level) {
      VerdictLevel.recommend => AppColors.verdictRecommend,
      VerdictLevel.caution => AppColors.verdictCaution,
      VerdictLevel.danger => AppColors.verdictDanger,
      VerdictLevel.unknown => AppColors.verdictUnknown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.chipPaddingH,
        vertical: AppSpacing.chipPaddingV,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 신호등 dot
          Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.iconTextGap),
          // 한국어 라벨
          Text(
            level.label,
            style: AppTextStyles.body2Bold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
