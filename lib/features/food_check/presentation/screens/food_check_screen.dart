import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/data/search_history_providers.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/clear_search_history_dialog.dart';

/// 음식 검색 진입 화면 (Figma 554:5328 / 554:5329).
///
/// W2 범위: 검색 필드 포커스 + 최근 검색 기록 표시·삭제.
/// 검색 결과 패널(디바운스)은 W3에서 추가한다.
class FoodCheckScreen extends ConsumerStatefulWidget {
  const FoodCheckScreen({super.key});

  @override
  ConsumerState<FoodCheckScreen> createState() => _FoodCheckScreenState();
}

class _FoodCheckScreenState extends ConsumerState<FoodCheckScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              controller: _textController,
              onClose: _handleClose,
            ),
            Expanded(child: _HistoryContent(ref: ref)),
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
  });

  final TextEditingController controller;
  final VoidCallback onClose;

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
                // W2: 결과 패널 없음 — 다음 주 추가.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// History content
// ---------------------------------------------------------------------------

/// 검색 기록 영역. searchHistoryControllerProvider 상태를 watch 한다.
class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(searchHistoryControllerProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
      data: (terms) {
        if (terms.isEmpty) {
          return const _EmptyState();
        }
        return _RecentSection(terms: terms, ref: ref);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Recent section (non-empty)
// ---------------------------------------------------------------------------

class _RecentSection extends StatelessWidget {
  const _RecentSection({required this.terms, required this.ref});

  final List<String> terms;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding, // left 16
        AppSpacing.itemGap,       // top 8
        AppSpacing.screenPadding, // right 16
        AppSpacing.screenPadding, // bottom 16
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap), // inner 8
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
            // 검색어 행 목록. 항목 간 8px gap(Figma RecentList gap) + 각 행 vertical 8 padding.
            for (var i = 0; i < terms.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.itemGap),
              _HistoryRow(
                term: terms[i],
                onRemove: () => ref
                    .read(searchHistoryControllerProvider.notifier)
                    .removeTerm(terms[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.term, required this.onRemove});

  final String term;
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
              term,
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
// Empty state
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
