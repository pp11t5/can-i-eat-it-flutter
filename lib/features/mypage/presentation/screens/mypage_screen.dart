import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/account_actions_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/account_header_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/health_profile_summary_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/app_version_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/notification_toggle_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/profile_completeness_badge.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/withdraw_dialog.dart';

/// 마이페이지 화면.
///
/// ① 계정 헤더(아바타·닉네임·이메일)
/// ② 건강 프로필 요약(질환·트리거·복용약·알레르기)
/// ③ 계정 액션(로그아웃·탈퇴)
///
/// 편집·탈퇴 다이얼로그는 F4-3에서 구현한다.
class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authControllerProvider);
    final profileAsync = ref.watch(healthProfileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: sessionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              '세션 정보를 불러오지 못했어요.',
              style: AppTextStyles.body2Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          data: (session) {
            if (session == null) {
              return Center(
                child: Text(
                  '로그인 정보가 없어요.',
                  style: AppTextStyles.body2Regular
                      .copyWith(color: AppColors.textSecondary),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20, // Figma 1316:4994 — 마이페이지 좌우 패딩 20px
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── ① 계정 헤더 ──────────────────────────────────────
                  AccountHeaderWidget(session: session),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ② 건강 프로필 요약 ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '건강 프로필',
                        style: AppTextStyles.body1Bold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppButton.secondary(
                        label: '편집',
                        onPressed: () => context.push('/mypage/edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const ProfileCompletenessBadge(),
                  const SizedBox(height: AppSpacing.itemGap),
                  profileAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Text(
                      '프로필 정보를 불러오지 못했어요.',
                      style: AppTextStyles.body2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    data: (profile) =>
                        HealthProfileSummaryWidget(profile: profile),
                  ),

                  const SizedBox(height: AppSpacing.contentGap),

                  // ── ③ 알림 설정 ──────────────────────────────────────
                  const NotificationToggleWidget(),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ④ 즐겨찾기 ──────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.bookmark_border,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '즐겨찾기',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => context.push('/favorites'),
                  ),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ⑤ 판정 이력 ──────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.history,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '판정 이력',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => context.push('/history'),
                  ),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ④ 계정 액션 ──────────────────────────────────────
                  AccountActionsWidget(
                    onLogout: () =>
                        ref.read(authControllerProvider.notifier).logout(),
                    onWithdraw: () => showWithdrawDialog(context, ref),
                  ),

                  const SizedBox(height: AppSpacing.contentGap),

                  // ── ⑤ 앱 버전 ────────────────────────────────────────
                  const Center(child: AppVersionWidget()),
                  const SizedBox(height: AppSpacing.contentGap),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
