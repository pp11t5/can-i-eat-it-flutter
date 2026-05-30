import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

/// Figma node 365:1557 의 커스텀 체크박스를 그대로 구현한 위젯.
///
/// - **ON 상태**: 24×24 초록 원(#00BF72) + 흰색 체크마크
/// - **OFF (24px)**: 24×24 흰 원 + 회색 테두리(#E9E9E9)  — 전체동의/필수 항목용
/// - **OFF (20px)**: 20×20 흰 원 + 회색 테두리(#D0D0D0) — [선택] 항목용
///
/// Material Checkbox 와 시각이 다르므로(원형 + 커스텀 체크) 직접 구현.
class FigmaCheckbox extends StatelessWidget {
  const FigmaCheckbox({
    super.key,
    required this.checked,
    this.size = 24,
  });

  /// 체크 여부.
  final bool checked;

  /// 크기 — 기본 24, [선택] 항목은 20.
  final double size;

  @override
  Widget build(BuildContext context) {
    if (checked) {
      // ON: 초록 원형 배경 + 흰 체크.
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.check_rounded,
          size: size * 0.625, // 24px 기준 ~15px 체크.
          color: AppColors.surface,
        ),
      );
    }
    // OFF: 흰 배경 + 회색 테두리 원형.
    // 24px(기본/필수)는 #E9E9E9, 20px(선택)는 #D0D0D0 — Figma 실측 반영.
    final borderColor =
        size < 24 ? AppColors.textTertiary : AppColors.border;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
    );
  }
}
