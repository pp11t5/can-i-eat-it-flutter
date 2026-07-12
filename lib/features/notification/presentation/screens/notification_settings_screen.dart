import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';

/// 1st-party 플랫폼 채널 — 취약한 app_settings 패키지(Swift 6 SPM 매니페스트로
/// `flutter build ios`가 깨짐) 대체용. iOS: [AppDelegate], Android: [MainActivity]에서 구현.
const _appSettingsChannel = MethodChannel('canieatit/app_settings');

/// 기기 OS 알림 설정 화면을 연다. 채널 미구현/실패 시 best-effort로 무시한다.
Future<void> _openOsNotificationSettings() async {
  try {
    await _appSettingsChannel.invokeMethod<void>('openNotificationSettings');
  } catch (_) {
    // best-effort — 채널 미구현/실패 시 무시
  }
}

/// 기기 OS 설정 앱을 여는 콜백 provider — 테스트에서 override 가능한 seam.
///
/// 기본값: [_openOsNotificationSettings] (설정 > 앱 > 알림 화면으로 이동).
final openAppSettingsProvider = Provider<Future<void> Function()>(
  (ref) => _openOsNotificationSettings,
);

/// 알림 설정 화면 (Figma 577-10290, 577-10286).
///
/// - 토글 3개: 식후 2시간 알림(postMeal), 식단 기록 알림(dailyRecord), 주간 리포트(weeklyReport).
/// - 알림 수신 시간 라디오 4개(morning8/evening8/night9/night10).
/// - 토글·라디오 변경 시 낙관적 갱신 + PATCH 호출.
/// - 기기 OS 알림 권한이 차단(denied)돼 있으면 상단 안내 배너를 띄우고 나머지 설정을 비활성화한다.
///   포그라운드 복귀 시 권한 상태를 재조회해 배너 표시를 갱신한다.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 설정 앱에서 알림을 켜고 돌아오면(resumed) 배너 표시를 갱신한다.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(osNotificationBlockedProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(notificationSettingsControllerProvider);
    final osBlocked =
        ref.watch(osNotificationBlockedProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          '알림 설정',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          onRetry: () => ref.invalidate(notificationSettingsControllerProvider),
        ),
        data: (settings) => _SettingsBody(
          settings: settings,
          osBlocked: osBlocked,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 에러 바디
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '알림 설정을 불러올 수 없어요.',
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          TextButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 설정 바디
// ---------------------------------------------------------------------------

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.settings, required this.osBlocked});
  final NotificationSettings settings;

  /// 기기 OS 알림 권한이 denied(차단)됐는지 여부.
  final bool osBlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = Column(
      children: [
        // 알림 토글 카드
        _SectionCard(
          children: [
            _ToggleRow(
              title: '식후 2시간 알림',
              subtitle: '증상 기록을 위해 보내요',
              value: settings.postMealEnabled,
              onChanged: (v) => _handleToggle(
                context,
                ref,
                NotificationToggleType.postMeal,
              ),
            ),
            const Divider(
              height: 1,
              indent: AppSpacing.cardPadding,
              endIndent: AppSpacing.cardPadding,
              color: AppColors.divider,
            ),
            _ToggleRow(
              title: '식단 기록 알림',
              subtitle: '식사, 증상 기록을 위해 보내요',
              value: settings.dailyRecordEnabled,
              onChanged: (v) => _handleToggle(
                context,
                ref,
                NotificationToggleType.dailyRecord,
              ),
            ),
            const Divider(
              height: 1,
              indent: AppSpacing.cardPadding,
              endIndent: AppSpacing.cardPadding,
              color: AppColors.divider,
            ),
            _ToggleRow(
              title: '주간 리포트',
              subtitle: '매주 일요일 19:00에 알림이 가요',
              value: settings.weeklyReportEnabled,
              onChanged: (v) => _handleToggle(
                context,
                ref,
                NotificationToggleType.weeklyReport,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),

        // 알림 수신 시간 카드
        const _SectionLabel(label: '알림 받을 시간'),
        const SizedBox(height: AppSpacing.itemGap),
        // Figma 577:10290 — 시간 라디오 카드는 행 사이 구분선 없음(간격만).
        _SectionCard(
          children: DailyNotificationTime.values
              .map((slot) => _RadioRow(
                    label: slot.label,
                    selected: settings.dailyTime == slot,
                    onTap: () => _handleDailyTime(context, ref, slot),
                  ))
              .toList(),
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.cardPadding,
      ),
      children: [
        if (osBlocked) ...[
          const _OsBlockedBanner(),
          const SizedBox(height: AppSpacing.sectionGap),
        ],
        if (osBlocked)
          Opacity(
            opacity: 0.5,
            child: IgnorePointer(child: sections),
          )
        else
          sections,
      ],
    );
  }

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    NotificationToggleType type,
  ) async {
    try {
      await ref
          .read(notificationSettingsControllerProvider.notifier)
          .toggle(type);
    } catch (_) {
      if (context.mounted) {
        await showAppToast(context, '알림 설정 변경에 실패했어요.');
      }
    }
  }

  Future<void> _handleDailyTime(
    BuildContext context,
    WidgetRef ref,
    DailyNotificationTime time,
  ) async {
    try {
      await ref
          .read(notificationSettingsControllerProvider.notifier)
          .updateDailyTime(time);
    } catch (_) {
      if (context.mounted) {
        await showAppToast(context, '알림 시간 변경에 실패했어요.');
      }
    }
  }
}

// ---------------------------------------------------------------------------
// OS 알림 차단 안내 배너 (Figma 577-10286)
// ---------------------------------------------------------------------------

class _OsBlockedBanner extends ConsumerWidget {
  const _OsBlockedBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
      decoration: BoxDecoration(
        // Figma 577:10286 배너 — bg #FCFCFC, stroke #EAEAEA 1.5, radius 14.
        color: AppColors.surfaceInset,
        borderRadius: BorderRadius.circular(AppSpacing.radiusStatCard),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Figma 배너 얼굴 일러스트(😰 주황) = MoodFace uncomfortable 재사용.
              Image.asset(AppImages.moodUncomfortable, width: 24, height: 24),
              const SizedBox(width: AppSpacing.iconTextGap),
              Expanded(
                child: Text(
                  '기기 알림이 꺼져있어요',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '설정 → 먹어도돼? → 알림 허용에서\n알림을 켜주세요',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ref.read(openAppSettingsProvider)(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.itemGap + 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                elevation: 0,
              ),
              child: Text(
                '설정 바로 가기',
                style: AppTextStyles.body2Bold.copyWith(
                  color: AppColors.onPrimary,
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
// 공용 섹션 라벨
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
// 공용 섹션 카드 (테두리 + 둥근 모서리)
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        // Figma 577:10290 섹션 카드 — radius 16, stroke #EAEAEA.
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 토글 행
// ---------------------------------------------------------------------------

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.cardPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Figma 577:10290 — iOS 스타일 스위치(흰 thumb, ON=#34C759 track).
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 라디오 행
// ---------------------------------------------------------------------------

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.cardPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body2Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Figma 577:10290 — 선택=초록 원+흰 체크(verdict grade 재사용),
            // 미선택=흰 원+#EAEAEA 1px 링.
            if (selected)
              SvgPicture.asset(AppIcons.verdictRecommend, width: 24, height: 24)
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
