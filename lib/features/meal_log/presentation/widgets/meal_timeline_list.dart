import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';

/// 타임라인 리스트 위젯 — 왼쪽 수직 스파인 + 시간대 배지 + 변형별 타일.
///
/// [TimelineItem] sealed union(single/group/symptom)을 변형별로 렌더한다.
/// - single: 음식 1개짜리 식사 (음식명 + grade 배지 + 연결증상 카드).
/// - group: 음식 2개 이상짜리 식사 (대표음식 + "외 N개" + 연결증상 카드).
/// - symptom: 증상 기록 (symptomId 있으면 탭 가능 → 증상 상세).
///
/// 스파인 배지는 Figma 에셋(자체완결 원형): 증상은 `checklist`, 식사는
/// [TimelineItem.timeIcon] 우선(sun/moon), 없으면 hour 휴리스틱(주간=sun/야간=moon).
///
/// [items]: 표시할 타임라인 항목 목록 (비어있지 않아야 함).
/// [onTapMeal]: single/group 타일 탭 콜백 (식사 상세 진입).
/// [onAddFood]: single/group 타일 "+음식 추가" 콜백 (mealRecordId, 기존 식사 섭취시각).
/// [onTapSymptom]: 증상 행 또는 연결증상 카드 탭 콜백 (증상 상세 진입, symptomId).
class MealTimelineList extends StatelessWidget {
  const MealTimelineList({
    super.key,
    required this.items,
    this.onTapMeal,
    this.onAddFood,
    this.onTapSymptom,
  });

  final List<TimelineItem> items;

  /// single/group 타일 탭 → 식사 상세(mealRecordId).
  final void Function(String mealRecordId)? onTapMeal;

  /// single/group 타일 "+음식 추가" → 기존 식사에 추가(mealRecordId, mealRecordDateTime).
  final void Function(String mealRecordId, String mealRecordDateTime)?
      onAddFood;

  /// 증상 행/연결증상 카드 탭 → 증상 상세(symptomId).
  final void Function(String symptomId)? onTapSymptom;

  /// ISO-8601 문자열 → 시(hour).
  static int _hourOf(String isoString) {
    try {
      return parseKst(isoString).hour;
    } catch (_) {
      return 12;
    }
  }

  /// 항목별 시간대 hour 추출.
  static int _itemHour(TimelineItem item) => switch (item) {
        TimelineSingle(:final mealRecordDateTime) =>
          _hourOf(mealRecordDateTime),
        TimelineGroup(:final mealRecordDateTime) => _hourOf(mealRecordDateTime),
        TimelineSymptom(:final occurredAt) => _hourOf(occurredAt),
      };

  /// 스파인 배지 에셋 — 증상은 checklist, 식사는 timeIcon 우선(sun/moon),
  /// 없으면 hour 휴리스틱(주간=sun / 야간=moon). Figma Component 1 세트 정합.
  static String _resolveBadge(TimelineItem item) {
    if (item is TimelineSymptom) return AppIcons.recordChecklist;
    final timeIcon = switch (item) {
      TimelineSingle(:final timeIcon) => timeIcon,
      TimelineGroup(:final timeIcon) => timeIcon,
      TimelineSymptom() => null,
    };
    return switch (timeIcon) {
      TimeIcon.sun => AppIcons.mealSun,
      TimeIcon.moon => AppIcons.mealMoon,
      null => _itemHour(item) < 18 ? AppIcons.mealSun : AppIcons.mealMoon,
    };
  }

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
        final badge = _resolveBadge(item);

        final Widget card = switch (item) {
          TimelineSingle() => _SingleMealCard(
              item: item,
              onTap: onTapMeal != null
                  ? () => onTapMeal!(item.mealRecordId)
                  : null,
              onAddFood: onAddFood != null
                  ? () => onAddFood!(item.mealRecordId, item.mealRecordDateTime)
                  : null,
              onTapSymptom: onTapSymptom,
            ),
          TimelineGroup() => _GroupMealCard(
              item: item,
              onTap: onTapMeal != null
                  ? () => onTapMeal!(item.mealRecordId)
                  : null,
              onAddFood: onAddFood != null
                  ? () => onAddFood!(item.mealRecordId, item.mealRecordDateTime)
                  : null,
              onTapSymptom: onTapSymptom,
            ),
          TimelineSymptom() => _SymptomCard(
              item: item,
              onTap: (onTapSymptom != null && item.symptomId != null)
                  ? () => onTapSymptom!(item.symptomId!)
                  : null,
            ),
        };

        return _TimelineRow(badgeAsset: badge, isLast: isLast, child: card);
      },
    );
  }
}

/// 타임라인 행 — 스파인(배지 + 라인) + 오른쪽 카드.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.badgeAsset,
    required this.isLast,
    required this.child,
  });

  /// 스파인 배지 SVG 경로(자체완결 원형, 원본색 유지).
  final String badgeAsset;
  final bool isLast;
  final Widget child;

  static const double _iconContainerSize = 32.0;
  static const double _spineWidth = 1.5;
  static const double _rowGap = 16.0; // Figma 실측: 스파인 배지 ↔ 카드 가로 gap

  @override
  Widget build(BuildContext context) {
    // 스파인 라인 연속화: 세로 gap(16px)을 오른쪽 카드 쪽 Padding으로 흡수시켜
    // IntrinsicHeight 행 높이 = 카드 + gap 이 되게 하고, 왼쪽 라인이 그 전체
    // 높이를 채워 다음 배지 상단까지 끊김 없이 이어지도록 한다.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _iconContainerSize,
            child: Column(
              children: [
                // 자체완결 원형 배지(32×32) — 별도 회색 래퍼 없이 직접 렌더.
                AppIcon(badgeAsset, size: AppIconSizes.s32),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: _spineWidth,
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: _rowGap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: isLast ? 0 : 16), // Figma 실측: 아이템 세로 gap
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 공통 카드 셸
// ---------------------------------------------------------------------------

/// 흰 카드(radius, 은은한 그림자) 셸.
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, this.color = AppColors.surface});

  final Widget child;

  /// 카드 배경색 — 식사 카드는 흰색(기본값), 증상 단독 카드는 회색.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.weekStripShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 1,
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

/// 식사 대비 경과 분 → 표시 레이블 (_SymptomCard·_ConnectedSymptomsSection 공유).
///
/// 음수 → "식사 전 N분/시간", 0 이상 → "식후 N분/시간".
String _afterMealLabel(int minutes) {
  if (minutes < 0) {
    return _formatRelativeMinutes(minutes.abs(), prefix: '식사 전');
  }
  return _formatRelativeMinutes(minutes, prefix: '식후');
}

String _formatRelativeMinutes(int minutes, {required String prefix}) {
  if (minutes < 60) return '$prefix $minutes분';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$prefix $h시간' : '$prefix $h시간 $m분';
}

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
          const AppIcon(
            AppIcons.plus,
            size: AppIconSizes.s16,
            color: AppColors.textSecondary,
            semanticsLabel: '음식 추가',
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Text(
            '같이 먹은 음식이 있나요?',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 식사 카드 하단의 연결증상 섹션 — 대표증상 요약 + "식후 N분".
///
/// 음식 정보와는 구분선으로 나누되, 외곽 테두리는 식사 카드와 공유한다.
/// 따라서 별도 카드처럼 보이지 않고 이미지 레퍼런스처럼 카드의 하단 영역을
/// 온전히 차지한다.
class _ConnectedSymptomsSection extends StatelessWidget {
  const _ConnectedSymptomsSection({
    required this.connectedSymptoms,
    this.onTap,
  });

  final ConnectedSymptoms connectedSymptoms;
  final VoidCallback? onTap;

  /// 대표증상 + "외 N개" 요약.
  ///
  /// 증상 유형이 비어 있으면("없음" 선택) 상세 화면과 동일 문구를 쓴다.
  String _summary() {
    final names = connectedSymptoms.representativeSymptoms.join(', ');
    if (names.isEmpty && connectedSymptoms.etcCount == 0) {
      return '특별한 불편이 없었어요';
    }
    if (connectedSymptoms.etcCount > 0) {
      return names.isEmpty
          ? '외 ${connectedSymptoms.etcCount}개'
          : '$names 외 ${connectedSymptoms.etcCount}개';
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        color: AppColors.surfaceBackground,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _summary(),
                    style: AppTextStyles.body2Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _afterMealLabel(connectedSymptoms.afterMealMinutes),
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const AppIcon(
                AppIcons.chevronRight,
                size: AppIconSizes.s16,
                color: AppColors.textTertiary,
                semanticsLabel: '증상 상세',
              ),
          ],
        ),
      ),
    );
  }
}

/// 식사 정보와 연결증상을 한 외곽 카드로 묶는다.
///
/// 연결증상이 있을 때만 하단을 별도 회색 섹션으로 렌더한다. 음식 영역은 기존과
/// 같은 여백을 유지하고, 증상은 음식 카드 안의 중첩 카드가 아닌 하단 패널이 된다.
class _MealCardShell extends StatelessWidget {
  const _MealCardShell({
    required this.child,
    this.connectedSymptoms,
    this.onTapSymptom,
  });

  final Widget child;
  final ConnectedSymptoms? connectedSymptoms;
  final VoidCallback? onTapSymptom;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.weekStripShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
          if (connectedSymptoms case final symptoms?) ...[
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            _ConnectedSymptomsSection(
              connectedSymptoms: symptoms,
              onTap: onTapSymptom,
            ),
          ],
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
    this.onTapSymptom,
  });

  final TimelineSingle item;
  final VoidCallback? onTap;
  final VoidCallback? onAddFood;

  /// 연결증상 카드 탭 → 증상 상세(symptomId).
  final void Function(String symptomId)? onTapSymptom;

  @override
  Widget build(BuildContext context) {
    return _MealCardShell(
      connectedSymptoms: item.connectedSymptoms,
      onTapSymptom: onTapSymptom != null && item.connectedSymptoms != null
          ? () => onTapSymptom!(item.connectedSymptoms!.symptomId)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              '먹은 음식 · ${_formatTime(item.mealRecordDateTime)}',
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CategoryIcon(code: item.categoryCode, size: 32),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      item.mealFoodName,
                      style: AppTextStyles.body2Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    item.grade.label,
                    style: AppTextStyles.body2Medium.copyWith(
                      color: _verdictColor(item.grade),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const AppIcon(
                    AppIcons.chevronRight,
                    size: AppIconSizes.s16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
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
    this.onTapSymptom,
  });

  final TimelineGroup item;
  final VoidCallback? onTap;
  final VoidCallback? onAddFood;

  /// 연결증상 카드 탭 → 증상 상세(symptomId).
  final void Function(String symptomId)? onTapSymptom;

  /// 대표음식 + "외 N개" 요약.
  String _summary() {
    final names = item.representativeFoods.join(', ');
    if (item.etcCount > 0) {
      return names.isEmpty
          ? '외 ${item.etcCount}개'
          : '$names 외 ${item.etcCount}개';
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return _MealCardShell(
      connectedSymptoms: item.connectedSymptoms,
      onTapSymptom: onTapSymptom != null && item.connectedSymptoms != null
          ? () => onTapSymptom!(item.connectedSymptoms!.symptomId)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              '먹은 음식 · ${_formatTime(item.mealRecordDateTime)}',
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CategoryIcon(code: item.categoryCode, size: 32),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      _summary(),
                      style: AppTextStyles.body2Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const AppIcon(
                    AppIcons.chevronRight,
                    size: AppIconSizes.s16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          _AddFoodRow(onAddFood: onAddFood),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// symptom 타일
// ---------------------------------------------------------------------------
// symptomId 가 있으면 탭 가능 → 증상 상세(구 페이로드 방어를 위해 nullable,
// symptomId 없는 항목은 onTap 이 null 로 전달되어 탭 불가).

class _SymptomCard extends StatelessWidget {
  const _SymptomCard({required this.item, this.onTap});

  final TimelineSymptom item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      color: AppColors.surfaceBackground,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '증상 기록 · ${_formatTime(item.occurredAt)}',
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.symptomState.label,
                    style: AppTextStyles.body2Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _afterMealLabel(item.afterMealMinutes),
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const AppIcon(
                AppIcons.chevronRight,
                size: AppIconSizes.s16,
                color: AppColors.textTertiary,
                semanticsLabel: '증상 상세',
              ),
          ],
        ),
      ),
    );
  }
}
