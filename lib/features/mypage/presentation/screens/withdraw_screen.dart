import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 계정 탈퇴 화면 (Figma 577-10287).
///
/// - 안내 문구 + 삭제 항목 카드.
/// - 하단 스티키 빨강 버튼 → [AuthController.withdraw] 호출.
/// - 성공 시 auth redirect 가드가 /login 으로 복귀 처리.
class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  bool _isLoading = false;

  Future<void> _handleWithdraw() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).withdraw();
      // 성공 시 auth redirect 가드가 /login 으로 이동시킴 — 별도 navigation 불필요.
    } catch (e) {
      if (mounted) {
        await showAppToast(context, '탈퇴 처리 중 오류가 발생했어요. 다시 시도해 주세요.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmAndWithdraw() async {
    final action = await showConfirmModal(
      context,
      title: '정말 탈퇴하시겠어요?',
      titleStyle: AppTextStyles.header2Bold,
      body: '탈퇴 후 2주 동안 로그인으로\n간편하게 복구할 수 있어요',
      primaryLabel: '탈퇴하기',
      primaryColor: AppColors.danger,
      secondaryLabel: '취소하기',
    );
    if (action != ConfirmModalAction.primary) return;
    if (!mounted) return;
    await _handleWithdraw();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          '탈퇴',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 표정 + 타이틀
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.moodUncomfortable,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '정말 계정을 삭제하시겠어요?',
                            style: AppTextStyles.header2Bold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 안내 문구 (평문)
                    Text(
                      '탈퇴하면 식사·증상 기록을 포함한 모든 데이터가 삭제돼요. '
                      '14일 안에 다시 로그인하면 복구할 수 있지만, 14일이 지나면 '
                      '모든 기록이 영구 삭제되어 되돌릴 수 없어요.',
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 32),
                    // 삭제 항목 카드
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusModal),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '- 식사기록\n- 증상기록\n- 건강 정보\n- 주간 리포트',
                        style: AppTextStyles.body1Medium.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 하단 스티키 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: FilledButton(
                onPressed: _isLoading ? null : _confirmAndWithdraw,
                style: FilledButton.styleFrom(
                  backgroundColor: _isLoading
                      ? AppColors.surfaceMuted
                      : AppColors.verdictDanger,
                  foregroundColor: AppColors.surface,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: AppTextStyles.body1Bold,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.surface,
                        ),
                      )
                    : const Text('데이터 영구 삭제'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
