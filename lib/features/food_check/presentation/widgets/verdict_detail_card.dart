import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_card.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_badge.dart';

/// 판정 상세 카드 — 신 구조 (W3-3, ADR-0003).
///
/// 서버 judgment 계약에 충실 정합:
/// - HeroSection: personalTitle + VerdictBadge
/// - PersonalAnalysis: items 2개 (트리거/증상, 알레르기/복용약)
/// - Substitutes: 대체 음식 칩 (빈배열이면 섹션 숨김)
/// - StateRecords: 연관 섭취 기록 (total==0이면 빈상태 또는 숨김)
///
/// unknown 상태는 이 위젯 대신 [VerdictUnknownScreen] 을 사용한다.
class VerdictDetailCard extends StatelessWidget {
  const VerdictDetailCard({super.key, required this.verdict});

  final EatVerdict verdict;

  Color _verdictColor() {
    return switch (verdict.level) {
      VerdictLevel.recommend => AppColors.verdictRecommend,
      VerdictLevel.caution => AppColors.verdictCaution,
      VerdictLevel.risk => AppColors.verdictDanger,   // 색상 토큰명 유지 (ADR-0003)
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
                      // HeroSection — VerdictBadge + personalTitle
                      _HeroSection(verdict: verdict),
                      const SizedBox(height: AppSpacing.itemGap),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      const SizedBox(height: AppSpacing.itemGap),

                      // PersonalAnalysis — items 2개
                      if (verdict.items.isNotEmpty) ...[
                        _PersonalAnalysisSection(items: verdict.items),
                        const SizedBox(height: AppSpacing.sectionGap),
                      ],

                      // Substitutes — 대체 음식 (빈배열이면 숨김)
                      if (verdict.substitutes.isNotEmpty) ...[
                        _SubstitutesSection(
                          substitutes: verdict.substitutes,
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),
                      ],

                      // StateRecords — 연관 섭취 기록 (total==0이면 숨김)
                      if (verdict.stateRecords.total > 0) ...[
                        _StateRecordsSection(
                          stateRecords: verdict.stateRecords,
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
// HeroSection
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.verdict});

  final EatVerdict verdict;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VerdictBadge(level: verdict.level),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                verdict.foodName,
                style: AppTextStyles.header2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (verdict.personalTitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  verdict.personalTitle,
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// PersonalAnalysis — items 2개
// ---------------------------------------------------------------------------

class _PersonalAnalysisSection extends StatelessWidget {
  const _PersonalAnalysisSection({required this.items});

  final List<VerdictItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.itemGap),
          _ItemRow(item: items[i]),
        ],
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final VerdictItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.emphasis,
          style: AppTextStyles.body2Bold.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          item.body,
          style: AppTextStyles.body2Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Substitutes — 대체 음식 칩 행
// ---------------------------------------------------------------------------

class _SubstitutesSection extends StatelessWidget {
  const _SubstitutesSection({required this.substitutes});

  final List<VerdictSubstitute> substitutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 음식은 어때요?',
          style: AppTextStyles.body2Bold.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final sub in substitutes)
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
                  sub.name,
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// StateRecords — 연관 섭취 기록
// ---------------------------------------------------------------------------

class _StateRecordsSection extends StatelessWidget {
  const _StateRecordsSection({required this.stateRecords});

  final VerdictStateRecords stateRecords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 먹고 기록한 내역',
          style: AppTextStyles.body2Bold.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final record in stateRecords.records) ...[
          _StateRecordRow(record: record),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

class _StateRecordRow extends StatelessWidget {
  const _StateRecordRow({required this.record});

  final VerdictStateRecord record;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            record.label,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          '${record.date} · ${record.timing}',
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
