import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/figma_checkbox.dart';

/// 약관 동의 화면 (03_약관동의) — Figma node 365:1557 기준 시각 충실.
///
/// 레이아웃:
/// - 배경: white
/// - TopBar (375×64): bg #FEFEFE, bottom stroke #F5F5F5 1px, chevron-left SVG 32×32,
///   타이틀 "약관 동의" Pretendard Medium 16, #1A1A1F
/// - Header (x:16, y:146): "서비스 이용을 위해\n약관에 동의해 주세요" Pretendard Bold 24/150%, #1A1A1F
/// - 전체동의 카드 (343 wide, bg #FCFCFC, stroke #EAEAEA, radius 8, padding 16, gap 16):
///   FigmaCheckbox 24px + "모든 약관에 동의합니다" Bold 16
/// - Divider 1px #DBDBE5
/// - 4개 약관 행:
///   - 필수 3: FigmaCheckbox ON 24px + 라벨 Pretendard Medium 14 #1A1A1F + chevron-right SVG
///   - 선택 1: FigmaCheckbox OFF 20px + 라벨 Pretendard Medium 14 **#737380(회색)** + chevron-right
/// - 다음 버튼 (padding 16/16/32): full-width 343, primary #00BF72, radius 8, Bold 16 white
///
/// 뒤로가기 = 가입 취소 → Navigator.pop + signOut (PopScope 로 swipe-back 도 처리).
class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  bool _termsOfService = false;
  bool _privacy = false;
  bool _sensitiveInfo = false;
  bool _marketing = false;

  bool get _allRequiredAgreed => _termsOfService && _privacy && _sensitiveInfo;
  bool get _allAgreed => _allRequiredAgreed && _marketing;

  void _toggleAll(bool? value) {
    final v = value ?? false;
    setState(() {
      _termsOfService = v;
      _privacy = v;
      _sensitiveInfo = v;
      _marketing = v;
    });
  }

  Future<void> _onNext() async {
    final agreement = TermsAgreement(
      version: 'v1.0',
      agreedAt: DateTime.now(),
      termsOfService: _termsOfService,
      privacy: _privacy,
      sensitiveInfo: _sensitiveInfo,
      marketing: _marketing,
    );
    // 가드가 /onboarding/intro 로 자동 redirect.
    await ref.read(authControllerProvider.notifier).agreeToTerms(agreement);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: true,
      // 뒤로가기/스와이프-back 어떤 경로로 pop 되든 signOut 으로 가입 취소.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(authControllerProvider.notifier).signOut();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(64 + MediaQuery.paddingOf(context).top),
          // SafeArea(bottom: false) — TopBar 를 노치/상태바 아래로 밀어준다.
          child: const SafeArea(bottom: false, child: _TopBar()),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.cardPadding),
              // Header padding x16
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Text(
                  '서비스 이용을 위해\n약관에 동의해 주세요',
                  style: AppTextStyles.header1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.contentGap),
              // Frame 42 (gap 16)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AllAgreeCard(
                      value: _allAgreed,
                      onTap: () => _toggleAll(!_allAgreed),
                    ),
                    const SizedBox(height: AppSpacing.cardPadding),
                    _TermRow(
                      label: '[필수] 서비스 이용약관',
                      checked: _termsOfService,
                      onTap: () =>
                          setState(() => _termsOfService = !_termsOfService),
                    ),
                    _TermRow(
                      label: '[필수] 개인정보 수집·이용 동의',
                      checked: _privacy,
                      onTap: () => setState(() => _privacy = !_privacy),
                    ),
                    _TermRow(
                      label: '[필수] 민감정보(건강) 수집 동의',
                      checked: _sensitiveInfo,
                      onTap: () =>
                          setState(() => _sensitiveInfo = !_sensitiveInfo),
                    ),
                    _TermRow(
                      label: '[선택] 마케팅·푸시 알림 수신',
                      checked: _marketing,
                      optional: true,
                      onTap: () => setState(() => _marketing = !_marketing),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // CTAWrap: padding 16/16/32
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.cardPadding,
                  AppSpacing.screenPadding,
                  AppSpacing.contentGap,
                ),
                child: AppButton.primary(
                  label: '다음',
                  isExpanded: true,
                  onPressed: _allRequiredAgreed ? _onNext : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TopBar (375×64, bg surface, bottom stroke gray30, chevron-left SVG 32, 타이틀)
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceMuted, width: 1),
        ),
      ),
      child: Stack(
        children: [
          // chevron-left at x:16, y:16, 32×32
          Positioned(
            left: AppSpacing.screenPadding,
            top: AppSpacing.cardPadding,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).maybePop(),
              child: SvgPicture.asset(
                'assets/figma_extracted/chevron_left.svg',
                width: 32,
                height: 32,
              ),
            ),
          ),
          // 중앙 타이틀 — Pretendard Medium 16, #1A1A1F
          Center(
            child: Text(
              '약관 동의',
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 전체 동의 카드 (bg #FCFCFC, stroke #EAEAEA, radius 8, padding 16, gap 16)
// ---------------------------------------------------------------------------

class _AllAgreeCard extends StatelessWidget {
  const _AllAgreeCard({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted, // Figma #FCFCFC ≈ gray20 (우리 토큰 gray30 #F5F5F5; 시각상 거의 동일)
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            FigmaCheckbox(checked: value),
            const SizedBox(width: AppSpacing.cardPadding),
            Text(
              '모든 약관에 동의합니다',
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 개별 약관 행
// ---------------------------------------------------------------------------

class _TermRow extends StatelessWidget {
  const _TermRow({
    required this.label,
    required this.checked,
    required this.onTap,
    this.optional = false,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;

  /// [선택] 항목 — checkbox 20px + 라벨 색 textSecondary.
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Figma: 8px 상하
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
      child: Row(
        children: [
          // 좌측: checkbox + 라벨 — 탭하면 체크박스 토글.
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  FigmaCheckbox(checked: checked),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: optional
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 우측 chevron — 약관 상세 웹뷰 push 영역(W1 placeholder).
          InkWell(
            onTap: () {
              // TODO: 약관 전문 WebView(34_개인정보약관) push — 화면 구현 후 연결.
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                'assets/figma_extracted/chevron_right.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
