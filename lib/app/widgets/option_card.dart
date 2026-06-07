import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/figma_checkbox.dart';

/// 온보딩 전체 너비 선택 카드 (Figma 365:1555).
///
/// 체크 인디케이터가 왼쪽에, 라벨(+옵션 캡션)이 오른쪽에 배치된다.
///
/// 상태:
/// - SELECTED : 배경 surfaceSelected(#F0FFF4), 테두리 primary 2px, 채워진 체크.
/// - UNSELECTED: 배경 cardUnselectedBg(#F7F7FA), 테두리 cardUnselectedBorder(#DBDBE5) 1px, 빈 체크.
/// - DISABLED  : 배경 surfaceMuted(#F5F5F5), 테두리 border(#EAEAEA) 1px, 체크 opacity 0.6, 라벨 disabledLabel(#D6D6D6), onTap 무시.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.label,
    this.caption,
    required this.selected,
    this.enabled = true,
    required this.onTap,
  });

  final String label;
  final String? caption;
  final bool selected;
  final bool enabled;

  /// null 또는 enabled==false 시 탭 이벤트를 무시한다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final double borderWidth;
    final Color labelColor;

    if (!enabled) {
      bgColor = AppColors.surfaceMuted;
      borderColor = AppColors.border;
      borderWidth = 1;
      labelColor = AppColors.disabledLabel;
    } else if (selected) {
      bgColor = AppColors.surfaceSelected;
      borderColor = AppColors.primary;
      borderWidth = 2;
      labelColor = AppColors.textPrimary;
    } else {
      bgColor = AppColors.cardUnselectedBg;
      borderColor = AppColors.cardUnselectedBorder;
      borderWidth = 1;
      labelColor = AppColors.textPrimary;
    }

    final checkWidget = Opacity(
      opacity: (!enabled) ? 0.6 : 1.0,
      child: FigmaCheckbox(checked: selected && enabled),
    );

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            checkWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: (selected && enabled
                            ? AppTextStyles.body1Bold
                            : AppTextStyles.body1Medium)
                        .copyWith(color: labelColor),
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      caption!,
                      style: AppTextStyles.body2Regular.copyWith(
                        color: enabled
                            ? AppColors.textSecondary
                            : AppColors.disabledLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
