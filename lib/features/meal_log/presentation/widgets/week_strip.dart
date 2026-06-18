import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 주간 날짜 스트립 (일~토 7칸).
///
/// Figma node 1351-14768:
/// - 각 칸: 요일(일~토) + 날짜 숫자. 오늘 칸은 요일 라벨을 "오늘"로 치환.
/// - 선택일: 검정 원형 배지 + 흰 텍스트 강조.
/// - 일요일 요일 라벨: [AppColors.calendarSunday] (빨강).
/// - 미래 날짜(today 이후): 요일라벨·숫자 모두 [AppColors.textTertiary] (회색).
/// - 각 칸 하단 도트(Ellipse) 최대 3개 — 당일 기록의 VerdictLevel 색상.
///
/// [weekStart]: 해당 주 일요일 날짜.
/// [selectedDate]: 현재 선택된 날짜.
/// [today]: 오늘 날짜 (결정적 렌더를 위해 외부 주입 — 테스트·골든에서 고정값 사용).
/// [dotsByDate]: 날짜별 도트 색상 목록 (최대 3개씩 표시).
/// [onDaySelected]: 날짜 탭 콜백.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.weekStart,
    required this.selectedDate,
    required this.today,
    this.dotsByDate = const {},
    required this.onDaySelected,
  });

  /// 해당 주 일요일 날짜.
  final DateTime weekStart;

  /// 현재 선택된 날짜.
  final DateTime selectedDate;

  /// 오늘 날짜 (외부 주입 — KST 오늘 또는 테스트 고정값).
  final DateTime today;

  /// 날짜별 도트 VerdictLevel 목록.
  ///
  /// key: DateTime(year, month, day) 정규화 값.
  /// value: 해당 날짜의 기록 판정 목록 (최대 3개 표시).
  ///
  /// // TODO(server): 주간 집계EP 확인 후 7일 도트 연동 [figma:1351-14768]
  final Map<DateTime, List<VerdictLevel>> dotsByDate;

  /// 날짜 탭 콜백.
  final ValueChanged<DateTime> onDaySelected;

  static const _dayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isSelected = _isSameDay(day, selectedDate);
        final isToday = _isSameDay(day, today);
        final isFuture = _isAfterDay(day, today);
        final isSunday = i == 0;
        final dots = dotsByDate[DateTime(day.year, day.month, day.day)] ?? [];

        // 요일 라벨: 오늘이면 "오늘", 아니면 요일명
        final label = isToday ? '오늘' : _dayLabels[i];

        return _DayCell(
          dayLabel: label,
          dayNumber: day.day,
          isSelected: isSelected,
          isSunday: isSunday,
          isFuture: isFuture,
          dots: dots.take(3).toList(),
          onTap: () => onDaySelected(day),
        );
      }),
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// day 가 today 보다 미래인지 (today 당일은 false).
  static bool _isAfterDay(DateTime day, DateTime today) {
    final d = DateTime(day.year, day.month, day.day);
    final t = DateTime(today.year, today.month, today.day);
    return d.isAfter(t);
  }
}

/// 주간 스트립 개별 날짜 칸.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.dayLabel,
    required this.dayNumber,
    required this.isSelected,
    required this.isSunday,
    required this.isFuture,
    required this.dots,
    required this.onTap,
  });

  final String dayLabel;
  final int dayNumber;
  final bool isSelected;
  final bool isSunday;
  final bool isFuture;
  final List<VerdictLevel> dots;
  final VoidCallback onTap;

  /// 요일 라벨 색상 결정.
  ///
  /// 우선순위: 선택(배지 안 흰색) < 미래(회색) < 일요일(빨강) < 기본(secondary)
  /// 선택일 라벨은 배지 바깥에 있으므로 isSelected 시 textPrimary 유지.
  Color _labelColor() {
    if (isFuture) return AppColors.textTertiary;
    if (isSunday) return AppColors.calendarSunday;
    return AppColors.textSecondary;
  }

  /// 날짜 숫자 색상 결정.
  Color _numberColor() {
    if (isSelected) return AppColors.surface; // 배지 안 흰색
    if (isFuture) return AppColors.textTertiary;
    return AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 요일 라벨 (또는 "오늘")
          Text(
            dayLabel,
            style: AppTextStyles.caption1Medium.copyWith(
              color: _labelColor(),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // 날짜 숫자 (선택 시 검정 원형 배경)
          _DayBadge(dayNumber: dayNumber, isSelected: isSelected, numberColor: _numberColor()),
          const SizedBox(height: AppSpacing.xs),
          // 도트 (최대 3개)
          _DotRow(dots: dots),
        ],
      ),
    );
  }
}

/// 날짜 숫자 배지 — 선택 시 검정 원형 배경 + 흰 텍스트.
class _DayBadge extends StatelessWidget {
  const _DayBadge({
    required this.dayNumber,
    required this.isSelected,
    required this.numberColor,
  });

  final int dayNumber;
  final bool isSelected;
  final Color numberColor;

  static const double _size = 32.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: isSelected
          ? const BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            )
          : null,
      alignment: Alignment.center,
      child: Text(
        '$dayNumber',
        style: AppTextStyles.body2Medium.copyWith(color: numberColor),
      ),
    );
  }
}

/// 도트 행 — VerdictLevel 색상 최대 3개.
class _DotRow extends StatelessWidget {
  const _DotRow({required this.dots});

  final List<VerdictLevel> dots;

  static const double _dotSize = 5.0;
  static const double _dotGap = 2.0;

  static Color _colorOf(VerdictLevel level) => switch (level) {
        VerdictLevel.recommend => AppColors.verdictRecommend,
        VerdictLevel.caution => AppColors.verdictCaution,
        VerdictLevel.risk => AppColors.verdictDanger,
        VerdictLevel.unknown => AppColors.verdictUnknown,
      };

  @override
  Widget build(BuildContext context) {
    if (dots.isEmpty) {
      // 도트 없어도 높이 유지 (레이아웃 안정)
      return const SizedBox(height: _dotSize);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < dots.length; i++) ...[
          if (i > 0) const SizedBox(width: _dotGap),
          Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: _colorOf(dots[i]),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}
