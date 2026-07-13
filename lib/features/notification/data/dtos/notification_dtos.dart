import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';

/// GET /notifications/settings 응답 DTO.
///
/// 서버 계약:
/// {postMealNotificationEnabled, dailyRecordNotificationEnabled,
///  dailyNotificationTime, weeklyReportEnabled}
class NotificationSettingResponseDto {
  const NotificationSettingResponseDto({
    required this.postMealNotificationEnabled,
    required this.dailyRecordNotificationEnabled,
    required this.dailyNotificationTime,
    required this.weeklyReportEnabled,
    required this.marketingPushEnabled,
  });

  final bool postMealNotificationEnabled;
  final bool dailyRecordNotificationEnabled;
  final String dailyNotificationTime;
  final bool weeklyReportEnabled;

  /// 마케팅·푸시 알림 수신 마스터 토글.
  final bool marketingPushEnabled;

  factory NotificationSettingResponseDto.fromJson(Map<String, dynamic> json) {
    return NotificationSettingResponseDto(
      postMealNotificationEnabled:
          json['postMealNotificationEnabled'] as bool? ?? false,
      dailyRecordNotificationEnabled:
          json['dailyRecordNotificationEnabled'] as bool? ?? false,
      dailyNotificationTime:
          json['dailyNotificationTime'] as String? ?? 'morning_8',
      weeklyReportEnabled: json['weeklyReportEnabled'] as bool? ?? false,
      // ⚠️ TODO(contract): 백엔드 계약 확정 시 마케팅 알림 키 정합 필요.
      // camel(marketingEnabled)/snake(marketing_enabled) 두 키 모두 대응하고,
      // 응답에 없으면 기본 true(옵트아웃 방식 안전 기본값).
      marketingPushEnabled:
          (json['marketingEnabled'] ?? json['marketing_enabled']) as bool? ??
              true,
    );
  }

  /// DTO → 도메인 엔티티 변환.
  NotificationSettings toEntity() {
    return NotificationSettings(
      postMealEnabled: postMealNotificationEnabled,
      dailyRecordEnabled: dailyRecordNotificationEnabled,
      weeklyReportEnabled: weeklyReportEnabled,
      dailyTime: DailyNotificationTime.fromServer(dailyNotificationTime),
      marketingPushEnabled: marketingPushEnabled,
    );
  }
}

/// PATCH /notifications/settings/toggle 요청 DTO.
class NotificationToggleRequestDto {
  const NotificationToggleRequestDto({required this.type});

  final String type;

  Map<String, dynamic> toJson() => {'type': type};
}

/// PATCH /notifications/settings/daily-time 요청 DTO.
class NotificationDailyTimeRequestDto {
  const NotificationDailyTimeRequestDto({required this.time});

  final String time;

  Map<String, dynamic> toJson() => {'time': time};
}
