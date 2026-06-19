import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_prefs.g.dart';

// ---------------------------------------------------------------------------
// 인터페이스
// ---------------------------------------------------------------------------

/// 앱 내 알림 활성화 설정 저장소.
///
/// 테스트에서는 [InMemoryNotificationPrefs]를 주입한다.
abstract interface class NotificationPrefs {
  /// 앱 내 알림 활성화 여부. 기본값: true.
  Future<bool> isNotificationEnabled();

  /// 알림 활성화 여부를 저장한다.
  Future<void> setNotificationEnabled(bool value);
}

// ---------------------------------------------------------------------------
// SharedPreferences 구현
// ---------------------------------------------------------------------------

/// [SharedPreferences] 기반 프로덕션 구현.
class SharedPrefsNotificationPrefs implements NotificationPrefs {
  static const _key = 'notification.enabled';

  @override
  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true; // 기본값: true
  }

  @override
  Future<void> setNotificationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

// ---------------------------------------------------------------------------
// 인메모리 Fake (테스트용)
// ---------------------------------------------------------------------------

/// 테스트용 인메모리 [NotificationPrefs].
class InMemoryNotificationPrefs implements NotificationPrefs {
  InMemoryNotificationPrefs({bool initial = true}) : _enabled = initial;

  bool _enabled;

  @override
  Future<bool> isNotificationEnabled() async => _enabled;

  @override
  Future<void> setNotificationEnabled(bool value) async => _enabled = value;
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

/// 앱 전역 [NotificationPrefs] provider.
@Riverpod(keepAlive: true)
NotificationPrefs notificationPrefs(Ref ref) => SharedPrefsNotificationPrefs();

/// 알림 활성화 여부 computed provider.
@riverpod
Future<bool> notificationEnabled(Ref ref) =>
    ref.watch(notificationPrefsProvider).isNotificationEnabled();
