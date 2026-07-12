import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/presentation/widgets/mood_face.dart';

/// 판정 상세 카드 — Figma HeroSection 재정합 (W3-3).
///
/// 구조:
/// 1. AI 분석 카드: sparkle + "AI 분석" 보라 칩 + 캡션 + items 불릿
/// 2. 증상 기록 섹션: "N개의 증상 기록" 헤더 + "모두 보기 >" + 카드형 기록 (≤3개)
/// 3. 대체 음식 섹션: "대체 음식 추천" 헤더 + 카드형 substitute 목록
///
/// unknown 상태는 이 위젯 대신 [VerdictUnknownScreen]을 사용한다.
class VerdictDetailCard extends StatelessWidget {
  const VerdictDetailCard({
    super.key,
    required this.verdict,
    this.onSeeAllRecords,
  });

  final EatVerdict verdict;

  /// "모두 보기" 탭 콜백. null이면 탭 무동작(F3 placeholder).
  final VoidCallback? onSeeAllRecords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. AI 분석 카드
        if (verdict.items.isNotEmpty) ...[
          _AiAnalysisCard(items: verdict.items),
          const SizedBox(height: AppSpacing.sectionGap),
        ],

        // 2. 증상 기록 섹션 (total>0 일 때만)
        if (verdict.stateRecords.total > 0) ...[
          _StateRecordsSection(
            stateRecords: verdict.stateRecords,
            onSeeAll: onSeeAllRecords,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
        ],

        // 3. 대체 음식 섹션 (빈배열이면 숨김)
        if (verdict.substitutes.isNotEmpty) ...[
          _SubstitutesSection(substitutes: verdict.substitutes),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AI 분석 카드
// ---------------------------------------------------------------------------

class _AiAnalysisCard extends StatelessWidget {
  const _AiAnalysisCard({required this.items});

  final List<VerdictItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 행: sparkle + "AI 분석" 보라 칩 + 캡션
          Row(
            children: [
              // AI 분석 칩
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.itemGap,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2FF), // 연보라 배경(Figma)
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppIcon(AppIcons.sparkle, size: AppIconSizes.s16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'AI 분석',
                      style: AppTextStyles.caption1Bold.copyWith(
                        color: const Color(0xFF9747FF), // 보라(Figma)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              // 캡션
              Flexible(
                child: Text(
                  '내 정보와 식사 기록을 바탕으로 분석',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardPadding),

          // 불릿 항목들
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.cardPadding),
            _BulletItem(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.item});

  final VerdictItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 볼드 emphasis 줄 (• 불릿 포함)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• ',
              style: AppTextStyles.body2Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: Text(
                item.emphasis,
                style: AppTextStyles.body2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // 회색 body 텍스트
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.itemGap),
          child: Text(
            item.body,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 증상 기록 섹션
// ---------------------------------------------------------------------------

class _StateRecordsSection extends StatelessWidget {
  const _StateRecordsSection({
    required this.stateRecords,
    this.onSeeAll,
  });

  final VerdictStateRecords stateRecords;

  /// null이면 "모두 보기" 탭 무동작 (F3 placeholder)
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    // ≤3개만 표시
    final displayRecords = stateRecords.records.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 행
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${stateRecords.total}개의 증상 기록',
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '모두 보기',
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const AppIcon(
                    AppIcons.chevronRight,
                    size: AppIconSizes.s16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.itemGap),

        // 기록 카드 (테두리 카드)
        for (var i = 0; i < displayRecords.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.itemGap),
          _StateRecordCard(record: displayRecords[i]),
        ],
      ],
    );
  }
}

class _StateRecordCard extends StatelessWidget {
  const _StateRecordCard({required this.record});

  final VerdictStateRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.itemGap + AppSpacing.xs, // 12
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // 좌측 심각도 무드 얼굴 (서버 라벨 → SymptomState 근사 매핑)
          MoodFace(state: SymptomStateMapper.fromLabel(record.label), size: 32),
          const SizedBox(width: AppSpacing.cardPadding),
          // label (볼드)
          Expanded(
            child: Text(
              record.label,
              style: AppTextStyles.body2Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // 우측 날짜 · 타이밍 (회색)
          Text(
            '${record.date} · ${record.timing}',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 대체 음식 섹션
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
          '대체 음식 추천',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),

        for (var i = 0; i < substitutes.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.itemGap),
          _SubstituteCard(substitute: substitutes[i]),
        ],
      ],
    );
  }
}

class _SubstituteCard extends StatelessWidget {
  const _SubstituteCard({required this.substitute});

  final VerdictSubstitute substitute;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.itemGap + AppSpacing.xs, // 12
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // 음식 카테고리 미제공(엔티티에 code 없음) → regular 폴백 일러스트.
          const CategoryIcon(code: null, size: 28),
          const SizedBox(width: AppSpacing.cardPadding),
          Expanded(
            child: Text(
              substitute.name,
              style: AppTextStyles.body2Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // 우측 녹색 체크 배지(권장 배지 재사용)
          const AppIcon(AppIcons.verdictRecommend, size: AppIconSizes.s24),
        ],
      ),
    );
  }
}
