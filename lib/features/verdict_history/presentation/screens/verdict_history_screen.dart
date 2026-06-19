import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';

/// 판정 이력 화면.
///
/// [VerdictHistoryController]를 watch해 이력 목록을 표시한다.
/// - 비어있으면 "아직 판정 이력이 없어요." 텍스트.
/// - 항목 있으면 [ListView.builder] — foodName + verdict 배지 + checkedAt.
/// - 우상단 삭제 버튼 → [VerdictHistoryController.clear].
/// - AppBar 아래 필터 칩(전체/권장/주의/위험)으로 등급별 필터링.
class VerdictHistoryScreen extends ConsumerStatefulWidget {
  const VerdictHistoryScreen({super.key});

  @override
  ConsumerState<VerdictHistoryScreen> createState() =>
      _VerdictHistoryScreenState();
}

class _VerdictHistoryScreenState extends ConsumerState<VerdictHistoryScreen> {
  String _selectedFilter = '전체';

  static const _filters = ['전체', '권장', '주의', '위험'];

  static const _filterToVerdict = {
    '권장': 'safe',
    '주의': 'caution',
    '위험': 'avoid',
  };

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(verdictHistoryControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '판정 이력',
          style: AppTextStyles.body1Bold.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textPrimary),
            tooltip: '이력 삭제',
            onPressed: () =>
                ref.read(verdictHistoryControllerProvider.notifier).clear(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── 필터 칩 행 ────────────────────────────────────────────────
          _FilterChipRow(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onSelected: (filter) => setState(() => _selectedFilter = filter),
          ),

          // ── 이력 목록 ─────────────────────────────────────────────────
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  '이력을 불러오지 못했어요.',
                  style: AppTextStyles.body2Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
              data: (items) {
                // 필터 적용
                final verdictFilter = _filterToVerdict[_selectedFilter];
                final filtered = verdictFilter == null
                    ? items
                    : items
                        .where((item) => item.verdict == verdictFilter)
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '아직 판정 이력이 없어요',
                          style: AppTextStyles.body1Bold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '음식을 검색해 판정을 받아보세요',
                          style: AppTextStyles.body2Regular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    // 원본 인덱스 계산 (삭제 시 필요)
                    final originalIndex = items.indexOf(item);
                    return Dismissible(
                      key: ValueKey(item.foodName),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        color: const Color(0xFFD32F2F),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) => ref
                          .read(verdictHistoryControllerProvider.notifier)
                          .removeAt(originalIndex),
                      child: _VerdictHistoryTile(item: item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 필터 칩 행
// ---------------------------------------------------------------------------

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => onSelected(filter),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.caption1Medium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 이력 항목 타일
// ---------------------------------------------------------------------------

class _VerdictHistoryTile extends StatelessWidget {
  const _VerdictHistoryTile({required this.item});

  final VerdictHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final local = item.checkedAt.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    final dateStr = '${local.month}월 ${local.day}일 $hh:$min';

    return ListTile(
      title: Text(
        item.foodName,
        style: AppTextStyles.body1Medium.copyWith(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        dateStr,
        style:
            AppTextStyles.caption1Medium.copyWith(color: AppColors.textSecondary),
      ),
      trailing: _VerdictBadge(verdict: item.verdict),
    );
  }
}

// ---------------------------------------------------------------------------
// 판정 배지
// ---------------------------------------------------------------------------

class _VerdictBadge extends StatelessWidget {
  const _VerdictBadge({required this.verdict});

  final String verdict;

  Color get _bgColor => switch (verdict) {
        'safe' => const Color(0xFFE6F7EF),
        'caution' => const Color(0xFFFFF8E1),
        'avoid' => const Color(0xFFFFEBEE),
        _ => const Color(0xFFF5F5F5),
      };

  Color get _textColor => switch (verdict) {
        'safe' => const Color(0xFF00875A),
        'caution' => const Color(0xFFB06000),
        'avoid' => const Color(0xFFD32F2F),
        _ => AppColors.textSecondary,
      };

  String get _label => switch (verdict) {
        'safe' => '권장',
        'caution' => '주의',
        'avoid' => '위험',
        _ => '확인어려움',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption1Medium.copyWith(color: _textColor),
      ),
    );
  }
}
