import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/food_thumbnail.dart';

/// 끼니 그룹 상세 화면 (F3-3).
///
/// 라우트: /meal/group (fullscreenDialog, extra=MealGroup)
///
/// 구성:
/// - TopBar: X(닫기) + "식사 상세 정보"
/// - 헤더: "오늘 HH:mm 시간에 먹은 음식이에요"
/// - 음식 행 리스트 (각 record → 단일상세 진입)
/// - 상태기록 섹션 (summary에 stateRecords 부재 → TODO)
/// - CTA 없음 (Figma 기준)
class MealGroupDetailScreen extends StatelessWidget {
  const MealGroupDetailScreen({super.key, required this.group});

  final MealGroup group;

  /// ISO-8601 문자열 → 'HH:mm' (Local).
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // TopBar
            _TopBar(onClose: () => context.pop()),
            // 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.sectionGap,
                  AppSpacing.screenPadding,
                  AppSpacing.sectionGap,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더 문구
                    Text(
                      '$timeLabel 시간에 먹은 음식이에요',
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 음식 행 목록
                    ...group.records.map(
                      (record) => _FoodRow(
                        key: ValueKey(record.mealId),
                        record: record,
                        onTap: () =>
                            context.push('/meal/${record.mealId}'),
                      ),
                    ),
                    // TODO(symptom/backend): 그룹 상태기록 집계 — summary에 stateRecords 부재
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TopBar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              '식사 상세 정보',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 음식 행 (단일상세 진입)
// ---------------------------------------------------------------------------

class _FoodRow extends StatelessWidget {
  const _FoodRow({super.key, required this.record, required this.onTap});

  final MealRecord record;
  final VoidCallback onTap;

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
    final timeLabel = _formatTime(record.eatenAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
        child: Row(
          children: [
            FoodThumbnail(category: record.food.category, size: 40),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.food.name,
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$timeLabel에 식사',
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
