import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 브랜드 스플래시 — 세션 판별 대기 중 노출.
///
/// 흰 배경 + 상단 카피 + 중앙 브랜드 합성 이미지(워드마크 + 전신 캐릭터).
/// OS 네이티브 스플래시는 [FlutterNativeSplash.preserve] 로 유지했다가,
/// 이 화면 첫 프레임·이미지 프리캐시 후 [FlutterNativeSplash.remove] 한다.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// Figma 프레임 368 기준, 화면 폭 대비 표시 너비.
  static const double brandWidth = 280;

  /// 카피 → 브랜드 이미지 간격 (Figma).
  static const double copyImageGap = 11;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _dismissNativeSplash());
  }

  /// 브랜드 이미지를 디코드한 뒤 네이티브 스플래시를 제거해
  /// 옛 splash_logo / 빈 프레임 깜빡임을 막는다.
  Future<void> _dismissNativeSplash() async {
    try {
      if (mounted) {
        await precacheImage(
          const AssetImage(AppImages.splashBrand),
          context,
        );
      }
    } catch (_) {
      // 프리캐시 실패해도 네이티브 스플래시는 반드시 제거.
    }
    FlutterNativeSplash.remove();
  }

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
              const SizedBox(height: SplashScreen.copyImageGap),
              Image.asset(
                AppImages.splashBrand,
                width: SplashScreen.brandWidth,
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
