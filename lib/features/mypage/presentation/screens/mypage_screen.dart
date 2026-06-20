import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/account_actions_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/account_header_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/health_profile_summary_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/meal_notification_settings_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/notification_toggle_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/profile_completeness_badge.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/app_version_widget.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/withdraw_dialog.dart';

/// 마이페이지 화면.
///
/// ① 계정 헤더(아바타·닉네임·이메일)
/// ② 건강 프로필 요약(질환·트리거·복용약·알레르기)
/// ③ 계정 액션(로그아웃·탈퇴)
///
/// 편집·탈퇴 다이얼로그는 F4-3에서 구현한다.
class MypageScreen extends ConsumerStatefulWidget {
  const MypageScreen({super.key});

  @override
  ConsumerState<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends ConsumerState<MypageScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                    onTap: () => context.push('/mypage/profile-edit'),
                    child: AccountHeaderWidget(session: session),
                  ),

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
                      OutlinedButton.icon(
                        onPressed: () => context.push('/mypage/edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          textStyle: AppTextStyles.body2Regular,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusCard,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text('편집'),
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

                  const SizedBox(height: 12),
                  Text(
                    '건강 목표',
                    style: AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '역류성 식도염 증상 완화',
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),

                  // ── ③ 알림 설정 ──────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '알림 설정',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => context.push('/mypage/notifications'),
                  ),
                  const NotificationToggleWidget(),
                  const MealNotificationSettingsWidget(),

                  // ── ③-1. 다크 모드 토글 ──────────────────────────────
                  ListTile(
                    key: const Key('darkModeTile'),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.dark_mode_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '다크 모드',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) =>
                          setState(() => _isDarkMode = value),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),

                  // ── ③-1-1. 알림 설정 토글 ──────────────────────────────
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '알림',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    subtitle: Text(
                      '판정 결과 알림을 받습니다.',
                      style: AppTextStyles.body2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    value: _notificationsEnabled,
                    onChanged: (v) =>
                        setState(() => _notificationsEnabled = v),
                    activeThumbColor: AppColors.primary,
                  ),

                  // ── ③-2. 테마 색상 선택 ──────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '테마 색상',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showThemeColorDialog(context),
                  ),

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

                  // ── ⑤ 공지사항 ──────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.campaign_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '공지사항',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () {},
                  ),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ⑤-1. 언어 설정 ──────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.language_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '언어 설정',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '한국어',
                          style: AppTextStyles.body2Regular
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ⑤-2. 업데이트 확인 ──────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.system_update_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '업데이트 확인',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showUpdateCheckDialog(context),
                  ),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ⑥ 판정 이력 ──────────────────────────────────────
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

                  // ── ⑦ 개인정보 처리방침 ──────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '개인정보 처리방침',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showPrivacyDialog(context),
                  ),

                  // ── ⑧ 문의하기 ──────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.textPrimary,
                    ),
                    title: Text(
                      '문의하기',
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showInquiryDialog(context),
                  ),

                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.link),
                    title: const Text('계정 연동'),
                    subtitle: const Text('Google · Apple'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAccountLinkDialog(context),
                  ),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── ④ 계정 액션 ──────────────────────────────────────
                  AccountActionsWidget(
                    onLogout: () => _showLogoutDialog(context, ref),
                    onWithdraw: () => showWithdrawDialog(context, ref),
                  ),

                  const SizedBox(height: 24),

                  // ── ⑤ 앱 버전 ────────────────────────────────────────
                  const Center(child: AppVersionWidget()),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 업데이트 확인 다이얼로그를 표시한다.
Future<void> _showUpdateCheckDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('업데이트 확인'),
      content: const Text('최신 버전을 사용 중입니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}

/// 로그아웃 확인 다이얼로그를 표시한다.
///
/// "로그아웃" 버튼 탭 시 [authControllerProvider]의 logout()을 호출한다.
Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('정말 로그아웃 하시겠어요?\n로그인 정보가 초기화됩니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
          ),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            ref.read(authControllerProvider.notifier).logout();
            context.go('/login');
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.danger,
          ),
          child: const Text('로그아웃'),
        ),
      ],
    ),
  );
}

void _showPrivacyDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('개인정보 처리방침'),
      content: const Text('개인정보는 서비스 제공 목적으로만 사용됩니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}

void _showThemeColorDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('테마 색상 선택'),
      content: Wrap(
        spacing: 8,
        children: [
          AppColors.primary,
          Colors.green,
          Colors.orange,
        ]
            .map(
              (color) => GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

void _showInquiryDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('문의하기'),
      content: const Text('support@canieatiit.com으로 문의해주세요.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}

void _showAccountLinkDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('계정 연동'),
      content: const Text('연동할 계정을 선택하세요.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}
