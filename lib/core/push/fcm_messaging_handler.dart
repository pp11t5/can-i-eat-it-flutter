import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ---------------------------------------------------------------------------
// 로컬 노티 플러그인 인스턴스 (패키지 전역 — UI isolate에서 1회 초기화)
// ---------------------------------------------------------------------------

final FlutterLocalNotificationsPlugin _localNotis =
    FlutterLocalNotificationsPlugin();

StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
StreamSubscription<RemoteMessage>? _openedAppSubscription;

const _channel = AndroidNotificationChannel(
  'default_high_importance',
  '일반 알림',
  importance: Importance.high,
);

// ---------------------------------------------------------------------------
// 백그라운드/종료 상태 핸들러 (top-level, @pragma 필수)
// ---------------------------------------------------------------------------

/// 백그라운드/종료 상태 메시지 핸들러.
///
/// notification+data 하이브리드 메시지는 OS가 표시한다. 이 별도 isolate에서는
/// Firebase만 초기화하고 UI·라우터·API 부수효과를 수행하지 않는다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    debugPrint('[FCM] bg message: ${message.messageId}');
  } catch (e) {
    debugPrint('[FCM] bg handler failed: $e');
  }
}

// ---------------------------------------------------------------------------
// Foreground 핸들러 초기화
// ---------------------------------------------------------------------------

/// UI isolate가 준비된 뒤 foreground 수신을 초기화한다.
///
/// Android는 foreground message를 로컬 알림으로 표시하고, 탭 payload를
/// [onLocalNotificationTap]으로 전달한다. iOS는 Firebase의 foreground
/// presentation을 사용하므로 로컬 알림을 중복 표시하지 않는다.
Future<void> initForegroundMessaging({
  required void Function(String? payload) onLocalNotificationTap,
}) async {
  try {
    await _localNotis
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotis.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        onLocalNotificationTap(response.payload);
      },
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _foregroundMessageSubscription ??= FirebaseMessaging.onMessage.listen(
      (message) => unawaited(_showForegroundNotification(message)),
    );
  } catch (e) {
    debugPrint('[FCM] initForegroundMessaging failed (ignored): $e');
  }
}

Future<void> _showForegroundNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null || defaultTargetPlatform == TargetPlatform.iOS) {
    return;
  }

  try {
    debugPrint('[FCM] fg message: ${message.messageId}');
    await _localNotis.show(
      id: message.messageId?.hashCode ?? notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  } catch (e) {
    debugPrint('[FCM] foreground notification failed (ignored): $e');
  }
}

// ---------------------------------------------------------------------------
// 탭 시 앱 오픈 처리
// ---------------------------------------------------------------------------

/// FCM 알림 탭 이벤트를 UI isolate의 [onOpened] callback으로 전달한다.
///
/// - terminated 상태: [FirebaseMessaging.instance.getInitialMessage]
/// - background → foreground 복귀: [FirebaseMessaging.onMessageOpenedApp]
Future<void> wireOpenedApp(
    void Function(RemoteMessage message) onOpened) async {
  try {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) onOpened(initial);

    _openedAppSubscription ??=
        FirebaseMessaging.onMessageOpenedApp.listen(onOpened);
  } catch (e) {
    debugPrint('[FCM] wireOpenedApp failed (ignored): $e');
  }
}
