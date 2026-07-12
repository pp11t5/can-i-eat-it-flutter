import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/state_record_card.dart';

/// 식사 상세 화면 (GET /meal-records/{mealRecordId}).
///
/// 라우트: /meal/:mealRecordId (fullscreenDialog)
///
/// 구성:
/// - TopBar: X(닫기) + "식사 상세 정보"
/// - 헤더: "HH:mm 시간에 먹은 음식이에요"
/// - 음식 행 리스트 (각 음식 → /meal/food/:mealFoodId 음식 상세 진입)
/// - 상태기록 섹션 (있을 때만)
/// - 하단 CTA: "기록 삭제하기"
class MealRecordDetailScreen extends ConsumerWidget {
  const MealRecordDetailScreen({super.key, required this.mealRecordId});

  final String mealRecordId;

  /// ISO-8601 문자열 → 'HH:mm' (KST, 머신 TZ 무관).
  static String _formatTime(String isoString) {
    try {
      final dt = parseKst(isoString);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return isoString;
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    // Figma 2469:9839 — 무확인 즉시삭제 방지. Primary(초록)="취소하기",
    // Secondary(빨강)="삭제하기"(파괴 액션). secondary 선택 시에만 진행.
    final action = await showConfirmModal(
      context,
      title: '음식 기록을 모두 삭제하시겠어요?',
      body: '음식 삭제 시 음식 기록에 연결된\n증상 기록도 함께 삭제돼요.',
      primaryLabel: '취소하기',
      primaryColor: AppColors.primary,
      secondaryLabel: '삭제하기',
      secondaryColor: AppColors.verdictDanger,
    );
    if (action != ConfirmModalAction.secondary) return;
    if (!context.mounted) return;

    try {
      await ref
          .read(mealRecordDetailControllerProvider(mealRecordId).notifier)
          .deleteMeal();
      if (!context.mounted) return;
      ref.invalidate(timelineControllerProvider);
      ref.invalidate(weeklyControllerProvider);
      showAppToast(context, '식사를 삭제했어요.');
      context.pop();
    } catch (_) {
      if (!context.mounted) return;
      showAppToast(context, '삭제에 실패했어요. 다시 시도해 주세요.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync =
        ref.watch(mealRecordDetailControllerProvider(mealRecordId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onClose: () => context.pop()),
            Expanded(
              child: detailAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
                error: (err, _) => _ErrorView(
                  onRetry: () => ref.invalidate(
                    mealRecordDetailControllerProvider(mealRecordId),
                  ),
                ),
                data: (record) => _Body(record: record),
              ),
            ),
            if (detailAsync.hasValue)
              _BottomCta(onDelete: () => _delete(context, ref)),
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
  const _Body({required this.record});

  final MealRecord record;

  @override
  Widget build(BuildContext context) {
    final timeLabel = MealRecordDetailScreen._formatTime(record.eatenAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sectionGap,
        AppSpacing.screenPadding,
        AppSpacing.cardPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$timeLabel 시간에 먹은 음식이에요',
            style: AppTextStyles.header2Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          ...record.foods.map(
            (food) => _FoodRow(
              key: ValueKey(food.mealFoodId),
              food: food,
              onTap: () => context.push('/meal/food/${food.mealFoodId}'),
            ),
          ),
          if (record.stateRecords.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            Text(
              '${record.stateRecords.length}개의 증상 기록',
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            ...record.stateRecords.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                child: StateRecordCard(record: r),
              ),
            ),
          ],
        ],
      ),
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
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const AppIcon(
              AppIcons.chevronLeft,
              size: AppIconSizes.s32,
              color: AppColors.textPrimary,
              semanticsLabel: '뒤로',
            ),
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              '식사 상세 정보',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Medium.copyWith(
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
// 음식 행 (음식 상세 진입)
// ---------------------------------------------------------------------------

class _FoodRow extends StatelessWidget {
  const _FoodRow({super.key, required this.food, required this.onTap});

  final MealFood food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeLabel = MealRecordDetailScreen._formatTime(food.eatenAt);

    // Figma 554:7338: 각 음식은 흰 배경 카드(테두리 #EDEDF5, radius8, padding16)로 표시.
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.itemGap),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderCard),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              CategoryIcon(code: food.category, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$timeLabel에 식사',
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const AppIcon(
                AppIcons.chevronRight,
                size: AppIconSizes.s24,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
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
            '식사 기록을 불러오지 못했어요',
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
            side: const BorderSide(color: Color(0xFF8C8C8C), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.cardPadding,
            ),
          ),
          child: Text(
            '기록 모두 삭제하기',
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
