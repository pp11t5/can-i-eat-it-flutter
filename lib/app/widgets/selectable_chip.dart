import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 온보딩 선택 칩 — 체크 없는 pill 형태 (Figma 365:1553 / 1064:12268).
///
/// - SELECTED  : 배경 surfaceSelected(#F0FFF4), 테두리 primary 1px, 텍스트 primary(#00BF72).
/// - UNSELECTED: 배경 white, 테두리 border(#EAEAEA) 1px, 텍스트 textPrimary(#1A1A1F).
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 칩 탭은 자식 GestureDetector가 제스처를 가져가 부모 unfocus 래퍼가
        // 동작하지 않으므로, 여기서 입력란/키보드를 직접 해제한다.
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: AppSpacing.chipPaddingV,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceSelected : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(
            color: selected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
