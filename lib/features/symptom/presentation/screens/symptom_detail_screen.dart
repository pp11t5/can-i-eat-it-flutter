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
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/presentation/providers/symptom_detail_controller.dart';
import 'package:can_i_eat_it/features/symptom/presentation/widgets/mood_face.dart';

// ---------------------------------------------------------------------------
// 요일 라벨
// ---------------------------------------------------------------------------

const _kWeekdays = ['월', '화', '수', '목', '금', '토', '일'];

// ---------------------------------------------------------------------------
// SymptomDetailScreen
// ---------------------------------------------------------------------------

/// 증상 상세 화면.
///
/// 라우트: /symptom/:symptomId (fullscreenDialog)
/// extra: int? afterMealMinutes (타임라인 탭 진입 시 전달, 직접 진입 시 null)
///
/// 데이터 갭:
/// - memo: 서버 응답에 없음 → 메모 섹션 미표시.
/// - afterMealMinutes: 서버 응답에 없음 → extra로만 헤더에 표시.
/// - linkedMeal 식사 시각(eatenAt): 서버 미제공 → 음식명만 표시.
class SymptomDetailScreen extends ConsumerWidget {
  const SymptomDetailScreen({
    super.key,
    required this.symptomId,
    this.afterMealMinutes,
  });

  final String symptomId;

  /// 타임라인 카드에서 진입 시 afterMealMinutes 를 extra 로 전달. 없으면 null.
  final int? afterMealMinutes;

  // -------------------------------------------------------------------------
  // KST 포맷 헬퍼
  // -------------------------------------------------------------------------

  /// ISO-8601 → "M월 D일 (요일) HH:mm"
  static String _formatOccurredAt(String isoString) {
    try {
      final dt = parseKst(isoString);
      final weekday = _kWeekdays[dt.weekday - 1];
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.month}월 ${dt.day}일 ($weekday) $h:$m';
    } catch (_) {
      return isoString;
    }
  }

  // -------------------------------------------------------------------------
  // 삭제
  // -------------------------------------------------------------------------

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    // Figma 1718:8508: 파괴적 액션을 de-emphasize — Primary(채움 green)=취소하기,
    // Secondary(빨강 텍스트)=삭제하기. 앱 전역 삭제 확인 패턴(showConfirmModal)과 일치.
    final action = await showConfirmModal(
      context,
      title: '기록을 삭제하시겠어요?',
      primaryLabel: '취소하기',
      primaryColor: AppColors.primary,
      secondaryLabel: '삭제하기',
      secondaryColor: AppColors.danger,
    );
    if (action != ConfirmModalAction.secondary) return;
    if (!context.mounted) return;

    try {
      await ref
          .read(symptomDetailControllerProvider(symptomId).notifier)
          .deleteSymptom();
      if (!context.mounted) return;
      ref.invalidate(timelineControllerProvider);
      ref.invalidate(weeklyControllerProvider);
      showAppToast(context, '증상 기록을 삭제했어요.');
      context.pop();
    } catch (_) {
      if (!context.mounted) return;
      showAppToast(context, '삭제에 실패했어요. 다시 시도해 주세요.');
    }
  }

  // -------------------------------------------------------------------------
  // build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync =
        ref.watch(symptomDetailControllerProvider(symptomId));
    final sessionAsync = ref.watch(authControllerProvider);
    final displayName = sessionAsync.valueOrNull?.displayName ?? '회원';

    return Scaffold(
      backgroundColor: AppColors.surface,
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
                    symptomDetailControllerProvider(symptomId),
                  ),
                ),
                data: (symptom) => _Body(
                  symptom: symptom,
                  afterMealMinutes: afterMealMinutes,
                  occurredAtLabel: _formatOccurredAt(symptom.occurredAt),
                  displayName: displayName,
                ),
              ),
            ),
            if (detailAsync.hasValue)
              _BottomCta(
                onDelete: () => _showDeleteDialog(context, ref),
                onEdit: () {
                  final symptom = detailAsync.value!;
                  context.push('/symptom/record', extra: symptom);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TopBar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: AppSpacing.xs,
            child: IconButton(
              icon: const AppIcon(
                AppIcons.close,
                size: AppIconSizes.s24,
                color: AppColors.textPrimary,
                semanticsLabel: '닫기',
              ),
              onPressed: onClose,
            ),
          ),
          Text(
            '증상 상세 정보',
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Body
// ---------------------------------------------------------------------------

class _Body extends StatelessWidget {
  const _Body({
    required this.symptom,
    required this.afterMealMinutes,
    required this.occurredAtLabel,
    required this.displayName,
  });

  final Symptom symptom;
  final int? afterMealMinutes;
  final String occurredAtLabel;
  final String displayName;

  /// 증상 유형 → 한국어 join. 비어있으면 기본 문구.
  String get _symptomTypesLabel {
    if (symptom.symptomTypes.isEmpty) return '특별한 불편이 없었어요';
    return symptom.symptomTypes.map((t) => t.label).join(', ');
  }

  /// "식후 N분" 또는 "식후 Nh Mm" 라벨.
  String _afterMealLabel(int minutes) {
    if (minutes < 60) return '식후 $minutes분';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '식후 $h시간' : '식후 $h시간 $m분';
  }

  /// linkedMeal foods → 표시명.
  String _foodsLabel(SymptomLinkedMeal meal) {
    if (meal.foods.isEmpty) return '연결된 음식';
    final first = meal.foods.first.name;
    if (meal.foods.length == 1) return first;
    return '$first 외 ${meal.foods.length - 1}개';
  }

  @override
  Widget build(BuildContext context) {
    final afterMeal = afterMealMinutes;
    final subLabel = afterMeal != null
        ? '$occurredAtLabel · ${_afterMealLabel(afterMeal)}'
        : occurredAtLabel;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sectionGap,
        AppSpacing.screenPadding,
        AppSpacing.contentGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------------
          // 헤더 (이모지 + 제목 + 부제)
          // ---------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoodFace(state: symptom.symptomState, size: 40),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _symptomTypesLabel,
                      style: AppTextStyles.header2Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subLabel,
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          // ---------------------------------------------------------------
          // "이 식사를 먹고 기록했어요" 섹션
          // ---------------------------------------------------------------
          Text(
            '이 식사를 먹고 기록했어요',
            style: AppTextStyles.body2Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          if (symptom.linkedMeal != null)
            _MealCard(
              foodsLabel: _foodsLabel(symptom.linkedMeal!),
              categoryCode: symptom.linkedMeal!.foods.isNotEmpty
                  ? symptom.linkedMeal!.foods.first.category
                  : null,
            )
          else
            const _NoMealRow(),

          // ---------------------------------------------------------------
          // AI 분석 섹션 (analysis null 또는 빈 목록이면 숨김)
          // ---------------------------------------------------------------
          if (symptom.analysisItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            _AnalysisSection(
              items: symptom.analysisItems,
              displayName: displayName,
            ),
          ],

          const SizedBox(height: AppSpacing.sectionGap),

          // ---------------------------------------------------------------
          // 면책 고지
          // ---------------------------------------------------------------
          Text(
            '구체적인 진단은 병원을 방문하여 의사와 상담하세요.',
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MealCard
// ---------------------------------------------------------------------------

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.foodsLabel,
    required this.categoryCode,
  });

  final String foodsLabel;

  /// 서버 음식 카테고리 코드. null/미매핑 → CategoryIcon regular 폴백.
  final String? categoryCode;

  @override
  Widget build(BuildContext context) {
    // Figma 1324:13865: 흰 배경 + 연회색 테두리 카드(surfaceBackground 회색 fill 아님).
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CategoryIcon(code: categoryCode, size: 32),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              foodsLabel,
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _NoMealRow
// ---------------------------------------------------------------------------

class _NoMealRow extends StatelessWidget {
  const _NoMealRow();

  @override
  Widget build(BuildContext context) {
    // Figma 554:7337: 흰 배경 + 연회색 테두리 카드(surfaceBackground 회색 fill 아님).
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '연결된 음식이 없어요',
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // 음식 연결하기 — W5-3 연동 가능해지면 활성화 예정.
          // TODO(W5-3): linkedMeal 연결 플로우 연결.
          Text(
            '음식 연결하기',
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const AppIcon(
            AppIcons.chevronRight,
            size: AppIconSizes.s16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AnalysisSection
// ---------------------------------------------------------------------------

class _AnalysisSection extends StatelessWidget {
  const _AnalysisSection({required this.items, required this.displayName});

  final List<SymptomAnalysisItem> items;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.itemGap,
          ),
          decoration: BoxDecoration(
            color: AppColors.aiAccentSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: Text(
            '$displayName 님을 위한 맞춤 분석이에요',
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        ...items.map((item) => _AnalysisCard(item: item)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _AnalysisCard
// ---------------------------------------------------------------------------

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.item});

  final SymptomAnalysisItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.itemGap),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.emphasis,
            style: AppTextStyles.body2Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.body,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ErrorView
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
            '증상 정보를 불러오지 못했어요.',
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
// _BottomCta
// ---------------------------------------------------------------------------

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.onDelete, required this.onEdit});

  final VoidCallback onDelete;
  final VoidCallback onEdit;

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
      child: Row(
        children: [
          Expanded(
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
                '기록 삭제하기',
                style: AppTextStyles.body2Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
                elevation: 0,
              ),
              child: Text(
                '수정하기',
                style: AppTextStyles.body2Medium.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
