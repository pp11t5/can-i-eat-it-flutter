import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';

/// [NotificationRepository] 목 구현 (테스트·오프라인용).
///
/// [seeded] 생성자: 초기 설정값 지정 가능.
/// [defaults] 생성자: 모두 false + morning8 시드.
class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository({required NotificationSettings seed})
      : _settings = seed;

  /// 기본값 시드 생성자.
  MockNotificationRepository.defaults()
      : _settings = const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
        );

  NotificationSettings _settings;

  /// 마지막으로 toggle된 타입 목록 (테스트 검증용).
  final List<NotificationToggleType> toggleCalls = [];

  /// 마지막으로 설정된 daily-time 목록 (테스트 검증용).
  final List<DailyNotificationTime> dailyTimeCalls = [];

  @override
  Future<NotificationSettings> fetch() async => _settings;

  @override
  Future<void> toggle(NotificationToggleType type) async {
    toggleCalls.add(type);
    _settings = switch (type) {
      NotificationToggleType.postMeal => _settings.copyWith(
          postMealEnabled: !_settings.postMealEnabled,
        ),
      NotificationToggleType.dailyRecord => _settings.copyWith(
          dailyRecordEnabled: !_settings.dailyRecordEnabled,
        ),
      NotificationToggleType.weeklyReport => _settings.copyWith(
          weeklyReportEnabled: !_settings.weeklyReportEnabled,
        ),
    };
  }

  @override
  Future<void> updateDailyTime(DailyNotificationTime time) async {
    dailyTimeCalls.add(time);
    _settings = _settings.copyWith(dailyTime: time);
  }
}
