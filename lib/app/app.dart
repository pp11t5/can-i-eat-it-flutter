import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/global_loading.dart';

/// 앱 루트 위젯. 라우터/테마를 주입한다.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: '먹어도 돼?',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // 전역 차단형 로딩 오버레이 — globalLoadingControllerProvider 카운터 > 0 이면
      // 화면 전체를 덮는 배리어+스피너를 얹어 중복 탭/추가 인터랙션을 막는다.
      builder: (context, child) =>
          GlobalLoadingOverlay(child: child ?? const SizedBox.shrink()),
    );
  }
}
