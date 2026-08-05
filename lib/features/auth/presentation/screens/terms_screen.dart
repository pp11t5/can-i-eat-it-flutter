import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/consent.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_detail_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/figma_checkbox.dart';

typedef OpenTermDetail = Future<void> Function(
  BuildContext context,
  ConsentTerm term,
);

/// 서버 약관 URL을 앱 내부 웹뷰로 연다.
Future<void> openTermDetailInWebView(
  BuildContext context,
  ConsentTerm term,
) async {
  final uri = Uri.tryParse(term.content);
  final isWebUrl = uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
  if (!isWebUrl) {
    await showAppToast(context, '링크를 열 수 없어요.');
    return;
  }
  if (!context.mounted) return;
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => TermsDetailScreen(title: term.title, url: uri.toString()),
    ),
  );
}

/// 소셜 로그인 후 온보딩 전에 노출하는 최신 약관 동의 화면.
///
/// 시각 구조는 375×812 기준 시안을 따르고, 약관 제목·필수 여부·상세 URL은
/// `GET /consent/terms` 응답만을 진실 원천으로 사용한다.
class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({
    super.key,
    this.openTerm = openTermDetailInWebView,
  });

  final OpenTermDetail openTerm;

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  final Set<int> _agreedTermIds = {};
  bool _isSubmitting = false;
  bool _isConsentTransitionActive = false;
  late final ConsentNavigationTransition _consentNavigationTransition;

  @override
  void initState() {
    super.initState();
    _consentNavigationTransition =
        ref.read(consentNavigationTransitionProvider.notifier);
  }

  void _beginConsentTransition() {
    if (_isConsentTransitionActive) return;
    _isConsentTransitionActive = true;
    _consentNavigationTransition.begin();
  }

  void _endConsentTransition() {
    if (!_isConsentTransitionActive) return;
    _isConsentTransitionActive = false;
    _consentNavigationTransition.end();
  }

  /// 교체 이동이 라우터에 반영된 다음 프레임에 전환 허용을 해제한다.
  ///
  /// dispose 중 provider 상태를 바꾸면 Riverpod이 빌드 중 변경으로 막으므로,
  /// 화면 수명주기 밖에서 해제한다.
  void _scheduleConsentTransitionEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _endConsentTransition();
    });
  }

  void _scheduleSignOut() {
    final controller = ref.read(authControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.signOut());
  }

  void _leaveTerms() {
    if (context.canPop()) {
      Navigator.of(context).maybePop();
      return;
    }
    context.go('/login');
    _scheduleSignOut();
  }

  bool _allRequiredAgreed(List<ConsentTerm> terms) => terms
      .where((term) => term.isRequired)
      .every((term) => _agreedTermIds.contains(term.id));

  bool _allAgreed(List<ConsentTerm> terms) =>
      terms.isNotEmpty &&
      terms.every((term) => _agreedTermIds.contains(term.id));

  void _toggleAll(List<ConsentTerm> terms) {
    setState(() {
      if (_allAgreed(terms)) {
        _agreedTermIds.clear();
      } else {
        _agreedTermIds
          ..clear()
          ..addAll(terms.map((term) => term.id));
      }
    });
  }

  void _toggleTerm(int termId) {
    setState(() {
      if (!_agreedTermIds.add(termId)) {
        _agreedTermIds.remove(termId);
      }
    });
  }

  Future<void> _onNext(List<ConsentTerm> terms) async {
    if (_isSubmitting || !_allRequiredAgreed(terms)) return;
    setState(() => _isSubmitting = true);
    _beginConsentTransition();
    final choices = terms
        .map(
          (term) => ConsentChoice(
            termId: term.id,
            agreed: _agreedTermIds.contains(term.id),
          ),
        )
        .toList(growable: false);
    try {
      await ref.read(globalLoadingControllerProvider.notifier).run(
            () =>
                ref.read(authControllerProvider.notifier).agreeToTerms(choices),
          );
      if (!mounted) {
        _endConsentTransition();
        return;
      }
      context.pushReplacement('/onboarding/condition');
      _scheduleConsentTransitionEnd();
    } catch (error) {
      _endConsentTransition();
      if (!mounted) return;
      final message =
          error is Failure ? error.message : '약관 동의를 저장하지 못했어요. 다시 시도해 주세요.';
      await showAppToast(context, message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final termsAsync = ref.watch(consentTermsProvider);
    final loadedTerms = termsAsync.valueOrNull ?? const <ConsentTerm>[];
    final canSubmit = loadedTerms.isNotEmpty &&
        _allRequiredAgreed(loadedTerms) &&
        !_isSubmitting;

    return PopScope<Object?>(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _scheduleSignOut();
        } else {
          context.go('/login');
          _scheduleSignOut();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 76,
          centerTitle: true,
          leadingWidth: 64,
          leading: IconButton(
            iconSize: AppIconSizes.s32,
            padding: EdgeInsets.zero,
            icon: const AppIcon(
              AppIcons.chevronLeft,
              size: AppIconSizes.s32,
              color: AppColors.textPrimary,
              semanticsLabel: '뒤로',
            ),
            onPressed: _leaveTerms,
          ),
          shape: const Border(
            bottom: BorderSide(color: AppColors.surfaceMuted, width: 1),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.cardPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 26),
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
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: termsAsync.when(
                          loading: () => const _TermsLoading(),
                          error: (error, _) => _TermsError(
                            message: error is Failure
                                ? error.message
                                : '약관 정보를 불러오지 못했어요.',
                            onRetry: () {
                              _agreedTermIds.clear();
                              ref.invalidate(consentTermsProvider);
                            },
                          ),
                          data: (terms) => _TermsList(
                            terms: terms,
                            agreedTermIds: _agreedTermIds,
                            onToggleAll: () => _toggleAll(terms),
                            onToggleTerm: _toggleTerm,
                            onOpenTerm: (term) =>
                                widget.openTerm(context, term),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  isLoading: _isSubmitting,
                  onPressed: canSubmit ? () => _onNext(loadedTerms) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsList extends StatelessWidget {
  const _TermsList({
    required this.terms,
    required this.agreedTermIds,
    required this.onToggleAll,
    required this.onToggleTerm,
    required this.onOpenTerm,
  });

  final List<ConsentTerm> terms;
  final Set<int> agreedTermIds;
  final VoidCallback onToggleAll;
  final ValueChanged<int> onToggleTerm;
  final ValueChanged<ConsentTerm> onOpenTerm;

  @override
  Widget build(BuildContext context) {
    final allAgreed = terms.isNotEmpty &&
        terms.every((term) => agreedTermIds.contains(term.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AllAgreeCard(value: allAgreed, onTap: onToggleAll),
        const SizedBox(height: AppSpacing.cardPadding),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
        const SizedBox(height: AppSpacing.cardPadding),
        for (final term in terms)
          _TermRow(
            label: '[${term.isRequired ? '필수' : '선택'}] ${term.title}',
            checked: agreedTermIds.contains(term.id),
            optional: !term.isRequired,
            onTap: () => onToggleTerm(term.id),
            onChevronTap: () => onOpenTerm(term),
          ),
      ],
    );
  }
}

class _TermsLoading extends StatelessWidget {
  const _TermsLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _TermsError extends StatelessWidget {
  const _TermsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.cardPadding),
          AppButton.secondary(label: '다시 시도', onPressed: onRetry),
        ],
      ),
    );
  }
}

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
          color: AppColors.surfaceInset,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 14,
        ),
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

class _TermRow extends StatelessWidget {
  const _TermRow({
    required this.label,
    required this.checked,
    required this.onTap,
    required this.onChevronTap,
    required this.optional,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;
  final VoidCallback onChevronTap;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          InkWell(
            onTap: onChevronTap,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: AppIcon(
                AppIcons.chevronRight,
                size: AppIconSizes.s24,
                color: AppColors.textPrimary,
                semanticsLabel: '약관 상세 열기',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
