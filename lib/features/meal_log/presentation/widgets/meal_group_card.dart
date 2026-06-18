import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_record_tile.dart';

/// 끼니 그룹 카드 위젯.
///
/// Figma node 1351-14768 — 흰 카드(radius 8, 은은한 그림자):
/// - 상단 라벨: "먹은 음식 · HH:mm" (eatenAt KST 시각)
/// - 그룹 내 각 [MealRecord] = [MealRecordTile] 세로 나열
/// - 하단 "＋ 같이 먹은 음식이 있나요?" 행 (정적 UI, onAddFood 콜백 노출)
///
/// // TODO(symptom): timeline 페이로드에 stateRecords 부재 — 백엔드 집계 or 상세조회 필요 [figma:1351-14768]
///
/// [group]: 표시할 끼니 그룹.
/// [onTapRecord]: 식사 기록 타일 탭 콜백. null이면 no-op.
/// [onTapGroup]: 그룹 헤더("먹은 음식 · HH:mm") 탭 콜백 (F3-3 그룹 상세 진입). null이면 no-op.
/// [onAddFood]: "같이 먹은 음식 추가" 행 탭 콜백. null이면 no-op.
class MealGroupCard extends StatelessWidget {
  const MealGroupCard({
    super.key,
    required this.group,
    this.onTapRecord,
    this.onTapGroup,
    this.onAddFood,
  });

  final MealGroup group;
  final void Function(MealRecord record)? onTapRecord;
  final void Function(MealGroup group)? onTapGroup;
  final void Function(MealGroup group)? onAddFood;

  /// ISO-8601 문자열 → 'HH:mm' (KST).
  static String _formatTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = _formatTime(group.eatenAt);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: AppColors.weekStripShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 라벨: "먹은 음식 · HH:mm" — 탭 시 그룹 상세 진입 (F3-3)
            GestureDetector(
              onTap: onTapGroup != null ? () => onTapGroup!(group) : null,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(
                    '먹은 음식 · $timeLabel',
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (onTapGroup != null) ...[
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            // 식사 기록 타일 목록
            ...group.records.map(
              (record) => MealRecordTile(
                key: ValueKey(record.mealId),
                record: record,
                onTap: onTapRecord != null
                    ? () => onTapRecord!(record)
                    : null,
              ),
            ),
            const Divider(
              height: AppSpacing.sectionGap,
              color: AppColors.divider,
              thickness: 0.5,
            ),
            // "＋ 같이 먹은 음식이 있나요?" 행
            GestureDetector(
              onTap: onAddFood != null ? () => onAddFood!(group) : null,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '같이 먹은 음식이 있나요?',
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
