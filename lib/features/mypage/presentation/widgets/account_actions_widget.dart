import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 마이페이지 계정 액션 섹션.
///
/// 로그아웃 버튼과 탈퇴 버튼을 표시한다.
/// 탈퇴는 F4-3에서 다이얼로그를 구현한다 — 현재는 [onWithdraw]를 null로 전달하면 비활성.
class AccountActionsWidget extends StatelessWidget {
  const AccountActionsWidget({
    super.key,
    required this.onLogout,
    this.onWithdraw, // F4-3에서 연결 — null이면 비활성
  });

  final VoidCallback onLogout;
  final VoidCallback? onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: AppColors.divider, height: 1),
        const SizedBox(height: AppSpacing.sectionGap),
        _ActionButton(
          label: '로그아웃',
          onTap: onLogout,
          textColor: AppColors.textPrimary,
        ),
        const SizedBox(height: AppSpacing.itemGap),
        _ActionButton(
          label: '탈퇴하기',
          onTap: onWithdraw, // TODO(F4-3): 탈퇴 다이얼로그 연결
          textColor: AppColors.danger,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.textColor,
  });

  final String label;
  final VoidCallback? onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14), // Figma 1316:4994
        child: Text(
          label,
          style: AppTextStyles.body1Medium.copyWith(
            color: onTap != null ? textColor : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
