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
class VerdictHistoryScreen extends ConsumerWidget {
  const VerdictHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            '이력을 불러오지 못했어요.',
            style: AppTextStyles.body2Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                '아직 판정 이력이 없어요.',
                style: AppTextStyles.body2Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _VerdictHistoryTile(item: items[index]),
          );
        },
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
    final mm = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    final dateStr = '$mm/$dd $hh:$min';

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
