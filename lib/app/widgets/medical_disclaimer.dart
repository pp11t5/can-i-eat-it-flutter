import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 판별 결과 화면용 기본 면책 고지 문구.
const String kResultDisclaimerText =
    '이 결과는 일반적인 참고 정보이며 의학적 진단이나 처방을 대신하지 않습니다. '
    '증상이 지속되면 전문의와 상담하세요.';

/// 온보딩 등 입력 화면용 면책 고지 문구(Figma 1064:12268 verbatim).
const String kOnboardingDisclaimerText =
    '이 앱은 건강 관리를 돕는 참고용 서비스입니다. 진단이나 치료가 필요한 경우 전문의와 상담해 주세요.';

/// 의료성 면책 고지. 판별 결과·입력 화면 등에 노출한다(제품 요건).
///
/// ADR-0005: disclaimerBg 배경 + radiusCard 반경 + cardPadding 적용.
/// [message] 미지정 시 판별 결과용 기본 문구([kResultDisclaimerText])를 사용한다.
class MedicalDisclaimer extends StatelessWidget {
  const MedicalDisclaimer({super.key, this.message = kResultDisclaimerText});

  /// 노출할 면책 문구. 화면 맥락에 맞게 교체 가능.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
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
              message,
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
