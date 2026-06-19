import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 식사 알림 / 건강 팁 알림 토글 위젯.
///
/// Riverpod 미연동 목 상태로 제공 — 초기값 모두 true.
/// [StatefulWidget]으로 구현하여 [setState]로 토글을 관리한다.
class MealNotificationSettingsWidget extends StatefulWidget {
  const MealNotificationSettingsWidget({super.key});

  @override
  State<MealNotificationSettingsWidget> createState() =>
      _MealNotificationSettingsWidgetState();
}

class _MealNotificationSettingsWidgetState
    extends State<MealNotificationSettingsWidget> {
  bool _mealNotification = true;
  bool _healthTipNotification = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.restaurant_outlined,
            color: AppColors.textPrimary,
          ),
          title: Text(
            '식사 알림',
            style: AppTextStyles.body1Medium
                .copyWith(color: AppColors.textPrimary),
          ),
          trailing: Switch(
            value: _mealNotification,
            activeThumbColor: AppColors.primary,
            onChanged: (value) => setState(() => _mealNotification = value),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.lightbulb_outline,
            color: AppColors.textPrimary,
          ),
          title: Text(
            '건강 팁 알림',
            style: AppTextStyles.body1Medium
                .copyWith(color: AppColors.textPrimary),
          ),
          trailing: Switch(
            value: _healthTipNotification,
            activeThumbColor: AppColors.primary,
            onChanged: (value) =>
                setState(() => _healthTipNotification = value),
          ),
        ),
      ],
    );
  }
}
