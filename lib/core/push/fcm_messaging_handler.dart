import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ---------------------------------------------------------------------------
// 로컬 노티 플러그인 인스턴스 (패키지 전역 — initForegroundMessaging에서 초기화)
// ---------------------------------------------------------------------------

final FlutterLocalNotificationsPlugin _localNotis =
    FlutterLocalNotificationsPlugin();

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
/// **반드시 top-level(또는 static) 함수**여야 한다 — 별도 isolate에서 실행됨.
/// 이 isolate는 앱의 Riverpod/Provider 상태에 접근 불가이므로
/// Firebase를 재초기화하고 로깅만 수행한다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 별도 isolate — Firebase 재초기화 필요.
  await Firebase.initializeApp();
  debugPrint('[FCM] bg message: ${message.messageId}');
  // 지금은 로깅만. data-message 처리/노티 표시는 추후(리치 푸시 단계).
}

// ---------------------------------------------------------------------------
// Foreground 핸들러 초기화
// ---------------------------------------------------------------------------

/// Foreground 메시지 수신 초기화.
///
/// - Android 알림 채널 생성
/// - flutter_local_notifications 초기화
/// - [FirebaseMessaging.onMessage] 구독 → foreground 알림 표시
///
/// [main()]에서 [Firebase.initializeApp()] 직후 1회 호출.
/// iOS는 APNs 미설정으로 메시지 미도착 — Android 한정으로 실효.
Future<void> initForegroundMessaging() async {
  try {
    // Android 알림 채널 생성
    await _localNotis
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotis.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // iOS foreground 표시 옵션 (APNs 추후 활성 시 동작)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground 메시지 수신 → 로컬 노티 표시
    FirebaseMessaging.onMessage.listen((message) {
      final n = message.notification;
      if (n == null) return;
      debugPrint('[FCM] fg message: ${message.messageId}');
      _localNotis.show(
        id: n.hashCode,
        title: n.title,
        body: n.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    });
  } catch (e) {
    debugPrint('[FCM] initForegroundMessaging failed (ignored): $e');
  }
}

// ---------------------------------------------------------------------------
// 탭 시 앱 오픈/네비 골격
// ---------------------------------------------------------------------------

/// FCM 알림 탭으로 앱 오픈 시 페이로드 처리 초기화.
///
/// - terminated 상태에서 열린 경우: [FirebaseMessaging.instance.getInitialMessage]
/// - background → foreground 복귀: [FirebaseMessaging.onMessageOpenedApp]
///
/// 실제 딥링크 라우팅 매핑은 페이로드 스키마 확정 후(추후). 현재는 로깅 골격만.
Future<void> wireOpenedApp() async {
  try {
    // Terminated 상태에서 탭으로 열린 경우
    final initial =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _handleOpened(initial);

    // Background → foreground 복귀 탭
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpened);
  } catch (e) {
    debugPrint('[FCM] wireOpenedApp failed (ignored): $e');
  }
}

void _handleOpened(RemoteMessage message) {
  debugPrint('[FCM] opened: ${message.data}');
  // TODO(APNs-active): message.data['route'] 등으로 go_router 네비.
  // 페이로드 스키마(식후 증상 응답 등) 확정 후 구현.
}
