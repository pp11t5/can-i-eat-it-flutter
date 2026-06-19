import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/core/prefs/notification_prefs.dart';

/// 앱 내 알림 활성화 토글 위젯.
///
/// [notificationEnabledProvider]를 watch해 SwitchListTile을 표시한다.
/// 토글 시 [notificationPrefsProvider]의 setNotificationEnabled를 호출하고
/// [notificationEnabledProvider]를 invalidate한다.
class NotificationToggleWidget extends ConsumerWidget {
  const NotificationToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificationEnabledProvider);

    return notifAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          '알림 설정을 불러오지 못했어요.',
          style: AppTextStyles.body2Regular
              .copyWith(color: AppColors.textSecondary),
        ),
      ),
      data: (enabled) => Semantics(
        label: enabled ? '앱 내 알림 켜짐' : '앱 내 알림 꺼짐',
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          title: Text(
            '앱 내 알림',
            style: AppTextStyles.body1Medium
                .copyWith(color: AppColors.textPrimary),
          ),
          subtitle: Text(
            '편집 유도 등 앱 내 안내 메시지',
            style: AppTextStyles.caption1Medium
                .copyWith(color: AppColors.textSecondary),
          ),
          value: enabled,
          activeColor: AppColors.primary,
          onChanged: (value) async {
            await ref
                .read(notificationPrefsProvider)
                .setNotificationEnabled(value);
            ref.invalidate(notificationEnabledProvider);
          },
        ),
      ),
    );
  }
}
