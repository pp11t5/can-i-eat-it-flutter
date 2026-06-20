import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 빠른 재검색 위젯 (목 데이터).
class QuickSearchWidget extends StatelessWidget {
  const QuickSearchWidget({super.key});

  static const _keywords = ['두부', '계란', '바나나'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 재검색',
          style: AppTextStyles.header3Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _keywords
              .map(
                (keyword) => ActionChip(
                  label: Text(keyword),
                  onPressed: () {},
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
