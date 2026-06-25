import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';

part 'notification_providers.g.dart';

// ---------------------------------------------------------------------------
// NotificationRepository 공급자
// ---------------------------------------------------------------------------

/// [NotificationRepository] 공급자.
///
/// 기본값: [NotificationRepositoryImpl] — 실 서버 연동 (dioProvider 주입).
/// 테스트 override:
///   ProviderScope overrides: [notificationRepositoryProvider.overrideWithValue(mock)]
@riverpod
NotificationRepository notificationRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// NotificationSettingsController — AsyncNotifier
// ---------------------------------------------------------------------------

/// 알림 설정 상태 컨트롤러.
///
/// [build]: GET /notifications/settings fetch.
/// [toggle]: 낙관적 갱신 후 PATCH /toggle 호출. 실패 시 이전 상태 복원.
/// [updateDailyTime]: 낙관적 갱신 후 PATCH /daily-time 호출. 실패 시 복원.
@riverpod
class NotificationSettingsController
    extends _$NotificationSettingsController {
  @override
  Future<NotificationSettings> build() async {
    return ref.watch(notificationRepositoryProvider).fetch();
  }

  /// 토글 타입을 낙관적으로 갱신하고 서버에 PATCH 요청한다.
  Future<void> toggle(NotificationToggleType type) async {
    final previous = state;
    // 낙관적 갱신
    state = previous.whenData((settings) {
      return switch (type) {
        NotificationToggleType.postMeal => settings.copyWith(
            postMealEnabled: !settings.postMealEnabled,
          ),
        NotificationToggleType.dailyRecord => settings.copyWith(
            dailyRecordEnabled: !settings.dailyRecordEnabled,
          ),
        NotificationToggleType.weeklyReport => settings.copyWith(
            weeklyReportEnabled: !settings.weeklyReportEnabled,
          ),
      };
    });

    try {
      await ref.read(notificationRepositoryProvider).toggle(type);
    } catch (_) {
      // 실패 시 이전 상태 복원
      state = previous;
      rethrow;
    }
  }

  /// 알림 수신 시간을 낙관적으로 갱신하고 서버에 PATCH 요청한다.
  Future<void> updateDailyTime(DailyNotificationTime time) async {
    final previous = state;
    // 낙관적 갱신
    state = previous.whenData((s) => s.copyWith(dailyTime: time));

    try {
      await ref.read(notificationRepositoryProvider).updateDailyTime(time);
    } catch (_) {
      // 실패 시 이전 상태 복원
      state = previous;
      rethrow;
    }
  }
}
