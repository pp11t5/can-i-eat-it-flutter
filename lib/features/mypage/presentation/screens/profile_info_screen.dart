import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 프로필 정보 화면 (Figma 577-10289).
///
/// 진입 시 AuthController.getMe() 1회 호출 → 식별정보 갱신.
/// 실패 시 기존 세션값/빈 표시 (크래시 금지).
class ProfileInfoScreen extends ConsumerStatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  ConsumerState<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends ConsumerState<ProfileInfoScreen> {
  @override
  void initState() {
    super.initState();
    // 진입 시 getMe 1회 호출 — 실패해도 크래시 없음
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(authControllerProvider.notifier).getMe();
      } catch (_) {
        // 실패 시 기존 세션값 유지, 크래시 금지
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          iconSize: 32,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            'assets/figma_extracted/chevron_left.svg',
            width: 32,
            height: 32,
          ),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          '프로필 정보',
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
          // 헤더: 아바타 + 닉네임 + 이메일·연동
          _ProfileHeader(session: session),
          const SizedBox(height: AppSpacing.sectionGap),

          // 내 건강 정보 카드
          _HealthInfoCard(profile: profile),
          const SizedBox(height: AppSpacing.itemGap),

          // 내 계정 카드
          _AccountCard(),
          const SizedBox(height: AppSpacing.sectionGap),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 프로필 헤더
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.session});

  final AuthSession? session;

  String get _providerLabel {
    switch (session?.provider) {
      case AuthProvider.kakao:
        return '카카오 연동';
      case AuthProvider.apple:
        return '애플 연동';
      case null:
        return '';
    }
  }

  String get _subtext {
    final email = session?.email ?? '';
    final provider = _providerLabel;
    if (email.isEmpty && provider.isEmpty) return '';
    if (email.isEmpty) return provider;
    if (provider.isEmpty) return email;
    return '$email · $provider';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = session?.displayName ?? '사용자';
    final imageUrl = session?.profileImageUrl;

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surfaceMuted,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null
              ? const Icon(Icons.person, size: 36, color: AppColors.textTertiary)
              : null,
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          displayName,
          style: AppTextStyles.header1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (_subtext.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            _subtext,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 내 건강 정보 카드
// ---------------------------------------------------------------------------

class _HealthInfoCard extends StatelessWidget {
  const _HealthInfoCard({required this.profile});

  final HealthProfile? profile;

  String get _conditionLabel {
    final conditions = profile?.conditions ?? [];
    if (conditions.isEmpty) return '미설정';
    return conditions
        .map(
          (code) =>
              labelForCode(
                conditionOptions
                    .map((e) => (code: e.code, label: e.label))
                    .toList(),
                code,
              ) ??
              code,
        )
        .join(', ');
  }

  String get _allergyMedLabel {
    final allergies = profile?.allergies ?? [];
    final medications = profile?.medications ?? [];
    final total = allergies.length + medications.length;
    if (total == 0) return '없음';
    return '$total개';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
              AppSpacing.itemGap,
            ),
            child: Text(
              '내 건강 정보',
              style: AppTextStyles.body2Bold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // 건강 고민 행 — 가로 ListTile: [선행아이콘] [라벨] …Spacer… [값] [자물쇠] (읽기전용, 탭 불가)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: AppSpacing.cardPadding,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Text(
                  '건강 고민',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  _conditionLabel,
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                const Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // 알레르기·복용약 행 — 가로 ListTile: [선행아이콘] [라벨] …Spacer… [값] [chevron]
          InkWell(
            onTap: () => context.push('/mypage/profile/allergy-med'),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSpacing.radiusCard),
              bottomRight: Radius.circular(AppSpacing.radiusCard),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: AppSpacing.cardPadding,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.medication_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Text(
                    '알레르기 · 복용약',
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _allergyMedLabel,
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
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
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 내 계정 카드
// ---------------------------------------------------------------------------

class _AccountCard extends ConsumerWidget {
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
          // 로그아웃
          InkWell(
            onTap: () => _onLogout(context, ref),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusCard),
              topRight: Radius.circular(AppSpacing.radiusCard),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      '로그아웃',
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // 탈퇴하기
          InkWell(
            onTap: () => _onWithdraw(context, ref),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSpacing.radiusCard),
              bottomRight: Radius.circular(AppSpacing.radiusCard),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      '탈퇴하기',
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        ),
        title: Text(
          '로그아웃',
          style: AppTextStyles.header3Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '로그아웃 하시겠어요?',
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              '취소',
              style: AppTextStyles.body1Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              '로그아웃',
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(authControllerProvider.notifier).logout();
    if (!context.mounted) return;
    context.go('/login');
  }

  Future<void> _onWithdraw(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _WithdrawDialog(),
    );

    if (confirmed != true) return;
    await ref.read(authControllerProvider.notifier).withdraw();
    if (!context.mounted) return;
    context.go('/login');
  }
}

// ---------------------------------------------------------------------------
// 탈퇴 Danger 다이얼로그 (deletion_grace_dialog 스타일 참조)
// ---------------------------------------------------------------------------

class _WithdrawDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Padding(
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
            Text(
              '정말 탈퇴하시겠어요?',
              textAlign: TextAlign.center,
              style: AppTextStyles.header3Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            Text(
              '탈퇴하면 모든 데이터가 영구 삭제되며\n복구할 수 없어요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.contentGap),
            // 탈퇴 확인 버튼 (danger)
            Material(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(true),
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Center(
                    child: Text(
                      '탈퇴하기',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            // 취소
            InkWell(
              onTap: () => Navigator.of(context).pop(false),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
                child: Center(
                  child: Text(
                    '취소',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
