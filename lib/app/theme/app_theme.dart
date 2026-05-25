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
      );

  /// provisional — W1에서는 light와 동일하게 유지. 다크 토큰 분리는 추후 진행.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme, // provisional
        textTheme: _textTheme,
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
    error: AppColors.verdictDanger, // provisional (verdictDanger 경유 — primitive 교체 시 연동)
    onError: AppColors.surface,
    errorContainer: AppColors.disclaimerBg, // provisional (disclaimerBg 경유)
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
    // heading2 → displaySmall 또는 titleLarge로 매핑
    displaySmall: AppTextStyles.heading1,
    titleLarge: AppTextStyles.heading2,
    titleMedium: AppTextStyles.title,
    titleSmall: AppTextStyles.labelBold,
    labelLarge: AppTextStyles.button,
    labelMedium: AppTextStyles.bodyMedium,
    labelSmall: AppTextStyles.caption,
    bodyLarge: AppTextStyles.bodyLg,
    bodyMedium: AppTextStyles.body,
    bodySmall: AppTextStyles.caption,
  );
}
