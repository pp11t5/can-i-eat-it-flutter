import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/calendar_popup.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/fab_action_sheet.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_timeline_list.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_nav.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_strip.dart';

/// 식사 타임라인 화면 (횡스크롤 월 캘린더 재설계).
///
/// 구조:
/// - MonthNav: 월 네비게이션 (이전/다음 달 이동 + 캘린더 팝업 진입)
/// - WeekStrip: 해당월 1일~말일 횡스크롤 단일행 (오늘/선택일 강조, 도트 표시)
/// - CalendarPopup: MonthNav 우측 캘린더 아이콘 탭 시 모달 진입
/// - 타임라인 리스트: AsyncValue.when (loading → 스켈레톤, error → 재시도, data → 그룹 타일)
/// - FAB 자리: 비배선 placeholder (F3-2c에서 연결)
///
/// 하단 탭은 AppShell(StatefulShellRoute)이 제공 — 이 화면에서 중복 추가 금지.
///
/// [todayOverride]: 테스트·골든에서 오늘 날짜를 고정값으로 주입할 때 사용.
///   null 이면 런타임 KST 오늘을 사용한다.
class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key, this.todayOverride});

  /// 오늘 날짜 고정 주입 (테스트·골든 전용). null = 런타임 KST 오늘.
  final DateTime? todayOverride;

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  /// 현재 선택된 날짜 (KST 오늘로 초기화).
  late DateTime _selectedDate;

  /// 현재 표시 중인 월 (DateTime(year, month, 1)).
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final today = _today();
    _selectedDate = today;
    _visibleMonth = DateTime(today.year, today.month, 1);
  }

  /// 오늘 날짜. todayOverride가 있으면 그 값을 사용, 없으면 KST 오늘.
  DateTime _today() {
    if (widget.todayOverride != null) return widget.todayOverride!;
    final k = nowKst();
    return DateTime(k.year, k.month, k.day);
  }

  /// [month]가 [today]가 속한 월보다 이전이면 true — 다음 달 이동 가능 여부
  /// (현실 시간 기준 미래 월로는 이동할 수 없음, MonthNav의 `›` 숨김에도 사용).
  bool _canGoNextFrom(DateTime month, DateTime today) {
    return DateTime(month.year, month.month)
        .isBefore(DateTime(today.year, today.month));
  }

  void _onPrevMonth() {
    final newMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    // 이전 달로 이동하면 선택일 = 그 달의 말일 (전월 말일은 항상 오늘보다
    // 과거이므로 항상 유효 — 미래 월 자체는 canGoNext 가드로 막혀 있음).
    final newSelected = DateTime(newMonth.year, newMonth.month + 1, 0);
    setState(() {
      _visibleMonth = newMonth;
      _selectedDate = newSelected;
    });
    _reloadTimeline(newSelected);
  }

  void _onNextMonth() {
    if (!_canGoNextFrom(_visibleMonth, _today())) return; // 미래월 진입 차단
    final newMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    // 다음 달로 이동하면 선택일 = 그 달의 1일.
    setState(() {
      _visibleMonth = newMonth;
      _selectedDate = newMonth;
    });
    _reloadTimeline(newMonth);
  }

  void _onDaySelected(DateTime day) {
    if (_isSameDay(day, _selectedDate)) return;
    setState(() {
      _selectedDate = day;
    });
    _reloadTimeline(day);
  }

  Future<void> _openCalendarPopup() async {
    final picked = await showCalendarPopup(
      context,
      initialMonth: _visibleMonth,
      initialSelectedDate: _selectedDate,
      today: _today(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _visibleMonth = DateTime(picked.year, picked.month, 1);
      _selectedDate = picked;
    });
    _reloadTimeline(picked);
  }

  void _reloadTimeline(DateTime date) {
    ref
        .read(timelineControllerProvider(date).notifier)
        .changeDate(date);
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final timelineAsync =
        ref.watch(timelineControllerProvider(_selectedDate));
    final monthlyAsync = ref.watch(monthlyControllerProvider(_visibleMonth));

    return Scaffold(
      // Figma 실측: #FCFCFC (surfaceBackground #F5F5F5 과 구분되는 타임라인 전용 배경)
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // --- 월 네비 + 횡스크롤 월 캘린더 ---
            // MonthNav(2756:22551)와 WeekStrip(2756:22501)은 별개 Figma 프레임 —
            // WeekStrip이 자체 카드 데코레이션(bg·stroke·radius·shadow)을 갖는다.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.itemGap,
                AppSpacing.screenPadding,
                AppSpacing.itemGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 월 네비 (좌측 chevron+라벨 클러스터 + 우측 캘린더 아이콘)
                  MonthNav(
                    label: monthNavLabel(_visibleMonth),
                    onPrevMonth: _onPrevMonth,
                    onNextMonth: _onNextMonth,
                    onOpenCalendar: _openCalendarPopup,
                    canGoNext: _canGoNextFrom(_visibleMonth, _today()),
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
                  // 횡스크롤 월 캘린더 — monthly() 연동 도트
                  WeekStrip(
                    visibleMonth: _visibleMonth,
                    selectedDate: _selectedDate,
                    today: _today(),
                    dotsByDate: _buildDotsByDate(monthlyAsync.valueOrNull),
                    onDaySelected: _onDaySelected,
                  ),
                ],
              ),
            ),
            // --- 타임라인 리스트 ---
            Expanded(
              child: timelineAsync.when(
                loading: () => const _TimelineLoadingPlaceholder(),
                error: (err, _) => _TimelineErrorView(
                  onRetry: () => _reloadTimeline(_selectedDate),
                ),
                data: (items) => items.isEmpty
                    ? const _TimelineEmptyView()
                    : _TimelineItemList(items: items),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFabActionSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: const CircleBorder(),
        child: const AppIcon(
          AppIcons.plus,
          size: AppIconSizes.s24,
          color: AppColors.onPrimary,
          semanticsLabel: '기록 추가',
        ),
      ),
    );
  }

  /// 월별 데이터에서 도트 맵 생성 (GET /timeline/monthly 연동).
  ///
  /// 서버는 [MonthlyDay.day](int)만 제공하므로 현재 표시월([_visibleMonth])의
  /// 연/월과 조합해 DateTime 키를 조립한다.
  Map<DateTime, List<VerdictLevel>> _buildDotsByDate(List<MonthlyDay>? days) {
    if (days == null || days.isEmpty) return {};
    return {
      for (final d in days)
        DateTime(_visibleMonth.year, _visibleMonth.month, d.day): d.judgements,
    };
  }
}

// ---------------------------------------------------------------------------
// 로딩 상태 — 스켈레톤 스피너
// ---------------------------------------------------------------------------

class _TimelineLoadingPlaceholder extends StatelessWidget {
  const _TimelineLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2.5,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 에러 상태 — 재시도 버튼
// ---------------------------------------------------------------------------

class _TimelineErrorView extends StatelessWidget {
  const _TimelineErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '식사 기록을 불러오지 못했어요',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          TextButton(
            onPressed: onRetry,
            child: Text(
              '다시 시도',
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 빈 상태 안내 (Figma 2699:21467 — 해당일 기록 0건)
// ---------------------------------------------------------------------------

/// 타임라인 빈 상태.
///
/// TODO(figma): 최초 진입 안내(node 2694:20716, 손글씨 일러스트)는 "전체 기록
/// 0건 여부" 같은 별도 신호가 필요해 이번 패스에서는 미분기. 데이터 신호
/// 확정 후 isFirstVisit 분기를 추가하고 일러스트 에셋을 연결한다.
class _TimelineEmptyView extends StatelessWidget {
  const _TimelineEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(
            AppIcons.foodEmpty,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            '기록이 없어요',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 데이터 상태 — 타임라인 리스트 (F3-2b: MealTimelineList로 교체 완료)
// ---------------------------------------------------------------------------

class _TimelineItemList extends StatelessWidget {
  const _TimelineItemList({required this.items});

  final List<TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return MealTimelineList(
      items: items,
      onTapMeal: (mealRecordId) {
        context.push('/meal/$mealRecordId');
      },
      onAddFood: (mealRecordId, mealRecordDateTime) {
        context.push(
          '/check',
          extra: MealRecordContext(
            eatenAt: parseKst(mealRecordDateTime),
            mealRecordId: mealRecordId,
          ),
        );
      },
      onTapSymptom: (symptomId) {
        context.push('/symptom/$symptomId');
      },
    );
  }
}
