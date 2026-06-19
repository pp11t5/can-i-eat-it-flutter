import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/core/prefs/first_visit_prefs.dart';
import 'package:can_i_eat_it/features/home/presentation/providers/home_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/recent_food_providers.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/home_empty_state_widget.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/health_tip_card.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/weather_banner.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/recent_search_chip.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/suggestion_chip.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/today_meal_summary_widget.dart';

/// W2 홈 화면 — Figma 1207:6590 empty-state 충실 구현.
///
/// AppShell(하단 탭) 내부에 포함되므로 자체 bottomNavigationBar를 갖지 않는다.
/// 최근 검색은 /check 검색 화면으로 이동했으므로 홈에서 제거됨.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.nowOverride});

  /// 테스트에서 시각 주입용. null이면 DateTime.now() 사용.
  final DateTime? nowOverride;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _toastShown = false;

  void _showToast() {
    if (_toastShown || !mounted) return;
    _toastShown = true;
    ref.read(firstVisitPrefsProvider).markToastShown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('프로필을 완성하면 더 정확한 판정을 받을 수 있어요'),
          action: SnackBarAction(
            label: '편집하기',
            onPressed: () => context.push('/mypage/edit'),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 토스트 표시 여부를 listen — data(true) 수신 시 1회 표시.
    ref.listen<AsyncValue<bool>>(
      shouldShowProfileToastProvider,
      (_, next) {
        if (next.valueOrNull == true) _showToast();
      },
    );

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
              _GreetingBlock(
                nowOverride: widget.nowOverride,
                weatherCondition: 'sunny',
              ),
              const SizedBox(height: 8),

              // ── 1-1. 날씨 배너 (목 데이터) ──────────────────────────────
              const WeatherBanner(),
              const SizedBox(height: AppSpacing.itemGap),

              // ── 1-2. 건강 팁 카드 (목 데이터) ────────────────────────────
              const HealthTipCard(),
              const SizedBox(height: AppSpacing.itemGap),

              // ── 2. 검색 바 ────────────────────────────────────────────
              HomeSearchBar(onTap: () => context.push('/check')),
              const SizedBox(height: AppSpacing.itemGap),

              // ── 2-1. 최근 검색어 섹션 ─────────────────────────────────
              _RecentSearchSection(),
              const SizedBox(height: AppSpacing.itemGap),

              // ── 3. 제안 칩 행 — Figma 1207:6604 단일 행 수평 스크롤 ────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HomeSuggestionChip(
                      label: '된장찌개',
                      iconAsset: 'assets/illustrations/food_soup.png',
                      onTap: () =>
                          context.push('/check?initialQuery=된장찌개'),
                    ),
                    const SizedBox(width: 8),
                    HomeSuggestionChip(
                      label: '아메리카노',
                      iconAsset: 'assets/illustrations/food_drink.png',
                      onTap: () =>
                          context.push('/check?initialQuery=아메리카노'),
                    ),
                    const SizedBox(width: 8),
                    HomeSuggestionChip(
                      label: '김치볶음밥',
                      iconAsset: 'assets/illustrations/food_rice.png',
                      onTap: () =>
                          context.push('/check?initialQuery=김치볶음밥'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.contentGap),

              // ── 4. 내 도감 카드 ───────────────────────────────────────
              const _MyDictionaryCard(),
              const SizedBox(height: AppSpacing.contentGap),

              // ── 5. 빈 상태 유도 위젯 (최근 검색 없을 때만) ──────────────
              _HomeEmptyState(),
              // ── 6. 오늘의 식사 요약 ──────────────────────────────────
              const TodayMealSummaryWidget(),
              const SizedBox(height: AppSpacing.contentGap),

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
  const _GreetingBlock({
    this.nowOverride,
    this.weatherCondition = 'sunny',
  });

  /// 테스트에서 시각 주입용. null이면 DateTime.now() 사용.
  final DateTime? nowOverride;

  /// 날씨 조건 코드. 목 기본값: 'sunny'.
  final String weatherCondition;

  static const _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  String get _todayLabel {
    final now = nowOverride ?? DateTime.now();
    final weekday = _weekdays[now.weekday % 7];
    return '${now.year}년 ${now.month}월 ${now.day}일 $weekday요일';
  }

  String get _greetingText {
    final hour = (nowOverride ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 11) {
      return '좋은 아침이에요! 오늘도 건강한 식사 시작해볼까요?';
    } else if (hour >= 11 && hour < 14) {
      return '점심 시간이에요! 오늘 점심은 속이 편안한 메뉴로 드세요.';
    } else if (hour >= 14 && hour < 18) {
      return '오후도 건강하게 보내세요!';
    } else if (hour >= 18 && hour < 22) {
      return '저녁 시간이에요! 과식은 역류 증상을 악화시킬 수 있어요.';
    } else {
      return '늦은 시간 식사는 속 건강에 좋지 않아요.';
    }
  }

  /// 날씨 조건별 서브텍스트.
  String get _weatherSubtext => switch (weatherCondition) {
        'sunny' => '오늘은 맑아요. 가벼운 산책 어때요?',
        'rainy' => '비가 오네요. 따뜻한 음식이 좋겠어요.',
        'cloudy' => '흐린 날이에요. 소화 잘 되는 음식을 드세요.',
        'snowy' => '눈이 와요. 따뜻하게 드세요.',
        _ => '오늘 날씨에 맞는 식사를 드세요.',
      };

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
                _todayLabel,
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _greetingText,
                style: AppTextStyles.header2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _weatherSubtext,
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.textSecondary,
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

// ── 최근 검색어 섹션 ───────────────────────────────────────────────────────────

class _RecentSearchSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentFoodControllerProvider);

    return recentAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (recentList) {
        if (recentList.isEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.search,
                size: 32,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                '아직 검색한 음식이 없어요',
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/check'),
                  child: Text(
                    '전체보기',
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.itemGap),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: recentList
                  .map(
                    (food) => RecentSearchChip(
                      label: food.name,
                      onSearch: () => context
                          .push('/check?initialQuery=${Uri.encodeComponent(food.name)}'),
                      onDelete: () => ref
                          .read(recentFoodControllerProvider.notifier)
                          .removeRecent(food.foodExternalId),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

// ── 빈 상태 위젯 래퍼 (최근 검색 없을 때만 표시) ──────────────────────────────────

class _HomeEmptyState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentFoodControllerProvider);
    final isEmpty = recentAsync.valueOrNull?.isEmpty ?? true;
    if (!isEmpty) return const SizedBox.shrink();
    return const HomeEmptyStateWidget();
  }
}

// ── 토스트 카드 ───────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
  const _ToastCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/check'),
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
            SvgPicture.asset(
              'assets/figma_extracted/chevron_right.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
