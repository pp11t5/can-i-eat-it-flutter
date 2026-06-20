import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 최근 판정 미리보기 위젯 (목 데이터).
class RecentVerdictPreviewWidget extends StatelessWidget {
  const RecentVerdictPreviewWidget({super.key});

  static const _mockItems = [
    {'food': '두부', 'verdict': 'safe'},
    {'food': '커피', 'verdict': 'avoid'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 판정',
          style: AppTextStyles.header3Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mockItems.length,
          separatorBuilder: (_, __) =>
              const Divider(color: AppColors.divider, height: 1),
          itemBuilder: (_, index) {
            final item = _mockItems[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item['food']!),
              trailing: Text(item['verdict']!),
            );
          },
        ),
      ],
    );
  }
}
