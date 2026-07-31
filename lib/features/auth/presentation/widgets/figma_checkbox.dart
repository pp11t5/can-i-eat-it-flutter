import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';

/// Figma node 365:1557 의 커스텀 체크박스를 그대로 구현한 위젯.
///
/// 사용자 요청에 따라 모든 행이 동일한 시각 패턴을 사용한다:
/// - **OFF**: 20×20 흰 원 + 회색 테두리(#D0D0D0 ≈ checkboxBorder) — Figma 마케팅 행의 빈 동그라미
/// - **ON**: 20×20 초록 원(#00BF72) + 흰색 체크마크 — Figma 필수 행의 ON 상태
///
/// 선택 전환 애니메이션은 온보딩 [OptionCard]/[SelectableChip] 과 동일하게
/// **150ms** 암시적 애니메이션([AnimatedContainer] + [AnimatedOpacity])을 쓴다.
///
/// Material Checkbox 와 시각이 완전히 다르므로(원형 + 커스텀 체크) 직접 구현.
class FigmaCheckbox extends StatelessWidget {
  const FigmaCheckbox({super.key, required this.checked});

  /// 체크 여부.
  final bool checked;

  /// 온보딩 선택 위젯 공통 duration (OptionCard / SelectableChip 과 동일).
  static const Duration _animDuration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    // 정렬 안정성을 위해 모든 상태에서 동일 외곽 크기(24)를 차지.
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: AnimatedContainer(
          duration: _animDuration,
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: checked ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: checked ? AppColors.primary : AppColors.checkboxBorder,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: _animDuration,
            opacity: checked ? 1 : 0,
            child: const AppIcon(
              AppIcons.check,
              size: 10,
              color: AppColors.surface,
            ),
          ),
        ),
      ),
    );
  }
}
