import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 온보딩 인트로 화면 — 로그인 성공 직후 첫 진입점.
///
/// "시작하기" 탭 시 [onStart] 콜백 호출.
/// 기본 콜백은 `/onboarding/condition`으로 이동한다.
class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({
    super.key,
    this.onStart,
  });

  /// "시작하기" 버튼 탭 콜백. null이면 `/onboarding/condition`으로 이동.
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    void handleStart() {
      if (onStart != null) {
        onStart!();
      } else {
        context.go('/onboarding/condition');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go('/'),
            child: Text(
              '건너뛰기',
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // 앱 로고 (assets/images/app_logo.png 없으면 FlutterLogo 폴백)
              Center(
                child: _AppLogo(),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // 타이틀
              Semantics(
                label: '먹어도 돼?',
                child: Text(
                  '먹어도 돼?',
                  style: AppTextStyles.header1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),

              // 서브타이틀
              Text(
                '내 건강 상태에 맞는 음식을 찾아드려요',
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // CTA 버튼
              Semantics(
                button: true,
                label: '시작하기',
                child: SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: handleStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                      ),
                      textStyle: AppTextStyles.body1Bold,
                    ),
                    child: const Text('시작하기'),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 로고 위젯 (assets/images/app_logo.png 없으면 FlutterLogo 폴백)
// ---------------------------------------------------------------------------

class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      width: 80,
      height: 80,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const FlutterLogo(size: 80),
    );
  }
}
