import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
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
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 이모지 + 타이틀
                    const Center(
                      child: Text(
                        '😣',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.cardPadding),
                    Center(
                      child: Text(
                        '정말 계정을 삭제하시겠어요?',
                        style: AppTextStyles.header1Bold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.cardPadding),
                    // 안내 문구
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.cardPadding),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Text(
                        '탈퇴하면 식사·증상 기록 포함 모든 데이터가 삭제돼요.\n\n'
                        '14일 안에 다시 로그인하면 복구할 수 있지만, 14일이 지나면 '
                        '모든 기록이 영구 삭제되어 되돌릴 수 없어요.',
                        style: AppTextStyles.body2Regular.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    // 삭제 항목 카드
                    Text(
                      '삭제되는 항목',
                      style: AppTextStyles.caption1Bold.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: const Column(
                        children: [
                          _DeleteItemRow(label: '식사 기록'),
                          Divider(height: 1, color: AppColors.divider),
                          _DeleteItemRow(label: '증상 기록'),
                          Divider(height: 1, color: AppColors.divider),
                          _DeleteItemRow(label: '건강 정보'),
                          Divider(height: 1, color: AppColors.divider),
                          _DeleteItemRow(label: '주간 리포트'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 하단 스티키 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.itemGap,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
              ),
              child: FilledButton(
                onPressed: _isLoading ? null : _handleWithdraw,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      _isLoading ? AppColors.surfaceMuted : AppColors.danger,
                  foregroundColor: AppColors.surface,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
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

// ---------------------------------------------------------------------------
// 삭제 항목 행
// ---------------------------------------------------------------------------

class _DeleteItemRow extends StatelessWidget {
  const _DeleteItemRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.cardPadding,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.delete_outline,
            size: 18,
            color: AppColors.danger,
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Text(
            label,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
