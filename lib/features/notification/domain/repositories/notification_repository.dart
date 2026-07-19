import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';

/// 알림 설정 저장소 인터페이스.
abstract interface class NotificationRepository {
  /// GET /notifications/settings → [NotificationSettings].
  Future<NotificationSettings> fetch();

  /// PATCH /notifications/settings/toggle — 토글 타입 지정.
  Future<void> toggle(NotificationToggleType type);

  /// PATCH /notifications/settings/daily-time — 알림 수신 시간 변경.
  Future<void> updateDailyTime(DailyNotificationTime time);

  /// PATCH /consent/marketing/toggle — 마케팅·푸시 알림 수신 동의 토글.
  ///
  /// [enabled]는 변경 후 원하는 값이다. `/notifications/settings/toggle`과
  /// 달리 마케팅 동의는 별도 계약(consent)에 속한다(A2).
  Future<void> toggleMarketingConsent(bool enabled);
}
