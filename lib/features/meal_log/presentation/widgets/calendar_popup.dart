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
/// [today]: 미래일 판별 기준 (외부 주입 — 테스트·골든 결정성).
///
/// 반환값: "확인" 탭 시 선택된 날짜, "취소"·바깥탭 시 null.
/// 호출부는 null 이 아니면 선택일 반영 + 타임라인 재조회를 수행한다.
Future<DateTime?> showCalendarPopup(
  BuildContext context, {
  required DateTime initialMonth,
  required DateTime initialSelectedDate,
  required DateTime today,
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
    ),
  );
}

class _CalendarPopup extends StatefulWidget {
  const _CalendarPopup({
    required this.initialMonth,
    required this.initialSelectedDate,
    required this.today,
  });

  final DateTime initialMonth;
  final DateTime initialSelectedDate;
  final DateTime today;

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
    _selected = widget.initialSelectedDate;
  }

  void _prevMonth() {
    setState(() => _month = DateTime(_month.year, _month.month - 1, 1));
  }

  void _nextMonth() {
    setState(() => _month = DateTime(_month.year, _month.month + 1, 1));
  }

  bool _isFuture(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final t = DateTime(widget.today.year, widget.today.month, widget.today.day);
    return d.isAfter(t);
  }

  void _selectDay(DateTime day) {
    if (_isFuture(day)) return;
    setState(() {
      // 전/후월 날짜를 탭하면 그 달로 이동해 선택한다(일반 캘린더 관행).
      _month = DateTime(day.year, day.month, 1);
      _selected = day;
    });
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
              onPrev: _prevMonth,
              onNext: _nextMonth,
            ),
            const SizedBox(height: AppSpacing.itemGap * 2), // gap 16
            Expanded(
              child: _CalendarGrid(
                month: _month,
                selected: _selected,
                isFuture: _isFuture,
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
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
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
          icon: const AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s32,
            color: AppColors.textPrimary,
            semanticsLabel: '이전 달',
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onNext,
          icon: const AppIcon(
            AppIcons.chevronRight,
            size: AppIconSizes.s32,
            color: AppColors.textPrimary,
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
    required this.isFuture,
    required this.onDayTap,
  });

  final DateTime month;
  final DateTime selected;
  final bool Function(DateTime day) isFuture;
  final ValueChanged<DateTime> onDayTap;

  static const _weekdayHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  /// 표시월 그리드용 42(7×6)일 목록 — 일요일 시작, 전/후월 날짜로 채움.
  List<DateTime> _buildGridDays() {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final leadingCount = firstOfMonth.weekday % 7; // Sun=0, Mon=1 ... Sat=6
    final gridStart = firstOfMonth.subtract(Duration(days: leadingCount));
    return List.generate(42, (i) => gridStart.add(Duration(days: i)));
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
            for (final h in _weekdayHeaders)
              Expanded(
                child: Center(
                  child: Text(
                    h,
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: const Color(0xFF000000),
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
              final inCurrentMonth = day.month == month.month && day.year == month.year;
              final isSelected = _isSameDay(day, selected);
              final future = isFuture(day);

              Color textColor;
              if (isSelected) {
                textColor = AppColors.surface;
              } else if (future) {
                textColor = const Color(0xFFBBBBBB);
              } else if (inCurrentMonth) {
                textColor = const Color(0xFF000000);
              } else {
                textColor = const Color(0xFF8C8C99);
              }

              return GestureDetector(
                onTap: future ? null : () => onDayTap(day),
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: isSelected
                        ? const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          )
                        : null,
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: AppTextStyles.caption1Medium.copyWith(color: textColor),
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
              style: AppTextStyles.body2Bold.copyWith(color: const Color(0xFF8C8C99)),
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
              style: AppTextStyles.body2Bold.copyWith(color: AppColors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
