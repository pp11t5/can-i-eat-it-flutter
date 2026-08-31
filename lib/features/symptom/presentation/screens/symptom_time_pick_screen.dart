import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/core/utils/recent_day_options.dart';

/// 증상 시간 설정 화면.
///
/// [Navigator.push] + pop(DateTime) 으로 결과를 반환한다.
/// 반환값: 선택된 KST wall-clock [DateTime].
///
/// 시간 선택 UI는 식사 기록 화면과 동일하다(빠른 선택 6칩, 직접 입력 시에만 휠,
/// 오늘이면 현재 시각 이후 숨김, 날짜는 과거가 위). 앱바·확인 버튼은 이 화면 고유.
class SymptomTimePickScreen extends StatefulWidget {
  const SymptomTimePickScreen({
    super.key,
    required this.initialDateTime,
    this.joinDate,
  });

  /// 초기 선택 시각 (KST wall-clock).
  final DateTime initialDateTime;

  /// 가입일(날짜만). 휠·칩이 이 날짜 이전으로 내려가지 않는다. null이면 최근 7일.
  final DateTime? joinDate;

  @override
  State<SymptomTimePickScreen> createState() => _SymptomTimePickScreenState();
}

class _SymptomTimePickScreenState extends State<SymptomTimePickScreen> {
  late DateTime _selectedDateTime;

  // 빠른 선택 칩 오프셋(분). _manualOffset이면 "직접 입력" 칩 선택(휠 노출) 상태.
  int _selectedOffsetMinutes = 0;

  // 휠 컨트롤러
  late FixedExtentScrollController _dateCtrl;
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;

  // jumpToItem → onSelectedItemChanged 재진입 방지.
  bool _syncingWheel = false;

  /// "직접 입력" 칩을 나타내는 오프셋 sentinel(실제 분 단위 오프셋이 아님).
  static const int _manualOffset = -1;

  static const _quickOffsets = [0, 10, 30, 60, 120, _manualOffset];
  static const _quickLabels = ['지금', '10분 전', '30분 전', '1시간 전', '2시간 전', '직접 입력'];

  @override
  void initState() {
    super.initState();
    final now = nowKst();
    var dt = _capToNow(widget.initialDateTime, now);
    final dates = _dateOptions();
    var dateIdx = dates.indexWhere(
      (d) => d == DateTime(dt.year, dt.month, dt.day),
    );
    if (dateIdx < 0) {
      dt = _capToNow(
        DateTime(now.year, now.month, now.day, dt.hour, dt.minute),
        now,
      );
      dateIdx = dates.length - 1;
    }
    _selectedDateTime = dt;

    final isNow = _isSameCalendarDay(dt, now) &&
        dt.hour == now.hour &&
        dt.minute == now.minute;
    _selectedOffsetMinutes = isNow ? 0 : _manualOffset;

    final hourCount = _hourCountFor(dt, now);
    final minuteCount = _minuteCountFor(dt, dt.hour, now);
    _dateCtrl = FixedExtentScrollController(
      initialItem: dateIdx >= 0 ? dateIdx : dates.length - 1,
    );
    _hourCtrl = FixedExtentScrollController(
      initialItem: dt.hour.clamp(0, hourCount - 1),
    );
    _minuteCtrl = FixedExtentScrollController(
      initialItem: dt.minute.clamp(0, minuteCount - 1),
    );
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  /// 날짜 옵션 목록 (최근 7일, 가입일 이후, 오래된 날짜부터 오늘까지).
  List<DateTime> _dateOptions() {
    return recentDayOptions(now: nowKst(), minDate: widget.joinDate);
  }

  /// 날짜 → 휠 표시 레이블.
  String _dateLabel(DateTime date) {
    final today = nowKst();
    final base = DateTime(today.year, today.month, today.day);
    if (date == base) return '오늘';
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final wd = weekdays[date.weekday - 1];
    return '${date.month}월 ${date.day}일 ($wd)';
  }

  bool _isSameCalendarDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// 미래이거나 가입일 이전이면 허용 범위로 맞춘다.
  DateTime _capToNow(DateTime candidate, DateTime now) {
    var dt = candidate;
    if (dt.isAfter(now)) {
      dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }
    final join = widget.joinDate;
    if (join != null) {
      final joinDay = DateTime(join.year, join.month, join.day);
      if (dt.isBefore(joinDay)) return joinDay;
    }
    return dt;
  }

  int _hourCountFor(DateTime date, DateTime now) =>
      _isSameCalendarDay(date, now) ? now.hour + 1 : 24;

  int _minuteCountFor(DateTime date, int hour, DateTime now) {
    if (_isSameCalendarDay(date, now) && hour >= now.hour) {
      return now.minute + 1;
    }
    return 60;
  }

  /// 빠른 선택 칩 탭. "직접 입력" sentinel이면 [_enterManualMode]로 위임.
  void _onChipTap(int offsetMinutes) {
    if (offsetMinutes == _manualOffset) {
      if (_selectedOffsetMinutes != _manualOffset) {
        _enterManualMode();
      }
      return;
    }
    final base = nowKst();
    // KST wall-clock에서 subtract. .toUtc() 금지.
    final newDt =
        _capToNow(base.subtract(Duration(minutes: offsetMinutes)), base);

    setState(() {
      _selectedDateTime = newDt;
      _selectedOffsetMinutes = offsetMinutes;
    });
  }

  /// "직접 입력" 칩 선택 → 휠 노출. 선택값은 항상 현재 시각(스크롤 시작점).
  void _enterManualMode() {
    final now = nowKst();
    final dates = _dateOptions();
    final today = DateTime(now.year, now.month, now.day);
    final dateIdx = dates.indexWhere((d) => d == today);
    final hourCount = _hourCountFor(now, now);
    final minuteCount = _minuteCountFor(now, now.hour, now);

    _dateCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();

    setState(() {
      _selectedDateTime = now;
      _selectedOffsetMinutes = _manualOffset;
      _dateCtrl = FixedExtentScrollController(
        initialItem: dateIdx >= 0 ? dateIdx : dates.length - 1,
      );
      _hourCtrl = FixedExtentScrollController(
        initialItem: now.hour.clamp(0, hourCount - 1),
      );
      _minuteCtrl = FixedExtentScrollController(
        initialItem: now.minute.clamp(0, minuteCount - 1),
      );
    });
  }

  /// 휠 스크롤이 시각의 단일 진실(직접 입력 모드에서만 호출됨).
  ///
  /// 오늘이면 현재 시각 이후는 선택할 수 없다. itemCount를 줄이기 전에
  /// 컨트롤러를 상한으로 점프해 ListWheel이 범위 밖 selectedItem을 갖지 않게 한다.
  void _onWheelChanged() {
    if (_syncingWheel) return;
    final now = nowKst();
    final dates = _dateOptions();
    final dateIdx = _dateCtrl.selectedItem.clamp(0, dates.length - 1);
    final date = dates[dateIdx];
    final maxHour = _hourCountFor(date, now) - 1;
    final hour = _hourCtrl.hasClients
        ? _hourCtrl.selectedItem.clamp(0, maxHour)
        : 0;
    final maxMinute = _minuteCountFor(date, hour, now) - 1;
    final minute = _minuteCtrl.hasClients
        ? _minuteCtrl.selectedItem.clamp(0, maxMinute)
        : 0;
    final newDt = _capToNow(
      DateTime(date.year, date.month, date.day, hour, minute),
      now,
    );

    final hourNeedsJump =
        _hourCtrl.hasClients && _hourCtrl.selectedItem != newDt.hour;
    final minuteNeedsJump =
        _minuteCtrl.hasClients && _minuteCtrl.selectedItem != newDt.minute;
    if (hourNeedsJump || minuteNeedsJump) {
      _syncingWheel = true;
      if (hourNeedsJump) _hourCtrl.jumpToItem(newDt.hour);
      if (minuteNeedsJump) _minuteCtrl.jumpToItem(newDt.minute);
      _syncingWheel = false;
    }

    if (newDt == _selectedDateTime) return;
    setState(() {
      _selectedDateTime = newDt;
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop(_capToNow(_selectedDateTime, nowKst()));
  }

  @override
  Widget build(BuildContext context) {
    final showWheel = _selectedOffsetMinutes == _manualOffset;
    final now = nowKst();
    final hourCount = _hourCountFor(_selectedDateTime, now);
    final minuteCount =
        _minuteCountFor(_selectedDateTime, _selectedDateTime.hour, now);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s32,
            color: AppColors.textPrimary,
            semanticsLabel: '뒤로',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '시간 설정',
          style:
              AppTextStyles.body1Medium.copyWith(color: AppColors.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text(
                    '언제 그런 증상을 느끼셨나요?',
                    style: AppTextStyles.header1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '기억나는 시간을 알려주세요',
                    style: AppTextStyles.body1Regular
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text(
                    '빠른 선택',
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
                  _QuickChips(
                    offsets: _quickOffsets,
                    labels: _quickLabels,
                    selectedOffset: _selectedOffsetMinutes,
                    onTap: _onChipTap,
                  ),
                  if (showWheel) ...[
                    const SizedBox(height: AppSpacing.sectionGap),
                    Text(
                      '직접 선택',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    _WheelPicker(
                      dateOptions: _dateOptions(),
                      dateLabel: _dateLabel,
                      dateCtrl: _dateCtrl,
                      hourCtrl: _hourCtrl,
                      minuteCtrl: _minuteCtrl,
                      hourCount: hourCount,
                      minuteCount: minuteCount,
                      onChanged: _onWheelChanged,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 하단 확인 버튼
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.itemGap,
              AppSpacing.screenPadding,
              MediaQuery.of(context).padding.bottom + AppSpacing.screenPadding,
            ),
            child: SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  textStyle: AppTextStyles.body1Bold,
                ),
                child: const Text('확인'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 빠른 선택 칩
// ---------------------------------------------------------------------------

class _QuickChips extends StatelessWidget {
  const _QuickChips({
    required this.offsets,
    required this.labels,
    required this.selectedOffset,
    required this.onTap,
  });

  final List<int> offsets;
  final List<String> labels;
  final int selectedOffset;
  final void Function(int offsetMinutes) onTap;

  @override
  Widget build(BuildContext context) {
    // 식사 기록과 동일: 흰 배경+테두리, 선택 시 green 아웃라인.
    return Wrap(
      spacing: AppSpacing.itemGap,
      runSpacing: AppSpacing.itemGap,
      children: List.generate(offsets.length, (i) {
        return SelectableChip(
          label: labels[i],
          selected: selectedOffset == offsets[i],
          onTap: () => onTap(offsets[i]),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// 3열 휠 픽커 (날짜 / 시 / 분) — 식사 기록과 동일 치수.
// ---------------------------------------------------------------------------

class _WheelPicker extends StatelessWidget {
  const _WheelPicker({
    required this.dateOptions,
    required this.dateLabel,
    required this.dateCtrl,
    required this.hourCtrl,
    required this.minuteCtrl,
    required this.hourCount,
    required this.minuteCount,
    required this.onChanged,
  });

  final List<DateTime> dateOptions;
  final String Function(DateTime) dateLabel;
  final FixedExtentScrollController dateCtrl;
  final FixedExtentScrollController hourCtrl;
  final FixedExtentScrollController minuteCtrl;
  final int hourCount;
  final int minuteCount;
  final VoidCallback onChanged;

  static const double _itemExtent = 32.0;
  static const double _pickerHeight = 174.0;
  static const double _highlightRadius = 7.6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _pickerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: (_pickerHeight - _itemExtent) / 2,
            height: _itemExtent,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(_highlightRadius),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sectionGap),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _WheelColumn(
                    controller: dateCtrl,
                    itemCount: dateOptions.length,
                    itemBuilder: (i) => dateLabel(dateOptions[i]),
                    onChanged: onChanged,
                    offAxisFraction: -_WheelColumn.offAxis,
                    alignment: Alignment.centerRight,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _WheelColumn(
                    controller: hourCtrl,
                    itemCount: hourCount,
                    itemBuilder: (i) => '${i.toString().padLeft(2, '0')}시',
                    onChanged: onChanged,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _WheelColumn(
                    controller: minuteCtrl,
                    itemCount: minuteCount,
                    itemBuilder: (i) => '${i.toString().padLeft(2, '0')}분',
                    onChanged: onChanged,
                    offAxisFraction: _WheelColumn.offAxis,
                    alignment: Alignment.centerLeft,
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

class _WheelColumn extends StatelessWidget {
  const _WheelColumn({
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    required this.onChanged,
    this.offAxisFraction = 0,
    this.alignment = Alignment.center,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int) itemBuilder;
  final VoidCallback onChanged;
  final double offAxisFraction;
  final Alignment alignment;

  static const double _itemExtent = 32.0;

  /// iOS CupertinoDatePicker 좌/우 열 vanishing 각도.
  static const double offAxis = 0.45;

  @override
  Widget build(BuildContext context) {
    // 원통 + 열별 offAxisFraction(옆에서 본 각도). iOS 날짜 피커와 동일.
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      diameterRatio: 1.07,
      squeeze: 1.25,
      offAxisFraction: offAxisFraction,
      useMagnifier: true,
      magnification: 2.35 / 2.1,
      overAndUnderCenterOpacity: 0.447,
      onSelectedItemChanged: (_) => onChanged(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          return Align(
            alignment: alignment,
            child: Text(
              itemBuilder(index),
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
