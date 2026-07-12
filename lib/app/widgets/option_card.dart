import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/figma_checkbox.dart';

/// 온보딩 전체 너비 선택 카드 (Figma 365:1555).
///
/// 체크 인디케이터가 왼쪽에, 라벨(+옵션 캡션)이 오른쪽에 배치된다.
///
/// [size]에 따라 두 가지 Figma 스펙을 따른다:
/// - [OptionCardSize.large] (1p 질환 선택): 라벨 16px(선택 시 Bold), 테두리 2px.
///   - SELECTED  : 배경 surfaceSelected(#F0FFF4), 테두리 primary 2px, 채워진 체크.
///   - UNSELECTED: 배경 #FEFEFE, 테두리 #EAEAEA 2px, 빈 체크.
///   - DISABLED  : 배경 surfaceMuted(#F5F5F5), 테두리 border(#EAEAEA) 1px, 체크 opacity 0.6, 라벨 disabledLabel(#D6D6D6), onTap 무시.
/// - [OptionCardSize.compact] (2p 증상 빈도): 라벨 14px Medium(선택 무관 고정), 테두리 1px.
///   - SELECTED  : 배경 surfaceSelected(#F0FFF4), 테두리 #B1EBD3(green80) 1px.
///   - UNSELECTED: 배경 #FCFCFC, 테두리 #EAEAEA 1px.
enum OptionCardSize { large, compact }

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.label,
    this.caption,
    required this.selected,
    this.enabled = true,
    required this.onTap,
    this.size = OptionCardSize.large,
  });

  final String label;
  final String? caption;
  final bool selected;
  final bool enabled;
  final OptionCardSize size;

  /// null 또는 enabled==false 시 탭 이벤트를 무시한다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final double borderWidth;
    final Color labelColor;

    final bool isCompact = size == OptionCardSize.compact;

    if (!enabled) {
      bgColor = AppColors.surfaceMuted;
      borderColor = AppColors.border;
      borderWidth = 1;
      labelColor = AppColors.disabledLabel;
    } else if (selected) {
      bgColor = AppColors.surfaceSelected;
      borderColor = isCompact ? const Color(0xFFB1EBD3) : AppColors.primary;
      borderWidth = isCompact ? 1 : 2;
      labelColor = isCompact ? AppColors.textStrong : AppColors.textPrimary;
    } else {
      bgColor = isCompact ? const Color(0xFFFCFCFC) : const Color(0xFFFEFEFE);
      borderColor = AppColors.border;
      borderWidth = isCompact ? 1 : 2;
      labelColor = isCompact ? AppColors.textStrong : AppColors.textPrimary;
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
                    style: (isCompact
                            ? AppTextStyles.body2Medium
                            : (selected && enabled
                                ? AppTextStyles.body1Bold
                                : AppTextStyles.body1Medium))
                        .copyWith(color: labelColor),
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      caption!,
                      style: AppTextStyles.body2Medium.copyWith(
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
