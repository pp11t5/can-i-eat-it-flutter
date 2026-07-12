import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/controllers/dictionary_list_controller.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/widgets/verdict_outline_badge.dart';

// ---------------------------------------------------------------------------
// FoodHistoryScreen — 음식 히스토리(내 도감) 화면 (Figma 1718-7883/1718-7882)
// ---------------------------------------------------------------------------

/// 음식 히스토리(내 도감) 화면.
///
/// 홈 '음식 히스토리' 카드에서 push 진입. 권장/주의 음식 2세그먼트 커서
/// 무한스크롤 목록을 보여준다. W6-1 데이터레이어([SafeDictionaryController],
/// [CautionRiskDictionaryController], [dictionaryCountProvider])를 소비한다.
class FoodHistoryScreen extends ConsumerStatefulWidget {
  const FoodHistoryScreen({super.key});

  @override
  ConsumerState<FoodHistoryScreen> createState() => _FoodHistoryScreenState();
}

class _FoodHistoryScreenState extends ConsumerState<FoodHistoryScreen> {
  // 스크롤이 바닥에서 이 거리(px) 이내로 접근하면 다음 페이지를 요청한다.
  static const _loadMoreThreshold = 200.0;

  int _tabIndex = 0;

  final _safeScrollController = ScrollController();
  final _cautionRiskScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _safeScrollController.addListener(() => _onScroll(0));
    _cautionRiskScrollController.addListener(() => _onScroll(1));
  }

  @override
  void dispose() {
    _safeScrollController.dispose();
    _cautionRiskScrollController.dispose();
    super.dispose();
  }

  void _onScroll(int tabIndex) {
    final controller =
        tabIndex == 0 ? _safeScrollController : _cautionRiskScrollController;
    if (!controller.hasClients) return;

    final position = controller.position;
    if (position.pixels < position.maxScrollExtent - _loadMoreThreshold) {
      return;
    }

    if (tabIndex == 0) {
      ref.read(safeDictionaryControllerProvider.notifier).loadMore();
    } else {
      ref.read(cautionRiskDictionaryControllerProvider.notifier).loadMore();
    }
  }

  void _onSegmentTap(int index) {
    if (index == _tabIndex) return;
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final countAsync = ref.watch(dictionaryCountProvider);
    final safeAsync = ref.watch(safeDictionaryControllerProvider);
    final cautionRiskAsync = ref.watch(cautionRiskDictionaryControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        leading: IconButton(
          iconSize: 32,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            'assets/figma_extracted/chevron_left.svg',
            width: 32,
            height: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '음식 히스토리',
          style:
              AppTextStyles.body1Medium.copyWith(color: AppColors.textPrimary),
        ),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                16,
                AppSpacing.screenPadding,
                0,
              ),
              child: _HeaderBlock(),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: _SegmentToggle(
                selectedIndex: _tabIndex,
                safeCount: countAsync.valueOrNull?.safeCount,
                cautionRiskCount: countAsync.valueOrNull?.cautionRiskCount,
                onTap: _onSegmentTap,
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  _DictionaryList(
                    scrollController: _safeScrollController,
                    asyncState: safeAsync,
                    emptyMessage: '아직 권장 음식이 없어요',
                  ),
                  _DictionaryList(
                    scrollController: _cautionRiskScrollController,
                    asyncState: cautionRiskAsync,
                    emptyMessage: '아직 주의·위험 음식이 없어요',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _HeaderBlock — 인사말 텍스트 + 캐릭터 이미지
// ---------------------------------------------------------------------------

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock();

  @override
  Widget build(BuildContext context) {
    // 홈 인사말 블록(_GreetingBlock)과 유사 배치 — Row + 우측 고정폭 캐릭터.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '식단과 증상을 기록하면\n알아서 도감에 쏙!',
            style: AppTextStyles.header2Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Image.asset(
          'assets/illustrations/character_greeting.png',
          width: 140,
          height: 126,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _SegmentToggle — 커스텀 2세그먼트 토글
// ---------------------------------------------------------------------------

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({
    required this.selectedIndex,
    required this.safeCount,
    required this.cautionRiskCount,
    required this.onTap,
  });

  final int selectedIndex;
  final int? safeCount;
  final int? cautionRiskCount;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: '권장 음식 ${safeCount ?? 0}',
              selected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              label: '주의 음식 ${cautionRiskCount ?? 0}',
              selected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.chipPaddingV),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: selected
              ? AppTextStyles.body1Medium
                  .copyWith(color: const Color(0xFF000000))
              : AppTextStyles.body1Medium
                  .copyWith(color: AppColors.textTertiary),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DictionaryList — 탭별 커서 무한스크롤 목록
// ---------------------------------------------------------------------------

class _DictionaryList extends StatelessWidget {
  const _DictionaryList({
    required this.scrollController,
    required this.asyncState,
    required this.emptyMessage,
  });

  final ScrollController scrollController;
  final AsyncValue<DictionaryListState> asyncState;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return asyncState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          '불러오지 못했어요.\n잠시 후 다시 시도해 주세요.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body2Regular
              .copyWith(color: AppColors.textSecondary),
        ),
      ),
      data: (dictState) {
        if (dictState.items.isEmpty) {
          return _EmptyState(message: emptyMessage);
        }
        return ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            top: AppSpacing.itemGap,
            bottom: 16,
          ),
          itemCount: dictState.items.length + (dictState.hasNext ? 1 : 0),
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSpacing.itemGap),
          itemBuilder: (context, index) {
            if (index >= dictState.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _DictionaryCard(item: dictState.items[index]);
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _DictionaryCard — 도감 항목 카드
// ---------------------------------------------------------------------------

class _DictionaryCard extends StatelessWidget {
  const _DictionaryCard({required this.item});

  final DictionaryFoodItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CategoryIcon(code: item.categoryCode, size: 32),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          VerdictOutlineBadge(level: item.verdict),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _EmptyState — 빈 목록 안내
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

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
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            message,
            style: AppTextStyles.body1Medium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
