import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';

/// 온보딩 선택 리스트 + 하단 플로팅 CTA (1/4 · 2/4 공용).
///
/// 리스트는 화면 하단까지 이어지고 «다음» 버튼은 그 위에 떠 있다. 마지막 항목이
/// 버튼 아래에 갇히지 않도록 리스트 하단에 버튼 높이만큼 여백을 둔다.
class OnboardingListWithCta extends StatelessWidget {
  const OnboardingListWithCta({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onPressed,
    this.ctaLabel = '다음',
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// null 이면 CTA 비활성.
  final VoidCallback? onPressed;
  final String ctaLabel;

  static const double _ctaBottom = 32;

  /// AppButton 높이(패딩 16×2 + 텍스트) 여유 포함.
  static const double _ctaHeight = 56;
  static const double _ctaGap = 24;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            _ctaBottom + _ctaHeight + _ctaGap,
          ),
          itemCount: itemCount,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: itemBuilder,
        ),
        Positioned(
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          bottom: _ctaBottom,
          child: AppButton.primary(
            label: ctaLabel,
            onPressed: onPressed,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
