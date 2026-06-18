import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/fab_action_sheet.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/meal_timeline_list.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_nav.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_strip.dart';

/// 식사 타임라인 화면 (F3-2a 골격).
///
/// 구조:
/// - WeekNav: 주차 네비게이션 (이전/다음 주 이동)
/// - WeekStrip: 일~토 7칸 주간 스트립 (오늘/선택일 강조, 도트 표시)
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

  /// 현재 표시 중인 주의 일요일.
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    final today = _today();
    _selectedDate = today;
    _weekStart = _sundayOf(today);
  }

  /// 오늘 날짜. todayOverride가 있으면 그 값을 사용, 없으면 KST 오늘.
  DateTime _today() => widget.todayOverride ?? _todayKst();

  /// KST 오늘 날짜 (UTC+9).
  static DateTime _todayKst() {
    final utcNow = DateTime.now().toUtc();
    final kst = utcNow.add(const Duration(hours: 9));
    return DateTime(kst.year, kst.month, kst.day);
  }

  /// 주어진 날짜가 속한 주의 일요일을 반환.
  static DateTime _sundayOf(DateTime date) {
    // DateTime.weekday: 1=월 ~ 7=일
    final daysFromSunday = date.weekday % 7; // 일=0, 월=1, ..., 토=6
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysFromSunday));
  }

  void _onPrevWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    });
    _reloadTimeline(_selectedDate);
  }

  void _onNextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    });
    _reloadTimeline(_selectedDate);
  }

  void _onDaySelected(DateTime day) {
    if (_isSameDay(day, _selectedDate)) return;
    setState(() {
      _selectedDate = day;
    });
    _reloadTimeline(day);
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

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: SafeArea(
        child: Column(
          children: [
            // --- 주차 네비 + 주간 스트립 카드 ---
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.itemGap,
                AppSpacing.screenPadding,
                AppSpacing.itemGap,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.weekStripShadow,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 주차 네비 (좌측 밀착)
                    WeekNav(
                      label: weekNavLabel(_selectedDate),
                      onPrevWeek: _onPrevWeek,
                      onNextWeek: _onNextWeek,
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    // 주간 스트립
                    WeekStrip(
                      weekStart: _weekStart,
                      selectedDate: _selectedDate,
                      today: _today(),
                      // TODO(server): 주간 집계EP 확인 후 7일 도트 연동 [figma:1351-14768]
                      dotsByDate: _buildDotsByDate(timelineAsync.valueOrNull),
                      onDaySelected: _onDaySelected,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            // --- 타임라인 리스트 ---
            Expanded(
              child: timelineAsync.when(
                loading: () => const _TimelineLoadingPlaceholder(),
                error: (err, _) => _TimelineErrorView(
                  onRetry: () => _reloadTimeline(_selectedDate),
                ),
                data: (groups) => groups.isEmpty
                    ? const _TimelineEmptyView()
                    : _TimelineGroupList(groups: groups),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFabActionSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 선택일 데이터에서 도트 맵 생성.
  ///
  /// 현재는 선택일 단건만 점등 (주간 집계EP 미제공).
  Map<DateTime, List<VerdictLevel>> _buildDotsByDate(List<MealGroup>? groups) {
    if (groups == null || groups.isEmpty) return {};
    final key = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final levels = groups
        .expand((g) => g.records)
        .where((r) => r.judgedGrade != null)
        .map((r) => r.judgedGrade!)
        .toList();
    return {key: levels};
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
// 빈 상태 안내
// ---------------------------------------------------------------------------

class _TimelineEmptyView extends StatelessWidget {
  const _TimelineEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.restaurant_menu_outlined,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            '오늘 먹은 음식을 기록해보세요',
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

class _TimelineGroupList extends StatelessWidget {
  const _TimelineGroupList({required this.groups});

  final List<MealGroup> groups;

  @override
  Widget build(BuildContext context) {
    return MealTimelineList(
      groups: groups,
      onTapRecord: (record) {
        context.push('/meal/${record.mealId}');
      },
      onTapGroup: (group) {
        context.push('/meal/group', extra: group);
      },
      onAddFood: (group) {
        context.push('/meal/record', extra: group.mealGroupId);
      },
    );
  }
}
