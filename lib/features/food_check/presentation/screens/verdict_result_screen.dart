import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/utils/verdict_share_util.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: onRetry,
        ),
        title: Text(
          '식사 가이드',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          _BookmarkButton(verdict: verdict),
        ],
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
            // HeroSection: 원형 placeholder + 음식명 + 등급 헤드라인 (등급별 배경)
            Container(
              decoration: BoxDecoration(
                color: switch (verdict.level) {
                  VerdictLevel.recommend => const Color(0xFFE6F7EF),
                  VerdictLevel.caution => const Color(0xFFFFF8E1),
                  VerdictLevel.risk => const Color(0xFFFFEBEE),
                  VerdictLevel.unknown => AppColors.surface,
                },
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: _HeroSection(verdict: verdict),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // 상세 판정 카드 (AI분석 칩 카드 + 불릿 items + 대체음식 + 기록)
            VerdictDetailCard(verdict: verdict),
            const SizedBox(height: AppSpacing.sectionGap),

            // 면책 고지 (모든 verdict 화면 필수 — 제품 요건)
            const MedicalDisclaimer(),
            const SizedBox(height: AppSpacing.sectionGap),

            // 관련 음식 섹션 (목 데이터)
            const _RelatedFoodsSection(),
            const SizedBox(height: AppSpacing.sectionGap),

            // 영양 정보 섹션 (목 데이터)
            const _NutritionInfoSection(),
            const SizedBox(height: AppSpacing.sectionGap),

            // CTA 3개 (공유하기 + 다시 검색 + 내 식단에 추가)
            _CtaSection(
              verdict: verdict,
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
// AppBar 북마크 버튼
// ---------------------------------------------------------------------------

class _BookmarkButton extends ConsumerStatefulWidget {
  const _BookmarkButton({required this.verdict});

  final EatVerdict verdict;

  @override
  ConsumerState<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends ConsumerState<_BookmarkButton> {
  bool _isToggling = false;

  Future<void> _onTap(bool currentlyFavorite) async {
    if (_isToggling) return;
    setState(() => _isToggling = true);
    try {
      await ref
          .read(favoriteControllerProvider(widget.verdict.foodName).notifier)
          .toggle(widget.verdict);
      if (!mounted) return;
      final added = !currentlyFavorite;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(added ? '즐겨찾기에 추가됐어요' : '즐겨찾기에서 제거됐어요'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('즐겨찾기 변경에 실패했어요'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteAsync =
        ref.watch(favoriteControllerProvider(widget.verdict.foodName));

    return favoriteAsync.when(
      loading: () => const IconButton(
        icon: Icon(Icons.bookmark_border, color: AppColors.textSecondary),
        onPressed: null, // 로딩 중 비활성화
      ),
      error: (_, __) => IconButton(
        icon: const Icon(Icons.bookmark_border, color: AppColors.textSecondary),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('즐겨찾기를 변경할 수 없어요. 잠시 후 다시 시도해주세요.'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      data: (isFavorite) => IconButton(
        icon: Icon(
          isFavorite ? Icons.bookmark : Icons.bookmark_border,
          color: isFavorite ? AppColors.primary : AppColors.textSecondary,
        ),
        onPressed: _isToggling ? null : () => _onTap(isFavorite),
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

  Color _verdictColor() {
    return switch (verdict.level) {
      VerdictLevel.recommend => AppColors.verdictRecommend,
      VerdictLevel.caution => AppColors.verdictCaution,
      VerdictLevel.risk => AppColors.verdictDanger,
      VerdictLevel.unknown => AppColors.verdictUnknown,
    };
  }

  /// 등급별 헤드라인 아이콘
  Widget _headlineIcon(Color color) {
    final decoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
    );
    return switch (verdict.level) {
      VerdictLevel.recommend => Container(
          width: 32,
          height: 32,
          decoration: decoration,
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        ),
      VerdictLevel.caution => Container(
          width: 32,
          height: 32,
          decoration: decoration,
          child: const Icon(Icons.priority_high, color: Colors.white, size: 20),
        ),
      VerdictLevel.risk => Container(
          width: 32,
          height: 32,
          decoration: decoration,
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        ),
      VerdictLevel.unknown => Container(
          width: 32,
          height: 32,
          decoration: decoration,
          child: const Icon(Icons.help_outline, color: Colors.white, size: 20),
        ),
    };
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

  /// 등급별 라벨 텍스트 색상
  Color _labelColor() {
    return switch (verdict.level) {
      VerdictLevel.recommend => const Color(0xFF00875A),
      VerdictLevel.caution => const Color(0xFFB06000),
      VerdictLevel.risk => const Color(0xFFD32F2F),
      VerdictLevel.unknown => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _verdictColor();

    return Semantics(
      label: '${verdict.foodName}, 판정: ${verdict.level.label}',
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 원형 컨테이너 — 음식 이미지 없음 → 등급색 배경 + 등급 아이콘 placeholder
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.25), width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.restaurant,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),

        // 음식명 — 가운데 정렬, 큰 볼드
        Text(
          verdict.foodName,
          style: AppTextStyles.header1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        // 카테고리 서브텍스트 (있을 때만 표시)
        if (verdict.category != null && verdict.category!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            verdict.category!,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.itemGap),

        // 등급 헤드라인: 아이콘 + 문구
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headlineIcon(color),
            const SizedBox(width: AppSpacing.itemGap),
            Flexible(
              child: Text(
                _headlineText(),
                style: AppTextStyles.header3Bold.copyWith(
                  color: _labelColor(),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    ),
    );
  }

}

// ---------------------------------------------------------------------------
// CTA 2개 (다시 검색 + 내 식단에 추가)
// ---------------------------------------------------------------------------

class _CtaSection extends StatelessWidget {
  const _CtaSection({
    required this.verdict,
    required this.onRetry,
    required this.onAddToDiet,
  });

  final EatVerdict verdict;
  final VoidCallback onRetry;
  final VoidCallback onAddToDiet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "공유하기" — filled 버튼 full-width (아이콘 추가)
        Semantics(
          button: true,
          label: '판정 결과 공유하기',
          child: SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () => shareVerdict(verdict),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                textStyle: AppTextStyles.body1Bold,
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.share, size: 18),
              label: const Text('공유하기'),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Row(
          children: [
            // "다시 검색" — 아웃라인 버튼 #00BF72
            Expanded(
              child: Semantics(
                button: true,
                label: '다시 검색하기',
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: onRetry,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                      ),
                      textStyle: AppTextStyles.body1Bold,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('다시 검색'),
                  ),
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
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusCard),
                    ),
                    textStyle: AppTextStyles.body1Bold,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('내 식단에 추가'),
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
// 관련 음식 섹션 (목 데이터)
// ---------------------------------------------------------------------------

class _RelatedFoodsSection extends StatelessWidget {
  const _RelatedFoodsSection();

  static const _foods = ['두부', '바나나', '오트밀'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 음식은 어때요?',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _foods
              .map((food) => ActionChip(
                    label: Text(food),
                    onPressed: () {},
                  ))
              .toList(),
        ),
      ],
    );
  }
}

/// 영양 정보 섹션 (목 데이터).
///
/// 칼로리·탄수화물·단백질·지방 4개 항목을 Row로 균등 분배해 표시.
class _NutritionInfoSection extends StatelessWidget {
  const _NutritionInfoSection();

  static const _items = [
    ('칼로리', '72kcal'),
    ('탄수화물', '1.8g'),
    ('단백질', '8g'),
    ('지방', '4g'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '영양 정보',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _items
              .map(
                (item) => Expanded(
                  child: Column(
                    children: [
                      Text(
                        item.$1,
                        style: AppTextStyles.body2Regular.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$2,
                        style: AppTextStyles.body1Bold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
