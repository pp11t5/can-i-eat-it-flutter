import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/suggestion_chip.dart';

/// W6-0 홈 화면 — Figma 2122:14045("첫화면") / 2122:14040("데이터有") 구조 반영.
///
/// AppShell(하단 탭) 내부에 포함되므로 자체 bottomNavigationBar를 갖지 않는다.
/// 최근 검색은 /check 검색 화면으로 이동했으므로 홈에서 제거됨.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Figma bg #FBFBFB
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.contentGap),

              // ── 1. 인사말 블록 ─────────────────────────────────────────
              // 캐릭터 하단이 검색바 상단과 맞붙도록 gap 0 (Figma 절대배치 overlap).
              const _GreetingBlock(),

              // ── 2. 검색 바 ────────────────────────────────────────────
              HomeSearchBar(onTap: () => context.push('/check')),
              const SizedBox(height: AppSpacing.itemGap),

              // ── 3. 제안 칩 행 — Figma 1207:6604 단일 행 수평 스크롤 ────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HomeSuggestionChip(
                      label: '된장찌개',
                      iconAsset: 'assets/illustrations/food_soup.png',
                      onTap: () => context.push('/check'),
                    ),
                    const SizedBox(width: 8),
                    HomeSuggestionChip(
                      label: '아메리카노',
                      iconAsset: 'assets/illustrations/food_drink.png',
                      onTap: () => context.push('/check'),
                    ),
                    const SizedBox(width: 8),
                    HomeSuggestionChip(
                      label: '김치볶음밥',
                      iconAsset: 'assets/illustrations/food_rice.png',
                      onTap: () => context.push('/check'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.contentGap),

              // ── 4. 2-up 진입 카드 행 — Figma 2122:14040 ───────────────
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _HomeEntryCard(
                        iconAsset: 'assets/illustrations/icon_pencil.png',
                        title: '증상 기록하기',
                        // TODO(W6-0b): 미기록 식단 카운트 = /meal-records/candidates
                        subtitle: '미기록 식단 0',
                        onTap: () => context.push('/unrecorded-meals'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HomeEntryCard(
                        iconAsset: 'assets/illustrations/food_salad.png',
                        title: '음식 히스토리',
                        subtitle: '식단과 증상 요약',
                        onTap: () => context.push('/food-history'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.contentGap),

              // ── 5. 최근 식사 섹션 ─────────────────────────────────────
              Text(
                '최근 식사',
                style: AppTextStyles.header2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              // TODO(W4): 식사 기록 데이터 연결 시 실제 목록으로 교체.
              // Figma 1207:6614
              GestureDetector(
                onTap: () {}, // TODO(W4): 식사 기록 진입
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                    border: Border.all(
                      color: AppColors.borderCard, // Figma stroke #EDEDF5
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/illustrations/food_regular.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '먹은 음식이 있으신가요?',
                            style: AppTextStyles.body1Medium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      // Figma heck-fill_small/plus — 초록 disc + 흰 플러스 일체형 SVG.
                      SvgPicture.asset(
                        'assets/figma_extracted/icon_plus_circle.svg',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.contentGap),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 인사말 블록 (캐릭터 이미지 + 텍스트) ────────────────────────────────────

class _GreetingBlock extends StatelessWidget {
  const _GreetingBlock();

  @override
  Widget build(BuildContext context) {
    // Figma 1207:6593: row justify center — 텍스트+캐릭터를 한 그룹으로 가운데 정렬
    // (Expanded/space-between 금지 — 좌우로 벌리면 Figma와 패딩 불일치).
    // TODO(data): /my-page/summary weeklySummary streak 연동(후속)
    const streakDays = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘 속은\n편안하신가요?',
                style: AppTextStyles.header2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: '연속 편안한 날 '),
                    TextSpan(
                      text: '$streakDays일',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const TextSpan(text: ' 째'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 캐릭터 이미지 — Figma overlap ~-26px; Row 내 고정 너비로 근사.
        Image.asset(
          'assets/illustrations/character_greeting.png',
          width: 154,
          height: 138,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

// ── 2-up 진입 카드 (증상 기록하기 / 음식 히스토리) ──────────────────────────

class _HomeEntryCard extends StatelessWidget {
  const _HomeEntryCard({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: AppColors.borderCard, // Figma stroke #EDEDF5
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconAsset,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
