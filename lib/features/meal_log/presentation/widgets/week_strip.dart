import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 횡스크롤 **연속** 날짜 스트립 (월 경계로 끊지 않음).
///
/// Figma node 2756:22501:
/// - 카드: bg surface, stroke `#EAEAEA`, radius 16, shadow 유지.
/// - `ListView.separated` 가로 스크롤. 셀 폭 = `(viewport - gap*6)/7` (한 화면 7칸).
/// - **오늘부터** [dayCount]일까지 연속 나열 (월 말→다음 달 1일로 자연 이어짐).
/// - 오늘 이전은 포함하지 않음.
/// - 선택일 변경 시 해당 칸이 뷰포트 가운데로 스크롤.
/// - DayCell: 요일 / 숫자 / 도트. 선택 = 검정 캡슐 + 흰 텍스트.
///
/// [selectedDate]: 현재 선택일 (스크롤 타깃).
/// [today]: 시작 기준일 (외부 주입 — 테스트·골든 결정성).
/// [dayCount]: 오늘 포함 앞으로 몇 일까지 표시 (기본 730 ≈ 2년).
/// [dotsByDate]: 날짜별 도트.
/// [onDaySelected]: 날짜 탭 콜백.
class WeekStrip extends StatefulWidget {
  const WeekStrip({
    super.key,
    required this.selectedDate,
    required this.today,
    this.dayCount = 730,
    this.dotsByDate = const {},
    required this.onDaySelected,
  });

  /// 현재 선택된 날짜.
  final DateTime selectedDate;

  /// 오늘 날짜 (외부 주입 — KST 오늘 또는 테스트 고정값).
  final DateTime today;

  /// 오늘 포함, 앞으로 생성할 일 수 (연속 스크롤 범위).
  final int dayCount;

  /// 날짜별 도트 VerdictLevel 목록.
  ///
  /// key: DateTime(year, month, day) 정규화 값.
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

  double? _viewportWidth;

  DateTime get _startDate => DateTime(
        widget.today.year,
        widget.today.month,
        widget.today.day,
      );

  double _cellWidthFor(double viewportWidth) =>
      (viewportWidth - _cellGap * 6) / 7;

  /// 오늘부터 [dayCount]일 연속 (월 경계 없이 이어짐).
  List<DateTime> _buildDays() {
    final start = _startDate;
    final count = widget.dayCount < 1 ? 1 : widget.dayCount;
    return List.generate(count, (i) => start.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
  }

  @override
  void didUpdateWidget(covariant WeekStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selectedChanged =
        !_isSameDay(oldWidget.selectedDate, widget.selectedDate);
    final todayChanged = !_isSameDay(oldWidget.today, widget.today);
    final countChanged = oldWidget.dayCount != widget.dayCount;
    if (selectedChanged || todayChanged || countChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _targetIndex(List<DateTime> days) {
    if (days.isEmpty) return 0;
    final selectedIdx = days.indexWhere(
      (d) => _isSameDay(d, widget.selectedDate),
    );
    if (selectedIdx >= 0) return selectedIdx;
    // 선택일이 범위 밖(과거 등)이면 시작(오늘)으로.
    return 0;
  }

  void _scrollToTarget() {
    if (!mounted || !_scrollController.hasClients) return;
    final viewportWidth = _viewportWidth;
    if (viewportWidth == null) return;
    final days = _buildDays();
    if (days.isEmpty) return;
    final cellWidth = _cellWidthFor(viewportWidth);
    final index = _targetIndex(days);
    final offset =
        index * (cellWidth + _cellGap) - (viewportWidth - cellWidth) / 2;
    final maxExtent = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(offset.clamp(0.0, maxExtent));
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildDays();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        boxShadow: const [
          BoxShadow(
            color: AppColors.weekStripShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap * 2),
      child: SizedBox(
        height: 88,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportWidth = constraints.maxWidth;
            final cellWidth = _cellWidthFor(viewportWidth);
            if (_viewportWidth != viewportWidth) {
              _viewportWidth = viewportWidth;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToTarget());
            }

            if (days.isEmpty) {
              return const SizedBox.shrink();
            }

            return ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: _cellGap),
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = _isSameDay(day, widget.selectedDate);
                final isToday = _isSameDay(day, widget.today);
                final isSunday = day.weekday == DateTime.sunday;
                final isSaturday = day.weekday == DateTime.saturday;
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
                    isSaturday: isSaturday,
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
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.dayLabel,
    required this.dayNumber,
    required this.isSelected,
    required this.isSunday,
    required this.isSaturday,
    required this.dots,
    required this.onTap,
  });

  final String dayLabel;
  final int dayNumber;
  final bool isSelected;
  final bool isSunday;
  final bool isSaturday;
  final List<VerdictLevel> dots;
  final VoidCallback onTap;

  Color _labelColor() {
    if (isSelected) return AppColors.surface;
    if (isSunday) return AppColors.calendarSunday;
    if (isSaturday) return AppColors.calendarSaturday;
    return AppColors.textSecondary;
  }

  Color _numberColor() {
    if (isSelected) return AppColors.surface;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              dayLabel,
              style: AppTextStyles.caption1Medium.copyWith(
                color: _labelColor(),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$dayNumber',
              style: AppTextStyles.body1Bold.copyWith(color: _numberColor()),
            ),
            const SizedBox(height: AppSpacing.xs),
            _DotRow(dots: dots),
          ],
        ),
      ),
    );
  }
}

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
