import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/app/router/app_router.dart';
import 'package:can_i_eat_it/core/push/push_route_navigator.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/home/data/home_providers.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_bridge.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_composer.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_controller.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_coordinator.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';

part 'home_widget_providers.g.dart';

/// 식사/증상 저장 직후 위젯을 갱신할 때 쓴다. [Ref]와 [WidgetRef] 모두 `.read`로 호출한다.
void scheduleHomeWidgetSync(HomeWidgetController controller) {
  unawaited(controller.sync());
}

/// 수동 Provider 대신 generated provider로 제공한다 — generated provider가
/// manual provider에 의존하면 riverpod_lint(avoid_manual_providers_as_
/// generated_provider_dependency)가 빌드를 실패시킨다.
@Riverpod(keepAlive: true)
HomeWidgetController homeWidgetController(Ref ref) {
  return HomeWidgetController(
    composer: HomeWidgetComposer(
      homeRepository: ref.watch(homeRepositoryProvider),
      mealRepository: ref.watch(mealRepositoryProvider),
    ),
    bridge: const HomeWidgetPluginBridge(),
    isLoggedIn: () => ref.read(sessionStatusProvider) == SessionStatus.ready,
  );
}

/// 세션 전이·앱 재개·위젯 탭을 연결한다. [App]에서 watch한다.
final homeWidgetCoordinatorProvider = Provider<HomeWidgetCoordinator>((ref) {
  ref.watch(appRouterProvider);

  final coordinator = HomeWidgetCoordinator(
    initialStatus: ref.read(sessionStatusProvider),
    onNavigate: (location) {
      final router = ref.read(appRouterProvider);
      final current = router.routerDelegate.currentConfiguration;
      if (current.error == null) {
        final target = Uri.parse(location);
        if (current.uri.path == target.path &&
            current.uri.query == target.query) {
          return;
        }
      }
      unawaited(navigateFromPush(router: router, location: location));
    },
    onGo: (location) => ref.read(appRouterProvider).go(location),
    onSync: () => unawaited(ref.read(homeWidgetControllerProvider).sync()),
  );

  ref.listen<SessionStatus>(
    sessionStatusProvider,
    (_, next) => coordinator.onSessionStatusChanged(next),
    fireImmediately: true,
  );

  try {
    final clickSub =
        HomeWidgetPluginBridge.clickStream().listen(coordinator.handleUri);
    ref.onDispose(clickSub.cancel);
  } catch (e, st) {
    debugPrint('[HomeWidget] click listen failed: $e\n$st');
  }

  final observer = _HomeWidgetLifecycleObserver(coordinator.onAppResumed);
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));

  unawaited(() async {
    try {
      final initial = await HomeWidgetPluginBridge.initialUri();
      coordinator.handleUri(initial);
    } catch (e, st) {
      debugPrint('[HomeWidget] initial launch failed: $e\n$st');
    }
    coordinator.onAppResumed();
  }());

  return coordinator;
});

class _HomeWidgetLifecycleObserver extends WidgetsBindingObserver {
  _HomeWidgetLifecycleObserver(this._onResumed);

  final VoidCallback _onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResumed();
    }
  }
}
