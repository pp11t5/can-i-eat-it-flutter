import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';

/// 식단 기록 방식 선택 바텀시트를 띄운다. 카드를 누르면 시트를 닫고 콜백을 호출한다.
Future<void> showMealRecordMethodSheet(
  BuildContext context, {
  required VoidCallback onManual,
  required VoidCallback onPhoto,
}) {
  return showModalBottomSheet<void>(
    context: context,
    // 탭 브랜치 Navigator 에 띄우면 하단 네비바가 시트 위에 남는다.
    useRootNavigator: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusSheet),
      ),
    ),
    builder: (sheetContext) {
      void select(VoidCallback callback) {
        Navigator.of(sheetContext).pop();
        callback();
      }

      // 하단 48 은 홈 인디케이터 영역을 포함한다. 인셋이 더 큰 기기만 늘린다.
      final bottom = math.max(
        48.0,
        MediaQuery.viewPaddingOf(sheetContext).bottom + AppSpacing.cardPadding,
      );
      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.sectionGap,
          AppSpacing.screenPadding,
          bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '식단 기록을 어떻게 남길까요?',
                    style: AppTextStyles.body1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(sheetContext).pop(),
                  child: const AppIcon(
                    AppIcons.close,
                    size: AppIconSizes.s32,
                    color: AppColors.textPrimary,
                    semanticsLabel: '닫기',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            // 두 카드 높이를 같게 맞춘다(Column 안 stretch 는 무한 높이).
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _MethodCard(
                      title: '직접 입력',
                      description: '음식을 직접\n타이핑해요.',
                      icon: AppIcons.pencil,
                      onTap: () => select(onManual),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: _MethodCard(
                      title: '사진으로 기록',
                      description: '음식 사진을 찍어\n자동으로 인식해요.',
                      icon: AppIcons.camera,
                      iconSize: AppIconSizes.s32,
                      onTap: () => select(onPhoto),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// 기록 방식 카드.
class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.title,
    required this.description,
    required this.icon,
    this.iconSize = AppIconSizes.s24,
    required this.onTap,
  });

  final String title;
  final String description;
  final String icon;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surfaceSheetCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox.square(
                dimension: AppIconSizes.s32,
                child: Center(
                  child: AppIcon(
                    icon,
                    size: iconSize,
                    color: AppColors.textPrimary,
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
