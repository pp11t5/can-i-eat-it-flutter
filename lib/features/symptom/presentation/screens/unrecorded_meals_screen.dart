import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_write_screen.dart';

// ---------------------------------------------------------------------------
// 식사 후보 Provider (공개 — 화면 소비용)
// ---------------------------------------------------------------------------

/// [MealRepository.candidates()] FutureProvider.
final mealCandidatesProvider =
    FutureProvider.autoDispose<List<MealCandidatesDay>>((ref) {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.candidates();
});

// ---------------------------------------------------------------------------
// UnrecordedMealsScreen
// ---------------------------------------------------------------------------

/// 증상 미기록 식단 화면.
///
/// 홈 '증상 기록하기' 카드 진입점. 최근 식사를 날짜별로 보여주고, 카드를 탭하면
/// 해당 식사를 원인으로 프리필해 증상 작성으로 진입한다. 식사와 무관하게 증상만
/// 기록하는 진입점도 상단에 항상 노출한다.
class UnrecordedMealsScreen extends ConsumerWidget {
  const UnrecordedMealsScreen({super.key});

  String _formatEatenAt(String eatenAt) {
    try {
      final dt = parseKst(eatenAt);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m에 식사';
    } catch (_) {
      return '시간 불명';
    }
  }

  String _mealDisplayName(MealCandidate meal) {
    if (meal.otherFoodCount > 0) {
      return '${meal.representativeFoodName} 외 ${meal.otherFoodCount}개 음식';
    }
    return meal.representativeFoodName;
  }

  String _sectionLabel(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      final today = nowKst();
      final todayBase = DateTime(today.year, today.month, today.day);
      final yesterday = todayBase.subtract(const Duration(days: 1));

      if (date == todayBase) return '오늘';
      if (date == yesterday) return '어제';

      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final wd = weekdays[date.weekday - 1];
      return '${date.month}월 ${date.day}일 ($wd)';
    } catch (_) {
      return dateStr;
    }
  }

  void _onSymptomOnlyTap(BuildContext context) {
    context.push('/symptom/record');
  }

  void _onMealTap(BuildContext context, MealCandidate meal) {
    context.push(
      '/symptom/record',
      extra: SymptomWriteArgs(
        initialMealRecordId: meal.mealRecordId,
        initialMealName: _mealDisplayName(meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidatesAsync = ref.watch(mealCandidatesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s24,
            color: AppColors.textPrimary,
            semanticsLabel: '뒤로',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '증상 미기록 식단',
          style: AppTextStyles.body1Bold.copyWith(color: AppColors.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: candidatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            '식사 목록을 불러오지 못했어요.\n잠시 후 다시 시도해 주세요.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        data: (allDays) {
          final hasMeals = allDays.any((day) => day.meals.isNotEmpty);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.itemGap),

                // "증상만 기록하기" — 항상 최상단 노출.
                _SymptomOnlyCard(onTap: () => _onSymptomOnlyTap(context)),
                const SizedBox(height: AppSpacing.sectionGap),

                if (!hasMeals)
                  const _EmptyState()
                else
                  ...allDays.map((day) {
                    if (day.meals.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.sectionGap),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sectionLabel(day.date),
                            style: AppTextStyles.body1Bold
                                .copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: AppSpacing.itemGap),
                          ...day.meals.map((meal) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.itemGap),
                                child: _MealCard(
                                  meal: meal,
                                  displayName: _mealDisplayName(meal),
                                  timeLabel: _formatEatenAt(meal.eatenAt),
                                  onTap: () => _onMealTap(context, meal),
                                ),
                              )),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SymptomOnlyCard — "증상만 기록하기" 카드
// ---------------------------------------------------------------------------

class _SymptomOnlyCard extends StatelessWidget {
  const _SymptomOnlyCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '증상만 기록하기',
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '음식 상관없이 기록',
                    style: AppTextStyles.body2Regular
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/figma_extracted/chevron_right.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textTertiary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MealCard — 식사 카드
// ---------------------------------------------------------------------------

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.meal,
    required this.displayName,
    required this.timeLabel,
    required this.onTap,
  });

  final MealCandidate meal;
  final String displayName;
  final String timeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Row(
          children: [
            CategoryIcon(code: meal.representativeFoodCategory, size: 32),
            const SizedBox(width: AppSpacing.itemGap * 1.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTextStyles.body1Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    timeLabel,
                    style: AppTextStyles.caption1Medium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '증상 기록하기',
                  style: AppTextStyles.body2Medium
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(width: AppSpacing.xs),
                SvgPicture.asset(
                  'assets/figma_extracted/chevron_right.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textTertiary,
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

// ---------------------------------------------------------------------------
// _EmptyState — 미기록 식단 없음
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.contentGap),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/figma_extracted/icon_food_empty.svg',
              width: 48,
              height: 48,
            ),
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              '아직 식단 기록이 없어요',
              style: AppTextStyles.body1Medium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
