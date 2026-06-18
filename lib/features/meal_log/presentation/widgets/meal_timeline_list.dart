import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_group_card.dart';

/// 타임라인 리스트 위젯 — 왼쪽 수직 스파인 + 시간대 아이콘 + 끼니 그룹 카드.
///
/// Figma node 1351-14768:
/// - 좌측 세로 스파인 라인
/// - 그룹별 시간대 원형 아이콘 (아침/점심/저녁 — eatenAt.hour 기준)
///   · hour < 12  → 아침 (wb_sunny)
///   · 12 ≤ hour < 18 → 점심 (list)
///   · hour ≥ 18  → 저녁 (nights_stay)
/// - 각 그룹 우측에 [MealGroupCard]
///
/// [groups]: 표시할 끼니 그룹 목록 (비어있지 않아야 함).
/// [onTapRecord]: 레코드 탭 콜백.
/// [onTapGroup]: 그룹 헤더 탭 콜백 (F3-3 그룹 상세 진입).
/// [onAddFood]: 음식 추가 콜백.
class MealTimelineList extends StatelessWidget {
  const MealTimelineList({
    super.key,
    required this.groups,
    this.onTapRecord,
    this.onTapGroup,
    this.onAddFood,
  });

  final List<MealGroup> groups;
  final void Function(MealRecord record)? onTapRecord;
  final void Function(MealGroup group)? onTapGroup;
  final void Function(MealGroup group)? onAddFood;

  /// eatenAt ISO-8601 → 시(hour) 추출.
  static int _hourOf(String isoString) {
    try {
      return DateTime.parse(isoString).toLocal().hour;
    } catch (_) {
      return 12;
    }
  }

  /// hour → 시간대 아이콘 데이터.
  static IconData _mealTimeIcon(int hour) {
    if (hour < 12) return Icons.wb_sunny_outlined;       // 아침
    if (hour < 18) return Icons.wb_twilight_outlined;    // 점심
    return Icons.nights_stay_outlined;                   // 저녁
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sectionGap,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final hour = _hourOf(group.eatenAt);
        final icon = _mealTimeIcon(hour);
        final isLast = index == groups.length - 1;

        return _TimelineRow(
          icon: icon,
          isLast: isLast,
          child: MealGroupCard(
            group: group,
            onTapRecord: onTapRecord,
            onTapGroup: onTapGroup,
            onAddFood: onAddFood,
          ),
        );
      },
    );
  }
}

/// 타임라인 행 — 스파인(라인+아이콘) + 오른쪽 카드.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.isLast,
    required this.child,
  });

  final IconData icon;
  final bool isLast;
  final Widget child;

  static const double _iconContainerSize = 32.0;
  static const double _spineWidth = 1.5;
  static const double _rowGap = AppSpacing.itemGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sectionGap),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 스파인 컬럼: 아이콘 + 수직 라인
            SizedBox(
              width: _iconContainerSize,
              child: Column(
                children: [
                  // 시간대 원형 아이콘
                  Container(
                    width: _iconContainerSize,
                    height: _iconContainerSize,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // 아이콘 하단 ~ 카드 끝까지 연장되는 수직 라인
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: _spineWidth,
                        color: AppColors.divider,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: _rowGap),
            // 끼니 그룹 카드 (남은 너비 채움)
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
