import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 프로필 정보 화면 (Figma 프로필 정보 / 내 정보 카드).
///
/// 진입 시 AuthController.getMe() 1회 호출 → 식별정보 갱신.
/// 실패 시 기존 세션값/빈 표시 (크래시 금지).
///
/// 내 정보 카드:
/// - 닉네임 / 건강 고민 / 알레르기·복용약 — 우측 "수정" (chevron·자물쇠 없음)
/// - 건강 고민·알레르기: 라벨 위 + 값 아래 스택
/// - 알레르기·복용약 2개 이상: "{첫 항목} 외 N개"
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
// 프로필 헤더 — 아바타 + 닉네임만
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
// 내 정보 카드
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

  /// 알레르기(라벨) + 복용약(원문) 목록.
  /// 0개 → "없음", 1개 → 해당 이름, 2개 이상 → "{첫 항목} 외 N개".
  String get _allergyMedLabel {
    final items = <String>[
      for (final code in profile?.allergies ?? const <String>[])
        labelForCode(allergyOptions, code) ?? code,
      ...?profile?.medications,
    ];
    if (items.isEmpty) return '없음';
    if (items.length == 1) return items.first;
    return '${items.first} 외 ${items.length - 1}개';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Figma: 카드 내부 패딩 24
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 닉네임 — 값 + "수정" → name-edit
          _EditRow(
            onTap: () => context.push('/mypage/profile/name-edit'),
            child: Text(
              session?.displayName ?? '사용자',
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 행 구분선 — 상·하 24, stroke 1 (Foundation/gray/40)
          const _RowDivider(),
          // 건강 고민 — 라벨/값 스택 + "수정"
          // 질환 편집 화면 미구현: 탭 동작 없음(표시만 Figma 정합).
          _EditRow(
            onTap: null,
            child: _LabeledValue(
              label: '건강 고민',
              value: _conditionLabel,
            ),
          ),
          const _RowDivider(),
          // 알레르기 · 복용약 — 라벨/값 스택 + "수정" → allergy-med
          _EditRow(
            onTap: () => context.push('/mypage/profile/allergy-med'),
            child: _LabeledValue(
              label: '알레르기 · 복용약',
              value: _allergyMedLabel,
            ),
          ),
        ],
      ),
    );
  }
}

/// 내 정보 카드 행 사이 구분선 — 상·하 여백 24 + 1px stroke.
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sectionGap), // 24
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.border, // Foundation/gray/40
      ),
    );
  }
}

/// 좌측 [child] + 우측 "수정" 칩 버튼.
///
/// Figma: padding 4×12, radius 4, bg Foundation/gray/30.
/// 화면 이동은 행 전체가 아니라 [onTap]이 있는 **버튼만** 탭할 때 발생한다.
class _EditRow extends StatelessWidget {
  const _EditRow({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
        const SizedBox(width: AppSpacing.cardPadding),
        _EditButton(onTap: onTap),
      ],
    );
  }
}

/// "수정" 칩 버튼 — gray30 배경, 4×12 패딩, radius 4.
class _EditButton extends StatelessWidget {
  const _EditButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      '수정',
      style: AppTextStyles.body2Medium.copyWith(
        color: AppColors.textSecondary,
      ),
    );

    return Material(
      color: AppColors.surfaceMuted, // Foundation/gray/30
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          // Figma: padding 4px 12px
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: label,
        ),
      ),
    );
  }
}

/// 라벨(위) + 값(아래) 스택 — 건강 고민 / 알레르기·복용약.
class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body2Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

