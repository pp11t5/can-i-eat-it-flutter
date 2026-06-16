import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/deletion_grace_dialog.dart';

/// 로그인 화면 (02_로그인) — Figma node 365:1552 기준 절대 위치 충실.
///
/// 캔버스 375×812 기준 절대 좌표:
/// - 배경: #F7FFFB (loginBg), opacity 15% 배경 사진(위/아래 flip — 흰색이 상단)
/// - 로고 PNG: x:76, y:141, 218×218
/// - 슬로건: y:343, Pretendard Bold 16, color brandAccent #02995B
/// - 버튼 컨테이너: x:16, y:518, 342 wide, gap 16
/// 화면 비율로 환산해 LayoutBuilder + Positioned 로 매핑.
///
/// ## 로그인 후 분기 (SignInOutcome switch)
/// - [Authenticated] → onboarded=true: `context.go('/')` (게이트 재평가),
///   onboarded=false: `context.go('/onboarding/condition')`.
///   게이트 정합: 세션에 hasAgreedTerms=true 이므로 resolveRedirect 가 needsOnboarding
///   상태에서 /onboarding/condition 을 허용 → redirect 루프 없음.
///   실 onboardedStatus() 반영은 티켓 4 (현재는 Authenticated.onboarded 직접 사용).
/// - [NeedsTerms] → `context.push('/terms')` (imperative push, ADR-0006 보존).
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

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Figma 기준 비율 상수 (375×812).
  static const double _kCanvasW = 375;
  static const double _kCanvasH = 812;
  static const double _kLogoY = 141; // → 17.4% from top
  static const double _kLogoSize = 218;
  static const double _kSloganY = 343; // → 42.2%
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
    final isLoading = authState.isLoading;

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
              // 로고 — y 141/812 (17.4%) 중앙 정렬, 크기 218 기준 비례.
              Positioned(
                top: h * _kLogoY / _kCanvasH,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: logoSize,
                    height: logoSize,
                    child: Image.asset(
                      'assets/figma_extracted/login_logo_illust.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // 슬로건 — y 343/812 (42.2%).
              Positioned(
                top: h * _kSloganY / _kCanvasH,
                left: 0,
                right: 0,
                child: const Center(child: _Slogan()),
              ),
              // 버튼 컨테이너 — y 518/812 (63.8%), 좌우 16.
              Positioned(
                top: h * _kButtonY / _kCanvasH,
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
                child: _ButtonSection(
                  isLoading: isLoading,
                  onKakaoPressed: () => _handleKakaoPressed(context),
                  onApplePressed: () => _handleApplePressed(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleKakaoPressed(BuildContext context) async {
    final outcome =
        await ref.read(authControllerProvider.notifier).signInWithKakao();
    if (!context.mounted) return;
    await _handlePostSignIn(context, outcome);
  }

  Future<void> _handleApplePressed(BuildContext context) async {
    final outcome =
        await ref.read(authControllerProvider.notifier).signInWithApple();
    if (!context.mounted) return;
    await _handlePostSignIn(context, outcome);
  }

  /// 로그인 후 라우팅 — [SignInOutcome] exhaustive switch (ADR-0007 §3-1 (6-A)).
  ///
  /// ## 게이트 정합 (완료 기준 6번)
  /// [Authenticated.onboarded] 를 라우팅에 직접 반영:
  /// - onboarded=true → `context.go('/')`: 가드 sessionStatus=ready → '/' 허용.
  /// - onboarded=false → `context.go('/onboarding/condition')`:
  ///   세션 hasAgreedTerms=true 이므로 sessionStatusFrom 이 needsOnboarding 을 반환하고
  ///   resolveRedirect(needsOnboarding, '/onboarding/condition') = null → redirect 없음.
  ///
  /// 실 onboardedStatus() 는 티켓 4 (HealthProfileRepository.onboardedStatus() 실연동).
  /// 현재는 Authenticated.onboarded (서버 GET /onboarding/status 결과) 를 직접 사용.
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
          context.go('/onboarding/condition');
        }

      case NeedsTerms():
        // imperative push — iOS pop 애니메이션 보장, 가드 redirect 와 분리 (ADR-0006).
        context.push('/terms');

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
    required this.onKakaoPressed,
    required this.onApplePressed,
  });

  final bool isLoading;
  final VoidCallback onKakaoPressed;
  final VoidCallback onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                SvgPicture.asset(
                  'assets/figma_extracted/kakao_logo_symbol.svg',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Text(
                  '카카오로 로그인',
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
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.apple, size: 22, color: AppColors.surface),
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
