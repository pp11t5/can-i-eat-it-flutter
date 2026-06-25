import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/presentation/providers/symptom_detail_controller.dart';

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
  // SymptomState 이모지 / 색상
  // -------------------------------------------------------------------------

  static String _stateEmoji(SymptomState state) => switch (state) {
        SymptomState.comfortable => '😊',
        SymptomState.good => '🙂',
        SymptomState.normal => '😐',
        SymptomState.uncomfortable => '😕',
        SymptomState.severe => '😣',
      };

  static Color _stateColor(SymptomState state) => switch (state) {
        SymptomState.comfortable || SymptomState.good => AppColors.primary,
        SymptomState.normal => AppColors.textSecondary,
        SymptomState.uncomfortable => const Color(0xFFFF8C00),
        SymptomState.severe => AppColors.danger,
      };

  // -------------------------------------------------------------------------
  // 삭제
  // -------------------------------------------------------------------------

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => _DeleteConfirmDialog(
        onConfirm: () => Navigator.of(dialogCtx).pop(true),
        onCancel: () => Navigator.of(dialogCtx).pop(false),
      ),
    );
    if (confirmed != true) return;
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
                  stateEmoji: _stateEmoji(symptom.symptomState),
                  stateColor: _stateColor(symptom.symptomState),
                  occurredAtLabel: _formatOccurredAt(symptom.occurredAt),
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
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: AppSpacing.xs,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: AppColors.textPrimary,
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
    required this.stateEmoji,
    required this.stateColor,
    required this.occurredAtLabel,
  });

  final Symptom symptom;
  final int? afterMealMinutes;
  final String stateEmoji;
  final Color stateColor;
  final String occurredAtLabel;

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

  /// category → 이모지 (기본 🍽️).
  String _categoryEmoji(String? category) {
    if (category == null) return '🍽️';
    return switch (category) {
      '한식' => '🍲',
      '중식' => '🥢',
      '일식' => '🍣',
      '양식' => '🍝',
      '패스트푸드' => '🍔',
      '음료' => '☕',
      '간식' => '🍪',
      '과일' => '🍎',
      '채소' => '🥦',
      _ => '🍽️',
    };
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
              Text(
                stateEmoji,
                style: TextStyle(
                  fontSize: 36,
                  color: stateColor,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _symptomTypesLabel,
                      style: AppTextStyles.header1Medium.copyWith(
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
              meal: symptom.linkedMeal!,
              foodsLabel: _foodsLabel(symptom.linkedMeal!),
              categoryEmoji: _categoryEmoji(
                symptom.linkedMeal!.foods.isNotEmpty
                    ? symptom.linkedMeal!.foods.first.category
                    : null,
              ),
            )
          else
            const _NoMealRow(),

          // ---------------------------------------------------------------
          // AI 분석 섹션 (analysis null 또는 빈 목록이면 숨김)
          // ---------------------------------------------------------------
          if (symptom.analysisItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            _AnalysisSection(items: symptom.analysisItems),
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
    required this.meal,
    required this.foodsLabel,
    required this.categoryEmoji,
  });

  final SymptomLinkedMeal meal;
  final String foodsLabel;
  final String categoryEmoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          Text(categoryEmoji, style: const TextStyle(fontSize: 20)),
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.divider, width: 0.5),
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
            '음식 연결하기 >',
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textTertiary,
            ),
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
  const _AnalysisSection({required this.items});

  final List<SymptomAnalysisItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('✨', style: TextStyle(fontSize: 14)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'AI 맞춤 분석이에요',
              style: AppTextStyles.body2Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
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

// ---------------------------------------------------------------------------
// _DeleteConfirmDialog
// ---------------------------------------------------------------------------

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog({
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
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
              '기록을 삭제하시겠어요?',
              textAlign: TextAlign.center,
              style: AppTextStyles.header3Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            Text(
              '삭제하면 되돌릴 수 없어요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            Material(
              color: AppColors.primary,
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
              onTap: onCancel,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
                child: Center(
                  child: Text(
                    '취소',
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
