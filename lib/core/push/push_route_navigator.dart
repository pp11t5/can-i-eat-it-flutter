import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 푸시 탭 직후 현재 경로가 pre-auth(스플래시·로그인 등)이면 홈을 기준으로 삼아야 한다.
///
/// 닫기/뒤로가기 시 빈 스택·로그인 화면으로 떨어지지 않게 하기 위함.
bool needsHomeBaseline(String location) {
  return location == '/splash' ||
      location == '/login' ||
      location == '/terms' ||
      location.startsWith('/onboarding');
}

String currentRouterPath(GoRouter router) {
  return router.routerDelegate.currentConfiguration.uri.path;
}

/// 다음 프레임까지 대기. 프레임이 없으면 스케줄한 뒤 기다린다(테스트에서 hang 방지 위해
/// [waitFrame] 주입 가능).
Future<void> waitForNextFrame() {
  final binding = WidgetsBinding.instance;
  final completer = Completer<void>();
  binding.addPostFrameCallback((_) {
    if (!completer.isCompleted) completer.complete();
  });
  // idle이면 endOfFrame만으로는 영원히 안 올 수 있어 프레임을 요청한다.
  binding.scheduleFrame();
  return completer.future;
}

/// 푸시 목적지로 이동한다. cold start·게이트 통과 직후에도 안정적으로 push한다.
///
/// 1. 한 프레임 양보 — session ready 직후 go_router redirect(splash→/)가 먼저 적용되게 한다.
/// 2. 여전히 pre-auth면 `go('/')` 후 경로가 풀릴 때까지 프레임을 기다린다.
/// 3. `push` 실패 시 `go(location)` 폴백으로라도 목적지에 착지시킨다.
///
/// `router.push`의 Future는 **pop 시점**에 완료되므로 await하지 않는다.
Future<void> navigateFromPush({
  required GoRouter router,
  required String location,
  Future<void> Function()? waitFrame,
  int maxWaitFrames = 40,
}) async {
  final wait = waitFrame ?? waitForNextFrame;

  // session ready + refreshListenable redirect가 같은 틱에 겹칠 수 있어 한 프레임 양보.
  await wait();

  var path = currentRouterPath(router);
  if (needsHomeBaseline(path)) {
    debugPrint('[FCM] push nav: baseline from $path → / then $location');
    router.go('/');
    for (var i = 0; i < maxWaitFrames; i++) {
      await wait();
      path = currentRouterPath(router);
      if (!needsHomeBaseline(path)) break;
    }
  }

  path = currentRouterPath(router);
  if (needsHomeBaseline(path)) {
    // 게이트가 아직 막혀 있으면(예상 밖) 강제 go로라도 목적지를 연다.
    debugPrint(
      '[FCM] push nav: still on $path after wait — go($location) fallback',
    );
    try {
      router.go(location);
    } catch (e, st) {
      debugPrint('[FCM] push nav go fallback failed: $e\n$st');
    }
    return;
  }

  try {
    unawaited(
      router.push<void>(location).catchError((Object e, StackTrace st) {
        debugPrint('[FCM] push nav: push failed for $location: $e\n$st');
        try {
          router.go(location);
          debugPrint('[FCM] push nav: go($location) after push failure');
        } catch (e2, st2) {
          debugPrint('[FCM] push nav: go fallback failed: $e2\n$st2');
        }
      }),
    );
    debugPrint('[FCM] push nav: pushed $location (from $path)');
  } catch (e, st) {
    debugPrint('[FCM] push nav: push threw for $location: $e\n$st');
    try {
      router.go(location);
    } catch (e2, st2) {
      debugPrint('[FCM] push nav: go fallback failed: $e2\n$st2');
    }
  }
}
