import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/food_thumbnail.dart';

/// 식사 기록 단건 타일.
///
/// Figma node 1351-14768:
/// - 좌측: 음식 썸네일(32×32 placeholder)
/// - 중앙: 음식명 (body2Medium, textPrimary)
/// - 우측: 판정 라벨(grade != null 시 VerdictLevel.label + 해당 색) + chevron
///
/// [record]: 표시할 식사 기록.
/// [onTap]: 타일 전체 탭 콜백 (F3-3에서 상세 화면 진입에 사용).
class MealRecordTile extends StatelessWidget {
  const MealRecordTile({
    super.key,
    required this.record,
    this.onTap,
  });

  final MealRecord record;
  final VoidCallback? onTap;

  /// VerdictLevel → 표시 색 매핑.
  static Color _verdictColor(VerdictLevel level) => switch (level) {
        VerdictLevel.recommend => AppColors.verdictRecommend,
        VerdictLevel.caution => AppColors.verdictCaution,
        VerdictLevel.risk => AppColors.verdictDanger,
        VerdictLevel.unknown => AppColors.verdictUnknown,
      };

  @override
  Widget build(BuildContext context) {
    final grade = record.judgedGrade;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            // 음식 썸네일
            FoodThumbnail(category: record.food.category),
            const SizedBox(width: AppSpacing.itemGap),
            // 음식명 (남은 공간 채움)
            Expanded(
              child: Text(
                record.food.name,
                style: AppTextStyles.body2Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 판정 라벨 (grade 있을 때만 표시)
            if (grade != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                grade.label,
                style: AppTextStyles.caption1Medium.copyWith(
                  color: _verdictColor(grade),
                ),
              ),
            ],
            const SizedBox(width: AppSpacing.xs),
            // chevron
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
