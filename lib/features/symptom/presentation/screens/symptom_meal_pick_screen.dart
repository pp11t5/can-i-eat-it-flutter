import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

// ---------------------------------------------------------------------------
// 선택 결과 모델
// ---------------------------------------------------------------------------

/// 원인 식사 선택 결과.
///
/// - 식사 선택: [mealRecordId]/[displayName] non-null, [cleared]=false.
/// - "선택 안 할래요"(명시적 해제): [MealPickResult.cleared] 사용, [cleared]=true.
/// - 단순 dismiss(AppBar/시스템 뒤로가기): pop 값 자체가 bare null이며 이
///   클래스의 인스턴스가 아니다. 호출부에서 null과 [cleared]를 구분해야 한다.
class MealPickResult {
  const MealPickResult({
    required this.mealRecordId,
    required this.displayName,
  }) : cleared = false;

  /// "선택 안 할래요" 탭 → 명시적 해제 신호.
  const MealPickResult.cleared()
      : mealRecordId = null,
        displayName = null,
        cleared = true;

  final String? mealRecordId;
  final String? displayName;

  /// true면 사용자가 "선택 안 할래요"를 명시적으로 선택함(linkedMeal 해제 의도).
  final bool cleared;
}

// ---------------------------------------------------------------------------
// 원인 식사 화면
// ---------------------------------------------------------------------------

/// 증상 원인 식사 선택 화면.
///
/// [Navigator.push] + pop([MealPickResult]?) 으로 결과를 반환한다.
/// "선택 안 할래요" 탭 시 pop(null).
class SymptomMealPickScreen extends ConsumerStatefulWidget {
  const SymptomMealPickScreen({super.key, this.initialMealRecordId});

  /// 현재 선택된 식사 ID (수정 모드 프리필용). null = 미선택.
  final String? initialMealRecordId;

  @override
  ConsumerState<SymptomMealPickScreen> createState() =>
      _SymptomMealPickScreenState();
}

class _SymptomMealPickScreenState
    extends ConsumerState<SymptomMealPickScreen> {
  /// 현재 선택 상태. null = "선택 안 할래요".
  String? _selectedMealRecordId;

  @override
  void initState() {
    super.initState();
    _selectedMealRecordId = widget.initialMealRecordId;
  }

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

  String _sectionTitle(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      final today = nowKst();
      final todayBase =
          DateTime(today.year, today.month, today.day);
      final yesterday = todayBase.subtract(const Duration(days: 1));
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final wd = weekdays[date.weekday - 1];
      final label =
          '${date.month}월 ${date.day}일 ($wd)';

      if (date == todayBase) return '오늘 · $label';
      if (date == yesterday) return '어제 · $label';
      return label;
    } catch (_) {
      return dateStr;
    }
  }

  String _mealDisplayName(MealCandidate meal) {
    if (meal.otherFoodCount > 0) {
      return '${meal.representativeFoodName} 외 ${meal.otherFoodCount}개 음식';
    }
    return meal.representativeFoodName;
  }

  void _onConfirm(List<MealCandidatesDay> allDays) {
    if (_selectedMealRecordId == null) {
      // "선택 안 할래요" 명시적 해제 — bare null(dismiss)과 구분되는 전용 신호.
      Navigator.of(context).pop(const MealPickResult.cleared());
      return;
    }
    // 선택된 식사를 찾아 displayName 계산
    for (final day in allDays) {
      for (final meal in day.meals) {
        if (meal.mealRecordId == _selectedMealRecordId) {
          Navigator.of(context).pop(
            MealPickResult(
              mealRecordId: meal.mealRecordId,
              displayName: _mealDisplayName(meal),
            ),
          );
          return;
        }
      }
    }
    // 데이터 불일치로 선택된 식사를 찾지 못한 방어적 fallback — 해제로 처리.
    Navigator.of(context).pop(const MealPickResult.cleared());
  }

  @override
  Widget build(BuildContext context) {
    final candidatesAsync = ref.watch(
      // MealRepository.candidates()를 직접 FutureProvider로 감싸기
      _mealCandidatesProvider,
    );

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
          '원인 식사',
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
        data: (allDays) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sectionGap),

                    // 헤더
                    Text(
                      '어떤 식사와\n관련된 증상인가요?',
                      style: AppTextStyles.header1Bold
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '하루 동안 먹은 식사 중 선택해주세요',
                      style: AppTextStyles.body2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    // "선택 안 할래요" 카드 (Figma: leading 아이콘 없음)
                    _MealOptionCard(
                      leading: null,
                      title: '선택 안 할래요',
                      subtitle: '모르겠어요, 식사와 상관없어요',
                      selected: _selectedMealRecordId == null,
                      onTap: () {
                        setState(() => _selectedMealRecordId = null);
                      },
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    // 날짜별 식사 목록
                    ...allDays.map((day) {
                      if (day.meals.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sectionTitle(day.date),
                            style: AppTextStyles.body2Bold
                                .copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.itemGap),
                          ...day.meals.map((meal) {
                            final selected =
                                _selectedMealRecordId == meal.mealRecordId;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppSpacing.itemGap),
                              child: _MealOptionCard(
                                leading: CategoryIcon(
                                  code: meal.representativeFoodCategory,
                                  size: 32,
                                ),
                                title: _mealDisplayName(meal),
                                subtitle: _formatEatenAt(meal.eatenAt),
                                selected: selected,
                                onTap: () {
                                  setState(() =>
                                      _selectedMealRecordId = meal.mealRecordId);
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: AppSpacing.itemGap),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // 하단 확인 버튼
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.itemGap,
                AppSpacing.screenPadding,
                MediaQuery.of(context).padding.bottom +
                    AppSpacing.screenPadding,
              ),
              child: SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: () => _onConfirm(allDays),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusCard),
                    ),
                    textStyle: AppTextStyles.body1Bold,
                  ),
                  child: const Text('확인'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 식사 후보 Provider
// ---------------------------------------------------------------------------

/// [MealRepository.candidates()] FutureProvider.
final _mealCandidatesProvider =
    FutureProvider.autoDispose<List<MealCandidatesDay>>((ref) {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.candidates();
});

// ---------------------------------------------------------------------------
// 식사 옵션 카드 위젯
// ---------------------------------------------------------------------------

class _MealOptionCard extends StatelessWidget {
  const _MealOptionCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  /// 좌측 아이콘. null 이면 생략(예: "선택 안 할래요" 카드).
  final Widget? leading;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        // Figma 554:7347: 선택된 카드도 흰 배경·회색 테두리를 유지한다.
        // 선택 표시는 우측 green plus_circle 아이콘이 전담(카드 green fill 아님).
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.border, width: 1.0),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.itemGap),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textPrimary,
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
            const SizedBox(width: AppSpacing.itemGap),
            // 선택: Figma 녹색 plus_circle / 미선택: 빈 테두리 원
            if (selected)
              const AppIcon(
                AppIcons.plusCircle,
                size: AppIconSizes.s24,
                semanticsLabel: '선택됨',
              )
            else
              Container(
                width: AppIconSizes.s24,
                height: AppIconSizes.s24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
