import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 판정 로딩 화면 (Figma node 554-5332).
///
/// 배경 흰색, 화면 중앙에 스피너 + 로딩 안내 텍스트.
class VerdictLoadingScreen extends StatelessWidget {
  const VerdictLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 스피너 — Figma: mingcute:loading-fill 66×66, 색 #00BF72
            const SizedBox(
              width: 66,
              height: 66,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            // "○○님에게 맞는 음식 분석 중이에요"
            // Body_1(M): Pretendard Medium 16, lineHeight 160%, color #10111A
            Text(
              '내 몸에 맞는지\n확인하고 있어요',
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            // 스켈레톤 블록 3개
            const _SkeletonBlocks(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 스켈레톤 블록
// ---------------------------------------------------------------------------

class _SkeletonBlocks extends StatelessWidget {
  const _SkeletonBlocks();

  static const _skeletonColor = Color(0xFFE0E0E0);
  static const _blockDecoration = BoxDecoration(
    color: _skeletonColor,
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 20,
            decoration: _blockDecoration,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 20,
            decoration: _blockDecoration,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 20,
            decoration: _blockDecoration,
          ),
        ],
      ),
    );
  }
}
