import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/features/food_check/data/recent_food_providers.dart';

/// 검색 기록 전체 삭제 확인 다이얼로그.
///
/// Figma node 554:5324 정합:
/// - barrierColor: rgba(0,0,0,0.35)
/// - 모달카드: radius 16, white, padding 24/24/16
/// - 제목: header3Bold(18/700), #1A1A1F, center
/// - 버튼 열(gap 8): primary "삭제하기" expanded / text "취소"
Future<void> showClearSearchHistoryDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    barrierDismissible: true,
    builder: (dialogContext) => _ClearSearchHistoryDialog(ref: ref),
  );
}

class _ClearSearchHistoryDialog extends StatelessWidget {
  const _ClearSearchHistoryDialog({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Padding(
        // Figma: padding 24(top/sides) / 16(bottom).
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sectionGap,
          AppSpacing.sectionGap,
          AppSpacing.sectionGap,
          AppSpacing.cardPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '검색 기록을 삭제하시겠어요?',
              textAlign: TextAlign.center,
              style: AppTextStyles.header3Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            // 삭제하기 — primary expanded.
            AppButton.primary(
              label: '삭제하기',
              isExpanded: true,
              onPressed: () async {
                await ref
                    .read(recentFoodControllerProvider.notifier)
                    .clear();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AppSpacing.itemGap),
            // 취소 — text button.
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardPadding,
                ),
                child: Center(
                  child: Text(
                    '취소',
                    style: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
