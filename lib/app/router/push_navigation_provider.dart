import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/core/push/fcm_messaging_handler.dart';
import 'package:can_i_eat_it/core/push/push_navigation_coordinator.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

import 'app_router.dart';

/// UI isolate에서 FCM 탭 수신과 앱 라우팅을 연결한다.
///
/// 앱 루트에서 한 번 watch하여 활성화한다. background handler는 별도 isolate라
/// 이 provider에 접근하지 않고, 다음 앱 시작의 `getInitialMessage`가 탭을 전달한다.
final pushNavigationCoordinatorProvider =
    Provider<PushNavigationCoordinator>((ref) {
  final router = ref.watch(appRouterProvider);
  final coordinator = PushNavigationCoordinator(
    initialStatus: ref.read(sessionStatusProvider),
    onPush: (location) => _pushDestination(router, location),
    onGo: router.go,
  );

  ref.listen<SessionStatus>(sessionStatusProvider, (_, next) {
    coordinator.onSessionStatusChanged(next);
  });

  unawaited(_startPushMessaging(coordinator));
  return coordinator;
});

/// 푸시 목적지는 기존 화면 위에 쌓아 닫기/뒤로가기가 원래 화면으로 돌아가게 한다.
///
/// 앱을 푸시 탭으로 막 시작했거나 인증 게이트를 막 통과한 경우에는 현재 경로가
/// splash/login/onboarding일 수 있다. 이때는 먼저 홈을 기준 스택으로 만든 뒤 다음
/// 프레임에서 push해, 닫기 시 pre-auth 화면이나 빈 스택으로 돌아가지 않게 한다.
void _pushDestination(GoRouter router, String location) {
  final currentLocation = router.routerDelegate.currentConfiguration.uri.path;
  if (_needsHomeBaseline(currentLocation)) {
    router.go('/');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(router.push<void>(location));
    });
    return;
  }

  unawaited(router.push<void>(location));
}

bool _needsHomeBaseline(String location) {
  return location == '/splash' ||
      location == '/login' ||
      location == '/terms' ||
      location.startsWith('/onboarding');
}

Future<void> _startPushMessaging(PushNavigationCoordinator coordinator) async {
  await initForegroundMessaging(
    onLocalNotificationTap: coordinator.handleLocalPayload,
  );
  await wireOpenedApp(coordinator.handleRemoteMessage);
}
