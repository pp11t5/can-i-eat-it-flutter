import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';

/// 식사 기록 화면 — 섭취 시각 선택 후 음식 검색으로 이어지는 흐름.
///
/// Figma node 554-7335.
///
/// 진입 경로:
/// - FAB 액션시트 → '/meal/record' (mealRecordId null)
/// - 타임라인 타일 "같이 먹은 음식" → '/meal/record' extra=mealRecordId
///
/// '다음' 버튼 → context.push('/check', extra: MealRecordContext(eatenAt, mealRecordId))
class MealRecordScreen extends StatefulWidget {
  const MealRecordScreen({super.key, this.mealRecordId});

  /// 기존 식사에 음식을 추가(append)할 때 지정. null이면 신규 식사.
  final String? mealRecordId;

  @override
  State<MealRecordScreen> createState() => _MealRecordScreenState();
}

class _MealRecordScreenState extends State<MealRecordScreen> {
  // 선택된 시각의 단일 진실. 기본: KST now.
  late DateTime _selectedDateTime;

  // 빠른 선택 칩 오프셋(분). null = 어느 칩도 선택 안 됨(휠로 직접 설정).
  int? _selectedOffsetMinutes;

  // 휠 컨트롤러
  late FixedExtentScrollController _dateCtrl;
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;

  // 휠 업데이트 중 상호 재진입 방지 플래그
  bool _updatingFromChip = false;

  static const _quickOffsets = [0, 10, 30, 60, 120];
  static const _quickLabels = ['지금', '10분 전', '30분 전', '1시간 전', '2시간 전'];

  @override
  void initState() {
    super.initState();
    final now = nowKst();
    _selectedDateTime = now;
    _selectedOffsetMinutes = 0; // 기본: '지금' 선택

    _dateCtrl = FixedExtentScrollController(initialItem: 0); // 오늘=0
    _hourCtrl = FixedExtentScrollController(initialItem: now.hour);
    _minuteCtrl = FixedExtentScrollController(initialItem: now.minute);
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
    Future.delayed(const Duration(milliseconds: 250), () {
      _updatingFromChip = false;
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

    // '지금' 칩과 일치하는지 확인
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

  void _onNext() {
    final ctx = MealRecordContext(
      eatenAt: _selectedDateTime,
      mealRecordId: widget.mealRecordId,
    );
    context.push('/check', extra: ctx);
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
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          '식사 기록',
          style: AppTextStyles.body1Bold.copyWith(color: AppColors.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
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
                  // 헤더
                  Text(
                    '언제 드셨나요?',
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

                  // 빠른 선택
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
                  const SizedBox(height: AppSpacing.sectionGap),

                  // 직접 선택
                  Text(
                    '직접 선택',
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
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

          // 하단 '다음' 버튼
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
                onPressed: _onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  textStyle: AppTextStyles.body1Bold,
                ),
                child: const Text('다음'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 빠른 선택 칩 행
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
    return Wrap(
      spacing: AppSpacing.itemGap,
      runSpacing: AppSpacing.itemGap,
      children: List.generate(offsets.length, (i) {
        final selected = selectedOffset == offsets[i];
        return GestureDetector(
          onTap: () => onTap(offsets[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.chipPaddingH,
              vertical: AppSpacing.chipPaddingV,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              labels[i],
              style: AppTextStyles.body2Medium.copyWith(
                color: selected ? AppColors.onPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// 3열 휠 픽커 (날짜 / 시 / 분)
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
    return Container(
      height: _pickerHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
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
