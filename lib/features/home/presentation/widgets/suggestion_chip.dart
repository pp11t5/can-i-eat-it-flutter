import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';

/// 홈 화면 음식 제안 칩.
///
/// Figma 1207:6590 — white fill, stroke #E9E9E9 1px, radius pill,
/// padding 8(V)×16(H), 좌측 24×24 이미지 아이콘 + 8 gap + 라벨.
class HomeSuggestionChip extends StatelessWidget {
  const HomeSuggestionChip({
    super.key,
    required this.label,
    required this.category,
    required this.onTap,
  });

  final String label;

  /// 서버 음식 카테고리 코드. null·알 수 없는 값은 [CategoryIcon]이 regular로 폴백한다.
  final String? category;

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
            CategoryIcon(code: category, size: 24),
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
