import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/home/data/home_providers.dart';

import '../theme/app_colors.dart';
import '../theme/app_icon_sizes.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// 바텀 내비를 포함한 앱 셸.
/// StatefulShellRoute의 builder가 반환한다.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    _TabItem(label: '홈', iconAsset: AppIcons.navHome),
    _TabItem(label: '타임라인', iconAsset: AppIcons.navTimeline),
    _TabItem(label: '마이', iconAsset: AppIcons.navMy),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // StatefulShellRoute.indexedStack은 홈 브랜치를 유지하므로, 홈 탭에
          // 재진입할 때 식사 관련 요약 데이터를 명시적으로 다시 조회한다.
          if (index == 0) {
            ref.invalidate(recentMealsProvider);
            ref.invalidate(unrecordedMealCountProvider);
          }
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        tabs: _tabs,
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.iconAsset});
  final String label;
  final String iconAsset;
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000), // black @ 4% opacity
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isActive = index == currentIndex;
              final color =
                  isActive ? AppColors.primary : AppColors.navInactive;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon(
                        tabs[index].iconAsset,
                        size: AppIconSizes.s24,
                        color: color,
                        semanticsLabel: tabs[index].label,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tabs[index].label,
                        style: AppTextStyles.caption1Medium.copyWith(
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
