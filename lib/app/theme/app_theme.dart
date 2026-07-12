import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Layer 3: AppColors·AppTextStyles를 ThemeData/ColorScheme/TextTheme으로 조립.
///
/// [AppTheme.light] / [AppTheme.dark] getter 시그니처는 고정 — lib/app/app.dart가 참조.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        textTheme: _textTheme,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
      );

  /// W1에서는 light와 동일하게 유지. 다크 토큰 분리는 추후 진행.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        textTheme: _textTheme,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
      );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.surfaceSelected,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.primary,
    onSecondary: AppColors.onPrimary,
    secondaryContainer: AppColors.surfaceSelected,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.textTertiary,
    onTertiary: AppColors.surface,
    tertiaryContainer: AppColors.surfaceMuted,
    onTertiaryContainer: AppColors.textPrimary,
    error: AppColors.verdictDanger, // 실측 #FF383C (verdictDanger 경유 — primitive 교체 시 연동)
    onError: AppColors.surface,
    errorContainer: AppColors.disclaimerBg, // disclaimerBg 경유
    onErrorContainer: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.divider,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.surfaceSelected,
  );

  static const TextTheme _textTheme = TextTheme(
    displaySmall: AppTextStyles.title2,
    titleLarge: AppTextStyles.header1Bold,
    titleMedium: AppTextStyles.header2Bold,
    titleSmall: AppTextStyles.header1Medium,
    labelLarge: AppTextStyles.body1Bold,
    labelMedium: AppTextStyles.body2Bold,
    labelSmall: AppTextStyles.caption1Bold,
    bodyLarge: AppTextStyles.body1Medium,
    bodyMedium: AppTextStyles.body2Medium,
    bodySmall: AppTextStyles.caption1Medium,
  );
}
