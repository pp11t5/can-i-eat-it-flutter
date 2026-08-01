import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/providers/timeline_fab_guide_provider.dart';

/// 타임라인 최초 진입 FAB 유도 가이드 (Figma 2694:20716 · 타임라인/처음 보여주는 화면).
///
/// empty 영역 우측 하단에 문구+곡선 화살표 에셋을 배치한다.
/// **아무 곳이나 탭**하면 닫힌다 (empty 영역 · 가이드 이미지 · FAB 포함).
///
/// ## 위치 (Figma 실측)
/// | 값 | 의미 |
/// |----|------|
/// | 좌 207 + 우 15 | frame 375 기준 → [guideWidth] 153 |
/// | 우 15 | 프레임 우단 ~ 가이드 우단 ([guidePaddingRight]) |
/// | 하 ~165.61 (스크린 하단 기준) | 하단 내비(~64)+홈인디(~34) 제외 시 body 기준 ≈68 |
class TimelineFirstVisitGuide extends ConsumerWidget {
  const TimelineFirstVisitGuide({super.key});

  /// Figma: 375 − 207 − 15. 에셋 2x 306px → logical 153.
  static const double guideWidth = 153;

  /// Figma 우측 여백 15.
  static const double guidePaddingRight = 15;

  /// Scaffold body 하단 ~ 가이드(에셋) 하단.
  ///
  /// Figma 스크린 하단 inset ≈165.61 에서 하단 탭(64)+홈 인디케이터(≈34)를
  /// 빼면 body 기준 ≈68. 화살촉이 FAB 상단에 닿도록 맞춤.
  static const double guidePaddingBottom = 68;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref.read(timelineFabGuideProvider.notifier).dismiss(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: guidePaddingRight,
                bottom: guidePaddingBottom,
              ),
              child: Semantics(
                label: '식사 기록을 추가하거나 증상을 기록해보세요',
                child: Image.asset(
                  AppImages.timelineFabGuide,
                  width: guideWidth,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
