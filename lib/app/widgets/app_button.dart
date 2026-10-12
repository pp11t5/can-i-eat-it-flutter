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

  /// 회색 채움 보조 버튼 (배경 border, 텍스트 textSecondary).
  tertiary,
}

/// 앱 공용 CTA 버튼.
///
/// - [label]: 버튼 텍스트 (필수).
/// - [onPressed]: null 전달 시 disabled 상태.
/// - [variant]: [AppButtonVariant.primary] (기본), [AppButtonVariant.secondary],
///   [AppButtonVariant.tertiary].
/// - [isExpanded]: true이면 가로 전체 확장. false이면 내용에 맞는 너비.
/// - [width]: 명시적 너비. [isExpanded]보다 우선 적용되지 않음(expanded가 우선).
/// - [height]: 고정 높이(텍스트는 세로 가운데). null 이면 패딩 기반 높이.
/// - [isLoading]: true이면 버튼을 비활성화하고 로딩 인디케이터를 표시한다.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isExpanded = false,
    this.width,
    this.height,
    this.isLoading = false,
  });

  /// 채워진 주요 버튼 (편의 생성자).
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isExpanded = false,
    this.width,
    this.height,
    this.isLoading = false,
  }) : variant = AppButtonVariant.primary;

  /// 외곽선 보조 버튼 (편의 생성자).
  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isExpanded = false,
    this.width,
    this.height,
    this.isLoading = false,
  }) : variant = AppButtonVariant.secondary;

  /// 회색 채움 보조 버튼 (편의 생성자).
  const AppButton.tertiary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isExpanded = false,
    this.width,
    this.height,
    this.isLoading = false,
  }) : variant = AppButtonVariant.tertiary;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isExpanded;
  final double? width;

  /// 고정 높이. null 이면 세로 패딩 16 + 텍스트 높이.
  final double? height;
  final bool isLoading;

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary =>
        _buildFilled(AppColors.primary, AppColors.onPrimary),
      AppButtonVariant.secondary => _buildSecondary(),
      AppButtonVariant.tertiary =>
        _buildFilled(AppColors.border, AppColors.textSecondary),
    };

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }

  /// 온보딩 선택/CTA 활성 전환과 맞춘 색 보간 duration.
  static const Duration _stateAnimDuration = Duration(milliseconds: 150);

  Widget _buildFilled(Color background, Color foreground) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _isDisabled ? AppColors.surfaceMuted : background,
        foregroundColor: _isDisabled ? AppColors.textTertiary : foreground,
        disabledBackgroundColor: AppColors.surfaceMuted,
        disabledForegroundColor: AppColors.textTertiary,
        padding: EdgeInsets.symmetric(
          vertical: height == null ? AppSpacing.cardPadding : 0,
          horizontal: AppSpacing.sectionGap, // 24
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        textStyle: AppTextStyles.body1Bold,
        minimumSize: Size(0, height ?? 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        animationDuration: _stateAnimDuration,
      ),
      child: _buildChild(foreground),
    );
  }

  Widget _buildSecondary() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            _isDisabled ? AppColors.surfaceMuted : AppColors.surface,
        foregroundColor:
            _isDisabled ? AppColors.textTertiary : AppColors.primary,
        disabledBackgroundColor: AppColors.surfaceMuted,
        disabledForegroundColor: AppColors.textTertiary,
        side: BorderSide(
          color: _isDisabled ? AppColors.border : AppColors.primary,
        ),
        padding: EdgeInsets.symmetric(
          vertical: height == null ? AppSpacing.cardPadding : 0,
          horizontal: AppSpacing.sectionGap, // 24
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        textStyle: AppTextStyles.body1Bold,
        minimumSize: Size(0, height ?? 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        animationDuration: _stateAnimDuration,
      ),
      child: _buildChild(AppColors.primary),
    );
  }

  Widget _buildChild(Color loadingColor) {
    if (!isLoading) return Text(label);
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: loadingColor,
      ),
    );
  }
}
