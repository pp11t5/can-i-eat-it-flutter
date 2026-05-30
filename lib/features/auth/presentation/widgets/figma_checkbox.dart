import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

/// Figma node 365:1557 의 커스텀 체크박스를 그대로 구현한 위젯.
///
/// 사용자 요청에 따라 모든 행이 동일한 시각 패턴을 사용한다:
/// - **OFF**: 20×20 흰 원 + 회색 테두리(#D0D0D0 ≈ checkboxBorder) — Figma 마케팅 행의 빈 동그라미
/// - **ON**: 24×24 초록 원(#00BF72) + 흰색 체크마크 — Figma 필수 행의 ON 상태
///
/// Material Checkbox 와 시각이 완전히 다르므로(원형 + 커스텀 체크) 직접 구현.
class FigmaCheckbox extends StatelessWidget {
  const FigmaCheckbox({super.key, required this.checked});

  /// 체크 여부.
  final bool checked;

  @override
  Widget build(BuildContext context) {
    // 정렬 안정성을 위해 모든 상태에서 동일 외곽 크기(24)를 차지.
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: checked
            ? Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  size: 15,
                  color: AppColors.surface,
                ),
              )
            : Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.checkboxBorder,
                    width: 1,
                  ),
                ),
              ),
      ),
    );
  }
}
