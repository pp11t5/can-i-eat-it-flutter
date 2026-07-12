import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/home/data/home_providers.dart';
import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/suggestion_chip.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';

/// W6-0 홈 화면 — Figma 2122:14045("첫화면") / 2122:14040("데이터有") 구조 반영.
///
/// AppShell(하단 탭) 내부에 포함되므로 자체 bottomNavigationBar를 갖지 않는다.
/// 최근 검색은 /check 검색 화면으로 이동했으므로 홈에서 제거됨.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // loading/error 시 '—' 폴백 (_FoodHistoryCard valueOrNull 패턴과 동일).
    final streakDays =
        ref.watch(mySummaryProvider).valueOrNull?.weeklySummary.streakCount;
    final unrecordedCount = ref.watch(unrecordedMealCountProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
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
              _GreetingBlock(streakDays: streakDays),

              // ── 2. 검색 바 ────────────────────────────────────────────
              HomeSearchBar(onTap: () => context.push('/check')),
              const SizedBox(height: 14),

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
                        subtitle: '미기록 식단 ${unrecordedCount ?? '—'}',
                        onTap: () => context.push('/unrecorded-meals'),
                      ),
                    ),
                    const SizedBox(width: 8),
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
              const SizedBox(height: 16),
              const _RecentMealsSection(),
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
  const _GreetingBlock({required this.streakDays});

  /// 연속 편안 일수. mySummaryProvider loading/error 시 null → '—' 폴백.
  final int? streakDays;

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
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: '연속 편안한 날 '),
                    TextSpan(
                      text: '${streakDays ?? '—'}일',
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
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconAsset,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.textStrong,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 최근 식사 섹션 (recentMealsProvider 실데이터, W7) ────────────────────────

class _RecentMealsSection extends ConsumerWidget {
  const _RecentMealsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals =
        ref.watch(recentMealsProvider).valueOrNull ?? const <RecentMeal>[];

    // 로딩·에러·빈 상태 — 기존 빈 상태 placeholder 카드 유지 (Figma 1207:6614).
    if (meals.isEmpty) {
      return GestureDetector(
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
      );
    }

    return Column(
      children: [
        for (var i = 0; i < meals.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.itemGap),
          _RecentMealTile(meal: meals[i]),
        ],
      ],
    );
  }
}

class _RecentMealTile extends StatelessWidget {
  const _RecentMealTile({required this.meal});
  final RecentMeal meal;

  @override
  Widget build(BuildContext context) {
    // eatenAt은 서버 ISO(+09:00) 원문 — parseKst로 KST 컴포넌트 복원 후 수동 포맷
    // (KST 이중변환 방지, meal_timeline_list.dart _formatTime과 동일 원칙).
    // malformed eatenAt이어도 타일 자체(음식명 등)는 렌더되도록 방어
    // (meal_timeline_list.dart _hourOf와 동일 패턴).
    final time = _formatEatenAtTime(meal.eatenAt);

    return Container(
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
        children: [
          CategoryIcon(code: meal.category, size: 32),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meal.foodName,
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (meal.symptomState != null)
                  Text(
                    meal.symptomState!.label,
                    style: AppTextStyles.caption1Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// eatenAt(서버 ISO +09:00)을 'HH:mm'으로 포맷한다. malformed 값이면
  /// FormatException으로 타일 전체가 레드스크린 되지 않도록 '—'로 폴백한다
  /// (meal_timeline_list.dart `_hourOf`와 동일한 방어 패턴).
  static String _formatEatenAtTime(String eatenAt) {
    try {
      final dt = parseKst(eatenAt);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '—';
    }
  }
}
