import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/core/push/fcm_messaging_handler.dart';
import 'package:can_i_eat_it/core/push/push_navigation_coordinator.dart';
import 'package:can_i_eat_it/core/push/push_route_navigator.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

import 'app_router.dart';

/// UI isolate에서 FCM 탭 수신과 앱 라우팅을 연결한다.
///
/// 앱 루트에서 한 번 watch하여 활성화한다. background handler는 별도 isolate라
/// 이 provider에 접근하지 않고, 다음 앱 시작의 `getInitialMessage`가 탭을 전달한다.
final pushNavigationCoordinatorProvider =
    Provider<PushNavigationCoordinator>((ref) {
  // GoRouter를 살려 두고, 콜백 시점마다 최신 인스턴스를 읽는다.
  ref.watch(appRouterProvider);

  final coordinator = PushNavigationCoordinator(
    initialStatus: ref.read(sessionStatusProvider),
    onPush: (location) {
      final router = ref.read(appRouterProvider);
      unawaited(navigateFromPush(router: router, location: location));
    },
    onGo: (location) {
      ref.read(appRouterProvider).go(location);
    },
  );

  // fireImmediately: 생성 직후 이미 ready면 pending 재생 경로와 상태를 맞춘다.
  // (listen 기본값은 이후 변경만 통지 → cold start 레이스 때 _status 고정 위험 완화)
  ref.listen<SessionStatus>(
    sessionStatusProvider,
    (_, next) => coordinator.onSessionStatusChanged(next),
    fireImmediately: true,
  );

  unawaited(_startPushMessaging(coordinator));
  return coordinator;
});

/// cold start 탭을 먼저 잡고, 그다음 포그라운드/로컬 알림을 켠다.
Future<void> _startPushMessaging(PushNavigationCoordinator coordinator) async {
  await wireOpenedApp(coordinator.handleRemoteMessage);
  await initForegroundMessaging(
    onLocalNotificationTap: coordinator.handleLocalPayload,
  );
}
