import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';

/// 증상 시간 설정 화면.
///
/// [Navigator.push] + pop(DateTime) 으로 결과를 반환한다.
/// 반환값: 선택된 KST wall-clock [DateTime].
class SymptomTimePickScreen extends StatefulWidget {
  const SymptomTimePickScreen({super.key, required this.initialDateTime});

  /// 초기 선택 시각 (KST wall-clock).
  final DateTime initialDateTime;

  @override
  State<SymptomTimePickScreen> createState() => _SymptomTimePickScreenState();
}

class _SymptomTimePickScreenState extends State<SymptomTimePickScreen> {
  late DateTime _selectedDateTime;

  // 빠른 선택에서 선택된 오프셋(분). null = 직접 선택 or 없음.
  int? _selectedOffsetMinutes;

  // 휠 컨트롤러
  late FixedExtentScrollController _dateCtrl;
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;

  // 칩에 의한 휠 업데이트 중 상호 재진입 방지
  bool _updatingFromChip = false;

  static const _quickOffsets = [0, 10, 30, 60, 120];
  static const _quickLabels = ['지금', '10분 전', '30분 전', '1시간 전', '2시간 전'];

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;

    final dates = _dateOptions();
    final targetDate = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
    );
    final dateIdx = dates.indexWhere((d) => d == targetDate);

    _dateCtrl = FixedExtentScrollController(
      initialItem: dateIdx >= 0 ? dateIdx : 0,
    );
    _hourCtrl =
        FixedExtentScrollController(initialItem: _selectedDateTime.hour);
    _minuteCtrl =
        FixedExtentScrollController(initialItem: _selectedDateTime.minute);

    // 초기값이 "지금"과 일치하는지 확인
    final now = nowKst();
    final isNow = _selectedDateTime.year == now.year &&
        _selectedDateTime.month == now.month &&
        _selectedDateTime.day == now.day &&
        _selectedDateTime.hour == now.hour &&
        _selectedDateTime.minute == now.minute;
    _selectedOffsetMinutes = isNow ? 0 : null;
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  /// 날짜 옵션 목록 (오늘 포함 최근 7일).
  List<DateTime> _dateOptions() {
    final today = nowKst();
    final base = DateTime(today.year, today.month, today.day);
    return List.generate(7, (i) => base.subtract(Duration(days: i)));
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

  void _onChipTap(int offsetMinutes) {
    final base = nowKst();
    // KST wall-clock에서 subtract. .toUtc() 금지.
    final newDt = base.subtract(Duration(minutes: offsetMinutes));
    final dates = _dateOptions();
    final targetDate = DateTime(newDt.year, newDt.month, newDt.day);
    final dateIdx = dates.indexWhere((d) => d == targetDate);

    setState(() {
      _selectedDateTime = newDt;
      _selectedOffsetMinutes = offsetMinutes;
    });

    _updatingFromChip = true;
    if (dateIdx >= 0) {
      _dateCtrl.animateToItem(
        dateIdx,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
    _hourCtrl.animateToItem(
      newDt.hour,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    _minuteCtrl.animateToItem(
      newDt.minute,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    // 애니메이션(200ms) 완료 후 플래그 해제.
    // Future.delayed 대신 WidgetsBinding 콜백으로 pending timer 문제 회피.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updatingFromChip = false;
    });
  }

  void _onWheelChanged() {
    if (_updatingFromChip) return;
    final dates = _dateOptions();
    final dateIdx = _dateCtrl.selectedItem.clamp(0, dates.length - 1);
    final hour = _hourCtrl.selectedItem.clamp(0, 23);
    final minute = _minuteCtrl.selectedItem.clamp(0, 59);
    final base = dates[dateIdx];
    final newDt = DateTime(base.year, base.month, base.day, hour, minute);

    final now = nowKst();
    final isNow = newDt.year == now.year &&
        newDt.month == now.month &&
        newDt.day == now.day &&
        newDt.hour == now.hour &&
        newDt.minute == now.minute;

    setState(() {
      _selectedDateTime = newDt;
      _selectedOffsetMinutes = isNow ? 0 : null;
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final dates = _dateOptions();

    return Scaffold(
      backgroundColor: AppColors.surface,
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
          style: AppTextStyles.body1Medium
              .copyWith(color: AppColors.textPrimary),
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
                  // 빠른 선택
                  Text(
                    '빠른 선택',
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  _QuickChips(
                    offsets: _quickOffsets,
                    labels: _quickLabels,
                    selectedOffset: _selectedOffsetMinutes,
                    onTap: _onChipTap,
                  ),
                  const SizedBox(height: 48),

                  // 직접 선택
                  Text(
                    '직접 선택',
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  _WheelPicker(
                    dateOptions: dates,
                    dateLabel: _dateLabel,
                    dateCtrl: _dateCtrl,
                    hourCtrl: _hourCtrl,
                    minuteCtrl: _minuteCtrl,
                    onChanged: _onWheelChanged,
                  ),
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
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
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
  final int? selectedOffset;
  final void Function(int offsetMinutes) onTap;

  @override
  Widget build(BuildContext context) {
    // Figma 554:7342: 빠른선택 칩 = 흰 배경 + 테두리, 선택 시 green 아웃라인.
    // 증상 유형 칩과 동일한 SelectableChip 스타일을 공유한다(회색 fill 아님).
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
// 3열 휠 픽커
// ---------------------------------------------------------------------------

class _WheelPicker extends StatelessWidget {
  const _WheelPicker({
    required this.dateOptions,
    required this.dateLabel,
    required this.dateCtrl,
    required this.hourCtrl,
    required this.minuteCtrl,
    required this.onChanged,
  });

  final List<DateTime> dateOptions;
  final String Function(DateTime) dateLabel;
  final FixedExtentScrollController dateCtrl;
  final FixedExtentScrollController hourCtrl;
  final FixedExtentScrollController minuteCtrl;
  final VoidCallback onChanged;

  static const double _itemExtent = 48.0;
  static const double _pickerHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    // Figma 554:7342: 휠은 흰 화면 위에 놓이며 회색 카드로 감싸지 않는다.
    // 선택행만 회색(surfaceMuted) 하이라이트 pill.
    return SizedBox(
      height: _pickerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 선택행 하이라이트
          Positioned(
            left: 0,
            right: 0,
            top: (_pickerHeight - _itemExtent) / 2,
            height: _itemExtent,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
            ),
          ),
          Row(
            children: [
              // 날짜 열 (넓음)
              Expanded(
                flex: 3,
                child: _WheelColumn(
                  controller: dateCtrl,
                  itemCount: dateOptions.length,
                  itemBuilder: (i) => dateLabel(dateOptions[i]),
                  onChanged: onChanged,
                ),
              ),
              // 시 열
              Expanded(
                flex: 2,
                child: _WheelColumn(
                  controller: hourCtrl,
                  itemCount: 24,
                  itemBuilder: (i) => '${i.toString().padLeft(2, '0')}시',
                  onChanged: onChanged,
                ),
              ),
              // 분 열
              Expanded(
                flex: 2,
                child: _WheelColumn(
                  controller: minuteCtrl,
                  itemCount: 60,
                  itemBuilder: (i) => '${i.toString().padLeft(2, '0')}분',
                  onChanged: onChanged,
                ),
              ),
            ],
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
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int) itemBuilder;
  final VoidCallback onChanged;

  static const double _itemExtent = 48.0;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      diameterRatio: 2.0,
      onSelectedItemChanged: (_) => onChanged(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          return Center(
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
