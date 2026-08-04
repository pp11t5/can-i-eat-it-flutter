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
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/core/config/terms_catalog.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_detail_screen.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/controllers/dictionary_list_controller.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';
import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 마이페이지 요약 화면 (Figma 1718-7884).
///
/// 상단→하단:
/// - 타이틀 "마이페이지"(중앙)
/// - 프로필 카드 → /mypage/profile push
/// - 내 음식 히스토리 카드 → /food-history push (dictionaryCountProvider 실카운트)
/// - 주간 리포트 카드 (지난주 요약, 없으면 수집 중 빈 상태)
/// - 설정 섹션
/// - 약관 섹션
/// - 내 계정 섹션 (로그아웃 / 탈퇴하기)
class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authControllerProvider);
    final profileAsync = ref.watch(healthProfileControllerProvider);
    final summaryAsync = ref.watch(mySummaryProvider);
    final countAsync = ref.watch(dictionaryCountProvider);

    final session = sessionAsync.valueOrNull;
    final profile = profileAsync.valueOrNull;

    // 첫 진입(캐시 없음) 시 요약·히스토리·프로필 API 대기 중이면 로딩 표시.
    // hasValue면 재진입/리프레시이므로 기존 콘텐츠를 유지한다.
    final isInitialLoading =
        (profileAsync.isLoading && !profileAsync.hasValue) ||
        (summaryAsync.isLoading && !summaryAsync.hasValue) ||
        (countAsync.isLoading && !countAsync.hasValue);

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
      body: isInitialLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            )
          // 섹션 간 간격 24 (Figma 마이페이지 레이아웃).
          : ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding, // 16
                vertical: AppSpacing.sectionGap, // 24
              ),
              children: [
                // 프로필 카드
                _ProfileCard(session: session, profile: profile),
                const SizedBox(height: AppSpacing.sectionGap), // 24

                // 내 음식 히스토리 카드
                const _FoodHistoryCard(),
                const SizedBox(height: AppSpacing.sectionGap), // 24

                // 주간 리포트 카드 (지난주 요약 · 전체보기 → /weekly-report)
                _WeeklyLogCard(
                  onViewAll: () => context.push('/weekly-report'),
                ),
                const SizedBox(height: AppSpacing.sectionGap), // 24

                // 설정 섹션
                const _SectionLabel(label: '설정'),
                const SizedBox(height: AppSpacing.itemGap),
                _SettingsSection(),
                const SizedBox(height: AppSpacing.sectionGap), // 24

                // 약관 섹션
                const _SectionLabel(label: '약관'),
                const SizedBox(height: AppSpacing.itemGap),
                _TermsSection(),
                const SizedBox(height: AppSpacing.sectionGap), // 24

                // 내 계정 섹션
                const _SectionLabel(label: '내 계정'),
                const SizedBox(height: AppSpacing.itemGap),
                const _AccountSection(),
                const SizedBox(height: AppSpacing.sectionGap), // 24
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
// 프로필 카드 (Figma: padding 16 · gap 16 · radius 16 · border #EDEDF5)
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

    // 카드 전체 탭 아님 — "내 정보 수정"만 프로필 정보로 이동.
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding), // 16
      decoration: BoxDecoration(
        color: AppColors.surface, // #FFF
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal), // 16
        border: Border.all(color: AppColors.borderCard), // #EDEDF5
      ),
      child: Row(
        children: [
          _Avatar(imageUrl: imageUrl),
          const SizedBox(width: AppSpacing.cardPadding), // gap 16
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _conditionSubtext,
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.cardPadding), // gap 16
          // "내 정보 수정" 칩 — Figma: padding 4×12, radius 4, bg gray/30
          // 이 버튼만 탭 시 /mypage/profile
          Material(
            color: AppColors.surfaceMuted, // Foundation/gray/30
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () => context.push('/mypage/profile'),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  '내 정보 수정',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
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

// ---------------------------------------------------------------------------
// 주간 리포트 카드 (Figma — 헤더 "주간 리포트" + 지난주 요약 / 수집 중 빈 상태)
// ---------------------------------------------------------------------------

class _WeeklyLogCard extends ConsumerWidget {
  const _WeeklyLogCard({required this.onViewAll});
  final VoidCallback onViewAll;

  /// 지난주 리포트에 집계할 기록이 있는지.
  ///
  /// 서버는 지난주 [WeeklyReport] 행이 없으면 summary를 0으로 폴백한다.
  /// 가입 직후 첫 주(리포트 미발행)와 동일하게 빈 상태 UI로 처리한다.
  static bool _hasLastWeekData(WeeklySummary? weekly) {
    if (weekly == null) return false;
    final meals = weekly.mealCount;
    return weekly.mealRecordCount > 0 ||
        weekly.recentSymptomCount > 0 ||
        weekly.streakCount > 0 ||
        meals.recommendCount > 0 ||
        meals.cautionCount > 0 ||
        meals.riskCount > 0 ||
        meals.unknownCount > 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekly = ref.watch(mySummaryProvider).valueOrNull?.weeklySummary;
    final hasData = _hasLastWeekData(weekly);
    final mealCount = weekly?.mealCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (카드 밖) — 타이틀 고정 "주간 리포트". 데이터가 있을 때만 전체보기.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주간 리포트',
                    style: AppTextStyles.header2Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '월요일 아침 10시에 리포트를 발행해요.',
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (hasData)
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
        if (hasData)
          // 지난주 통계 카드 — Figma StatCard
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
          )
        else
          // 수집 중 빈 상태 — Figma: padding 16×24, radius 14, gray/30
          const _WeeklyReportCollectingCard(),
      ],
    );
  }
}

/// 지난주 리포트가 아직 없을 때(가입 후 첫 주 등) 표시하는 빈 상태 카드.
class _WeeklyReportCollectingCard extends StatelessWidget {
  const _WeeklyReportCollectingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionGap, // 24
        vertical: AppSpacing.cardPadding, // 16
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted, // foundation gray/30
        borderRadius: BorderRadius.circular(AppSpacing.radiusStatCard), // 14
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        '내 데이터를 모으고 있어요.',
        textAlign: TextAlign.center,
        style: AppTextStyles.body2Medium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
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
// 설정 섹션 (Figma: padding 24 · radius 16 · border gray · white)
// ---------------------------------------------------------------------------

class _SettingsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // Foundation white
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal), // 16
        border: Border.all(color: AppColors.border), // 1px gray
      ),
      child: InkWell(
        onTap: () => context.push('/mypage/notification-settings'),
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        // Figma: padding 24, space-between, align center
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sectionGap), // 24
          child: Row(
            children: [
              const AppIcon(
                AppIcons.bell,
                size: AppIconSizes.s24,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.cardPadding), // 아이콘-라벨
              Expanded(
                child: Text(
                  '알림 설정',
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 약관 섹션 (Figma: padding 24 · 행 사이 24+24=48 · radius 16)
// - 서비스 이용 약관 → 약관 상세
// - 개인정보 수집·이용 동의 → 라벨 탭 시 약관 상세 / Switch 는 동의 토글
// ---------------------------------------------------------------------------

class _TermsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 동의 토글 상태 — notification settings 의 marketing 필드를 재사용.
    // GET /notifications/settings 에 마케팅 필드가 없으면 기본 true.
    final consentOn = ref
            .watch(notificationSettingsControllerProvider)
            .valueOrNull
            ?.marketingPushEnabled ??
        true;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sectionGap), // 24
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 서비스 이용 약관 + chevron
          // rootNavigator: 바텀 탭 셸 위로 올려 탭바가 가리지 않게 한다.
          InkWell(
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => const TermsDetailScreen(
                  title: '서비스 이용약관',
                  url: TermsCatalog.tosUrl,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '서비스 이용 약관',
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
          // 행 사이 24 + 구분선 + 24 (= 48)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sectionGap),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
            ),
          ),
          // 개인정보 수집·이용 동의: 밑줄 라벨 → 약관 조회 / Switch → 동의 토글
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => const TermsDetailScreen(
                        title: '개인정보 보호 약관',
                        url: TermsCatalog.privacyUrl,
                      ),
                    ),
                  ),
                  child: Text(
                    '개인정보 수집·이용 동의',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              Switch.adaptive(
                value: consentOn,
                activeTrackColor: const Color(0xFF34C759),
                onChanged: (_) => _onConsentToggle(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onConsentToggle(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(notificationSettingsControllerProvider.notifier)
          .toggleMarketing();
    } catch (_) {
      if (context.mounted) {
        await showAppToast(context, '동의 설정 변경에 실패했어요.');
      }
    }
  }
}

// ---------------------------------------------------------------------------
// 내 계정 섹션 (로그아웃 / 탈퇴하기)
// Figma: 카드 padding 24 · 행 사이 24+24=48 · radius 16
// ---------------------------------------------------------------------------

class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sectionGap), // 24
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => _onLogout(context, ref),
            child: Text(
              '로그아웃',
              style: AppTextStyles.body1Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // 행 사이 24 + 구분선 + 24 (= 48)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sectionGap),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
            ),
          ),
          InkWell(
            onTap: () => context.push('/mypage/withdraw'),
            child: Text(
              '탈퇴하기',
              style: AppTextStyles.body1Regular.copyWith(
                color: AppColors.danger,
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

    if (action != ConfirmModalAction.secondary) return;
    await ref
        .read(globalLoadingControllerProvider.notifier)
        .run(() => ref.read(authControllerProvider.notifier).logout());
    if (!context.mounted) return;
    context.go('/login');
  }
}
