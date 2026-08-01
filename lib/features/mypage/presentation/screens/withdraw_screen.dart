import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 계정 탈퇴 화면 (Figma 32_계정삭제확인 / 577-10287).
///
/// 세로 레이아웃 (Figma 주석):
/// - 앱바 아래 ↔ 본문 / 본문 ↔ 하단 버튼: 상·하 여백 각 242 (남는 높이를 균등 배분)
/// - 좌우 패딩 24, 안내↔삭제 카드 간격 32
/// - 하단 버튼은 화면 하단에 고정
///
/// - 하단 빨강 버튼 → [AuthController.withdraw] 호출.
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
      await ref
          .read(globalLoadingControllerProvider.notifier)
          .run(() => ref.read(authControllerProvider.notifier).withdraw());
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
      // Figma 32_계정삭제확인:
      // [상단 ~242] → [본문 좌우 24 · 안내↔카드 32] → [하단 ~242] → [버튼 하단 고정]
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      // 본문을 세로 중앙 — 상·하 여백이 Figma 242/242처럼 대칭.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          // 안내 ↔ 삭제 카드 (Figma 32)
                          const SizedBox(height: 32),
                          // 삭제 항목 카드 — 가로 최대
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusModal,
                              ),
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
                  );
                },
              ),
            ),
            // 하단 버튼 — 가로 최대
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
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
                  // 진행 중 스피너는 전역 로딩 오버레이가 담당(이중 표시 방지) —
                  // 이 버튼은 비활성 색상으로만 진행 중임을 표시한다.
                  child: const Text('데이터 영구 삭제'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
