import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// [showConfirmModal] 사용자가 선택한 액션.
enum ConfirmModalAction { primary, secondary }

/// 공용 확인 모달 (Figma ModalCard #365:2465 정합).
///
/// - 모달카드: 배경 white, radius 16, 패딩 24/24/16, bg white.
/// - 텍스트 그룹(gap 8) → 텍스트↔버튼 그룹 gap 24 → 버튼 그룹(gap 8).
/// - 타이틀 기본 body1Bold(16px). Primary: 채움 버튼([primaryColor]), padding 16,
///   radius 8, body1Bold + onPrimary(흰색). Secondary: 텍스트 버튼, body1Regular + textSecondary.
///
/// ★주의: Primary(채움)이 항상 "실행" 액션은 아니다 — 화면별로 강조 버튼이
/// 확인/취소 어느 쪽인지 다르므로(예: 로그아웃 팝업은 Primary가 "취소"),
/// 호출부가 `primaryLabel`/`secondaryLabel`과 반환된 [ConfirmModalAction]을
/// 명시적으로 매핑해야 한다.
///
/// barrierDismissible 기본값 false — 외부 탭·뒤로가기로 닫히지 않으며
/// 명시적 선택을 강제한다.
Future<ConfirmModalAction?> showConfirmModal(
  BuildContext context, {
  required String title,
  TextStyle? titleStyle,
  String? body,
  TextStyle? bodyStyle,
  required String primaryLabel,
  required Color primaryColor,
  required String secondaryLabel,
  Color? secondaryColor,
  bool barrierDismissible = false,
}) {
  return showDialog<ConfirmModalAction>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => _ConfirmModal(
      title: title,
      titleStyle: titleStyle,
      body: body,
      bodyStyle: bodyStyle,
      primaryLabel: primaryLabel,
      primaryColor: primaryColor,
      secondaryLabel: secondaryLabel,
      secondaryColor: secondaryColor,
    ),
  );
}

class _ConfirmModal extends StatelessWidget {
  const _ConfirmModal({
    required this.title,
    this.titleStyle,
    this.body,
    this.bodyStyle,
    required this.primaryLabel,
    required this.primaryColor,
    required this.secondaryLabel,
    this.secondaryColor,
  });

  final String title;
  final TextStyle? titleStyle;
  final String? body;
  final TextStyle? bodyStyle;
  final String primaryLabel;
  final Color primaryColor;
  final String secondaryLabel;
  final Color? secondaryColor;

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
        // Figma ModalCard: 24/24/16 (top/sides/bottom).
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
            // 텍스트 그룹 (gap 8).
            Text(
              title,
              textAlign: TextAlign.center,
              style: (titleStyle ?? AppTextStyles.body1Bold).copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: (bodyStyle ?? AppTextStyles.body1Medium).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sectionGap),
            // 버튼 그룹 (gap 8).
            _PrimaryCta(
              label: primaryLabel,
              color: primaryColor,
              onTap: () =>
                  Navigator.of(context).pop(ConfirmModalAction.primary),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _SecondaryCta(
              label: secondaryLabel,
              color: secondaryColor,
              onTap: () =>
                  Navigator.of(context).pop(ConfirmModalAction.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// 채움 버튼(primary) — 색은 호출부가 지정.
class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 텍스트 버튼(secondary) — 전체 너비 탭. [color] 미지정 시 textSecondary(회색).
class _SecondaryCta extends StatelessWidget {
  const _SecondaryCta({required this.label, this.color, required this.onTap});

  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardPadding),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body1Regular.copyWith(
              color: color ?? AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
