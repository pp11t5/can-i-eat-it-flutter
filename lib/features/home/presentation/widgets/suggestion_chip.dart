import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 음식 제안 칩.
///
/// Figma 1207:6590 — white fill, stroke #E9E9E9 1px, radius pill,
/// padding 8(V)×16(H), 좌측 24×24 이미지 아이콘 + 8 gap + 라벨.
class HomeSuggestionChip extends StatelessWidget {
  const HomeSuggestionChip({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  final String label;

  /// `assets/illustrations/` 하위 경로 (e.g. `assets/illustrations/food_soup.png`).
  final String iconAsset;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(999)),
          border: Border.all(
            color: const Color(0xFFE9E9E9), // Figma stroke
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconAsset,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
