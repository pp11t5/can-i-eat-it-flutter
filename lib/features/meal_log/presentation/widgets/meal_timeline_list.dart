import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';

/// 타임라인 리스트 위젯 — 왼쪽 수직 스파인 + 시간대 아이콘 + 변형별 타일.
///
/// [TimelineItem] sealed union(single/group/symptom)을 변형별로 렌더한다.
/// - single: 음식 1개짜리 식사 (음식명 + grade 배지).
/// - group: 음식 2개 이상짜리 식사 (대표음식 + "외 N개").
/// - symptom: 증상 기록 (탭 보류 — TimelineSymptom 에 symptomId 없음, W5-4 NOTE 참조).
///
/// 시간대 아이콘은 mealRecordDateTime/occurredAt 의 hour 로 결정.
///
/// [items]: 표시할 타임라인 항목 목록 (비어있지 않아야 함).
/// [onTapMeal]: single/group 타일 탭 콜백 (식사 상세 진입).
/// [onAddFood]: single/group 타일 "+음식 추가" 콜백.
class MealTimelineList extends StatelessWidget {
  const MealTimelineList({
    super.key,
    required this.items,
    this.onTapMeal,
    this.onAddFood,
  });

  final List<TimelineItem> items;

  /// single/group 타일 탭 → 식사 상세(mealRecordId).
  final void Function(String mealRecordId)? onTapMeal;

  /// single/group 타일 "+음식 추가" → 기존 식사에 추가(mealRecordId).
  final void Function(String mealRecordId)? onAddFood;

  /// ISO-8601 문자열 → 시(hour).
  static int _hourOf(String isoString) {
    try {
      return parseKst(isoString).hour;
    } catch (_) {
      return 12;
    }
  }

  /// hour → 시간대 아이콘.
  static IconData _mealTimeIcon(int hour) {
    if (hour < 12) return Icons.wb_sunny_outlined; // 아침
    if (hour < 18) return Icons.wb_twilight_outlined; // 점심
    return Icons.nights_stay_outlined; // 저녁
  }

  /// 항목별 시간대 hour 추출.
  static int _itemHour(TimelineItem item) => switch (item) {
        TimelineSingle(:final mealRecordDateTime) => _hourOf(mealRecordDateTime),
        TimelineGroup(:final mealRecordDateTime) => _hourOf(mealRecordDateTime),
        TimelineSymptom(:final occurredAt) => _hourOf(occurredAt),
      };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sectionGap,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        final icon = item is TimelineSymptom
            ? Icons.medical_information_outlined
            : _mealTimeIcon(_itemHour(item));

        final Widget card = switch (item) {
          TimelineSingle() => _SingleMealCard(
              item: item,
              onTap: onTapMeal != null
                  ? () => onTapMeal!(item.mealRecordId)
                  : null,
              onAddFood: onAddFood != null
                  ? () => onAddFood!(item.mealRecordId)
                  : null,
            ),
          TimelineGroup() => _GroupMealCard(
              item: item,
              onTap: onTapMeal != null
                  ? () => onTapMeal!(item.mealRecordId)
                  : null,
              onAddFood: onAddFood != null
                  ? () => onAddFood!(item.mealRecordId)
                  : null,
            ),
          TimelineSymptom() => _SymptomCard(item: item),
        };

        return _TimelineRow(icon: icon, isLast: isLast, child: card);
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
            SizedBox(
              width: _iconContainerSize,
              child: Column(
                children: [
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
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 공통 카드 셸
// ---------------------------------------------------------------------------

/// 흰 카드(radius, 은은한 그림자) 셸.
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
        child: child,
      ),
    );
  }
}

/// 시각 라벨 'HH:mm'.
String _formatTime(String isoString) {
  try {
    final dt = parseKst(isoString);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  } catch (_) {
    return isoString;
  }
}

/// VerdictLevel → 표시 색.
Color _verdictColor(VerdictLevel level) => switch (level) {
      VerdictLevel.recommend => AppColors.verdictRecommend,
      VerdictLevel.caution => AppColors.verdictCaution,
      VerdictLevel.risk => AppColors.verdictDanger,
      VerdictLevel.unknown => AppColors.verdictUnknown,
    };

/// "＋ 같이 먹은 음식이 있나요?" 행.
class _AddFoodRow extends StatelessWidget {
  const _AddFoodRow({required this.onAddFood});

  final VoidCallback? onAddFood;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddFood,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          const Icon(Icons.add, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '같이 먹은 음식이 있나요?',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// single 타일
// ---------------------------------------------------------------------------

class _SingleMealCard extends StatelessWidget {
  const _SingleMealCard({
    required this.item,
    this.onTap,
    this.onAddFood,
  });

  final TimelineSingle item;
  final VoidCallback? onTap;
  final VoidCallback? onAddFood;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  '먹은 음식 · ${_formatTime(item.mealRecordDateTime)}',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (onTap != null) ...[
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
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  CategoryIcon(code: item.categoryCode, size: 32),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      item.mealFoodName,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    item.grade.label,
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: _verdictColor(item.grade),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.sectionGap,
            color: AppColors.divider,
            thickness: 0.5,
          ),
          _AddFoodRow(onAddFood: onAddFood),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// group 타일
// ---------------------------------------------------------------------------

class _GroupMealCard extends StatelessWidget {
  const _GroupMealCard({
    required this.item,
    this.onTap,
    this.onAddFood,
  });

  final TimelineGroup item;
  final VoidCallback? onTap;
  final VoidCallback? onAddFood;

  /// 대표음식 + "외 N개" 요약.
  String _summary() {
    final names = item.representativeFoods.join(', ');
    if (item.etcCount > 0) {
      return names.isEmpty ? '외 ${item.etcCount}개' : '$names 외 ${item.etcCount}개';
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  '먹은 음식 · ${_formatTime(item.mealRecordDateTime)}',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (onTap != null) ...[
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
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  CategoryIcon(code: item.categoryCode, size: 32),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      _summary(),
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.sectionGap,
            color: AppColors.divider,
            thickness: 0.5,
          ),
          _AddFoodRow(onAddFood: onAddFood),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// symptom 타일
// ---------------------------------------------------------------------------
// NOTE(W5-4 탭 보류): TimelineSymptom 에 symptomId 가 없어 상세 진입 불가.
// 서버 GET /timeline?date= 의 symptom 변형이 symptomId 를 포함하지 않는다.
// 서버 계약이 symptomId 를 추가하면 _SymptomCard 에 onTap→context.push('/symptom/:id') 연결.

class _SymptomCard extends StatelessWidget {
  const _SymptomCard({required this.item});

  final TimelineSymptom item;

  /// 식후 경과 분 → "식후 N분".
  String _afterMealLabel(int minutes) {
    if (minutes < 60) return '식후 $minutes분';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '식후 $h시간' : '식후 $h시간 $m분';
  }

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        children: [
          const Text('🩺', style: TextStyle(fontSize: 18, height: 1.0)),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.symptomState.label,
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${_afterMealLabel(item.afterMealMinutes)} · ${_formatTime(item.occurredAt)}',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
