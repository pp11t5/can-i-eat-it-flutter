import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/deletion_grace_dialog.dart';

/// 로그인 화면.
///
/// 플랫폼 분기:
/// - iOS: 카카오 + Apple(Apple App Store Guideline 4.8 충족)
/// - Android/기타: 카카오만 노출
///
/// 버튼 비주얼은 디자이너 재디자인 예정 — 현재 기능 동작 수준(토큰만 사용).
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              const Spacer(),
              _LogoSection(),
              const SizedBox(height: AppSpacing.contentGap),
              _ButtonSection(
                isLoading: isLoading,
                onKakaoPressed: () => _handleKakaoPressed(context, ref),
                onApplePressed: () => _handleApplePressed(context, ref),
              ),
              const Spacer(),
              _DisclaimerText(),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
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

  /// 로그인 후 accountStatus 확인.
  ///
  /// deletionGrace면 02a 삭제유예 다이얼로그를 표시한다.
  /// 그 외 상태(active 등)는 가드가 자동으로 redirect한다.
  Future<void> _handlePostSignIn(BuildContext context, WidgetRef ref) async {
    final session = ref.read(authControllerProvider).valueOrNull;
    if (session?.accountStatus == AccountStatus.deletionGrace) {
      if (!context.mounted) return;
      await showDeletionGraceDialog(context, ref);
    }
  }
}

// ---------------------------------------------------------------------------
// 로고 섹션
// ---------------------------------------------------------------------------

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO: 디자이너 제공 일러스트 에셋으로 교체 예정
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceSelected,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: const Icon(
            Icons.restaurant,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(
          '먹기 전에 물어보고\n먹은 후에 기록하세요',
          textAlign: TextAlign.center,
          style: AppTextStyles.header1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 버튼 섹션 (플랫폼 분기)
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
        // Apple 버튼: iOS에서만 노출 (Apple App Store Guideline 4.8)
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
// 카카오 버튼
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLoading ? AppColors.surfaceMuted : AppColors.kakao,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.cardPadding,
            horizontal: AppSpacing.sectionGap,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          textStyle: AppTextStyles.body1Bold,
          elevation: 0,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: 공식 카카오 심볼 에셋(디자이너 제공 예정)으로 교체
            Icon(Icons.chat_bubble, size: AppSpacing.cardPadding),
            SizedBox(width: AppSpacing.itemGap),
            Text('카카오로 시작하기'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Apple 버튼 (iOS 전용)
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
    // TODO: 출시 시 sign_in_with_apple 공식 SignInWithAppleButton으로 교체(HIG)
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLoading ? AppColors.surfaceMuted : AppColors.textPrimary,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.cardPadding,
            horizontal: AppSpacing.sectionGap,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          textStyle: AppTextStyles.body1Bold,
          elevation: 0,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: 출시 시 공식 Apple 로고 에셋으로 교체(HIG: SF 글리프 사용)
            Icon(Icons.apple, size: AppSpacing.cardPadding, color: AppColors.surface),
            SizedBox(width: AppSpacing.itemGap),
            // 승인 문구: "Apple로 계속하기" (HIG 준수 — "애플로 시작하기" 비승인)
            Text('Apple로 계속하기'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 하단 면책 텍스트
// ---------------------------------------------------------------------------

class _DisclaimerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      // provisional, PO 카피 검수 대상
      '본 앱은 의료기기가 아니며 진단·치료 목적이 아닙니다',
      textAlign: TextAlign.center,
      style: AppTextStyles.caption1Medium.copyWith(
        color: AppColors.textTertiary,
      ),
    );
  }
}
