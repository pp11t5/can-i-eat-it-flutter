import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_card.dart';
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
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 1. 인사말 블록 ─────────────────────────────────────────
              _GreetingBlock(),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 2. 검색 바 ────────────────────────────────────────────
              HomeSearchBar(onTap: () => context.push('/check')),
              const SizedBox(height: AppSpacing.itemGap),

              // ── 3. 제안 칩 행 ─────────────────────────────────────────
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  HomeSuggestionChip(
                    label: '된장찌개',
                    iconAsset: 'assets/illustrations/food_soup.png',
                    onTap: () => context.push('/check'),
                  ),
                  HomeSuggestionChip(
                    label: '아메리카노',
                    iconAsset: 'assets/illustrations/food_drink.png',
                    onTap: () => context.push('/check'),
                  ),
                  HomeSuggestionChip(
                    label: '김치볶음밥',
                    iconAsset: 'assets/illustrations/food_rice.png',
                    onTap: () => context.push('/check'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 4. 내 도감 카드 ───────────────────────────────────────
              _MyDictionaryCard(),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 5. 최근 식사 섹션 ─────────────────────────────────────
              Text(
                '최근 식사',
                style: AppTextStyles.header2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              // TODO(W4): 식사 기록 데이터 연결 시 실제 목록으로 교체.
              AppCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.itemGap,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '식단을 기록해 보세요',
                          style: AppTextStyles.body2Regular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // ── 6. 토스트 카드 ────────────────────────────────────────
              _ToastCard(),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 인사말 블록 (캐릭터 이미지 + 텍스트) ────────────────────────────────────

class _GreetingBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO(name): '디도' 는 실제 사용자 이름으로 바인딩.
              Text(
                '디도야\n이거 먹어도 돼?',
                style: AppTextStyles.header1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // 식단·증상 기록 카운터 — W2는 0/0 static.
              Text.rich(
                TextSpan(
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: '식단 기록 '),
                    TextSpan(
                      text: '0',
                      style: AppTextStyles.body2Bold.copyWith(
                        color: const Color(0xFF10111A),
                      ),
                    ),
                    const TextSpan(text: ' 회\n증상 기록 '),
                    TextSpan(
                      text: '0',
                      style: AppTextStyles.body2Bold.copyWith(
                        color: const Color(0xFF10111A),
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
          width: 120,
          height: 138,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

// ── 내 도감 카드 ──────────────────────────────────────────────────────────────

class _MyDictionaryCard extends StatelessWidget {
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
            color: const Color(0xFFEDEDF5), // Figma stroke
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/illustrations/icon_fire.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Text(
                  '내 도감',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}

// ── 토스트 카드 ───────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
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
            color: const Color(0xFFEAEAEA), // Figma stroke #EAEAEA
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
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
                  const SizedBox(width: AppSpacing.itemGap),
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
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}
