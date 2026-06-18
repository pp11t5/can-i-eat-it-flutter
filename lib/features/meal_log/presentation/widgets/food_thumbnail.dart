import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 음식 썸네일 placeholder 위젯 (32×32).
///
/// 서버에 이미지 URL이 없으므로 카테고리 기반 이모지를 둥근 컨테이너에 표시한다.
/// 향후 실 이미지 URL 연동 시 이 위젯만 교체하면 된다.
///
/// [category]: 음식 카테고리 (예: '한식', '음료'). null이면 기본 아이콘.
/// [size]: 썸네일 크기. 기본 32.
class FoodThumbnail extends StatelessWidget {
  const FoodThumbnail({
    super.key,
    this.category,
    this.size = 32.0,
  });

  /// 음식 카테고리 (MealFood.category 또는 FoodSummary.category).
  final String? category;

  /// 썸네일 정사각형 크기.
  final double size;

  /// 카테고리 → 이모지 매핑.
  static String _emojiFor(String? cat) => switch (cat?.toLowerCase()) {
        '한식' => '🍲',
        '두류' || '콩류' => '🫘',
        '음료' || '커피' || '차' => '☕',
        '과일' || '과일류' => '🍎',
        '채소' || '채소류' => '🥦',
        '고기' || '육류' => '🥩',
        '생선' || '해산물' => '🐟',
        '유제품' => '🥛',
        '빵' || '제과' => '🍞',
        _ => '🍽️',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _emojiFor(category),
        style: AppTextStyles.caption1Medium.copyWith(
          fontSize: size * 0.55,
          height: 1.0,
        ),
      ),
    );
  }
}
