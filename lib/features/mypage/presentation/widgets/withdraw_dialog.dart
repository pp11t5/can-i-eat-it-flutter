import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 탈퇴 확인 다이얼로그를 표시한다.
///
/// 탈퇴 버튼 탭 → [AuthController.withdraw] 호출.
/// 성공 시 라우터 가드가 /login 으로 redirect — 다이얼로그는 별도 pop 불필요.
Future<void> showWithdrawDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _WithdrawDialog(ref: ref),
  );
}

class _WithdrawDialog extends StatefulWidget {
  const _WithdrawDialog({required this.ref});

  final WidgetRef ref;

  @override
  State<_WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<_WithdrawDialog> {
  bool _isWithdrawing = false;
  String? _selectedReason;

  static const _reasons = [
    '서비스가 불편해요',
    '개인정보 우려',
    '다른 앱으로 이동',
    '기타',
  ];

  Future<void> _onWithdraw() async {
    if (_isWithdrawing) return;
    setState(() => _isWithdrawing = true);
    try {
      await widget.ref
          .read(authControllerProvider.notifier)
          .withdraw();
      // 성공 시 라우터 가드가 /login redirect — 다이얼로그 자동 소멸.
      // mounted 확인 후 pop (redirect 전 여전히 mounted 인 경우 대비).
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _isWithdrawing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '정말 탈퇴하시겠어요?',
        style: AppTextStyles.header3Bold.copyWith(color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '탈퇴 후 30일 이내에 다시 로그인하면 계정을 복구할 수 있어요. '
            '30일이 지나면 모든 데이터가 삭제되며 복구가 불가능해요.',
            style: AppTextStyles.body2Regular
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ..._reasons.map(
            (reason) => InkWell(
              onTap: () => setState(() => _selectedReason = reason),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      _selectedReason == reason
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _selectedReason == reason
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reason,
                      style: AppTextStyles.body2Regular
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              _isWithdrawing ? null : () => Navigator.of(context).pop(),
          child: Text(
            '취소',
            style: AppTextStyles.body1Medium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _isWithdrawing ? null : _onWithdraw,
          child: Text(
            _isWithdrawing ? '처리 중...' : '탈퇴',
            style: AppTextStyles.body1Medium.copyWith(
              color: _isWithdrawing ? AppColors.textTertiary : AppColors.danger,
            ),
          ),
        ),
      ],
    );
  }
}
