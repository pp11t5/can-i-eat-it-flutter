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
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/state_record_card.dart';

/// 식사 기록 단일 상세 화면 (F3-3).
///
/// 라우트: /meal/:mealId (fullscreenDialog)
///
/// 구성:
/// - TopBar: X(닫기) + "식사 상세 정보"
/// - Hero: FoodThumbnail(큰 사이즈) + 음식명 + judgedGrade 단순 상태표시
/// - 메모 섹션 (있을 때만)
/// - 연결 상태기록 섹션 (있을 때만)
/// - 하단 스티키 CTA: "기록 삭제하기" / "수정하기"
class MealDetailScreen extends ConsumerStatefulWidget {
  const MealDetailScreen({super.key, required this.mealId});

  final String mealId;

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  /// 수정 모드 여부.
  bool _isEditing = false;

  /// 메모 텍스트 컨트롤러 (수정 모드 전용).
  final _memoController = TextEditingController();

  /// 원본 메모 (dirty 체크용).
  String _originalMemo = '';

  bool get _isDirty => _memoController.text != _originalMemo;

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  /// VerdictLevel → 표시 색.
  static Color _verdictColor(VerdictLevel level) => switch (level) {
        VerdictLevel.recommend => AppColors.verdictRecommend,
        VerdictLevel.caution => AppColors.verdictCaution,
        VerdictLevel.risk => AppColors.verdictDanger,
        VerdictLevel.unknown => AppColors.verdictUnknown,
      };

  // ---------------------------------------------------------------------------
  // P6 삭제 다이얼로그
  // ---------------------------------------------------------------------------

  Future<void> _showDeleteDialog(BuildContext ctx) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      barrierDismissible: true,
      builder: (dialogCtx) =>
          _DeleteConfirmDialog(onConfirm: () => Navigator.of(dialogCtx).pop(true)),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    try {
      await ref.read(mealDetailControllerProvider(widget.mealId).notifier).delete();
      if (!mounted) return;
      // 타임라인 invalidate — 전체 family invalidate
      ref.invalidate(timelineControllerProvider);
      showAppToast(context, '기록을 삭제했어요.');
      context.pop();
    } catch (_) {
      if (!mounted) return;
      showAppToast(context, '삭제에 실패했어요. 다시 시도해 주세요.');
    }
  }

  // ---------------------------------------------------------------------------
  // P7 미저장 변경 경고 다이얼로그
  // ---------------------------------------------------------------------------

  Future<bool> _showUnsavedDialog(BuildContext context) async {
    final leave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _UnsavedChangesDialog(
        onContinueEdit: () => Navigator.of(ctx).pop(false),
        onLeave: () => Navigator.of(ctx).pop(true),
      ),
    );
    return leave ?? false;
  }

  // ---------------------------------------------------------------------------
  // 수정 모드 진입
  // ---------------------------------------------------------------------------

  void _enterEditMode(String? currentMemo) {
    _originalMemo = currentMemo ?? '';
    _memoController.text = _originalMemo;
    setState(() => _isEditing = true);
  }

  // ---------------------------------------------------------------------------
  // 저장
  // ---------------------------------------------------------------------------

  Future<void> _saveMemo() async {
    final memo = _memoController.text.trim().isEmpty ? null : _memoController.text.trim();
    try {
      await ref
          .read(mealDetailControllerProvider(widget.mealId).notifier)
          .updateMemo(memo);
      if (!mounted) return;
      setState(() => _isEditing = false);
      showAppToast(context, '메모를 저장했어요.');
    } catch (_) {
      if (!mounted) return;
      showAppToast(context, '저장에 실패했어요. 다시 시도해 주세요.');
    }
  }

  // ---------------------------------------------------------------------------
  // 닫기/뒤로가기 처리 (dirty 체크)
  // ---------------------------------------------------------------------------

  Future<void> _handleClose() async {
    if (_isEditing && _isDirty) {
      final leave = await _showUnsavedDialog(context);
      if (!leave) return;
    }
    if (!mounted) return;
    context.pop();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(mealDetailControllerProvider(widget.mealId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleClose();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: detailAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
            error: (err, _) => Center(
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
                    onPressed: () =>
                        ref.invalidate(mealDetailControllerProvider(widget.mealId)),
                    child: Text(
                      '다시 시도',
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            data: (detail) => _MealDetailBody(
              detail: detail,
              isEditing: _isEditing,
              memoController: _memoController,
              verdictColor: _verdictColor,
              onClose: _handleClose,
              onDelete: () => _showDeleteDialog(context),
              onEditTap: () => _enterEditMode(detail.memo),
              onSave: _saveMemo,
              onCancelEdit: () async {
                if (_isDirty) {
                  final leave = await _showUnsavedDialog(context);
                  if (!leave) return;
                }
                setState(() => _isEditing = false);
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body (데이터 있을 때)
// ---------------------------------------------------------------------------

class _MealDetailBody extends StatelessWidget {
  const _MealDetailBody({
    required this.detail,
    required this.isEditing,
    required this.memoController,
    required this.verdictColor,
    required this.onClose,
    required this.onDelete,
    required this.onEditTap,
    required this.onSave,
    required this.onCancelEdit,
  });

  final MealDetail detail;
  final bool isEditing;
  final TextEditingController memoController;
  final Color Function(VerdictLevel) verdictColor;
  final VoidCallback onClose;
  final VoidCallback onDelete;
  final VoidCallback onEditTap;
  final VoidCallback onSave;
  final VoidCallback onCancelEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TopBar
        _TopBar(onClose: onClose),
        // 스크롤 콘텐츠
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sectionGap,
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero 섹션
                _HeroSection(detail: detail, verdictColor: verdictColor),
                const SizedBox(height: AppSpacing.sectionGap),
                // 메모 섹션
                _MemoSection(
                  detail: detail,
                  isEditing: isEditing,
                  memoController: memoController,
                  onSave: onSave,
                  onCancelEdit: onCancelEdit,
                ),
                // 연결 상태기록 섹션
                if (detail.stateRecords.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sectionGap),
                  _StateRecordsSection(stateRecords: detail.stateRecords),
                ],
                // 하단 CTA 높이만큼 여백
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        // 하단 스티키 CTA
        if (!isEditing)
          _BottomCta(onDelete: onDelete, onEdit: onEditTap),
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
              '식사 상세 정보',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // 우측 대칭 여백용 빈 아이콘버튼
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero 섹션
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.detail,
    required this.verdictColor,
  });

  final MealDetail detail;
  final Color Function(VerdictLevel) verdictColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FoodThumbnail(category: detail.food.category, size: 72),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Center(
          child: Text(
            detail.food.name,
            style: AppTextStyles.header1Medium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (detail.judgedGrade != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              detail.judgedGrade!.label,
              style: AppTextStyles.body2Medium.copyWith(
                color: verdictColor(detail.judgedGrade!),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 메모 섹션
// ---------------------------------------------------------------------------

class _MemoSection extends StatelessWidget {
  const _MemoSection({
    required this.detail,
    required this.isEditing,
    required this.memoController,
    required this.onSave,
    required this.onCancelEdit,
  });

  final MealDetail detail;
  final bool isEditing;
  final TextEditingController memoController;
  final VoidCallback onSave;
  final VoidCallback onCancelEdit;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return _MemoEditField(
        controller: memoController,
        onSave: onSave,
        onCancel: onCancelEdit,
      );
    }

    final memo = detail.memo;
    if (memo == null || memo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메모',
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
            memo,
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
// 메모 편집 필드
// ---------------------------------------------------------------------------

class _MemoEditField extends StatelessWidget {
  const _MemoEditField({
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메모',
          style: AppTextStyles.body2Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        TextField(
          controller: controller,
          maxLength: 200,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '식사에 대한 메모를 남겨보세요',
            hintStyle: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.surfaceBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
          ),
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.cardPadding,
                  ),
                ),
                child: Text(
                  '취소',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: FilledButton(
                onPressed: onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.cardPadding,
                  ),
                ),
                child: Text(
                  '저장',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 상태기록 섹션
// ---------------------------------------------------------------------------

class _StateRecordsSection extends StatelessWidget {
  const _StateRecordsSection({required this.stateRecords});

  final List<StateRecord> stateRecords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${stateRecords.length}개의 증상 기록',
          style: AppTextStyles.body2Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        ...stateRecords.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
            child: StateRecordCard(record: r),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 하단 스티키 CTA
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
            child: FilledButton(
              onPressed: onEdit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
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
// P6 삭제 확인 다이얼로그
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
              '이 기록을 삭제할까요?',
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
            // 삭제하기 — Danger
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
            // 취소하기
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

// ---------------------------------------------------------------------------
// P7 미저장 변경 경고 다이얼로그
// ---------------------------------------------------------------------------

class _UnsavedChangesDialog extends StatelessWidget {
  const _UnsavedChangesDialog({
    required this.onContinueEdit,
    required this.onLeave,
  });

  final VoidCallback onContinueEdit;
  final VoidCallback onLeave;

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
              '저장하지 않고 나갈까요?',
              textAlign: TextAlign.center,
              style: AppTextStyles.header3Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            Text(
              '지금 나가면 수정한 내용이 사라져요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            // 계속 편집하기 — Primary
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              child: InkWell(
                onTap: onContinueEdit,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Center(
                    child: Text(
                      '계속 편집하기',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            // 나가기 — Danger 텍스트
            InkWell(
              onTap: onLeave,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
                child: Center(
                  child: Text(
                    '나가기',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.danger,
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
