/// 알림 수신 시간 슬롯 enum.
///
/// 서버 enum 값을 SSOT로 사용한다. 표시 라벨은 [label]로 제공한다.
///
/// ⚠️ TODO(contract): daily-time enum↔표시시각 매핑 — 백엔드/디자이너 확인 필요.
/// 현재 서버 enum(morning_8/evening_8/night_9/night_10)과 디자인 라벨
/// (아침08/점심12/저녁18/밤22)이 의미상 불일치함.
/// 서버 enum을 순서 기준 SSOT로 4슬롯 매핑: morning_8=1번, evening_8=2번,
/// night_9=3번, night_10=4번.
enum DailyNotificationTime {
  morning8,
  evening8,
  night9,
  night10;

  /// 서버 전송 문자열 (`toServer`).
  String toServer() {
    return switch (this) {
      DailyNotificationTime.morning8 => 'morning_8',
      DailyNotificationTime.evening8 => 'evening_8',
      DailyNotificationTime.night9 => 'night_9',
      DailyNotificationTime.night10 => 'night_10',
    };
  }

  /// 서버 문자열 → enum 변환 (`fromServer`).
  static DailyNotificationTime fromServer(String value) {
    return switch (value) {
      'morning_8' => DailyNotificationTime.morning8,
      'evening_8' => DailyNotificationTime.evening8,
      'night_9' => DailyNotificationTime.night9,
      'night_10' => DailyNotificationTime.night10,
      _ => DailyNotificationTime.morning8, // 미지 값 fallback
    };
  }

  /// 화면 표시 라벨 (디자인 기준).
  ///
  /// ⚠️ TODO(contract): 서버 enum과 표시 시각 불일치 — 백엔드/디자이너 확인 필요.
  String get label {
    return switch (this) {
      DailyNotificationTime.morning8 => '아침 08:00',
      DailyNotificationTime.evening8 => '점심 12:00',
      DailyNotificationTime.night9 => '저녁 18:00',
      DailyNotificationTime.night10 => '밤 22:00',
    };
  }
}

/// 알림 토글 타입.
///
/// ⚠️ `marketing`은 이 enum에 포함하지 않는다 — Swagger toggle enum은
/// `post_meal | daily_record | weekly_report`만 유효하다. 마케팅·푸시 알림
/// 수신 동의는 별도 경로(`PATCH /consent/marketing/toggle`)로 처리한다
/// ([NotificationRepository.toggleMarketingConsent] 참고).
enum NotificationToggleType {
  postMeal,
  dailyRecord,
  weeklyReport;

  /// 서버 전송 문자열 (`toServer`).
  String toServer() {
    return switch (this) {
      NotificationToggleType.postMeal => 'post_meal',
      NotificationToggleType.dailyRecord => 'daily_record',
      NotificationToggleType.weeklyReport => 'weekly_report',
    };
  }
}

/// 알림 설정 도메인 엔티티.
class NotificationSettings {
  const NotificationSettings({
    required this.postMealEnabled,
    required this.dailyRecordEnabled,
    required this.weeklyReportEnabled,
    required this.dailyTime,
    required this.marketingPushEnabled,
  });

  final bool postMealEnabled;
  final bool dailyRecordEnabled;
  final bool weeklyReportEnabled;
  final DailyNotificationTime dailyTime;

  /// 마케팅·푸시 알림 수신 마스터 토글 (Figma 577:10290).
  final bool marketingPushEnabled;

  NotificationSettings copyWith({
    bool? postMealEnabled,
    bool? dailyRecordEnabled,
    bool? weeklyReportEnabled,
    DailyNotificationTime? dailyTime,
    bool? marketingPushEnabled,
  }) {
    return NotificationSettings(
      postMealEnabled: postMealEnabled ?? this.postMealEnabled,
      dailyRecordEnabled: dailyRecordEnabled ?? this.dailyRecordEnabled,
      weeklyReportEnabled: weeklyReportEnabled ?? this.weeklyReportEnabled,
      dailyTime: dailyTime ?? this.dailyTime,
      marketingPushEnabled: marketingPushEnabled ?? this.marketingPushEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettings &&
          runtimeType == other.runtimeType &&
          postMealEnabled == other.postMealEnabled &&
          dailyRecordEnabled == other.dailyRecordEnabled &&
          weeklyReportEnabled == other.weeklyReportEnabled &&
          dailyTime == other.dailyTime &&
          marketingPushEnabled == other.marketingPushEnabled;

  @override
  int get hashCode =>
      postMealEnabled.hashCode ^
      dailyRecordEnabled.hashCode ^
      weeklyReportEnabled.hashCode ^
      dailyTime.hashCode ^
      marketingPushEnabled.hashCode;
}
