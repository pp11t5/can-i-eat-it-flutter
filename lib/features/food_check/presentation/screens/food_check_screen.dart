import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/recent_food_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/clear_search_history_dialog.dart';

/// 음식 검색 진입 화면 (Figma 554:5328 / 554:5329 / 554:5322).
///
/// W3 범위:
/// - 디바운스(1초)+Submit 검색 → 결과 패널(FoodSummary 리스트)
/// - 결과 셀 탭 → POST /foods/recent 기록 + 판정 화면 present-modal
/// - 매칭 없음 → raw text 직접 분석 진입 (Figma 365-1849, externalId 없음 → recent 기록 생략)
/// - 최근검색 RecentFood 엔티티 기반 (String 기반 SearchHistoryRepository 흡수)
class FoodCheckScreen extends ConsumerStatefulWidget {
  const FoodCheckScreen({super.key});

  @override
  ConsumerState<FoodCheckScreen> createState() => _FoodCheckScreenState();
}

class _FoodCheckScreenState extends ConsumerState<FoodCheckScreen> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;

  /// 현재 검색 쿼리 (디바운스 후 갱신).
  String _query = '';

  /// 검색 결과 로딩 중 여부.
  bool _searchLoading = false;

  /// 검색 결과 목록. null = 결과 패널 미표시(초기/입력 없음).
  List<FoodSummary>? _searchResults;

  /// 검색 에러 메시지. null = 에러 없음.
  String? _searchError;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  /// 텍스트 필드 변경 핸들러 — 디바운스 1초 후 검색 실행.
  void _onTextChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _query = '';
        _searchResults = null;
        _searchError = null;
        _searchLoading = false;
      });
      return;
    }
    setState(() {
      _searchLoading = true;
      _searchError = null;
    });
    _debounce = Timer(const Duration(seconds: 1), () => _runSearch(trimmed));
  }

  /// Submit(엔터) 핸들러 — 디바운스 취소 후 즉시 검색.
  void _onSubmit(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    _runSearch(trimmed);
  }

  Future<void> _runSearch(String q) async {
    if (!mounted) return;
    setState(() {
      _query = q;
      _searchLoading = true;
      _searchError = null;
    });
    try {
      final results = await ref.read(foodRepositoryProvider).search(q);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _searchLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _searchError = '검색 중 오류가 발생했어요.';
        _searchLoading = false;
      });
    }
  }

  /// 검색 결과 항목 탭 핸들러.
  ///
  /// 1. POST /foods/recent 기록 (externalId 있으므로 기록).
  /// 2. 판정 화면 present-modal (go_router /verdict).
  Future<void> _onResultTap(FoodSummary food) async {
    // POST /foods/recent 기록 (DB 매칭 있으므로 기록)
    try {
      await ref
          .read(recentFoodControllerProvider.notifier)
          .addRecent(food.externalId);
    } catch (_) {
      // 기록 실패는 판정 진입을 막지 않는다.
    }
    if (!mounted) return;
    // 판정 화면 present-modal
    context.push('/verdict', extra: food.name);
  }

  /// 매칭 없음 → raw text 직접 분석 진입.
  ///
  /// externalId 없으므로 POST /foods/recent 기록 생략 (ADR-0007 §3-1 (5)).
  void _onDirectAnalyze() {
    final q = _query.trim();
    if (q.isEmpty) return;
    context.push('/verdict', extra: q);
  }

  @override
  Widget build(BuildContext context) {
    final bool showResults = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              controller: _textController,
              onClose: _handleClose,
              onChanged: _onTextChanged,
              onSubmit: _onSubmit,
            ),
            Expanded(
              child: showResults
                  ? _SearchResultPanel(
                      query: _query,
                      loading: _searchLoading,
                      results: _searchResults,
                      error: _searchError,
                      onTap: _onResultTap,
                      onDirectAnalyze: _onDirectAnalyze,
                    )
                  : _HistoryContent(ref: ref),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TopBar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.controller,
    required this.onClose,
    required this.onChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Row(
          children: [
            // 닫기 X 아이콘.
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                'assets/figma_extracted/icon_close.svg',
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.screenPadding),
            // 검색 필드 — 가로 나머지 공간 전부.
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: onSubmit,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: '음식을 검색해주세요',
                  hintStyle: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceMuted,
                  contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 검색 결과 패널 (Figma 554:5322)
// ---------------------------------------------------------------------------

class _SearchResultPanel extends StatelessWidget {
  const _SearchResultPanel({
    required this.query,
    required this.loading,
    required this.results,
    required this.error,
    required this.onTap,
    required this.onDirectAnalyze,
  });

  final String query;
  final bool loading;
  final List<FoodSummary>? results;
  final String? error;
  final Future<void> Function(FoodSummary) onTap;
  final VoidCallback onDirectAnalyze;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return _SearchErrorState(message: error!, onRetry: onDirectAnalyze);
    }
    final list = results ?? [];
    if (list.isEmpty) {
      // 매칭 없음 → 직접 분석 유도 (Figma 365-1849)
      return _NoResultState(query: query, onDirectAnalyze: onDirectAnalyze);
    }
    return _ResultList(items: list, onTap: onTap);
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.items, required this.onTap});

  final List<FoodSummary> items;
  final Future<void> Function(FoodSummary) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.itemGap,
      ),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final food = items[index];
        return _ResultCell(food: food, onTap: () => onTap(food));
      },
    );
  }
}

class _ResultCell extends StatelessWidget {
  const _ResultCell({required this.food, required this.onTap});

  final FoodSummary food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: AppTextStyles.body1Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (food.category != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      food.category!,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 매칭 없음 상태 — raw text 직접 분석 유도 (Figma 365-1849).
class _NoResultState extends StatelessWidget {
  const _NoResultState({required this.query, required this.onDirectAnalyze});

  final String query;
  final VoidCallback onDirectAnalyze;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '"$query" 검색 결과가 없어요',
            textAlign: TextAlign.center,
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          OutlinedButton(
            onPressed: onDirectAnalyze,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              textStyle: AppTextStyles.body1Medium,
            ),
            child: Text('"$query" 직접 분석하기'),
          ),
        ],
      ),
    );
  }
}

class _SearchErrorState extends StatelessWidget {
  const _SearchErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            TextButton(
              onPressed: onRetry,
              child: Text(
                '직접 분석하기',
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 최근검색 영역 (RecentFood 엔티티 기반)
// ---------------------------------------------------------------------------

/// 최근 검색 기록 영역. [recentFoodControllerProvider] 상태를 watch한다.
class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(recentFoodControllerProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyState();
        }
        return _RecentSection(items: items, ref: ref);
      },
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection({required this.items, required this.ref});

  final List<RecentFood> items;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.itemGap,
        AppSpacing.screenPadding,
        AppSpacing.screenPadding,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더 행: "최근 검색" + "전체 삭제"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '최근 검색',
                    style: AppTextStyles.body1Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showClearSearchHistoryDialog(context, ref),
                    child: Text(
                      '전체 삭제',
                      style: AppTextStyles.body1Medium.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.itemGap),
              _HistoryRow(
                item: items[i],
                onRemove: () => ref
                    .read(recentFoodControllerProvider.notifier)
                    .removeRecent(items[i].foodExternalId),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item, required this.onRemove});

  final RecentFood item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.name,
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              'assets/figma_extracted/icon_close_small.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 빈 상태
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/figma_extracted/icon_food_empty.svg',
            width: 48,
            height: 48,
            colorFilter: const ColorFilter.mode(
              AppColors.navInactive,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 검색 기록이 없어요',
            textAlign: TextAlign.center,
            style: AppTextStyles.body1Regular.copyWith(
              fontSize: 18,
              color: AppColors.navInactive,
            ),
          ),
        ],
      ),
    );
  }
}
