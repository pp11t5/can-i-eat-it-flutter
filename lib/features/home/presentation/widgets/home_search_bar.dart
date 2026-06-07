import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 검색 진입 바 (tappable pill).
///
/// Figma 1207:6590 — fill #F5F5F5, radius pill, padding 8/8/8/24.
/// 전체 탭 시 [onTap] 호출.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 24,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted, // #F5F5F5
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '이 음식 먹어도 돼?',
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            // 흰 원형 검색 아이콘 버튼 (36×38, radius 999, white fill)
            Container(
              width: 36,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/figma_extracted/icon_search.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
