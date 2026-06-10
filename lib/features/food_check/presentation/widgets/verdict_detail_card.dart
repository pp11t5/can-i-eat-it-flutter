import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_card.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_badge.dart';

/// 판정 상세 카드 — 3섹션 구조 (ADR-0003 §4).
///
/// [VerdictCard] 의 플레이스홀더를 실제 콘텐츠로 대체한 완성 버전.
/// unknown 상태는 이 위젯 대신 [VerdictUnknownScreen] 을 사용한다.
///
/// 섹션 구조:
/// - Section 1: [EatVerdict.reasonGeneral] — 일반 분석
/// - Section 2: [EatVerdict.reasonPersonal] + [EatVerdict.alternatives] — 개인화 분석
/// - Section 3: [EatVerdict.historySummary] — 섭취 후 기록 (count == 0 이면 숨김)
///
/// 파라미터:
/// - [verdict]: 판정 결과 엔티티 (unknown 제외).
class VerdictDetailCard extends StatelessWidget {
  const VerdictDetailCard({super.key, required this.verdict});

  final EatVerdict verdict;

  Color _verdictColor() {
    return switch (verdict.level) {
      VerdictLevel.recommend => AppColors.verdictRecommend,
      VerdictLevel.caution => AppColors.verdictCaution,
      VerdictLevel.danger => AppColors.verdictDanger,
      VerdictLevel.unknown => AppColors.verdictUnknown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final verdictColor = _verdictColor();

    return AppCard(
      padding: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 좌측 컬러 바
              Container(
                width: AppSpacing.xs,
                color: verdictColor,
              ),
              // 본문 영역
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 헤더: 배지 + 음식명
                      Row(
                        children: [
                          VerdictBadge(level: verdict.level),
                          const SizedBox(width: AppSpacing.itemGap),
                          Expanded(
                            child: Text(
                              verdict.foodName,
                              style: AppTextStyles.header2Bold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      const SizedBox(height: AppSpacing.itemGap),

                      // Section 1 — 일반 분석
                      if (verdict.reasonGeneral.isNotEmpty) ...[
                        const _SectionLabel(label: '일반 분석'),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          verdict.reasonGeneral,
                          style: AppTextStyles.body2Medium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),
                      ],

                      // Section 2 — 개인화 맞춤 분석
                      if (verdict.reasonPersonal.isNotEmpty) ...[
                        const _SectionLabel(label: '나에게 맞는 분석'),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          verdict.reasonPersonal,
                          style: AppTextStyles.body2Medium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // 대체 음식 (caution / danger)
                        if (verdict.alternatives.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.itemGap),
                          _AlternativesRow(alternatives: verdict.alternatives),
                        ],
                        const SizedBox(height: AppSpacing.sectionGap),
                      ],

                      // Section 3 — 섭취 후 기록 (기록 있을 때만)
                      if (verdict.historySummary.count > 0) ...[
                        const _SectionLabel(label: '이전 섭취 기록'),
                        const SizedBox(height: AppSpacing.xs),
                        _HistorySummaryRow(
                          count: verdict.historySummary.count,
                          averageSeverity: verdict.historySummary.averageSeverity,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 섹션 레이블
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.body2Bold.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 대체 음식 칩 행
// ---------------------------------------------------------------------------

class _AlternativesRow extends StatelessWidget {
  const _AlternativesRow({required this.alternatives});

  final List<String> alternatives;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final alt in alternatives)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.chipPaddingH,
              vertical: AppSpacing.chipPaddingV,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSelected,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(color: AppColors.primary),
            ),
            child: Text(
              alt,
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 섭취 후 기록 요약 행
// ---------------------------------------------------------------------------

class _HistorySummaryRow extends StatelessWidget {
  const _HistorySummaryRow({
    required this.count,
    this.averageSeverity,
  });

  final int count;
  final String? averageSeverity;

  @override
  Widget build(BuildContext context) {
    final severityText = averageSeverity != null ? ' · 평균 $averageSeverity' : '';
    return Text(
      '$count회 섭취 기록$severityText',
      style: AppTextStyles.body2Medium.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}
