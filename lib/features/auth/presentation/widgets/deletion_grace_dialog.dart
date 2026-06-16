import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 삭제 유예 계정(02a) 로그인 시 복구 여부를 묻는 다이얼로그.
///
/// Figma node 365:1558 정합:
/// - 외부 dim: rgba(0,0,0,0.5) (Material 기본 barrierColor 와 유사)
/// - 모달카드: 343 wide, padding 24/24/16, gap 32, radius 16, bg white
/// - 텍스트 그룹 (gap 16):
///   - 제목 "탈퇴를 진행 중인 계정이에요" — Bold 18(우리 토큰 header2Bold 20 ≈ 가장 가까움), #1A1A1F, center
///   - 본문 "유예 기간 동안에는 언제든 복구할 수 있어요\n지금 복구하시겠어요?" — 14, #595966 ≈ textSecondary, center
/// - 버튼 그룹 (gap 8):
///   - 주 CTA "계정 복구하고 계속하기" — #00BF72, padding 16, radius 8, Bold 16 white center
///   - 부 CTA "취소" — transparent, padding 16 0, #737380, Regular 16 center
///
/// barrierDismissible: false — 외부 탭·뒤로가기로 닫히지 않으며 명시적 선택을 강제.
Future<void> showDeletionGraceDialog(
  BuildContext context,
  WidgetRef ref, {
  required AuthProvider provider,
  required String idToken,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) =>
        _DeletionGraceDialog(ref: ref, provider: provider, idToken: idToken),
  );
}

class _DeletionGraceDialog extends StatelessWidget {
  const _DeletionGraceDialog({
    required this.ref,
    required this.provider,
    required this.idToken,
  });

  final WidgetRef ref;
  final AuthProvider provider;
  final String idToken;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
      ),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Padding(
        // Figma: 24/24/16 (top/sides/bottom).
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sectionGap,
          AppSpacing.sectionGap,
          AppSpacing.sectionGap,
          AppSpacing.cardPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 텍스트 그룹 (gap 16).
            Text(
              '탈퇴를 진행 중인 계정이에요',
              textAlign: TextAlign.center,
              // Figma 02a: 18 Bold (디자인시스템 외 신규 토큰 header3Bold).
              style: AppTextStyles.header3Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            Text(
              '유예 기간 동안에는 언제든 복구할 수 있어요\n지금 복구하시겠어요?',
              textAlign: TextAlign.center,
              // Figma 02a: 14 Regular / 150% (body2Regular).
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            // 버튼 그룹 (gap 8).
            _PrimaryCta(onTap: () => _onRecover(context, provider)),
            const SizedBox(height: AppSpacing.itemGap),
            _SecondaryCta(onTap: () => _onCancel(context)),
          ],
        ),
      ),
    );
  }

  Future<void> _onRecover(BuildContext context, AuthProvider provider) async {
    try {
      await ref
          .read(authControllerProvider.notifier)
          .recoverAccount(provider, idToken: idToken);
      if (!context.mounted) return;
      // 복구 성공: gate 가 sessionStatus 전이를 감지해 자동 라우팅.
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      // 의료성 흐름 — 무증상 실패 금지. 사용자에게 명시적 오류를 표시한다.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('계정 복구에 실패했어요. 잠시 후 다시 시도해 주세요.'),
          backgroundColor: AppColors.verdictDanger,
        ),
      );
    }
  }

  Future<void> _onCancel(BuildContext context) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

/// "계정 복구하고 계속하기" — primary CTA.
class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Center(
            child: Text(
              '계정 복구하고 계속하기',
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "취소" — secondary CTA (전체 너비 탭, 텍스트 only).
class _SecondaryCta extends StatelessWidget {
  const _SecondaryCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardPadding),
        child: Center(
          child: Text(
            '취소',
            // Figma 02a: 16 Regular (body1Regular).
            style: AppTextStyles.body1Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
