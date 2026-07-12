import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 온보딩 단계 진행 인디케이터.
///
/// [currentStep] / [totalSteps] 진행 상태를 가로 세그먼트 바로 표시한다.
///
/// - [currentStep]: 현재 단계 (1-base). [totalSteps]보다 크면 전체 채움으로 처리.
/// - [totalSteps]: 전체 단계 수. 1 이상이어야 한다.
/// - [height]: 세그먼트 높이. 기본값 AppSpacing.xs(4).
class StepProgress extends StatelessWidget {
  const StepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = AppSpacing.xs,
  })  : assert(totalSteps >= 1, 'totalSteps must be >= 1'),
        assert(currentStep >= 1, 'currentStep must be >= 1');

  final int currentStep;
  final int totalSteps;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isFilled = index < currentStep;
        final isLast = index == totalSteps - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: isLast ? 0 : AppSpacing.xs,
            ),
            child: _Segment(filled: isFilled, height: height),
          ),
        );
      }),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.filled, required this.height});

  final bool filled;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : const Color(0xFFEDEDF5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
    );
  }
}
