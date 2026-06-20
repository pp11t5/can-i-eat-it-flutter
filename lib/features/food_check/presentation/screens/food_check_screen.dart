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
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/clear_search_history_dialog.dart';

/// 음식 검색 진입 화면 (Figma 554:5328 / 554:5329 / 554:5322).
///
/// W3 범위:
/// - 디바운스(1초)+Submit 검색 → 결과 패널(FoodSummary 리스트)
/// - 결과 셀 탭 → POST /foods/recent 기록 + 판정 화면 present-modal
/// - 매칭 없음 → raw text 직접 분석 진입 (Figma 365-1849, externalId 없음 → recent 기록 생략)
/// - 최근검색 RecentFood 엔티티 기반 (String 기반 SearchHistoryRepository 흡수)
///
/// [recordContext]: 식사 기록 흐름에서 진입 시 전달 (FAB→시간선택→검색). null이면 단순 판정.
/// [initialQuery]: 홈 제안 칩 등에서 검색어를 미리 채워 자동 판정 트리거할 때 전달.
class FoodCheckScreen extends ConsumerStatefulWidget {
  const FoodCheckScreen({super.key, this.recordContext, this.initialQuery});

  /// 식사 기록 컨텍스트. null이면 단순 판정 흐름.
  final MealRecordContext? recordContext;

  /// 진입 시 자동 입력할 검색어. null이면 수동 입력 플로우.
  final String? initialQuery;

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

  /// 판정 화면 진입 in-flight 가드 (다중 탭 중복 push 방지).
  bool _navigating = false;

  /// 검색 결과 정렬 기준.
  String _sortOrder = '관련도순';

  @override
  void initState() {
    super.initState();
    final q = widget.initialQuery?.trim();
    if (q != null && q.isNotEmpty) {
      _textController.text = q;
      // 빌드 완료 후 1회 자동 검색 트리거 (initState에서 setState 금지).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onSubmit(q);
      });
    }
  }

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
    FocusScope.of(context).unfocus();
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
      // staleness 가드: 응답 도착 사이 더 최신 쿼리가 시작됐으면 덮어쓰지 않는다.
      if (!mounted || _query != q) return;
      setState(() {
        _searchResults = results;
        _searchLoading = false;
      });
    } catch (_) {
      if (!mounted || _query != q) return;
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
    // in-flight 가드: addRecent await 동안 다른 셀 탭으로 /verdict 중복 push 방지.
    if (_navigating) return;
    _navigating = true;
    try {
      // POST /foods/recent 기록 (DB 매칭 있으므로 기록)
      try {
        await ref
            .read(recentFoodControllerProvider.notifier)
            .addRecent(food.externalId);
      } catch (_) {
        // 기록 실패는 판정 진입을 막지 않는다.
      }
      if (!mounted) return;
      // 판정 화면 present-modal — by-id 진입 (externalId 보유)
      context.push(
        '/verdict',
        extra: VerdictArgs(
          externalId: food.externalId,
          text: food.name,
          recordContext: widget.recordContext,
        ),
      );
    } finally {
      _navigating = false;
    }
  }

  /// 매칭 없음 → raw text 직접 분석 진입 (by-text).
  ///
  /// externalId 없으므로 POST /foods/recent 기록 생략 (ADR-0007 §3-1 (5)).
  void _onDirectAnalyze() {
    if (_navigating) return;
    final q = _query.trim();
    if (q.isEmpty) return;
    _navigating = true;
    context.push(
      '/verdict',
      extra: VerdictArgs(text: q, recordContext: widget.recordContext),
    );
    _navigating = false;
  }

  void _showSortDialog(BuildContext ctx) {
    showDialog<void>(
      context: ctx,
      builder: (dialogCtx) => SimpleDialog(
        title: const Text('정렬 기준'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setState(() => _sortOrder = '관련도순');
              Navigator.pop(dialogCtx);
            },
            child: const Text('관련도순'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() => _sortOrder = '이름순');
              Navigator.pop(dialogCtx);
            },
            child: const Text('이름순'),
          ),
        ],
      ),
    );
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
              onSort: () => _showSortDialog(context),
              sortOrder: _sortOrder,
            ),
            if (_textController.text.trim().isNotEmpty && !showResults)
              _AutoCompleteHints(query: _textController.text.trim()),
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
    required this.onSort,
    required this.sortOrder,
  });

  final TextEditingController controller;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;
  final VoidCallback onSort;
  final String sortOrder;

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
                  hintText: '음식 이름을 입력해 주세요',
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
            IconButton(
              icon: const Icon(Icons.sort),
              tooltip: '정렬: $sortOrder',
              onPressed: onSort,
              color: AppColors.textPrimary,
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
      return _SearchErrorState(
        message: error!,
        query: query,
        onDirectAnalyze: onDirectAnalyze,
      );
    }
    final list = results ?? [];
    // 결과가 있든 없든 항상 직접분석 CTA 카드를 포함한 리스트를 렌더한다
    // (Figma 554-5322: 리스트 맨 아래 365-1849 카드 상시 노출).
    return _ResultList(
      query: query,
      items: list,
      onTap: onTap,
      onDirectAnalyze: onDirectAnalyze,
    );
  }
}

/// 검색 결과 카드 리스트 + 하단 직접분석 CTA (Figma 554-5322).
///
/// 결과가 없을 때도 직접분석 CTA 카드만 표시한다.
class _ResultList extends StatelessWidget {
  const _ResultList({
    required this.query,
    required this.items,
    required this.onTap,
    required this.onDirectAnalyze,
  });

  final String query;
  final List<FoodSummary> items;
  final Future<void> Function(FoodSummary) onTap;
  final VoidCallback onDirectAnalyze;

  @override
  Widget build(BuildContext context) {
    // 결과 카드 수 + CTA 카드 1개 + 헤더 1개 (+ 빈 상태 1개)
    final isEmpty = items.isEmpty;
    final itemCount = 1 + (isEmpty ? 1 : items.length) + 1;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.itemGap,
        AppSpacing.screenPadding,
        AppSpacing.screenPadding,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // 0: 헤더
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.itemGap,
            ),
            child: Text(
              '검색 결과',
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }
        // 1: 결과 없음 빈 상태
        if (isEmpty && index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  '검색 결과가 없어요',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '다른 검색어로 시도해 보세요',
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        // 1 ~ items.length: 결과 카드 (결과 있을 때)
        if (!isEmpty && index <= items.length) {
          final food = items[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ResultCard(
              food: food,
              query: query,
              onTap: () => onTap(food),
            ),
          );
        }
        // 마지막: 직접분석 CTA 카드 (365-1849) — 결과 있든 없든 항상 표시
        return _DirectAnalyzeCta(
          query: query,
          onTap: onDirectAnalyze,
        );
      },
    );
  }
}

/// 검색 결과 단일 카드 (Figma 554-5322 결과 항목).
///
/// - 흰 배경, #EAEAEA 1px 테두리, radius 16, 내부 패딩 16
/// - 좌측 placeholder leading 아이콘 (API에 이모지/아이콘 필드 없음)
/// - 이름 body1Bold/textPrimary
/// - chevron 없음, category 서브텍스트 없음
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.food,
    required this.onTap,
    this.query = '',
  });

  final FoodSummary food;
  final VoidCallback onTap;
  final String query;

  /// 음식 이름에서 검색어와 일치하는 부분을 굵게 강조한 TextSpan 목록을 반환한다.
  List<TextSpan> _buildSpans(TextStyle baseStyle) {
    final name = food.name;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return [TextSpan(text: name, style: baseStyle)];
    }
    final spans = <TextSpan>[];
    int start = 0;
    final lowerName = name.toLowerCase();
    while (true) {
      final idx = lowerName.indexOf(q, start);
      if (idx == -1) {
        spans.add(TextSpan(text: name.substring(start), style: baseStyle));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: name.substring(start, idx), style: baseStyle));
      }
      spans.add(TextSpan(
        text: name.substring(idx, idx + q.length),
        style: baseStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          backgroundColor: AppColors.primary.withValues(alpha: 0.3),
        ),
      ));
      start = idx + q.length;
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: const Color(0xFFEAEAEA),
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            // DESIGN-GAP: per-food 이모지는 API 미제공 → placeholder. 디자이너 확인 대기.
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.cardPadding),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: _buildSpans(
                    AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 직접분석 CTA 카드 (Figma 365-1849).
///
/// 결과 리스트 맨 아래 항상 표시 — 결과가 있을 때도, 없을 때도.
/// 탭 → raw query 직접 분석 (/verdict, externalId 없으니 addRecent 생략).
///
/// - surfaceMuted(#F4F4F5) 배경, radius 16, 내부 패딩 16~20
/// - 좌측 placeholder icon (슬픈 표정 아이콘)
/// - 제목 "찾는 음식이 없어요" body1Bold/textPrimary
/// - 부제 "'<query>'로 검색하기" + chevron(>) body2Medium/textSecondary
class _DirectAnalyzeCta extends StatelessWidget {
  const _DirectAnalyzeCta({required this.query, required this.onTap});

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 20,
        ),
        child: Row(
          children: [
            // DESIGN-GAP: per-food 이모지는 API 미제공 → placeholder. 디자이너 확인 대기.
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: const Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: 22,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.cardPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '찾는 음식이 없어요',
                    style: AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "'$query'로 검색하기",
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchErrorState extends StatelessWidget {
  const _SearchErrorState({
    required this.message,
    required this.query,
    required this.onDirectAnalyze,
  });

  final String message;
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
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body1Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _DirectAnalyzeCta(query: query, onTap: onDirectAnalyze),
        ],
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
        // searchedAt 기준 최신순 정렬 (뷰 레이어 전용)
        final sorted = [...items]
          ..sort((a, b) => b.searchedAt.compareTo(a.searchedAt));
        return _RecentSection(items: sorted, ref: ref);
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
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.danger,
                    ),
                    tooltip: '검색 기록 삭제',
                    onPressed: () =>
                        showClearSearchHistoryDialog(context, ref),
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
            onTap: () => _showDeleteConfirmDialog(context, onRemove),
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
// 검색어 삭제 확인 다이얼로그
// ---------------------------------------------------------------------------

Future<void> _showDeleteConfirmDialog(
  BuildContext context,
  VoidCallback onDelete,
) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('검색어 삭제'),
      content: const Text('이 검색어를 삭제할까요?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(ctx);
          },
          child: const Text('삭제'),
        ),
      ],
    ),
  );
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

// ---------------------------------------------------------------------------
// 자동완성 힌트 패널 (목 데이터)
// ---------------------------------------------------------------------------

class _AutoCompleteHints extends StatelessWidget {
  const _AutoCompleteHints({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final hints = ['$query 볶음', '$query 찜', '$query 구이'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: hints
          .map(
            (hint) => ListTile(
              leading: const Icon(Icons.search),
              title: Text(hint),
              onTap: () {},
            ),
          )
          .toList(),
    );
  }
}
