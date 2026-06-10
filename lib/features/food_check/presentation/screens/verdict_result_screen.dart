import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';

/// 판정 결과 화면.
///
/// [verdict] 상태에 따라:
/// - [VerdictLevel.unknown]: [VerdictUnknownScreen] 위임.
/// - 그 외(recommend / caution / danger): [VerdictDetailCard] 3섹션 표시.
///
/// 파라미터:
/// - [verdict]: 판정 결과 엔티티.
/// - [onRetry]: "다시 검색" / "돌아가기" 콜백 (내비게이션은 티켓 6 담당).
class VerdictResultScreen extends ConsumerWidget {
  const VerdictResultScreen({
    super.key,
    required this.verdict,
    required this.onRetry,
  });

  final EatVerdict verdict;

  /// 다시 검색 콜백. 티켓 6에서 실제 내비게이션으로 연결한다.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // unknown 상태는 확인어려움 화면으로 위임
    if (verdict.level == VerdictLevel.unknown) {
      return VerdictUnknownScreen(onRetry: onRetry);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: onRetry, // 뒤로가기 = 다시 검색으로 위임
        ),
        title: Text(
          '판정 결과',
          style: AppTextStyles.header2Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상세 판정 카드 (3섹션)
            VerdictDetailCard(verdict: verdict),
            const SizedBox(height: AppSpacing.sectionGap),
            // 면책 고지 (모든 verdict 화면 필수)
            const MedicalDisclaimer(),
            const SizedBox(height: AppSpacing.sectionGap),
            // 다시 검색 버튼
            SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  textStyle: AppTextStyles.body1Bold,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('다시 검색'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
