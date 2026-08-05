import 'package:flutter/foundation.dart' show debugPrint;

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

import 'push_payload_resolver.dart';

/// 푸시 탭을 인증/온보딩 게이트와 함께 처리한다.
///
/// background isolate에서는 이 객체를 생성하지 않는다. UI isolate에서만
/// `onMessageOpenedApp`/`getInitialMessage`의 결과를 전달받아 네비게이션한다.
class PushNavigationCoordinator {
  PushNavigationCoordinator({
    required SessionStatus initialStatus,
    required void Function(String location) onPush,
    required void Function(String location) onGo,
  })  : _status = initialStatus,
        _onPush = onPush,
        _onGo = onGo;

  SessionStatus _status;
  final void Function(String location) _onPush;
  final void Function(String location) _onGo;
  PushDestination? _pending;

  /// FCM notification 탭 이벤트를 처리한다.
  void handleRemoteMessage(RemoteMessage message) {
    debugPrint(
      '[FCM] handleRemoteMessage id=${message.messageId} data=${message.data}',
    );
    handleData(message.data);
  }

  /// Android foreground local notification의 payload를 처리한다.
  void handleLocalPayload(String? payload) {
    debugPrint('[FCM] handleLocalPayload payload=$payload');
    _handleDestination(PushPayloadResolver.fromLocalPayload(payload));
  }

  /// FCM `data` payload를 처리한다.
  void handleData(Map<String, dynamic> data) {
    _handleDestination(PushPayloadResolver.fromData(data), rawData: data);
  }

  /// 세션 상태가 바뀌면 보관된 최신 푸시 목적지를 재생한다.
  void onSessionStatusChanged(SessionStatus next) {
    final previous = _status;
    _status = next;
    debugPrint('[FCM] session $previous → $next pending=${_pending?.location}');
    if (_pending == null) return;

    if (next == SessionStatus.ready) {
      final destination = _pending!;
      _pending = null;
      _navigate(destination);
    } else if (next == SessionStatus.unauthenticated) {
      _onGo('/login');
    }
  }

  void _handleDestination(
    PushDestination? destination, {
    Map<String, dynamic>? rawData,
  }) {
    if (destination == null) {
      debugPrint(
        '[FCM] ignored unsupported push payload'
        '${rawData != null ? ': $rawData' : ''}',
      );
      return;
    }

    if (_status == SessionStatus.ready) {
      _navigate(destination);
      return;
    }

    // 동시에 여러 탭이 들어오면 사용자 의도가 가장 최근 탭에 있다고 본다.
    debugPrint(
      '[FCM] defer push ${destination.location} until ready (status=$_status)',
    );
    _pending = destination;
    if (_status == SessionStatus.unauthenticated) {
      _onGo('/login');
    }
  }

  void _navigate(PushDestination destination) {
    debugPrint('[FCM] navigate → ${destination.location}');
    _onPush(destination.location);
  }
}
