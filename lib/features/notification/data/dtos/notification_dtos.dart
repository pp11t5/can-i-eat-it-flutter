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
  });

  final bool postMealNotificationEnabled;
  final bool dailyRecordNotificationEnabled;
  final String dailyNotificationTime;
  final bool weeklyReportEnabled;

  factory NotificationSettingResponseDto.fromJson(Map<String, dynamic> json) {
    return NotificationSettingResponseDto(
      postMealNotificationEnabled:
          json['postMealNotificationEnabled'] as bool? ?? false,
      dailyRecordNotificationEnabled:
          json['dailyRecordNotificationEnabled'] as bool? ?? false,
      dailyNotificationTime:
          json['dailyNotificationTime'] as String? ?? 'morning_8',
      weeklyReportEnabled: json['weeklyReportEnabled'] as bool? ?? false,
    );
  }

  /// DTO → 도메인 엔티티 변환.
  NotificationSettings toEntity() {
    return NotificationSettings(
      postMealEnabled: postMealNotificationEnabled,
      dailyRecordEnabled: dailyRecordNotificationEnabled,
      weeklyReportEnabled: weeklyReportEnabled,
      dailyTime: DailyNotificationTime.fromServer(dailyNotificationTime),
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
