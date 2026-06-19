import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 건강 팁 카드 (목 데이터).
///
/// 아이콘 + 제목 Row + 내용 텍스트 구조.
/// 위젯 생성 시 [DateTime.now().millisecondsSinceEpoch] % 5 인덱스로 팁을 선택한다.
class HealthTipCard extends StatelessWidget {
  const HealthTipCard({super.key});

  static const _tips = [
    '식사 후 바로 눕지 않고 30분 이상 앉아 있으면 역류 증상을 줄일 수 있어요.',
    '물은 식사 중보다 식사 30분 전이나 후에 마시는 것이 소화에 도움이 돼요.',
    '취침 3시간 전에는 음식 섭취를 피하면 수면 중 역류를 예방할 수 있어요.',
    '작은 양을 자주 먹는 것이 한 번에 많이 먹는 것보다 위에 부담이 덜해요.',
    '카페인과 알코올은 하부식도괄약근을 느슨하게 해 역류를 유발할 수 있어요.',
  ];

  String get _tip =>
      _tips[DateTime.now().millisecondsSinceEpoch % _tips.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 + 제목 Row
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 24,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 건강 팁',
                style: AppTextStyles.body1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 내용 텍스트 (5개 팁 중 하나를 무작위 선택)
          Text(
            _tip,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
