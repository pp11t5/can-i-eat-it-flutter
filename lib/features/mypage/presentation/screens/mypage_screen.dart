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
import 'package:can_i_eat_it/core/config/terms_catalog.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_detail_screen.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/controllers/dictionary_list_controller.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 마이페이지 요약 화면 (Figma 1718-7884).
///
/// 상단→하단:
/// - 타이틀 "마이페이지"(중앙)
/// - 프로필 카드 → /mypage/profile push
/// - 내 음식 히스토리 카드 → /food-history push (dictionaryCountProvider 실카운트)
/// - 주간 기록 카드 (mySummaryProvider 실데이터, W7)
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
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        title: Text(
          '마이페이지',
          style: AppTextStyles.body1Medium.copyWith(
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
          const SizedBox(height: AppSpacing.sectionGap),

          // 내 음식 히스토리 카드
          const _FoodHistoryCard(),
          const SizedBox(height: AppSpacing.sectionGap),

          // 주간 기록 카드
          _WeeklyLogCard(
            onViewAll: () => context.push('/weekly-report'),
          ),
          const SizedBox(height: AppSpacing.sectionGap),

          // 설정 섹션
          const _SectionLabel(label: '설정'),
          const SizedBox(height: AppSpacing.cardPadding),
          _SettingsSection(),
          const SizedBox(height: AppSpacing.sectionGap),

          // 약관 섹션
          const _SectionLabel(label: '약관'),
          const SizedBox(height: AppSpacing.cardPadding),
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
    return Text(
      label,
      style: AppTextStyles.body2Bold.copyWith(
        color: AppColors.textSecondary,
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
        padding: const EdgeInsets.all(AppSpacing.sectionGap),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
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
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _conditionSubtext,
                    style: AppTextStyles.body2Medium.copyWith(
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
    return imageUrl != null
        ? CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.surfaceMuted,
            backgroundImage: NetworkImage(imageUrl!),
          )
        : const AppIcon(AppIcons.userAvatarPlaceholder, size: 40);
  }
}

// ---------------------------------------------------------------------------
// 내 음식 히스토리 카드
// ---------------------------------------------------------------------------

class _FoodHistoryCard extends ConsumerWidget {
  const _FoodHistoryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(dictionaryCountProvider);
    final safeCount = countAsync.valueOrNull?.safeCount;
    final cautionRiskCount = countAsync.valueOrNull?.cautionRiskCount;
    // loading/error 시 count '—' 폴백 (food_history_screen.dart valueOrNull 패턴과 동일).
    final subtitle =
        '안전 음식 ${safeCount ?? '—'}개, 주의 음식 ${cautionRiskCount ?? '—'}개';

    return GestureDetector(
      onTap: () => context.push('/food-history'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 음식 히스토리',
                    style: AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            // 좋음 무드 배지 (Figma 1718:7884 초록 스마일 — MoodFace 에셋 재사용)
            Image.asset(AppImages.moodComfortable, width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 주간 기록 카드 (Figma 1718:6134 — 헤더 밖 + 내부 회색 StatCard)
// ---------------------------------------------------------------------------

class _WeeklyLogCard extends ConsumerWidget {
  const _WeeklyLogCard({required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 날짜 기반 주 표시 (Figma "5월 둘째 주 기록" — 네이티브 서수).
    const ordinals = ['첫째', '둘째', '셋째', '넷째', '다섯째'];
    final now = DateTime.now();
    final weekOfMonth = ((now.day - 1) ~/ 7) + 1;
    final ordinal = ordinals[(weekOfMonth - 1).clamp(0, ordinals.length - 1)];
    final title = '${now.month}월 $ordinal 주 기록';

    // loading/error 시 각 수치 '—' 폴백 (_FoodHistoryCard valueOrNull 패턴과 동일).
    final weekly = ref.watch(mySummaryProvider).valueOrNull?.weeklySummary;
    final mealCount = weekly?.mealCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (카드 밖) — Figma 1718:6135
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.header2Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(
                    '전체 보기',
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textStrong,
                    ),
                  ),
                  SvgPicture.asset(
                    AppIcons.chevronRight,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textStrong,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardPadding),
        // 통계 내부 카드(StatCard) — Figma 1718:6140
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sectionGap),
          decoration: BoxDecoration(
            color: AppColors.surfaceInset,
            borderRadius: BorderRadius.circular(AppSpacing.radiusStatCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _WeeklyStatRow(
                label: '식사 기록',
                value: weekly?.mealRecordCount,
                unit: '회',
              ),
              const SizedBox(height: AppSpacing.cardPadding),
              _WeeklyStatRow(
                label: '최근 증상',
                value: weekly?.recentSymptomCount,
                unit: '회',
              ),
              const SizedBox(height: AppSpacing.cardPadding),
              _WeeklyStatRow(
                label: '연속 편안 일수',
                value: weekly?.streakCount,
                unit: '일',
              ),
              const SizedBox(height: AppSpacing.cardPadding),
              // 품질 행 — Figma 1718:6156 (✅⚠️❌ 아이콘 + "…음식 N끼")
              Wrap(
                spacing: AppSpacing.iconTextGap,
                runSpacing: AppSpacing.itemGap,
                children: [
                  _MealStatChip(
                    icon: AppIcons.verdictRecommend,
                    label: '권장음식',
                    value: mealCount?.recommendCount,
                  ),
                  _MealStatChip(
                    icon: AppIcons.verdictCaution,
                    label: '주의 음식',
                    value: mealCount?.cautionCount,
                  ),
                  _MealStatChip(
                    icon: AppIcons.verdictRisk,
                    label: '위험 음식',
                    value: mealCount?.riskCount,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 지표 1행 — 라벨(좌) / 큰 숫자+단위(우, baseline 정렬). Figma 1718:6141.
class _WeeklyStatRow extends StatelessWidget {
  const _WeeklyStatRow({
    required this.label,
    required this.value,
    required this.unit,
  });
  final String label;
  final int? value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value == null ? '—' : '$value',
              style: AppTextStyles.title2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Text(
              unit,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 품질 칩 — grade 아이콘 + "라벨 N끼". Figma 1718:6158/6161/6164.
class _MealStatChip extends StatelessWidget {
  const _MealStatChip({required this.icon, required this.label, this.value});
  final String icon;
  final String label;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 18, height: 18),
        const SizedBox(width: AppSpacing.iconTextGap),
        Text(
          '$label ${value ?? '—'}끼',
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ListTileRow(
            iconAsset: AppIcons.bell,
            label: '알림 설정',
            onTap: () => context.push('/mypage/notification-settings'),
          ),
        ],
      ),
    );
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ListTileRow(
            label: '개인정보 보호 약관',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TermsDetailScreen(
                  title: '개인정보 처리방침',
                  url: TermsCatalog.privacyUrl,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ListTileRow(
            label: '서비스 이용 약관',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TermsDetailScreen(
                  title: '서비스 이용약관',
                  url: TermsCatalog.tosUrl,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ListTileRow(
            label: '마케팅 정보 수신',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TermsDetailScreen(
                  title: '마케팅 정보 수신 동의',
                  url: TermsCatalog.marketingUrl,
                ),
              ),
            ),
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
    required this.label,
    required this.onTap,
    this.iconAsset,
  });

  final String? iconAsset;
  final String label;
  final VoidCallback onTap;

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
            if (iconAsset != null) ...[
              AppIcon(
                iconAsset!,
                size: AppIconSizes.s24,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.cardPadding),
            ],
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body1Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
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
