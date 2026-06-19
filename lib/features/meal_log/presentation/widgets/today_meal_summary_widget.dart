import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';

/// 홈 화면용 "오늘의 식사" 요약 카드.
///
/// 오늘(KST) 기준으로 [TimelineController]를 watch해
/// 기록된 식사 수·마지막 식사 시간을 표시한다.
/// "더 보기" 버튼 탭 시 `/meal-log` 라우트로 push한다.
class TodayMealSummaryWidget extends ConsumerWidget {
  const TodayMealSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = nowKst();
    final timelineAsync = ref.watch(timelineControllerProvider(today));

    return timelineAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          '식사 기록을 불러오지 못했어요.',
          style:
              AppTextStyles.body2Regular.copyWith(color: AppColors.textSecondary),
        ),
      ),
      data: (groups) {
        // 오늘 날짜 KST 기준으로 필터링
        final todayStr = toServerDate(today); // 'YYYY-MM-DD'
        final todayGroups = groups.where((g) {
          // eatenAt: ISO-8601, 앞 10자리가 날짜
          return g.eatenAt.startsWith(todayStr);
        }).toList();

        // 오늘 기록된 전체 식사 수 (MealRecord 수 합산)
        final totalCount =
            todayGroups.fold<int>(0, (sum, g) => sum + g.records.length);

        // 마지막 식사 시간: eatenAt 기준 최댓값
        String? lastTime;
        if (todayGroups.isNotEmpty) {
          final allRecords = todayGroups
              .expand((g) => g.records)
              .toList()
            ..sort((a, b) => a.eatenAt.compareTo(b.eatenAt));
          if (allRecords.isNotEmpty) {
            // eatenAt 예: '2026-06-17T08:00:00+09:00' — HH:mm 추출
            final last = allRecords.last.eatenAt;
            lastTime = _extractHHmm(last);
          }
        }

        return _SummaryCard(
          totalCount: totalCount,
          lastTime: lastTime,
        );
      },
    );
  }

  /// ISO-8601 문자열에서 'HH:mm' 추출.
  /// 예: '2026-06-17T08:00:00+09:00' → '08:00'
  String? _extractHHmm(String isoString) {
    final tIdx = isoString.indexOf('T');
    if (tIdx < 0 || tIdx + 6 > isoString.length) return null;
    return isoString.substring(tIdx + 1, tIdx + 6); // 'HH:mm'
  }
}

// ---------------------------------------------------------------------------
// 내부 카드 위젯
// ---------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalCount,
    this.lastTime,
  });

  final int totalCount;
  final String? lastTime;

  @override
  Widget build(BuildContext context) {
    final isEmpty = totalCount == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 헤더 행 ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '오늘의 식사',
                style: AppTextStyles.body1Bold
                    .copyWith(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () => context.push('/meal-log'),
                child: Text(
                  '더 보기',
                  style: AppTextStyles.body2Regular
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── 본문 ─────────────────────────────────────────────────────
          if (isEmpty)
            Text(
              '오늘 기록된 식사가 없어요.',
              style: AppTextStyles.body2Regular
                  .copyWith(color: AppColors.textSecondary),
            )
          else ...[
            // 식사 수
            Row(
              children: [
                Text(
                  '$totalCount개',
                  style: AppTextStyles.body1Bold
                      .copyWith(color: AppColors.primary),
                ),
                Text(
                  ' 기록됨',
                  style: AppTextStyles.body2Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 마지막 식사 시간
            Text(
              lastTime != null ? '마지막: $lastTime' : '아직 기록 없음',
              style: AppTextStyles.caption1Medium
                  .copyWith(color: AppColors.textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}
