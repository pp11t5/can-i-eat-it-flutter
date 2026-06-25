import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// FAB 액션시트 표시.
///
/// Figma node 1351-14767.
/// Dim 오버레이(검정 ~35%) + 우하단 X(녹색 원 FAB) + 흰 알약 메뉴 2개(우측정렬).
/// - "🥗 식단 기록" → 닫고 '/meal/record' push
/// - "✏️ 증상 일기" → 닫고 '/symptom/record' push (W5-3 활성화)
Future<void> showFabActionSheet(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '닫기',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _FabActionSheet(animation: animation);
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

class _FabActionSheet extends StatelessWidget {
  const _FabActionSheet({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dim 오버레이 — 탭으로 닫기
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.35),
            ),
          ),

          // 메뉴 항목 + X 버튼 — 우하단 정렬
          Positioned(
            right: AppSpacing.screenPadding,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 식단 기록 (활성)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: _ActionItem(
                    label: '🥗 식단 기록',
                    enabled: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/meal/record');
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 증상 일기 (활성)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: _ActionItem(
                    label: '✏️ 증상 일기',
                    enabled: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/symptom/record');
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // X 버튼 (녹색 원 FAB)
                FloatingActionButton(
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  elevation: 4,
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 알약형 메뉴 항목 위젯.
class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.chipPaddingV + 4,
        ),
        decoration: BoxDecoration(
          color: enabled ? AppColors.surface : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          boxShadow: enabled
              ? const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.body1Medium.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
