import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';

/// 음식 판정에 사용한 의료 근거 안내로 이동하는 공통 링크.
///
/// 목적지 화면은 `/mypage/medical-sources`.
/// 이 위젯은 그 경로로의 이동만 담당한다.
class MedicalSourcesLink extends StatelessWidget {
  const MedicalSourcesLink({super.key});

  static const routePath = '/mypage/medical-sources';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: '의료 근거 확인',
      child: ExcludeSemantics(
        child: Material(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: InkWell(
            excludeFromSemantics: true,
            onTap: () => context.push(routePath),
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: 14,
              ),
              child: Row(
                children: [
                  const AppIcon(
                    AppIcons.medicalSources,
                    size: AppIconSizes.s16,
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      '왜 이런 결과가 나왔나요?',
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.link,
                      ),
                    ),
                  ),
                  Text(
                    '근거 확인',
                    style: AppTextStyles.body2Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const AppIcon(
                    AppIcons.chevronRight,
                    size: AppIconSizes.s16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
