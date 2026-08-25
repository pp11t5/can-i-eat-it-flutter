import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'router/push_navigation_provider.dart';
import '../core/symptom_outbox/symptom_outbox_retry_coordinator.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import 'theme/app_theme.dart';
import 'widgets/global_loading.dart';

/// 앱 루트 위젯. 라우터/테마를 주입한다.
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final session = ref.read(authControllerProvider).valueOrNull;
    if (session != null) {
      unawaited(
        ref.read(symptomOutboxRetryCoordinatorProvider).drain(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    // ProviderScope/GoRouter가 준비된 뒤 FCM 탭 수신을 연결한다.
    ref.watch(pushNavigationCoordinatorProvider);
    ref.watch(symptomOutboxReadyListenerProvider);
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
