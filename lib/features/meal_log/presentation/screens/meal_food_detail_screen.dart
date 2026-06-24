import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/food_thumbnail.dart';

/// 음식 상세 화면 (GET /meal-records/foods/{mealFoodId}).
///
/// 라우트: /meal/food/:mealFoodId (fullscreenDialog)
///
/// 구성:
/// - TopBar: X(닫기) + "음식 상세 정보"
/// - Hero: FoodThumbnail(큰 사이즈) + 음식명 + analysis.judgmentGrade 상태표시
/// - 분석 섹션: trigger / allergy (있는 섹션만)
/// - 하단 CTA: "음식 삭제하기"
class MealFoodDetailScreen extends ConsumerWidget {
  const MealFoodDetailScreen({super.key, required this.mealFoodId});

  final String mealFoodId;

  /// VerdictLevel → 표시 색.
  static Color _verdictColor(VerdictLevel level) => switch (level) {
        VerdictLevel.recommend => AppColors.verdictRecommend,
        VerdictLevel.caution => AppColors.verdictCaution,
        VerdictLevel.risk => AppColors.verdictDanger,
        VerdictLevel.unknown => AppColors.verdictUnknown,
      };

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => _DeleteConfirmDialog(
        onConfirm: () => Navigator.of(dialogCtx).pop(true),
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      await ref
          .read(mealFoodDetailControllerProvider(mealFoodId).notifier)
          .deleteFood();
      if (!context.mounted) return;
      // 마지막 음식이면 서버가 식사도 삭제 → 타임라인/weekly invalidate로 동기화.
      ref.invalidate(timelineControllerProvider);
      ref.invalidate(weeklyControllerProvider);
      // 부모 식사 상세가 떠 있을 수 있으므로 식사상세 family도 무효화.
      ref.invalidate(mealRecordDetailControllerProvider);
      showAppToast(context, '음식을 삭제했어요.');
      context.pop();
    } catch (_) {
      if (!context.mounted) return;
      showAppToast(context, '삭제에 실패했어요. 다시 시도해 주세요.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodAsync = ref.watch(mealFoodDetailControllerProvider(mealFoodId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onClose: () => context.pop()),
            Expanded(
              child: foodAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
                error: (err, _) => _ErrorView(
                  onRetry: () => ref.invalidate(
                    mealFoodDetailControllerProvider(mealFoodId),
                  ),
                ),
                data: (food) => _Body(food: food, verdictColor: _verdictColor),
              ),
            ),
            if (foodAsync.hasValue)
              _BottomCta(onDelete: () => _showDeleteDialog(context, ref)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _Body extends StatelessWidget {
  const _Body({required this.food, required this.verdictColor});

  final MealFood food;
  final Color Function(VerdictLevel) verdictColor;

  @override
  Widget build(BuildContext context) {
    final analysis = food.analysis;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sectionGap,
        AppSpacing.screenPadding,
        AppSpacing.screenPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero
          Center(child: FoodThumbnail(category: food.category, size: 72)),
          const SizedBox(height: AppSpacing.itemGap),
          Center(
            child: Text(
              food.name,
              style: AppTextStyles.header1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (analysis != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                analysis.judgmentGrade.label,
                style: AppTextStyles.body2Medium.copyWith(
                  color: verdictColor(analysis.judgmentGrade),
                ),
              ),
            ),
          ],
          // 분석 섹션 (있는 섹션만)
          if (analysis?.trigger case final trigger?) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            _AnalysisSectionView(section: trigger),
          ],
          if (analysis?.allergy case final allergy?) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            _AnalysisSectionView(section: allergy),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 분석 섹션 뷰
// ---------------------------------------------------------------------------

class _AnalysisSectionView extends StatelessWidget {
  const _AnalysisSectionView({required this.section});

  final AnalysisSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.ment,
          style: AppTextStyles.body2Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surfaceBackground,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: Text(
            section.content,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TopBar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              '음식 상세 정보',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 에러 뷰
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '음식 정보를 불러오지 못했어요',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          TextButton(
            onPressed: onRetry,
            child: Text(
              '다시 시도',
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 하단 스티키 CTA
// ---------------------------------------------------------------------------

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.itemGap,
        AppSpacing.screenPadding,
        AppSpacing.sectionGap,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onDelete,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.cardPadding,
            ),
          ),
          child: Text(
            '음식 삭제하기',
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 삭제 확인 다이얼로그
// ---------------------------------------------------------------------------

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
      ),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sectionGap,
          AppSpacing.sectionGap,
          AppSpacing.sectionGap,
          AppSpacing.cardPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '이 음식을 삭제할까요?',
              textAlign: TextAlign.center,
              style: AppTextStyles.header3Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            Text(
              '삭제하면 되돌릴 수 없어요.\n패턴 분석에서도 제외돼요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            Material(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              child: InkWell(
                onTap: onConfirm,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Center(
                    child: Text(
                      '삭제하기',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
                child: Center(
                  child: Text(
                    '취소하기',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
