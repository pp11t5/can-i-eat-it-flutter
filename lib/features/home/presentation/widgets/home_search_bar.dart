import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';

/// 홈 화면 검색 진입 바 (tappable pill).
///
/// Figma 1207:6590 — fill #F5F5F5, radius pill, padding 8/8/8/24.
/// 카메라 아이콘 탭 시 [onCameraTap], 나머지 영역 탭 시 [onTap].
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.onTap,
    required this.onCameraTap,
  });

  final VoidCallback onTap;
  final VoidCallback onCameraTap;

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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
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
            // 바 전체 탭(검색)과 분리된 카메라 탭 영역.
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCameraTap,
              child: const SizedBox(
                width: 40,
                height: 38,
                child: Center(
                  child: AppIcon(
                    AppIcons.camera,
                    size: AppIconSizes.s32,
                    color: AppColors.iconCamera,
                    semanticsLabel: '사진으로 음식 확인',
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
