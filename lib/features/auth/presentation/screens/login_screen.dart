import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/deletion_grace_dialog.dart';

/// 로그인 화면 (02_로그인) — Figma node 365:1552 기준 시각 충실.
///
/// 레이아웃 (375×812 캔버스):
/// - 배경: #F7FFFB 연한 민트, opacity 15% 배경 이미지(558×838) 깔림
/// - 로고/일러스트 PNG: x:76, y:141, 218×218
/// - 슬로건: y:343, Pretendard Bold 16/140%, color #02995B (green200)
/// - 버튼 컨테이너: x:16, y:518, 342 width, gap 16
///   - 카카오: #FEE500 / 카카오 심볼 18×18 SVG / 텍스트 Pretendard Medium 16, rgba(0,0,0,0.85)
///   - Apple: #000000 / Material apple 아이콘(출시 시 공식 위젯으로 교체) / "Apple로 계속하기" (HIG 승인 문구)
///
/// 플랫폼 분기:
/// - iOS: 카카오 + Apple (App Store 4.8 충족)
/// - Android: 카카오만 노출
///
/// 진입 후 처리:
/// - 신규(약관 미동의) → context.push('/terms') (iOS pop 애니메이션 보장)
/// - 기존(미온보딩) → go /onboarding/intro
/// - 기존(완전) → go /
/// - 삭제유예 → 02a 다이얼로그
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: Stack(
        children: [
          // Opacity 15% 배경 사진 (Figma: 558×838 @ x=-32, y=0, opacity 0.15)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/figma_extracted/login_bg_image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              // 비례형 레이아웃 — 디바이스 크기에 강건.
              // Figma 비율(로고 상단 ~17% / 슬로건 중앙 ~42% / 버튼 ~64%) 근접.
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const Flexible(child: _LogoIllustration()),
                  const SizedBox(height: AppSpacing.contentGap),
                  const _Slogan(),
                  const Spacer(flex: 3),
                  _ButtonSection(
                    isLoading: isLoading,
                    onKakaoPressed: () => _handleKakaoPressed(context, ref),
                    onApplePressed: () => _handleApplePressed(context, ref),
                  ),
                  const SizedBox(height: AppSpacing.cardPadding),
                  const _DisclaimerText(),
                  const SizedBox(height: AppSpacing.cardPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleKakaoPressed(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signInWithKakao();
    if (!context.mounted) return;
    await _handlePostSignIn(context, ref);
  }

  Future<void> _handleApplePressed(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signInWithApple();
    if (!context.mounted) return;
    await _handlePostSignIn(context, ref);
  }

  /// 로그인 후 라우팅 — 명시적 push 로 Navigator 스택을 쌓아 iOS pop 보장.
  Future<void> _handlePostSignIn(BuildContext context, WidgetRef ref) async {
    final session = ref.read(authControllerProvider).valueOrNull;
    if (session == null) return;

    if (session.accountStatus == AccountStatus.deletionGrace) {
      await showDeletionGraceDialog(context, ref);
      return;
    }

    if (!context.mounted) return;
    if (!session.hasAgreedTerms) {
      context.push('/terms');
    } else if (!session.hasCompletedOnboarding) {
      context.go('/onboarding/intro');
    } else {
      context.go('/');
    }
  }
}

// ---------------------------------------------------------------------------
// 로고 일러스트 (Figma 다운로드 PNG)
// ---------------------------------------------------------------------------

class _LogoIllustration extends StatelessWidget {
  const _LogoIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 218,
      height: 218,
      child: Image.asset(
        'assets/figma_extracted/login_logo_illust.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 슬로건 (Figma: Pretendard Bold 16/140%, color green200 #02995B)
// ---------------------------------------------------------------------------

class _Slogan extends StatelessWidget {
  const _Slogan();

  @override
  Widget build(BuildContext context) {
    return Text(
      '먹기 전에 물어보고\n먹은 후에 기록하세요',
      textAlign: TextAlign.center,
      style: AppTextStyles.body1Bold.copyWith(
        color: AppColors.brandAccent,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 버튼 섹션 (플랫폼 분기 + 로딩 시 비활성)
// ---------------------------------------------------------------------------

class _ButtonSection extends StatelessWidget {
  const _ButtonSection({
    required this.isLoading,
    required this.onKakaoPressed,
    required this.onApplePressed,
  });

  final bool isLoading;
  final VoidCallback onKakaoPressed;
  final VoidCallback onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _KakaoButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : onKakaoPressed,
        ),
        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
          const SizedBox(height: AppSpacing.itemGap),
          _AppleButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : onApplePressed,
          ),
        ],
        if (isLoading) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          const CircularProgressIndicator(color: AppColors.primary),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 카카오 버튼 (Figma: #FEE500, padding 0/14, gap 8, 공식 카카오 SVG 심볼 18×18)
// ---------------------------------------------------------------------------

class _KakaoButton extends StatelessWidget {
  const _KakaoButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isLoading ? AppColors.surfaceMuted : AppColors.kakao,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.cardPadding - 2,
              horizontal: 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Figma 공식 카카오 심볼 — 다운로드된 SVG (18×18).
                SvgPicture.asset(
                  'assets/figma_extracted/kakao_logo_symbol.svg',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Text(
                  '카카오로 시작하기',
                  // Figma: Pretendard Medium 16 / lineHeight 160% / rgba(0,0,0,0.85)
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.kakaoText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Apple 버튼 (HIG 승인 문구. 출시 시 공식 SignInWithAppleButton 으로 교체)
// ---------------------------------------------------------------------------

class _AppleButton extends StatelessWidget {
  const _AppleButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: 출시 시 sign_in_with_apple 공식 SignInWithAppleButton 으로 교체(HIG).
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isLoading ? AppColors.surfaceMuted : AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Padding(
            // Figma: padding 15 / gap 15
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apple,
                  size: 22,
                  color: AppColors.surface,
                ),
                const SizedBox(width: 15),
                // HIG 승인 문구.
                Text(
                  'Apple로 계속하기',
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 하단 면책
// ---------------------------------------------------------------------------

class _DisclaimerText extends StatelessWidget {
  const _DisclaimerText();

  @override
  Widget build(BuildContext context) {
    return Text(
      // provisional, PO 카피 검수 대상.
      '본 앱은 의료기기가 아니며 진단·치료 목적이 아닙니다',
      textAlign: TextAlign.center,
      style: AppTextStyles.caption1Medium.copyWith(
        color: AppColors.textTertiary,
      ),
    );
  }
}
