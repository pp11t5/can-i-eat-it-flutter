import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 빠른 액세스 버튼 섹션.
///
/// 음식 검색 / 판정 이력 / 마이페이지 3개 버튼을 가로로 배치한다.
class QuickAccessButtons extends StatelessWidget {
  const QuickAccessButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickAccessButton(
          icon: Icons.search,
          label: '음식 검색',
          onTap: () {},
        ),
        _QuickAccessButton(
          icon: Icons.history,
          label: '판정 이력',
          onTap: () {},
        ),
        _QuickAccessButton(
          icon: Icons.person,
          label: '마이페이지',
          onTap: () {},
        ),
      ],
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption1Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
