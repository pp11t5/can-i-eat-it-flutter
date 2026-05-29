import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 삭제 유예 계정(02a) 로그인 시 복구 여부를 묻는 다이얼로그.
///
/// barrierDismissible: false — 외부 탭·뒤로가기로 닫히지 않으며 명시적 선택을 강제한다.
/// - [계정 복구하고 계속하기]: recoverAccount() 호출 후 닫기 (가드가 redirect).
/// - [취소]: signOut() 호출 후 닫기 (미인증 → 로그인 화면 유지).
Future<void> showDeletionGraceDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => _DeletionGraceDialog(ref: ref),
  );
}

class _DeletionGraceDialog extends StatelessWidget {
  const _DeletionGraceDialog({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.sectionGap),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '탈퇴를 진행 중인 계정이에요',
            style: AppTextStyles.header1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            '유예 기간 동안에는 언제든 복구할 수 있어요\n지금 복구하시겠어요?',
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppButton.primary(
            label: '계정 복구하고 계속하기',
            isExpanded: true,
            onPressed: () => _onRecover(context),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          AppButton.secondary(
            label: '취소',
            isExpanded: true,
            onPressed: () => _onCancel(context),
          ),
        ],
      ),
    );
  }

  Future<void> _onRecover(BuildContext context) async {
    await ref.read(authControllerProvider.notifier).recoverAccount();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _onCancel(BuildContext context) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
