import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 앱 공용 카드 컨테이너.
///
/// - [child]: 카드 내부 콘텐츠 (필수).
/// - [selected]: true이면 선택 상태 (배경 surfaceSelected, border primary).
///   false이면 기본 상태 (배경 surface, border border-색).
/// - [padding]: 내부 패딩. 기본값 [AppSpacing.cardPadding].
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.selected = false,
    this.padding = AppSpacing.cardPadding,
  });

  final Widget child;
  final bool selected;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceSelected : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
