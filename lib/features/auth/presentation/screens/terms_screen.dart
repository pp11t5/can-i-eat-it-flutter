import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 약관 동의 화면 (03_약관동의).
///
/// 신규 가입자만 진입(가드). 필수 3개(서비스 이용약관·개인정보·민감정보) 동의 시
/// '다음' 활성. '다음' → TermsAgreement(버전·항목·시각) 기록 → 가드가 온보딩으로 redirect.
/// 뒤로가기 → 가입 취소(signOut → 미인증 → 로그인).
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
    // 가드가 동의 후 /onboarding/intro 로 자동 redirect.
    await ref.read(authControllerProvider.notifier).agreeToTerms(agreement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        // Figma TopBar 타이틀: Pretendard Medium 16 → body1Medium.
        title: const Text('약관 동의', style: AppTextStyles.body1Medium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          // 1) pop 으로 Navigator 스택을 뒤로(=iOS Cupertino pop 애니메이션).
          // 2) signOut 으로 가입 취소(상태 unauthenticated). 가드는 /login 에서 redirect 없음.
          onPressed: () {
            context.pop();
            ref.read(authControllerProvider.notifier).signOut();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '서비스 이용을 위해\n약관에 동의해 주세요',
                style: AppTextStyles.header1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.contentGap),
              _AllAgreeRow(value: _allAgreed, onChanged: _toggleAll),
              const Divider(color: AppColors.divider),
              _TermRow(
                label: '[필수] 서비스 이용약관',
                value: _termsOfService,
                onChanged: (v) => setState(() => _termsOfService = v ?? false),
              ),
              _TermRow(
                label: '[필수] 개인정보 수집·이용 동의',
                value: _privacy,
                onChanged: (v) => setState(() => _privacy = v ?? false),
              ),
              _TermRow(
                label: '[필수] 민감정보(건강) 수집 동의',
                value: _sensitiveInfo,
                onChanged: (v) => setState(() => _sensitiveInfo = v ?? false),
              ),
              _TermRow(
                label: '[선택] 마케팅·푸시 알림 수신',
                value: _marketing,
                optional: true,
                onChanged: (v) => setState(() => _marketing = v ?? false),
              ),
              const Spacer(),
              AppButton.primary(
                label: '다음',
                isExpanded: true,
                onPressed: _allRequiredAgreed ? _onNext : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// '모든 약관에 동의합니다' 전체 토글 행.
class _AllAgreeRow extends StatelessWidget {
  const _AllAgreeRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.itemGap),
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

/// 개별 약관 항목 행(필수/선택).
class _TermRow extends StatelessWidget {
  const _TermRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body2Medium.copyWith(
                color:
                    optional ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            ),
          ),
          // TODO: 약관 전문 웹뷰(34_개인정보약관)로 연결 — 디자이너/PO 확정 후
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: AppColors.textTertiary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
