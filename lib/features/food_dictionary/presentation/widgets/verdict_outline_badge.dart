import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 판정 상태 아웃라인 배지 (도감 리스트 전용, Figma 1718-7883/1718-7882).
///
/// 아웃라인 pill(테두리 + 연한 배경 + 진한 텍스트) 스타일 — 기존
/// [VerdictBadge](dot + 인라인 배지)와는 별개 위젯이며, 그것을 대체하지 않는다.
/// 4상태 exhaustive switch — 상태 누락을 컴파일 타임에 방지.
///
/// 파라미터:
/// - [level]: 표시할 판정 상태.
class VerdictOutlineBadge extends StatelessWidget {
  const VerdictOutlineBadge({super.key, required this.level});

  final VerdictLevel level;

  Color _borderColor() => switch (level) {
        VerdictLevel.recommend => AppColors.verdictRecommend,
        VerdictLevel.caution => AppColors.verdictCaution,
        VerdictLevel.risk => AppColors.verdictDanger, // 색상 토큰명 유지 (ADR-0003)
        VerdictLevel.unknown => AppColors.verdictUnknown,
      };

  Color _backgroundColor() => switch (level) {
        // recommend: Figma 실측 flat 배경 (AppColors.surfaceSelected = green10 #F0FFF4).
        VerdictLevel.recommend => AppColors.surfaceSelected,
        // caution/risk: Figma 실측 연한 배경 — semantic 토큰 미정, const Color 유지.
        VerdictLevel.caution => const Color(0xFFFFF5EA),
        VerdictLevel.risk => const Color(0xFFFFE0E0),
        VerdictLevel.unknown => AppColors.surfaceMuted,
      };

  @override
  Widget build(BuildContext context) {
    final borderColor = _borderColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: AppSpacing.chipPaddingV,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        level.label,
        style: AppTextStyles.body2Medium.copyWith(color: borderColor),
      ),
    );
  }
}
