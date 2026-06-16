import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';

/// 판정 결과 화면 (W3-3 충실 정합).
///
/// [verdict] 상태에 따라:
/// - [VerdictLevel.unknown]: [VerdictUnknownScreen] 위임 (성공 응답 — D1).
/// - recommend / caution / risk: [VerdictDetailCard] + CTA 2개 표시.
///
/// CTA:
/// - "다시 검색": [onRetry] 콜백 (아웃라인 #00BF72).
/// - "내 식단에 추가": [onAddToDiet] 콜백 (채움 #00BF72). F3 미구현 → placeholder.
///
/// stateRecords "모두 보기": F3 소관 → placeholder (크래시 없이 스낵바).
class VerdictResultScreen extends ConsumerWidget {
  const VerdictResultScreen({
    super.key,
    required this.verdict,
    required this.onRetry,
    this.onAddToDiet,
  });

  final EatVerdict verdict;

  /// 다시 검색 콜백.
  final VoidCallback onRetry;

  /// 내 식단에 추가 콜백. null이면 스낵바 placeholder.
  final VoidCallback? onAddToDiet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // unknown 상태는 확인어려움 화면으로 위임 (성공 응답 — D1, R3)
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
          onPressed: onRetry,
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
            // 상세 판정 카드 (HeroSection + items + substitutes + stateRecords)
            VerdictDetailCard(verdict: verdict),
            const SizedBox(height: AppSpacing.sectionGap),

            // stateRecords "모두 보기" — total>0 이면 노출 (F3 placeholder)
            if (verdict.stateRecords.total > 0) ...[
              _SeeAllRecordsButton(
                total: verdict.stateRecords.total,
                onTap: () => _showF3Placeholder(context),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],

            // 면책 고지 (모든 verdict 화면 필수 — 제품 요건)
            const MedicalDisclaimer(),
            const SizedBox(height: AppSpacing.sectionGap),

            // CTA 2개
            _CtaSection(
              onRetry: onRetry,
              onAddToDiet: onAddToDiet ??
                  () => _showF3Placeholder(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showF3Placeholder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('곧 제공돼요'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "모두 보기" 버튼 (stateRecords, F3 placeholder)
// ---------------------------------------------------------------------------

class _SeeAllRecordsButton extends StatelessWidget {
  const _SeeAllRecordsButton({
    required this.total,
    required this.onTap,
  });

  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '섭취 기록 $total건',
          style: AppTextStyles.body2Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            '모두 보기',
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CTA 2개 (다시 검색 + 내 식단에 추가)
// ---------------------------------------------------------------------------

class _CtaSection extends StatelessWidget {
  const _CtaSection({
    required this.onRetry,
    required this.onAddToDiet,
  });

  final VoidCallback onRetry;
  final VoidCallback onAddToDiet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "다시 검색" — 아웃라인 버튼 #00BF72
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
        const SizedBox(height: AppSpacing.itemGap),
        // "내 식단에 추가" — 채움 버튼 #00BF72 (F3 placeholder)
        SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: onAddToDiet,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              textStyle: AppTextStyles.body1Bold,
              padding: EdgeInsets.zero,
            ),
            child: const Text('내 식단에 추가'),
          ),
        ),
      ],
    );
  }
}
