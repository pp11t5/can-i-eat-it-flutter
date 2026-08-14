import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_detail_screen.dart';

/// 음식 판정에 사용한 의료 근거 안내로 이동하는 공통 링크.
///
/// 기본형은 `/mypage/medical-sources`로 이동한다.
/// [MedicalSourcesLink.guideline]은 [sourceUrl](PubMed 등)을 인앱 웹뷰로 연다.
class MedicalSourcesLink extends StatelessWidget {
  const MedicalSourcesLink({
    super.key,
    this.message = _verdictMessage,
    this.actionLabel = _verdictAction,
    this.showLeadingIcon = true,
    this.sourceUrl,
    this.pageTitle,
    this.onOpen,
  });

  /// 온보딩 트리거 화면 — 아이콘·액션 라벨 없이 한 줄. 탭 시 [sourceUrl]로 이동.
  const MedicalSourcesLink.guideline({
    super.key,
    required this.sourceUrl,
    this.onOpen,
  })  : message = _guidelineMessage,
        actionLabel = null,
        showLeadingIcon = false,
        pageTitle = 'ACG 2022';

  static const routePath = '/mypage/medical-sources';

  static const _verdictMessage = '왜 이런 결과가 나왔나요?';
  static const _verdictAction = '근거 확인';
  static const _guidelineMessage = 'ACG 2022 가이드라인을 바탕으로 한 정보예요';

  final String message;
  final String? actionLabel;
  final bool showLeadingIcon;

  /// 지정되면 목록 화면 대신 이 URL을 연다.
  final String? sourceUrl;

  /// 웹뷰 앱바 제목. [sourceUrl]이 있을 때 사용한다.
  final String? pageTitle;

  /// 테스트 seam.
  final VoidCallback? onOpen;

  void _handleTap(BuildContext context) {
    if (onOpen != null) {
      onOpen!();
      return;
    }
    final url = sourceUrl;
    if (url != null) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          builder: (_) => TermsDetailScreen(
            title: pageTitle ?? 'ACG 2022',
            url: url,
          ),
        ),
      );
      return;
    }
    context.push(routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: actionLabel == null ? message : '의료 근거 확인',
      child: ExcludeSemantics(
        child: Material(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: InkWell(
            excludeFromSemantics: true,
            onTap: () => _handleTap(context),
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: 14,
              ),
              child: Row(
                children: [
                  if (showLeadingIcon) ...[
                    const AppIcon(
                      AppIcons.medicalSources,
                      size: AppIconSizes.s16,
                    ),
                    const SizedBox(width: AppSpacing.itemGap),
                  ],
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.link,
                      ),
                    ),
                  ),
                  if (actionLabel != null) ...[
                    Text(
                      actionLabel!,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  const AppIcon(
                    AppIcons.chevronRight,
                    size: AppIconSizes.s16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
