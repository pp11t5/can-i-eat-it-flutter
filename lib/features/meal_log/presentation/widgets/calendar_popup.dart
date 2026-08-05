import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_nav.dart'
    show monthNavLabel;

/// 캘린더 팝업 (Figma node 2757:23521).
///
/// [initialMonth]: 팝업 오픈 시 표시할 월 (연/월만 사용).
/// [initialSelectedDate]: 팝업 오픈 시 프리셀렉트할 날짜 (보통 타임라인 선택일).
/// [today]: 오늘 표시 기준 (외부 주입 — 테스트·골든 결정성).
/// [minDate]: 선택 가능 하한(가입일). null 이면 하한 없음.
///   - 가입일 이전 셀: 회색 박스 + 탭 불가
///   - 가입월보다 이전으로 `<` 월이동 불가 (chevron = [AppColors.controlDisabled])
///   - 오늘 월보다 이후로 `>` 월이동 불가 (chevron gray60)
///
/// 반환값: "확인" 탭 시 선택된 날짜, "취소"·바깥탭 시 null.
/// 호출부는 null 이 아니면 선택일 반영 + 타임라인 재조회를 수행한다.
Future<DateTime?> showCalendarPopup(
  BuildContext context, {
  required DateTime initialMonth,
  required DateTime initialSelectedDate,
  required DateTime today,
  DateTime? minDate,
}) {
  return showDialog<DateTime>(
    context: context,
    // Figma 실측: rgba(0,0,0,0.35). barrierDismissible 기본값(true)은 그대로
    // 두어 바깥 탭으로도 닫히게 한다(취소와 동일하게 null 반환).
    barrierColor: const Color(0x59000000),
    builder: (dialogContext) => _CalendarPopup(
      initialMonth: initialMonth,
      initialSelectedDate: initialSelectedDate,
      today: today,
      minDate: minDate == null
          ? null
          : DateTime(minDate.year, minDate.month, minDate.day),
    ),
  );
}

class _CalendarPopup extends StatefulWidget {
  const _CalendarPopup({
    required this.initialMonth,
    required this.initialSelectedDate,
    required this.today,
    this.minDate,
  });

  final DateTime initialMonth;
  final DateTime initialSelectedDate;
  final DateTime today;
  final DateTime? minDate;

  @override
  State<_CalendarPopup> createState() => _CalendarPopupState();
}

class _CalendarPopupState extends State<_CalendarPopup> {
  late DateTime _month; // DateTime(year, month, 1)
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _month = DateTime(widget.initialMonth.year, widget.initialMonth.month, 1);
    _selected = _clampToMin(widget.initialSelectedDate);

    // 가입월보다 이전 월로 열리면 가입월로 클램프.
    final min = widget.minDate;
    if (min != null) {
      final minMonth = DateTime(min.year, min.month, 1);
      if (_month.isBefore(minMonth)) {
        _month = minMonth;
      }
    }
    // 오늘 월보다 이후 월로 열리면 오늘 월로 클램프.
    final maxMonth = DateTime(widget.today.year, widget.today.month, 1);
    if (_month.isAfter(maxMonth)) {
      _month = maxMonth;
    }
  }

  DateTime _clampToMin(DateTime day) {
    final min = widget.minDate;
    if (min == null) return day;
    final d = DateTime(day.year, day.month, day.day);
    return d.isBefore(min) ? min : d;
  }

  bool get _canGoPrev {
    final min = widget.minDate;
    if (min == null) return true;
    final minMonth = DateTime(min.year, min.month, 1);
    return _month.isAfter(minMonth);
  }

  /// 오늘 월보다 이전이면 true — 다음 달 이동 가능.
  bool get _canGoNext {
    final maxMonth = DateTime(widget.today.year, widget.today.month, 1);
    return _month.isBefore(maxMonth);
  }

  void _prevMonth() {
    if (!_canGoPrev) return;
    setState(() => _month = DateTime(_month.year, _month.month - 1, 1));
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    setState(() => _month = DateTime(_month.year, _month.month + 1, 1));
  }

  void _selectDay(DateTime day) {
    // 그리드 onTap 이 선택 가능한 날짜만 전달한다.
    setState(() => _selected = day);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Container(
        width: 306,
        height: 379,
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          // TODO(token): radius 24는 현재 AppSpacing/RadiusPrimitives에 없는
          // 값 — 이 카드 전용 raw literal 사용(디자이너 확정 시 토큰화).
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CalendarHeader(
              label: monthNavLabel(_month),
              onPrev: _canGoPrev ? _prevMonth : null,
              onNext: _canGoNext ? _nextMonth : null,
            ),
            const SizedBox(height: AppSpacing.itemGap * 2), // gap 16
            Expanded(
              child: _CalendarGrid(
                month: _month,
                selected: _selected,
                today: widget.today,
                minDate: widget.minDate,
                onDayTap: _selectDay,
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap * 2), // gap 16
            _CalendarFooter(
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () => Navigator.of(context).pop(_selected),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 헤더 — "YYYY년 M월" + 우측 chevron 월이동
// ---------------------------------------------------------------------------

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;

  /// null 이면 이전 달 이동 불가 — chevron 색 [AppColors.controlDisabled].
  final VoidCallback? onPrev;

  /// null 이면 다음 달 이동 불가 — chevron 색 [AppColors.controlDisabled].
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final prevEnabled = onPrev != null;
    final nextEnabled = onNext != null;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body1Bold.copyWith(
              color: const Color(0xFF293050), // Figma 실측
            ),
          ),
        ),
        IconButton(
          onPressed: onPrev,
          icon: AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s32,
            color: prevEnabled
                ? AppColors.textPrimary
                : AppColors.controlDisabled,
            semanticsLabel: '이전 달',
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onNext,
          icon: AppIcon(
            AppIcons.chevronRight,
            size: AppIconSizes.s32,
            color: nextEnabled
                ? AppColors.textPrimary
                : AppColors.controlDisabled,
            semanticsLabel: '다음 달',
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 그리드 — 7열×6행
// ---------------------------------------------------------------------------

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.selected,
    required this.today,
    required this.onDayTap,
    this.minDate,
  });

  final DateTime month;
  final DateTime selected;
  final DateTime today;
  final DateTime? minDate;
  final ValueChanged<DateTime> onDayTap;

  static const _weekdayHeaders = ['일', '월', '화', '수', '목', '금', '토'];

  /// 요일 열 색 (Figma 2794-26223): 일(0)=빨강, 토(6)=파랑, 평일=textPrimary(#1A1A1F).
  static Color _columnColor(int columnIndex) {
    if (columnIndex == 0) return AppColors.calendarSunday;
    if (columnIndex == 6) return AppColors.calendarSaturday;
    return AppColors.textPrimary;
  }

  /// 표시월 그리드용 42(7×6)일 목록 — 일요일 시작.
  /// 전/후월 칸은 자리만 맞추고 표시하지 않는다(null).
  List<DateTime?> _buildGridDays() {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final leadingCount = firstOfMonth.weekday % 7; // Sun=0, Mon=1 ... Sat=6
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = List<DateTime?>.filled(42, null);
    for (var d = 1; d <= daysInMonth; d++) {
      cells[leadingCount + d - 1] = DateTime(month.year, month.month, d);
    }
    return cells;
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final days = _buildGridDays();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var i = 0; i < _weekdayHeaders.length; i++)
              Expanded(
                child: Center(
                  child: Text(
                    _weekdayHeaders[i],
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: _columnColor(i),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 5,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              // 전/후월 칸 — 빈 셀 (해당 월 날짜만 표시).
              if (day == null) {
                return const SizedBox.shrink();
              }

              final columnIndex = index % 7; // 0=일 ... 6=토
              final isSelected = _isSameDay(day, selected);
              final isToday = _isSameDay(day, today);
              final dayDate = DateTime(day.year, day.month, day.day);
              final min = minDate;
              final isBeforeJoin =
                  min != null && dayDate.isBefore(min);

              // 가입일 이상만 선택 가능.
              final selectable = !isBeforeJoin;

              // 색·배경:
              //  선택 = 흰 글씨 + green 라운드사각 r8.
              //  가입일 이전 = 회색 글씨 + 연회색 라운드 배경(#F5F5F5), 탭 불가.
              //  그 외 = 요일 열 색.
              Color textColor;
              BoxDecoration? decoration;
              if (isSelected) {
                textColor = AppColors.onPrimary;
                decoration = BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                );
              } else if (isBeforeJoin) {
                textColor = AppColors.textTertiary;
                decoration = BoxDecoration(
                  color: AppColors.surfaceMuted, // #F5F5F5
                  borderRadius: BorderRadius.circular(8),
                );
              } else {
                textColor = _columnColor(columnIndex);
              }

              // 오늘 셀은 숫자 대신 "오늘".
              final showToday = isToday;

              return GestureDetector(
                onTap: selectable ? () => onDayTap(day) : null,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: decoration,
                    alignment: Alignment.center,
                    child: Text(
                      showToday ? '오늘' : '${day.day}',
                      style: AppTextStyles.caption1Medium
                          .copyWith(color: textColor),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 하단 취소/확인 버튼
// ---------------------------------------------------------------------------

class _CalendarFooter extends StatelessWidget {
  const _CalendarFooter({required this.onCancel, required this.onConfirm});

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: const Color(0xFF8C8C99),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
            ),
            child: Text(
              '취소',
              style: AppTextStyles.body2Bold
                  .copyWith(color: const Color(0xFF8C8C99)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
            ),
            child: Text(
              '확인',
              style:
                  AppTextStyles.body2Bold.copyWith(color: AppColors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
