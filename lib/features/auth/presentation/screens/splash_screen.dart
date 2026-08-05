import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 브랜드 스플래시 — 세션 판별 대기 중 노출.
///
/// 흰 배경 + 상단 카피 + 중앙 브랜드 합성 이미지(워드마크 + 전신 캐릭터).
/// 스피너는 노출하지 않는다(로딩 인디케이션은 네이티브 런치스크린이 담당).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  /// Figma 프레임 368 기준, 화면 폭 대비 표시 너비.
  static const double _kBrandWidth = 280;

  /// 카피 → 브랜드 이미지 간격 (Figma).
  static const double _kCopyImageGap = 11;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '배아플지도 모르지만',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Bold.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: _kCopyImageGap),
              Image.asset(
                AppImages.splashBrand,
                width: _kBrandWidth,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
