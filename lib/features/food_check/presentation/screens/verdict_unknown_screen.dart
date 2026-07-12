import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';

/// 확인어려움 화면 (Figma node 554-5327).
///
/// 3가지 검색 팁 카드 + "다시 검색" CTA + MedicalDisclaimer.
///
/// 파라미터:
/// - [onRetry]: "다시 검색" 버튼 탭 콜백 (내비게이션은 티켓 6 담당).
class VerdictUnknownScreen extends StatelessWidget {
  const VerdictUnknownScreen({super.key, required this.onRetry});

  /// "다시 검색" 버튼 탭 콜백.
  /// 실제 화면 전환은 티켓 6(FoodCheckScreen 라우트)에서 처리한다.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding, // left 16
                  AppSpacing.itemGap,       // top 8
                  AppSpacing.screenPadding, // right 16
                  AppSpacing.itemGap,       // bottom 8
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목: Header_2(B) 20/Bold, lineHeight 120%, color #1A1A1F.
                    // Figma 554-5327: 제목 프레임은 가로 중앙 정렬(row justifyContent center).
                    Center(
                      child: Text(
                        '확인할 수 없어요',
                        style: AppTextStyles.header2Bold.copyWith(
                          color: const Color(0xFF1A1A1F),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 팁 카드
                    _TipCard(),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 면책 고지
                    const MedicalDisclaimer(),
                  ],
                ),
              ),
            ),
            // 하단 CTA
            _CtaWrap(onRetry: onRetry),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 팁 카드 (Figma: bg #FCFCFC, border #EAEAEA 1px, radius 16, padding 24)
// ---------------------------------------------------------------------------

class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(AppSpacing.sectionGap), // 24
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 팁 1
          _TipRow(
            tipText: '짧게 핵심 재료만 검색해보세요',
            badChipText: '간장 닭갈비 정식',
            goodChipText: '닭갈비',
          ),
          _TipDivider(),
          // 팁 2
          _TipRow(
            tipText: '영문이 아닌 한글로 검색해보세요',
            badChipText: 'galbi',
            goodChipText: '갈비',
          ),
          _TipDivider(),
          // 팁 3 (오타 교정: '집접' → '직접')
          _TipSimple(
            tipText: '등록되지 않은 음식은 직접 추가해보세요',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 팁 행 (텍스트 + 칩 변환 예시)
// ---------------------------------------------------------------------------

class _TipRow extends StatelessWidget {
  const _TipRow({
    required this.tipText,
    required this.badChipText,
    required this.goodChipText,
  });

  final String tipText;
  final String badChipText;
  final String goodChipText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tipText,
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // 나쁜 칩 (분홍: bg #FFE0E0, close 아이콘)
            _SearchChip(
              text: badChipText,
              backgroundColor: const Color(0xFFFFE0E0),
              iconAsset: AppIcons.close,
              iconColor: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            // 변환 화살표 (나쁜 검색 → 좋은 검색). Figma 렌더는 우측 방향(→).
            const AppIcon(
              AppIcons.arrowRight,
              size: AppIconSizes.s24,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            // 좋은 칩 (녹색: bg #D9F5EA, check 아이콘)
            _SearchChip(
              text: goodChipText,
              backgroundColor: const Color(0xFFD9F5EA),
              iconAsset: AppIcons.check,
              iconColor: const Color(0xFF525252),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 팁 3 — 칩 예시 없는 단순 텍스트 팁
// ---------------------------------------------------------------------------

class _TipSimple extends StatelessWidget {
  const _TipSimple({required this.tipText});

  final String tipText;

  @override
  Widget build(BuildContext context) {
    return Text(
      tipText,
      style: AppTextStyles.body1Medium.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 칩 (radius 999, padding 8/12, 아이콘 + 텍스트)
// ---------------------------------------------------------------------------

class _SearchChip extends StatelessWidget {
  const _SearchChip({
    required this.text,
    required this.backgroundColor,
    required this.iconAsset,
    required this.iconColor,
  });

  final String text;
  final Color backgroundColor;
  final String iconAsset;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: AppSpacing.itemGap, // 8
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: const Color(0xFFE9E9E9)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(iconAsset, size: AppIconSizes.s16, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 팁 구분선
// ---------------------------------------------------------------------------

class _TipDivider extends StatelessWidget {
  const _TipDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sectionGap), // 24 top/bottom
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFEAEAEA),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 하단 CTA 영역 (padding 16/16/32)
// ---------------------------------------------------------------------------

class _CtaWrap extends StatelessWidget {
  const _CtaWrap({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding, // left 16
        AppSpacing.screenPadding, // top 16
        AppSpacing.screenPadding, // right 16
        32,                       // bottom 32
      ),
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
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard), // 8
            ),
            textStyle: AppTextStyles.body1Bold,
            padding: EdgeInsets.zero,
          ),
          child: const Text('다시 검색'),
        ),
      ),
    );
  }
}
