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
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/providers/timeline_fab_guide_provider.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/calendar_popup.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/fab_action_sheet.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_timeline_list.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/timeline_first_visit_guide.dart';
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

  /// 가입일(날짜만). 없으면 null — 과거 월 하한 없음.
  ///
  /// 콜백에서는 [ref.read], 빌드에서는 [ref.watch] 한 세션을 넘긴다.
  DateTime? _joinDateFromSession(AuthSession? session) {
    final createdAt = session?.createdAt;
    if (createdAt == null) return null;
    return DateTime(createdAt.year, createdAt.month, createdAt.day);
  }

  DateTime? _joinDate() =>
      _joinDateFromSession(ref.read(authControllerProvider).valueOrNull);

  /// [month]가 가입월보다 이후이면 true — 이전 달 이동 가능 여부
  /// (가입일 이전 월로는 이동 불가, MonthNav의 `‹` gray60 비활성에도 사용).
  bool _canGoPrevFrom(DateTime month, DateTime? joinDate) {
    if (joinDate == null) return true;
    final minMonth = DateTime(joinDate.year, joinDate.month, 1);
    return DateTime(month.year, month.month).isAfter(minMonth);
  }

  /// [month]가 오늘 월보다 이전이면 true — 다음 달 이동 가능 여부
  /// (오늘 이후 월로는 이동 불가, MonthNav의 `›` gray60 비활성에도 사용).
  bool _canGoNextFrom(DateTime month, DateTime today) {
    final current = DateTime(month.year, month.month);
    final maxMonth = DateTime(today.year, today.month);
    return current.isBefore(maxMonth);
  }

  /// 월 이동 시 기본 선택일.
  ///
  /// - 그 달에 **오늘**이 있으면 오늘
  /// - 없으면 **1일** (이전/다음 달 동일)
  /// - 가입일 이전이면 가입일로 클램프
  DateTime _selectedForMonth(DateTime monthFirst, {DateTime? join}) {
    final today = _today();
    late DateTime selected;
    if (today.year == monthFirst.year && today.month == monthFirst.month) {
      selected = today;
    } else {
      selected = monthFirst; // 1일
    }
    if (join != null) {
      final d = DateTime(selected.year, selected.month, selected.day);
      if (d.isBefore(join)) selected = join;
    }
    return selected;
  }

  void _onPrevMonth() {
    final join = _joinDate();
    if (!_canGoPrevFrom(_visibleMonth, join)) return; // 가입월 이전 차단

    final newMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    final newSelected = _selectedForMonth(newMonth, join: join);
    setState(() {
      _visibleMonth = newMonth;
      _selectedDate = newSelected;
    });
    _reloadTimeline(newSelected);
  }

  void _onNextMonth() {
    final today = _today();
    if (!_canGoNextFrom(_visibleMonth, today)) return; // 오늘 월 이후 차단

    final newMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    final newSelected = _selectedForMonth(newMonth, join: _joinDate());
    setState(() {
      _visibleMonth = newMonth;
      _selectedDate = newSelected;
    });
    _reloadTimeline(newSelected);
  }

  void _onDaySelected(DateTime day) {
    if (_isSameDay(day, _selectedDate)) return;
    setState(() {
      _selectedDate = day;
    });
    _reloadTimeline(day);
  }

  Future<void> _openCalendarPopup() async {
    final minDate = _joinDate();

    final picked = await showCalendarPopup(
      context,
      initialMonth: _visibleMonth,
      initialSelectedDate: _selectedDate,
      today: _today(),
      minDate: minDate,
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
    // 가입일 하한 — auth 세션이 로드되면 MonthNav `‹` 비활성 갱신.
    final joinDate = _joinDateFromSession(
      ref.watch(authControllerProvider).valueOrNull,
    );
    // false = 미열람(가이드), true = 봄, null = 플래그 로딩 중.
    final hasSeenGuide = ref.watch(timelineFabGuideProvider).valueOrNull;

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
                    canGoPrev: _canGoPrevFrom(_visibleMonth, joinDate),
                    canGoNext: _canGoNextFrom(_visibleMonth, _today()),
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
                  // 횡스크롤 월 캘린더 — monthly() 연동 도트
                  WeekStrip(
                    visibleMonth: _visibleMonth,
                    selectedDate: _selectedDate,
                    today: _today(),
                    minDate: joinDate,
                    dotsByDate: _buildDotsByDate(monthlyAsync.valueOrNull),
                    onDaySelected: _onDaySelected,
                  ),
                ],
              ),
            ),
            // --- 타임라인 리스트 ---
            // 미열람(hasSeenGuide == false)이면 API 로딩 스피너 없이 가이드 즉시 표시.
            Expanded(
              child: timelineAsync.when(
                loading: () => hasSeenGuide == false
                    ? const TimelineFirstVisitGuide()
                    : const _TimelineLoadingPlaceholder(),
                error: (err, _) => _TimelineErrorView(
                  onRetry: () => _reloadTimeline(_selectedDate),
                ),
                data: (items) {
                  if (items.isNotEmpty) {
                    return _TimelineItemList(items: items);
                  }
                  if (hasSeenGuide == false) {
                    return const TimelineFirstVisitGuide();
                  }
                  return const _TimelineEmptyView();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 가이드가 떠 있으면 아무 탭( FAB 포함 )에서도 닫는다.
          ref.read(timelineFabGuideProvider.notifier).dismiss();
          showFabActionSheet(context);
        },
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

/// 타임라인 빈 상태 (해당일 기록 0건 · 가이드 이미 본 계정).
///
/// 최초 진입 FAB 가이드는 [TimelineFirstVisitGuide] —
/// [timelineFabGuideProvider] 가 false 일 때 empty 분기에서 노출.
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
