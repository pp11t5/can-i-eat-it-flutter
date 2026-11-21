import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';

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
/// - 토글 1개: 마케팅 정보 수신 동의. 법적 수신 동의라 OS 권한과 무관하게 항상 활성.
/// - 앱 알림(식후·식단 기록·주간 리포트)은 OS 알림 권한으로만 제어한다(#261).
///   그래서 OS 권한이 차단(denied)돼 있으면 안내 배너로 시스템 설정 진입을 돕는다.
/// - 「설정 바로 가기」→ 시스템 설정 후 복귀 시 OS 권한을 재조회한다.
///   **상태가 바뀐 경우에만** 로딩 인디케이터를 잠깐 보여 준 뒤 UI를 갱신하고,
///   동일하면 인디케이터 없이 유지한다.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen>
    with WidgetsBindingObserver {
  /// 권한 상태가 바뀐 뒤 UI 전환용 로딩 인디케이터.
  bool _showTransitionIndicator = false;

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
    // 시스템 설정 진입 경로와 무관하게 앱 복귀 시 OS 권한을 새로 읽는다.
    if (state == AppLifecycleState.resumed && mounted) {
      unawaited(_refreshOsNotificationPermission());
    }
  }

  /// 시스템 알림 설정 화면을 연다. 복귀 시 [didChangeAppLifecycleState]에서 재조회.
  Future<void> _openOsSettings() async {
    await ref.read(openAppSettingsProvider)();
  }

  /// OS 알림 권한 provider를 무효화하고 최신 상태가 반영될 때까지 기다린다.
  Future<void> _refreshOsNotificationPermission() async {
    if (!mounted || _showTransitionIndicator) return;

    setState(() => _showTransitionIndicator = true);
    try {
      ref.invalidate(osNotificationBlockedProvider);
      await ref.read(osNotificationBlockedProvider.future);
    } catch (_) {
      // best-effort — 실패해도 기존 UI 유지
    } finally {
      if (mounted) setState(() => _showTransitionIndicator = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(notificationSettingsControllerProvider);
    final osBlocked =
        ref.watch(osNotificationBlockedProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        leading: const IconTheme(
          data: IconThemeData(size: 32),
          child: BackButton(color: AppColors.textPrimary),
        ),
        title: Text(
          '알림 설정',
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      body: settingsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          onRetry: () => ref.invalidate(notificationSettingsControllerProvider),
        ),
        data: (settings) {
          // 권한 상태가 실제로 바뀐 경우에만 전환 인디케이터 표시.
          if (_showTransitionIndicator) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            );
          }
          return _SettingsBody(
            marketingEnabled: settings.marketingPushEnabled,
            osBlocked: osBlocked,
            onOpenOsSettings: _openOsSettings,
          );
        },
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
  const _SettingsBody({
    required this.marketingEnabled,
    required this.osBlocked,
    required this.onOpenOsSettings,
  });

  final bool marketingEnabled;

  /// 기기 OS 알림 권한이 denied(차단)됐는지 여부.
  final bool osBlocked;

  /// 「설정 바로 가기」— 시스템 설정 오픈 후 복귀 시 권한 재조회.
  final Future<void> Function() onOpenOsSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      children: [
        _MarketingToggleRow(
          value: marketingEnabled,
          onChanged: (_) => _handleMarketingToggle(context, ref),
        ),
        if (osBlocked) ...[
          const SizedBox(height: AppSpacing.contentGap),
          _OsBlockedBanner(onOpenSettings: onOpenOsSettings),
        ],
      ],
    );
  }

  Future<void> _handleMarketingToggle(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref
          .read(notificationSettingsControllerProvider.notifier)
          .toggleMarketing();
    } catch (_) {
      if (context.mounted) {
        await showAppToast(context, '알림 설정 변경에 실패했어요.');
      }
    }
  }
}

// ---------------------------------------------------------------------------
// OS 알림 차단 안내 배너 (Figma 577-10286)
// ---------------------------------------------------------------------------

class _OsBlockedBanner extends StatelessWidget {
  const _OsBlockedBanner({required this.onOpenSettings});

  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(width: 8),
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
          const SizedBox(height: 10),
          Text(
            '설정 → 먹어도돼? → 알림 허용에서\n알림을 켜주세요',
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onOpenSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                elevation: 0,
              ),
              child: Text(
                '설정 바로 가기',
                style: AppTextStyles.body1Bold.copyWith(
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
// 마케팅 정보 수신 토글 행 (Figma 577:10290)
// ---------------------------------------------------------------------------

/// 카드가 아닌 bare row — OS 차단 여부와 무관하게 항상 활성 상태를 유지한다.
class _MarketingToggleRow extends StatelessWidget {
  const _MarketingToggleRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '마케팅 정보 수신',
                  style: AppTextStyles.body1Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '신규 기능, 혜택, 이벤트를 알려드려요.',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
