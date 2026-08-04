import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

/// 온보딩 스텝 본문 래퍼 — 영역 전체를 불투명 배경으로 채운다.
///
/// [ShellRoute] + iOS Cupertino push 슬라이드 전환 시 이전 스텝 텍스트가
/// 비쳐 겹쳐 보이지 않도록 한다. 전환 애니메이션은 유지한다.
class OnboardingStepBody extends StatelessWidget {
  const OnboardingStepBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.scaffoldBackground,
      child: SizedBox.expand(child: child),
    );
  }
}
