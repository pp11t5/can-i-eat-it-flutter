import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 마이페이지 요약 화면 (Figma 1718-7884).
///
/// 상단→하단:
/// - 타이틀 "마이페이지"(중앙)
/// - 프로필 카드 → /mypage/profile push
/// - 내 음식 히스토리 카드 (placeholder — 집계 EP 부재)
/// - 주간 기록 카드 (placeholder — 주간 집계·증상 EP 부재)
/// - 설정 섹션
/// - 약관 섹션
class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authControllerProvider);
    final profileAsync = ref.watch(healthProfileControllerProvider);

    final session = sessionAsync.valueOrNull;
    final profile = profileAsync.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          '마이페이지',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.cardPadding,
        ),
        children: [
          // 프로필 카드
          _ProfileCard(session: session, profile: profile),
          const SizedBox(height: AppSpacing.itemGap),

          // 내 음식 히스토리 카드
          _FoodHistoryCard(),
          const SizedBox(height: AppSpacing.itemGap),

          // 주간 기록 카드
          _WeeklyLogCard(
            onViewAll: () => context.push('/weekly-report'),
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // 설정 섹션
          const _SectionLabel(label: '설정'),
          const SizedBox(height: AppSpacing.itemGap),
          _SettingsSection(),
          const SizedBox(height: AppSpacing.sectionGap),

          // 약관 섹션
          const _SectionLabel(label: '약관'),
          const SizedBox(height: AppSpacing.itemGap),
          _TermsSection(),
          const SizedBox(height: AppSpacing.sectionGap),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 섹션 라벨
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: AppTextStyles.caption1Bold.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 프로필 카드
// ---------------------------------------------------------------------------

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.session, required this.profile});

  final AuthSession? session;
  final HealthProfile? profile;

  String get _conditionSubtext {
    final conditions = profile?.conditions ?? [];
    if (conditions.isEmpty) return '건강 정보 미설정';
    final label = labelForCode(
      conditionOptions.map((e) => (code: e.code, label: e.label)).toList(),
      conditions.first,
    );
    return '${label ?? conditions.first} 관리중';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = session?.displayName ?? '사용자';
    final imageUrl = session?.profileImageUrl;

    return GestureDetector(
      onTap: () => context.push('/mypage/profile'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Row(
          children: [
            // 아바타
            _Avatar(imageUrl: imageUrl),
            const SizedBox(width: AppSpacing.cardPadding),
            // 닉네임 + 서브텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _conditionSubtext,
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // chevron
            SvgPicture.asset(
              'assets/figma_extracted/chevron_right.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textTertiary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.surfaceMuted,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? const Icon(Icons.person, size: 28, color: AppColors.textTertiary)
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// 내 음식 히스토리 카드 (placeholder)
// ---------------------------------------------------------------------------

class _FoodHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO(backend): 음식 히스토리 집계 EP 부재 — 탭 no-op
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '내 음식 히스토리',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SvgPicture.asset(
                  'assets/figma_extracted/chevron_right.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textTertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.itemGap),
            // TODO(backend): 음식 히스토리 집계 EP 부재 — 수치 placeholder
            const Row(
              children: [
                _HistoryStatItem(label: '안전 음식', value: '—'),
                SizedBox(width: AppSpacing.sectionGap),
                _HistoryStatItem(label: '주의 음식', value: '—'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryStatItem extends StatelessWidget {
  const _HistoryStatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.header1Bold.copyWith(
            color: AppColors.textStrong,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 주간 기록 카드 (placeholder)
// ---------------------------------------------------------------------------

class _WeeklyLogCard extends StatelessWidget {
  const _WeeklyLogCard({required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    // 현재 날짜 기반 주 표시
    final now = DateTime.now();
    final weekOfMonth = ((now.day - 1) ~/ 7) + 1;
    final title = '${now.month}월 $weekOfMonth째 주 기록';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.body1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  '전체보기',
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          // TODO(backend): 주간 집계·증상 EP 부재 — 수치 placeholder
          const Row(
            children: [
              _WeeklyStatItem(label: '식사 기록', value: '—'),
              SizedBox(width: AppSpacing.cardPadding),
              _WeeklyStatItem(label: '최근 증상', value: '—'),
              SizedBox(width: AppSpacing.cardPadding),
              _WeeklyStatItem(label: '연속 편안', value: '—'),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          const Row(
            children: [
              _MealStatChip(
                label: '권장',
                color: AppColors.verdictRecommend,
              ),
              SizedBox(width: AppSpacing.itemGap),
              _MealStatChip(
                label: '주의',
                color: AppColors.verdictCaution,
              ),
              SizedBox(width: AppSpacing.itemGap),
              _MealStatChip(
                label: '위험',
                color: AppColors.verdictDanger,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyStatItem extends StatelessWidget {
  const _WeeklyStatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textStrong,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MealStatChip extends StatelessWidget {
  const _MealStatChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label —',
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 설정 섹션
// ---------------------------------------------------------------------------

class _SettingsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        children: [
          _ListTileRow(
            icon: Icons.notifications_outlined,
            label: '알림 설정',
            onTap: () => context.push('/mypage/notification-settings'),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ListTileRow(
            icon: Icons.logout,
            label: '로그아웃',
            onTap: () => _showLogoutDialog(context, ref),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ListTileRow(
            icon: Icons.person_remove_outlined,
            label: '탈퇴',
            onTap: () => context.push('/mypage/withdraw'),
            labelColor: AppColors.danger,
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final action = await showConfirmModal(
      context,
      title: '로그아웃 하시겠어요?',
      primaryLabel: '취소',
      primaryColor: AppColors.primary,
      secondaryLabel: '로그아웃하기',
    );

    // primary(취소) 또는 바깥 닫힘(null)이면 아무 것도 하지 않는다.
    if (action == ConfirmModalAction.secondary && context.mounted) {
      try {
        await ref.read(authControllerProvider.notifier).logout();
        // auth redirect 가드가 /login 으로 이동시킴 — 별도 navigation 불필요.
      } catch (_) {
        if (context.mounted) {
          await showAppToast(context, '로그아웃 중 오류가 발생했어요.');
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// 약관 섹션
// ---------------------------------------------------------------------------

class _TermsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        children: [
          _ListTileRow(
            icon: Icons.privacy_tip_outlined,
            label: '개인정보 보호 약관',
            onTap: () {
              // TODO(content): 약관 실URL 확정 필요 — 현재 준비중 토스트.
              // url_launcher 의존성 미추가(pubspec 변경 최소화).
              // 확정 후 url_launcher로 https://can-i-eat-it.com/terms/privacy 열기.
              showAppToast(context, '약관 페이지 준비 중이에요.');
            },
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ListTileRow(
            icon: Icons.description_outlined,
            label: '서비스 이용 약관',
            onTap: () {
              // TODO(content): 약관 실URL 확정 필요 — 현재 준비중 토스트.
              // 확정 후 url_launcher로 https://can-i-eat-it.com/terms/service 열기.
              showAppToast(context, '약관 페이지 준비 중이에요.');
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 공용 ListTile 행
// ---------------------------------------------------------------------------

class _ListTileRow extends StatelessWidget {
  const _ListTileRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.cardPadding,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: labelColor ?? AppColors.textSecondary),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body2Medium.copyWith(
                  color: labelColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/figma_extracted/chevron_right.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textTertiary,
                BlendMode.srcIn,
              ),
                ),
          ],
        ),
      ),
    );
  }
}
