import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/suggestion_chip.dart';

/// W2 홈 화면 — Figma 1207:6590 empty-state 충실 구현.
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

              // ── 4. 내 도감 카드 ───────────────────────────────────────
              const _MyDictionaryCard(),
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
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 최근 식사 ↔ 토스트 카드 gap 70 (Figma).
              const SizedBox(height: 70),

              // ── 6. 토스트 카드 ────────────────────────────────────────
              const _ToastCard(),
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
              // TODO(data): 식사·증상 카운트 연동 시 실제 값.
              Text.rich(
                TextSpan(
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: '식단 기록 '),
                    TextSpan(
                      text: '0',
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' 회\n'),
                    const TextSpan(text: '증상 기록 '),
                    TextSpan(
                      text: '0',
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' 회'),
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

// ── 내 도감 카드 ──────────────────────────────────────────────────────────────

class _MyDictionaryCard extends StatelessWidget {
  const _MyDictionaryCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO(도감): 도감 화면 미구현 — 추후 연결.
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(999)),
          border: Border.all(
            color: AppColors.borderCard, // Figma stroke #EDEDF5
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT: 불꽃 아이콘 + 연속 편안한 날 streak
            Row(
              children: [
                Image.asset(
                  'assets/illustrations/icon_fire.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                // TODO(data): 실제 연속일수.
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      const TextSpan(text: '연속 편안한 날 '),
                      TextSpan(
                        text: '1일',
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
            // RIGHT: '내 도감' 라벨 + chevron
            Row(
              children: [
                Text(
                  '내 도감',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/figma_extracted/chevron_right.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary, // #1A1A1F
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── 토스트 카드 ───────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
  const _ToastCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO(W4): 식사 기록 진입 연결.
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE), // Figma #FEFEFE
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
          border: Border.all(
            color: AppColors.border, // Figma stroke #EAEAEA → AppColors.border
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 4), // Figma 1207:6704
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/illustrations/emoji_meal_prompt.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 16), // Figma 1207:6704 emoji↔text gap
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '검색하신 음식은 드셨어요?',
                          style: AppTextStyles.body1Medium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '식단에 추가하고 상태 기록하기',
                          style: AppTextStyles.body2Regular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
