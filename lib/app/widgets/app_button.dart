import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 버튼 변형 종류.
enum AppButtonVariant {
  /// 채워진 주요 액션 버튼 (배경 primary, 텍스트 onPrimary).
  primary,

  /// 외곽선 보조 버튼 (배경 surface, border primary).
  secondary,
}

/// 앱 공용 CTA 버튼.
///
/// - [label]: 버튼 텍스트 (필수).
/// - [onPressed]: null 전달 시 disabled 상태.
/// - [variant]: [AppButtonVariant.primary] (기본) 또는 [AppButtonVariant.secondary].
/// - [isExpanded]: true이면 가로 전체 확장. false이면 내용에 맞는 너비.
/// - [width]: 명시적 너비. [isExpanded]보다 우선 적용되지 않음(expanded가 우선).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isExpanded = false,
    this.width,
  });

  /// 채워진 주요 버튼 (편의 생성자).
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isExpanded = false,
    this.width,
  }) : variant = AppButtonVariant.primary;

  /// 외곽선 보조 버튼 (편의 생성자).
  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isExpanded = false,
    this.width,
  }) : variant = AppButtonVariant.secondary;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isExpanded;
  final double? width;

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => _buildPrimary(),
      AppButtonVariant.secondary => _buildSecondary(),
    };

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }

  Widget _buildPrimary() {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _isDisabled
            ? AppColors.surfaceMuted
            : AppColors.primary,
        foregroundColor: _isDisabled
            ? AppColors.textTertiary
            : AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.cardPadding, // 16
          horizontal: AppSpacing.sectionGap, // 24
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        textStyle: AppTextStyles.button,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }

  Widget _buildSecondary() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: _isDisabled ? AppColors.surfaceMuted : AppColors.surface,
        foregroundColor: _isDisabled ? AppColors.textTertiary : AppColors.primary,
        side: BorderSide(
          color: _isDisabled ? AppColors.border : AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.cardPadding, // 16
          horizontal: AppSpacing.sectionGap, // 24
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        textStyle: AppTextStyles.button,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}
