import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 의료성 면책 고지. 판별 결과를 보여주는 모든 화면에 노출한다(제품 요건).
///
/// ADR-0005: disclaimerBg 배경 + radiusCard 반경 + cardPadding 적용.
class MedicalDisclaimer extends StatelessWidget {
  const MedicalDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.disclaimerBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: AppSpacing.cardPadding, // 16
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.iconTextGap),
          Expanded(
            child: Text(
              '이 결과는 일반적인 참고 정보이며 의학적 진단이나 처방을 대신하지 않습니다. '
              '증상이 지속되면 전문의와 상담하세요.',
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
