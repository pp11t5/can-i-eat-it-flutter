import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_all_records_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';

/// 판정 결과 화면 (W3-3 Figma HeroSection 정합).
///
/// [verdict] 상태에 따라:
/// - [VerdictLevel.unknown]: [VerdictUnknownScreen] 위임 (성공 응답 — D1).
/// - recommend / caution / risk: HeroSection + VerdictDetailCard + CTA 2개 표시.
///
/// TopBar: "식사 가이드" 가운데 정렬, 좌측 뒤로/닫기 아이콘.
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
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s24,
            color: AppColors.textPrimary,
            semanticsLabel: '뒤로',
          ),
          onPressed: onRetry,
        ),
        title: Text(
          '식사 가이드',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HeroSection: 원형 placeholder + 음식명 + 등급 헤드라인
            _HeroSection(verdict: verdict),
            const SizedBox(height: AppSpacing.contentGap),

            // 상세 판정 카드 (AI분석 칩 카드 + 불릿 items + 대체음식 + 기록)
            VerdictDetailCard(
              verdict: verdict,
              onSeeAllRecords: verdict.stateRecords.total > 0
                  ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VerdictAllRecordsScreen(
                            stateRecords: verdict.stateRecords,
                          ),
                        ),
                      )
                  : null,
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // 면책 고지 (모든 verdict 화면 필수 — 제품 요건)
            const MedicalDisclaimer(),
            const SizedBox(height: AppSpacing.sectionGap),

            // CTA 2개
            _CtaSection(
              onRetry: onRetry,
              onAddToDiet: onAddToDiet ?? () => _showF3Placeholder(context),
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
// HeroSection: 원형 placeholder + 음식명 + 등급 헤드라인
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.verdict});

  final EatVerdict verdict;

  /// 등급별 헤드라인 배지 (자체완결 색배지 — 초록체크/주황!/빨강X).
  /// unknown 은 build() 상단에서 [VerdictUnknownScreen] 으로 위임돼 여기 도달하지 않음.
  Widget _headlineIcon() {
    final asset = switch (verdict.level) {
      VerdictLevel.recommend => AppIcons.verdictRecommend,
      VerdictLevel.caution => AppIcons.verdictCaution,
      VerdictLevel.risk => AppIcons.verdictRisk,
      VerdictLevel.unknown => AppIcons.verdictRisk, // 미도달 폴백
    };
    return AppIcon(asset, size: AppIconSizes.s24);
  }

  /// 등급별 헤드라인 문구
  String _headlineText() {
    return switch (verdict.level) {
      VerdictLevel.recommend => '좋은 선택이에요!',
      VerdictLevel.caution => '속이 편안할 수 있도록 천천히 드세요!',
      VerdictLevel.risk => '속이 많이 불편해질 수 있어요!',
      VerdictLevel.unknown => '확인이 어려워요',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 원형 컨테이너 — Figma: 중립 회색(#FAFAFA) + 연회색 테두리(#DBDBE5),
        // 등급색과 무관하게 항상 동일. 안에 음식 카테고리 일러스트.
        // (by-id 판정: food-type 코드 아이콘 / by-text 판정: category=null → regular 폴백)
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDBDBE5)),
          ),
          child: Center(
            child: CategoryIcon(code: verdict.category, size: 80),
          ),
        ),
        const SizedBox(height: 16),

        // 음식명 — 가운데 정렬, 큰 볼드
        Text(
          verdict.foodName,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
            letterSpacing: 0,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sectionGap),

        // 등급 헤드라인: 아이콘 + 문구 — Figma 좌측 정렬(스크린 마진 기준).
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _headlineIcon(),
            const SizedBox(width: AppSpacing.itemGap),
            Flexible(
              child: Text(
                _headlineText(),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  color: Color(0xFF000000),
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
    return Row(
      children: [
        // "다시 검색" — 아웃라인 버튼 #00BF72
        Expanded(
          child: SizedBox(
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
        ),
        const SizedBox(width: AppSpacing.itemGap),
        // "내 식단에 추가" — 채움 버튼 #00BF72 (F3 placeholder)
        Expanded(
          child: SizedBox(
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
        ),
      ],
    );
  }
}
