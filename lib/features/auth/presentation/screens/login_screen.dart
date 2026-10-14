import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/auth/data/services/google_auth_service.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/deletion_grace_dialog.dart';

/// 로그인 화면 (02_로그인) — Figma node 365:1552 기준 레이아웃.
///
/// 캔버스 375×812 기준:
/// - 배경: #F7FFFB (loginBg), opacity 15% 배경 사진(위/아래 flip — 흰색이 상단)
/// - 로고 PNG: y:141, 218×218 비율 스케일
/// - 슬로건: 로고 바로 아래 [_kLogoSloganGap](0) — 로고와 묶은 Column
///   (절대 y 분리 시 로고는 가로 스케일·슬로건은 세로 스케일이라 간격이 깨지던 문제 수정)
/// - 버튼 컨테이너: y:518, 좌우 16, gap 16
/// 화면 비율로 환산해 LayoutBuilder + Positioned 로 매핑.
///
/// ## 로그인 후 분기 (SignInOutcome switch)
/// - [Authenticated] → onboarded=true: `context.go('/')` (게이트 재평가),
///   onboarded=false: `context.push('/terms')`.
///   신규·온보딩 미완료 사용자 모두 로그인할 때마다 최신 약관을 확인한다.
/// - [Recoverable] → 복구 다이얼로그 (기존 deletion_grace_dialog 재사용).
///
/// ## 콜드스타트 오프라인 토스트 (T1)
/// initState post-frame 에서 [coldStartOfflineProvider] 를 1회 소비.
/// true 이면 "네트워크 연결을 확인해 주세요. 다시 로그인이 필요해요." 토스트 표시.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

enum _LoginMethod { kakao, kakaoAccount, apple, google }

class _LoginScreenState extends ConsumerState<LoginScreen> {
  _LoginMethod? _signingInWith;
  // Figma 기준 비율 상수 (375×812).
  static const double _kCanvasW = 375;
  static const double _kCanvasH = 812;
  static const double _kLogoY = 141; // → 17.4% from top
  static const double _kLogoSize = 218;

  /// 로고 박스 하단 → 슬로건 상단 간격 (스플래시와 동일, 전역 sectionGap과 분리).
  static const double _kLogoSloganGap = 0;
  static const double _kButtonY = 518; // → 63.8%

  @override
  void initState() {
    super.initState();
    // post-frame: coldStartOfflineProvider 소비 → T1 토스트 트리거.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isOffline = ref.read(coldStartOfflineProvider);
      if (isOffline) {
        showAppToast(
          context,
          '네트워크 연결을 확인해 주세요. 다시 로그인이 필요해요.',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading || _signingInWith != null;

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final logoSize = (w * _kLogoSize / _kCanvasW).clamp(160.0, 280.0);
          return Stack(
            children: [
              // 배경 사진 — 위아래 flip (흰색이 상단으로) + opacity 15%.
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Transform.flip(
                    flipY: true,
                    child: Image.asset(
                      'assets/figma_extracted/login_bg_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // 로고 + 슬로건 — y 141/812 에서 세로로 묶고 명시 간격.
              // (로고 가로 스케일 / 슬로건 절대 y 분리 시 기기 비율에 따라 간격 붕괴)
              Positioned(
                top: h * _kLogoY / _kCanvasH,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: logoSize,
                      height: logoSize,
                      child: Image.asset(
                        'assets/figma_extracted/login_logo_illust.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: _kLogoSloganGap),
                    const _Slogan(),
                  ],
                ),
              ),
              // 버튼 컨테이너 — y 518/812 (63.8%), 좌우 16.
              Positioned(
                top: h * _kButtonY / _kCanvasH,
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
                child: _ButtonSection(
                  isLoading: isLoading,
                  signingInWith: _signingInWith,
                  onKakaoPressed: () =>
                      _handleSignIn(context, _LoginMethod.kakao),
                  onKakaoAccountPressed: () =>
                      _handleSignIn(context, _LoginMethod.kakaoAccount),
                  onApplePressed: () =>
                      _handleSignIn(context, _LoginMethod.apple),
                  onGooglePressed: () =>
                      _handleSignIn(context, _LoginMethod.google),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleSignIn(BuildContext context, _LoginMethod method) async {
    if (_signingInWith != null || ref.read(authControllerProvider).isLoading) {
      return;
    }
    // 외부 OAuth 대기는 화면의 버튼 상태로만 표시한다.
    setState(() => _signingInWith = method);
    try {
      final controller = ref.read(authControllerProvider.notifier);
      final outcome = await switch (method) {
        _LoginMethod.kakao => controller.signInWithKakao(),
        _LoginMethod.kakaoAccount =>
          controller.signInWithKakao(useKakaoAccount: true),
        _LoginMethod.apple => controller.signInWithApple(),
        _LoginMethod.google => controller.signInWithGoogle(),
      };
      if (!context.mounted) return;
      setState(() => _signingInWith = null);
      await _handlePostSignIn(context, outcome);
    } catch (e) {
      if (!context.mounted) return;
      if (_isUserCancelledSocialAuth(e)) return;
      _showSignInErrorToast(context);
    } finally {
      if (mounted && _signingInWith != null) {
        setState(() => _signingInWith = null);
      }
    }
  }

  /// 사용자가 OAuth UI 를 닫거나 취소한 경우 — 실패 토스트 없이 로그인 화면 유지.
  bool _isUserCancelledSocialAuth(Object error) {
    if (isKakaoSignInCancelled(error)) {
      return true;
    }
    if (error is SignInWithAppleAuthorizationException &&
        error.code == AuthorizationErrorCode.canceled) {
      return true;
    }
    if (error is GoogleSignInCancelledException) {
      return true;
    }
    return false;
  }

  /// 로그인 실패 시 T2 토스트를 표시한다.
  ///
  /// [Failure] 서브타입과 기타 예외 모두 동일한 사용자 메시지를 노출한다.
  /// 진행 상태는 [_handleSignIn]의 finally에서 해제한다.
  void _showSignInErrorToast(BuildContext context) {
    showAppToast(context, '로그인에 실패했어요. 잠시 후 다시 시도해 주세요.');
  }

  /// 로그인 후 라우팅 — [SignInOutcome] exhaustive switch (ADR-0007 §3-1 (6-A)).
  ///
  /// ## 게이트 정합 (완료 기준 6번)
  /// [Authenticated.onboarded] 를 라우팅에 직접 반영한다.
  /// - onboarded=true → `context.go('/')`: 가드 sessionStatus=ready → '/' 허용.
  /// - onboarded=false → `context.push('/terms')`: 로그인 화면을 스택 아래 유지해
  ///   약관 뒤로가기 시 역방향 애니메이션과 가입 취소(signOut)를 보존한다.
  Future<void> _handlePostSignIn(
    BuildContext context,
    SignInOutcome outcome,
  ) async {
    switch (outcome) {
      case Authenticated(:final onboarded):
        // onboarded=false → 온보딩 1페이지로 직행.
        // onboarded=true → 홈으로 (가드가 ready 상태로 허용).
        if (onboarded) {
          context.go('/');
        } else {
          context.push('/terms');
        }

      case Recoverable(:final provider, :final idToken):
        // 복구 가능 계정 → 기존 deletion_grace_dialog 재사용.
        // 로그인 시 획득한 idToken 을 전달해 카카오 SDK 재인증 없이 복구한다.
        await showDeletionGraceDialog(
          context,
          ref,
          provider: provider,
          idToken: idToken,
        );
    }
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
    required this.signingInWith,
    required this.onKakaoPressed,
    required this.onKakaoAccountPressed,
    required this.onApplePressed,
    required this.onGooglePressed,
  });

  final bool isLoading;
  final _LoginMethod? signingInWith;
  final VoidCallback onKakaoPressed;
  final VoidCallback onKakaoAccountPressed;
  final VoidCallback onApplePressed;
  final VoidCallback onGooglePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KakaoButton(
          isLoading: isLoading,
          isSigningIn: signingInWith == _LoginMethod.kakao,
          onPressed: isLoading ? null : onKakaoPressed,
        ),
        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
          const SizedBox(height: AppSpacing.itemGap),
          _AppleButton(
            isLoading: isLoading,
            isSigningIn: signingInWith == _LoginMethod.apple,
            onPressed: isLoading ? null : onApplePressed,
          ),
        ],
        const SizedBox(height: AppSpacing.itemGap),
        _GoogleButton(
          isLoading: isLoading,
          isSigningIn: signingInWith == _LoginMethod.google,
          onPressed: isLoading ? null : onGooglePressed,
        ),
        const SizedBox(height: AppSpacing.itemGap),
        TextButton(
          onPressed: isLoading ? null : onKakaoAccountPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (signingInWith == _LoginMethod.kakaoAccount) ...[
                const _LoginSpinner(),
                const SizedBox(width: AppSpacing.itemGap),
              ],
              Text(
                '다른 카카오계정으로 로그인',
                style: AppTextStyles.body2Medium.copyWith(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        if (isLoading && signingInWith == null) ...[
          const SizedBox(height: AppSpacing.cardPadding),
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
    required this.isSigningIn,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isSigningIn;
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
                if (isSigningIn)
                  const _LoginSpinner()
                else
                  SvgPicture.asset(
                    'assets/figma_extracted/kakao_logo_symbol.svg',
                    width: 18,
                    height: 18,
                  ),
                const SizedBox(width: AppSpacing.itemGap),
                Text(
                  '카카오 로그인',
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
    required this.isSigningIn,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isSigningIn;
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
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSigningIn)
                  const _LoginSpinner()
                else
                  const AppIcon(
                    AppIcons.appleLogo,
                    size: 22,
                    color: AppColors.surface,
                  ),
                const SizedBox(width: 15),
                Text(
                  'Apple로 로그인',
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
// Google 버튼 (흰 배경 + 공식 G + 테두리)
// ---------------------------------------------------------------------------

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    required this.isLoading,
    required this.isSigningIn,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isSigningIn;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isLoading ? AppColors.surfaceMuted : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.border),
        ),
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
                if (isSigningIn)
                  const _LoginSpinner()
                else
                  SvgPicture.asset(
                    'assets/figma_extracted/google_logo.svg',
                    width: 18,
                    height: 18,
                  ),
                const SizedBox(width: AppSpacing.itemGap),
                Text(
                  'Google로 로그인',
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.textPrimary,
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

class _LoginSpinner extends StatelessWidget {
  const _LoginSpinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
          semanticsLabel: '로그인 진행 중',
        ),
      );
}
