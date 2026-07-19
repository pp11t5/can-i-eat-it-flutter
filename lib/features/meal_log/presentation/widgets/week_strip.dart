import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 횡스크롤 월 캘린더 (구 WeekStrip 고정 7칸 Row → 해당월 1일~말일 단일행).
///
/// Figma node 2756:22501:
/// - 카드: bg surface(흰), stroke `#EAEAEA`(=[AppColors.border]) 1px, radius 16,
///   기존 shadow([AppColors.weekStripShadow]) 유지, padding 세로 16 가로 0.
/// - `ListView.separated`(가로 스크롤), itemCount=해당월 일수. `LayoutBuilder`로
///   뷰포트 가용폭을 받아 셀 폭 = `(viewportWidth - gap*6) / 7`로 계산 —
///   한 화면에 정확히 7칸이 맞고 나머지는 횡스크롤. 칸 간 gap 8.
/// - 진입/월변경/선택일변경 시 대상일이 뷰포트 "가운데"에 오도록 스크롤
///   (`offset = index*(cellWidth+gap) - (viewportWidth-cellWidth)/2`,
///   0~maxScrollExtent로 clamp — 월초/월말에서 자동으로 가장자리 정렬).
/// - DayCell(기존 스타일 유지): 요일(일=빨강, 그외 secondary, 오늘칸="오늘") /
///   날짜 숫자(기본 secondary, 미래 `#BBBBBB`) / 도트(최대 3, VerdictLevel 색상).
///   선택일 = 검정 세로 캡슐(`#222222`) + 흰 텍스트.
///
/// [visibleMonth]: 현재 표시 중인 월 (연/월만 사용, day 무시).
/// [selectedDate]: 현재 선택된 날짜.
/// [today]: 오늘 날짜 (결정적 렌더를 위해 외부 주입 — 테스트·골든에서 고정값 사용).
/// [dotsByDate]: 날짜별 도트 색상 목록 (최대 3개씩 표시).
/// [onDaySelected]: 날짜 탭 콜백.
class WeekStrip extends StatefulWidget {
  const WeekStrip({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.today,
    this.dotsByDate = const {},
    required this.onDaySelected,
  });

  /// 현재 표시 중인 월 (연/월만 사용).
  final DateTime visibleMonth;

  /// 현재 선택된 날짜.
  final DateTime selectedDate;

  /// 오늘 날짜 (외부 주입 — KST 오늘 또는 테스트 고정값).
  final DateTime today;

  /// 날짜별 도트 VerdictLevel 목록.
  ///
  /// key: DateTime(year, month, day) 정규화 값.
  /// value: 해당 날짜의 기록 판정 목록 (최대 3개 표시).
  final Map<DateTime, List<VerdictLevel>> dotsByDate;

  /// 날짜 탭 콜백.
  final ValueChanged<DateTime> onDaySelected;

  @override
  State<WeekStrip> createState() => _WeekStripState();
}

class _WeekStripState extends State<WeekStrip> {
  final ScrollController _scrollController = ScrollController();

  static const double _cellGap = 8;
  static const List<String> _dayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  /// 가장 최근 LayoutBuilder가 보고한 뷰포트(가로 스크롤 영역) 가용 폭.
  ///
  /// 셀 폭 계산과 [_scrollToTarget]의 가운데 정렬 계산이 이 값을 공유한다.
  double? _viewportWidth;

  /// 뷰포트 폭 기준 셀 폭 — 정확히 7칸 + gap 6개가 한 화면에 맞도록 계산.
  double _cellWidthFor(double viewportWidth) =>
      (viewportWidth - _cellGap * 6) / 7;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
  }

  @override
  void didUpdateWidget(covariant WeekStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final monthChanged = oldWidget.visibleMonth.year != widget.visibleMonth.year ||
        oldWidget.visibleMonth.month != widget.visibleMonth.month;
    final selectedChanged = !_isSameDay(oldWidget.selectedDate, widget.selectedDate);
    if (monthChanged || selectedChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 초기/월변경/선택일변경 시 스크롤 정렬 대상일 — 선택일이 이 달이면 선택일,
  /// 아니면 오늘이 이 달이면 오늘, 둘 다 아니면 1일.
  int _targetDay() {
    final month = widget.visibleMonth;
    if (widget.selectedDate.year == month.year &&
        widget.selectedDate.month == month.month) {
      return widget.selectedDate.day;
    }
    if (widget.today.year == month.year && widget.today.month == month.month) {
      return widget.today.day;
    }
    return 1;
  }

  /// 대상 날짜가 뷰포트 "가운데"에 오도록 스크롤 (월초/월말 등 가운데 정렬이
  /// 불가능한 경계에서는 clamp가 자동으로 가장자리에 맞춘다).
  void _scrollToTarget() {
    if (!mounted || !_scrollController.hasClients) return;
    final viewportWidth = _viewportWidth;
    if (viewportWidth == null) return;
    final cellWidth = _cellWidthFor(viewportWidth);
    final index = _targetDay() - 1;
    final offset =
        index * (cellWidth + _cellGap) - (viewportWidth - cellWidth) / 2;
    final maxExtent = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(offset.clamp(0.0, maxExtent));
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateUtils.getDaysInMonth(widget.visibleMonth.year, widget.visibleMonth.month);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border), // Figma 실측 #EAEAEA
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal), // 16
        boxShadow: const [
          BoxShadow(
            color: AppColors.weekStripShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      // Figma 실측: padding 세로 16, 가로 0 (ListView가 가로 스크롤 여백을 담당).
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap * 2),
      // TODO(figma): 정확한 카드 높이 실측 필요 — 요일라벨+날짜숫자+도트행 기준 임시값.
      child: SizedBox(
        height: 88,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportWidth = constraints.maxWidth;
            final cellWidth = _cellWidthFor(viewportWidth);
            // 뷰포트 폭이 처음 확정되거나 바뀌면(회전 등) 정렬을 다시 계산한다.
            if (_viewportWidth != viewportWidth) {
              _viewportWidth = viewportWidth;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToTarget());
            }

            return ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: daysInMonth,
              separatorBuilder: (_, __) => const SizedBox(width: _cellGap),
              itemBuilder: (context, index) {
                final day = DateTime(
                  widget.visibleMonth.year,
                  widget.visibleMonth.month,
                  index + 1,
                );
                final isSelected = _isSameDay(day, widget.selectedDate);
                final isToday = _isSameDay(day, widget.today);
                final isFuture = _isAfterDay(day, widget.today);
                final isSunday = day.weekday == DateTime.sunday;
                final dots = widget.dotsByDate[
                        DateTime(day.year, day.month, day.day)] ??
                    [];
                final label = isToday ? '오늘' : _dayLabels[day.weekday % 7];

                return SizedBox(
                  width: cellWidth,
                  child: _DayCell(
                    dayLabel: label,
                    dayNumber: day.day,
                    isSelected: isSelected,
                    isSunday: isSunday,
                    isFuture: isFuture,
                    dots: dots.take(3).toList(),
                    onTap: () => widget.onDaySelected(day),
                  ),
                );
              },
            );
          },
        ),
      ),
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

/// 캘린더 개별 날짜 칸 (기존 WeekStrip _DayCell 스타일 유지).
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
  /// 선택일 라벨은 검정 캡슐 안에 놓이므로 흰색(surface)이 최우선.
  /// 그 외 우선순위: 미래(회색) < 일요일(빨강) < 기본(secondary).
  Color _labelColor() {
    if (isSelected) return AppColors.surface; // 선택 캡슐 안 흰색
    if (isFuture) return AppColors.textSecondary; // 미래에도 요일 라벨은 회색 유지
    if (isSunday) return AppColors.calendarSunday;
    return AppColors.textSecondary;
  }

  /// 날짜 숫자 색상 결정.
  Color _numberColor() {
    if (isSelected) return AppColors.surface; // 캡슐 안 흰색
    if (isFuture) return const Color(0xFFBBBBBB); // Figma 실측: 미래 날짜 숫자
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    // 선택일은 요일+숫자+도트를 감싸는 검정 세로 캡슐(흰 텍스트).
    // 숫자만 감싸는 원형이 아니다.
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.itemGap,
          horizontal: 4,
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
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
            // 날짜 숫자
            Text(
              '$dayNumber',
              style: AppTextStyles.body1Bold.copyWith(color: _numberColor()),
            ),
            const SizedBox(height: AppSpacing.xs),
            // 도트 (최대 3개)
            _DotRow(dots: dots),
          ],
        ),
      ),
    );
  }
}

/// 도트 행 — VerdictLevel 색상 최대 3개.
class _DotRow extends StatelessWidget {
  const _DotRow({required this.dots});

  final List<VerdictLevel> dots;

  static const double _dotSize = 8.0;
  static const double _dotGap = 3.0;

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
