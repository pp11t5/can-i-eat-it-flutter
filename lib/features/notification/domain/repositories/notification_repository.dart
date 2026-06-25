import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';

/// 알림 설정 저장소 인터페이스.
abstract interface class NotificationRepository {
  /// GET /notifications/settings → [NotificationSettings].
  Future<NotificationSettings> fetch();

  /// PATCH /notifications/settings/toggle — 토글 타입 지정.
  Future<void> toggle(NotificationToggleType type);

  /// PATCH /notifications/settings/daily-time — 알림 수신 시간 변경.
  Future<void> updateDailyTime(DailyNotificationTime time);
}
