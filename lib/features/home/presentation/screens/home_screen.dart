import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_card.dart';
import 'package:can_i_eat_it/features/food_check/data/search_history_providers.dart';

/// W2 홈 화면 — 검색 진입 + 최근 검색 + 오늘의 기록 플레이스홀더.
///
/// AppShell(하단 탭) 내부에 포함되므로 자체 bottomNavigationBar를 갖지 않는다.
/// TODO(figma): 홈 인사말 Figma 미설계 — 디자이너 확정 시 정합.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(searchHistoryControllerProvider);
    final controller = ref.read(searchHistoryControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 인사말 ──────────────────────────────────────────────
              Text(
                '오늘도 안심하고 드세요',
                style: AppTextStyles.header1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 검색 진입 (tappable, NOT a real TextField) ──────────
              _SearchEntryBar(
                onTap: () => context.push('/check'),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 최근 검색 섹션 ──────────────────────────────────────
              Text(
                '최근 검색',
                style: AppTextStyles.body1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              historyAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (terms) => terms.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.itemGap,
                        ),
                        child: Text(
                          '아직 검색 기록이 없어요',
                          style: AppTextStyles.body2Regular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : Column(
                        children: terms
                            .map(
                              (term) => _SearchHistoryRow(
                                term: term,
                                onDelete: () => controller.removeTerm(term),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 오늘의 기록 플레이스홀더 ────────────────────────────
              // TODO(W4): 식사·증상 데이터 연결 시 실제 요약으로 교체.
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 기록',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    Text(
                      '식사와 증상을 기록하면 여기에서 한눈에 볼 수 있어요',
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 검색 진입 바 (tappable container) ──────────────────────────────────────

class _SearchEntryBar extends StatelessWidget {
  const _SearchEntryBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.cardPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Text(
              '음식을 검색해주세요',
              style: AppTextStyles.body1Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 최근 검색 행 ─────────────────────────────────────────────────────────────

class _SearchHistoryRow extends StatelessWidget {
  const _SearchHistoryRow({
    required this.term,
    required this.onDelete,
  });

  final String term;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              term,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
