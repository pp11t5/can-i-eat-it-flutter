import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 건강 팁 카드 (목 데이터).
///
/// 아이콘 + 제목 Row + 내용 텍스트 구조.
/// 우상단 새로고침 버튼 탭 시 다음 팁으로 순환한다.
class HealthTipCard extends StatefulWidget {
  const HealthTipCard({super.key});

  @override
  State<HealthTipCard> createState() => _HealthTipCardState();
}

class _HealthTipCardState extends State<HealthTipCard> {
  static const _tips = [
    '식사 후 바로 눕지 않고 30분 이상 앉아 있으면 역류 증상을 줄일 수 있어요.',
    '물은 식사 중보다 식사 30분 전이나 후에 마시는 것이 소화에 도움이 돼요.',
    '취침 3시간 전에는 음식 섭취를 피하면 수면 중 역류를 예방할 수 있어요.',
    '작은 양을 자주 먹는 것이 한 번에 많이 먹는 것보다 위에 부담이 덜해요.',
    '카페인과 알코올은 하부식도괄약근을 느슨하게 해 역류를 유발할 수 있어요.',
  ];

  int _tipIndex = DateTime.now().millisecondsSinceEpoch % _tips.length;

  String get _tip => _tips[_tipIndex];

  void _nextTip() {
    setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tip,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '건강한 식습관을 위한 팁이에요. 매일 조금씩 실천해보세요.',
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + 제목 Row + 새로고침 버튼
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
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  color: AppColors.textSecondary,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: '다른 팁 보기',
                  onPressed: _nextTip,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 내용 텍스트
            Text(
              _tip,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
