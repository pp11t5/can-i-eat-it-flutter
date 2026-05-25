import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_card.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_badge.dart';

/// 판정 결과 카드 — 4상태 시각 골격.
///
/// VerdictCard 3섹션(일반분석/개인화/섭취기록) 상세 콘텐츠는 W3 범위.
/// 현재 구현: 상단 헤더(배지 + 음식명) + 좌측 컬러 바 강조 + 분석 결과 플레이스홀더
/// + 하단 MedicalDisclaimer 슬롯.
///
/// unknown 상태는 ADR-0003 기준 "확인이 어려워요" 톤으로 차별화.
///
/// 파라미터:
/// - [level]: 판정 상태.
/// - [foodName]: 음식 이름.
class VerdictCard extends StatelessWidget {
  const VerdictCard({
    super.key,
    required this.level,
    required this.foodName,
  });

  final VerdictLevel level;
  final String foodName;

  Color _verdictColor() {
    return switch (level) {
      VerdictLevel.recommend => AppColors.verdictRecommend,
      VerdictLevel.caution => AppColors.verdictCaution,
      VerdictLevel.danger => AppColors.verdictDanger,
      VerdictLevel.unknown => AppColors.verdictUnknown,
    };
  }

  /// unknown 상태 전용 메시지 (ADR-0003: 단정 회피 톤).
  String _placeholderMessage() {
    return switch (level) {
      VerdictLevel.unknown =>
        '이 음식에 대한 정보가 충분하지 않아 확인이 어려워요.\n'
        '전문의와 상담하거나 소량씩 시도해 보세요.',
      VerdictLevel.recommend ||
      VerdictLevel.caution ||
      VerdictLevel.danger =>
        '분석 결과가 이곳에 표시됩니다.',
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
                          VerdictBadge(level: level),
                          const SizedBox(width: AppSpacing.itemGap),
                          Expanded(
                            child: Text(
                              foodName,
                              style: AppTextStyles.title.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      // 배경 틴트 구분선
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      // 분석 결과 플레이스홀더 (W3에서 3섹션으로 교체)
                      Text(
                        _placeholderMessage(),
                        style: AppTextStyles.body.copyWith(
                          color: level == VerdictLevel.unknown
                              ? AppColors.textSecondary
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sectionGap),
                      // 면책 고지 슬롯 (제품 요건 — 모든 verdict 화면 노출)
                      const MedicalDisclaimer(),
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
