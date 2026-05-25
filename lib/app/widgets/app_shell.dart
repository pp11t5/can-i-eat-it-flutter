import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 바텀 내비 + 중앙 플로팅 체크 버튼을 포함한 앱 셸.
/// StatefulShellRoute의 builder가 반환한다.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.timeline), label: '타임라인'),
          NavigationDestination(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/check'),
        tooltip: '체크',
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
