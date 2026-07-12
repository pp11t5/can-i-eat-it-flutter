import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 브랜드 스플래시 (Figma node #554:5326) — 세션 판별 대기 중 노출.
///
/// 흰 배경 + 중앙 로고 워드마크 + 하단 슬로건. 스피너는 노출하지 않는다
/// (실제 로딩 인디케이션은 네이티브 런치스크린이 대신 담당).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/splash/splash_logo.png', width: 200),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                '먹기 전에 물어보고\n먹은 후에 기록하세요',
                textAlign: TextAlign.center,
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
