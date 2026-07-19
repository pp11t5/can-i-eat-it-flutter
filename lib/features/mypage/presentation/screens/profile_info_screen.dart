import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 프로필 정보 화면 (Figma node 2760-24140).
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
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
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
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.surfaceMuted, width: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.itemGap,
          AppSpacing.screenPadding,
          AppSpacing.cardPadding,
        ),
        children: [
          // 헤더: 아바타 + 닉네임(표시 전용, 탭 불가)
          _ProfileHeader(session: session),
          const SizedBox(height: AppSpacing.contentGap),

          // 내 정보 섹션 (닉네임/건강 고민/알레르기·복용약)
          const _SectionLabel(label: '내 정보'),
          const SizedBox(height: AppSpacing.itemGap),
          _MyInfoCard(session: session, profile: profile),
          const SizedBox(height: AppSpacing.contentGap),

          // 내 계정 섹션
          const _SectionLabel(label: '내 계정'),
          const SizedBox(height: AppSpacing.itemGap),
          _AccountCard(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 섹션 라벨 (카드 밖, mypage_screen.dart _SectionLabel과 동일 패턴)
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.body2Bold.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 프로필 헤더 — 아바타 + 닉네임만(이메일·연동 서브텍스트 제거, D1)
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.session});

  final AuthSession? session;

  @override
  Widget build(BuildContext context) {
    final displayName = session?.displayName ?? '사용자';
    final imageUrl = session?.profileImageUrl;

    return Column(
      children: [
        imageUrl != null
            ? CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.surfaceMuted,
                backgroundImage: NetworkImage(imageUrl),
              )
            : const AppIcon(AppIcons.userAvatarPlaceholder, size: 80),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          displayName,
          style: AppTextStyles.header2Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 내 정보 카드 (D1: 닉네임 · 건강 고민 · 알레르기/복용약, 기존 _HealthInfoCard 확장)
// ---------------------------------------------------------------------------

class _MyInfoCard extends StatelessWidget {
  const _MyInfoCard({required this.session, required this.profile});

  final AuthSession? session;
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
      padding: const EdgeInsets.all(AppSpacing.sectionGap), // 24
      decoration: BoxDecoration(
        // Figma 실측 fill #FEFEFE(카드 전용값, scaffoldBackground와 우연히 동일 hex).
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal), // 16
        border: Border.all(color: AppColors.border), // #EAEAEA
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 닉네임 행 — 값 + "수정하기" → name-edit 이동 (D1 신규)
          InkWell(
            onTap: () => context.push('/mypage/profile/name-edit'),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    session?.displayName ?? '사용자',
                    style: AppTextStyles.body1Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '수정하기',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
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
          const Divider(height: 24, thickness: 1, color: AppColors.border),

          // 건강 고민 행 — 읽기전용(자물쇠), 탭 불가. 선행 아이콘 제거(D1).
          Row(
            children: [
              Text(
                '건강 고민',
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                _conditionLabel,
                style: AppTextStyles.body2Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              const AppIcon(
                AppIcons.lock,
                size: AppIconSizes.s24,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: AppColors.border),

          // 알레르기·복용약 행 — 선행 아이콘 제거(D1).
          InkWell(
            onTap: () => context.push('/mypage/profile/allergy-med'),
            child: Row(
              children: [
                Text(
                  '알레르기・복용약',
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  _allergyMedLabel,
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
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
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 내 계정 카드 (D1: padding 24로 통일)
// ---------------------------------------------------------------------------

class _AccountCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 로그아웃
          InkWell(
            onTap: () => _onLogout(context, ref),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sectionGap),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '로그아웃',
                      style: AppTextStyles.body1Regular.copyWith(
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
            onTap: () => context.push('/mypage/withdraw'),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSpacing.radiusModal),
              bottomRight: Radius.circular(AppSpacing.radiusModal),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sectionGap),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '탈퇴하기',
                      style: AppTextStyles.body1Regular.copyWith(
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
    final action = await showConfirmModal(
      context,
      title: '로그아웃 하시겠어요?',
      // Figma 577:10285: Primary(green)=취소하기(안전), Secondary=로그아웃하기.
      primaryLabel: '취소하기',
      primaryColor: AppColors.primary,
      secondaryLabel: '로그아웃하기',
    );

    // primary(취소) 또는 바깥 닫힘(null)이면 아무 것도 하지 않는다.
    if (action != ConfirmModalAction.secondary) return;
    await ref
        .read(globalLoadingControllerProvider.notifier)
        .run(() => ref.read(authControllerProvider.notifier).logout());
    if (!context.mounted) return;
    context.go('/login');
  }
}
