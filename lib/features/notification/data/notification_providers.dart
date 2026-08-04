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
class NotificationSettingsController extends _$NotificationSettingsController {
  @override
  Future<NotificationSettings> build() async {
    return ref.watch(notificationRepositoryProvider).fetch();
  }

  /// 토글 타입을 낙관적으로 갱신하고 서버에 PATCH 요청한다.
  Future<void> toggle(NotificationToggleType type) async {
    final previous = state;
    final settings = previous.valueOrNull;

    // 마케팅·푸시 수신 동의가 꺼진 동안에는 하위 알림을 다시 켤 수 없다.
    if (settings == null || !settings.marketingPushEnabled) return;

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

  /// 마케팅·푸시 알림 수신 동의를 낙관적으로 갱신하고 서버에 PATCH 요청한다.
  ///
  /// `/notifications/settings/toggle`이 아닌 `/consent/marketing/toggle`을
  /// 별도로 호출한다(A2).
  Future<void> toggleMarketing() async {
    final previous = state;
    final settings = previous.valueOrNull;
    if (settings == null) return;

    final nextMarketingEnabled = !settings.marketingPushEnabled;
    final enabledChildToggles = nextMarketingEnabled
        ? const <NotificationToggleType>[]
        : _enabledChildToggles(settings);

    // 마스터를 끌 때는 하위 알림도 즉시 모두 끈다. 다시 켤 때에는
    // 사용자가 개별적으로 선택할 수 있도록 하위 상태를 복원하지 않는다.
    state = AsyncData(
      settings.copyWith(
        marketingPushEnabled: nextMarketingEnabled,
        postMealEnabled: nextMarketingEnabled ? null : false,
        dailyRecordEnabled: nextMarketingEnabled ? null : false,
        weeklyReportEnabled: nextMarketingEnabled ? null : false,
      ),
    );

    try {
      final repository = ref.read(notificationRepositoryProvider);
      await Future.wait([
        repository.toggleMarketingConsent(nextMarketingEnabled),
        for (final type in enabledChildToggles) repository.toggle(type),
      ]);
    } catch (_) {
      // 여러 요청 중 일부만 성공했을 수 있으므로 이전 로컬 상태로 되돌리지 않고
      // 서버의 최신 상태를 다시 읽어 화면을 정합시킨다.
      try {
        state =
            AsyncData(await ref.read(notificationRepositoryProvider).fetch());
      } catch (_) {
        // 재조회도 실패하면 기존 화면 상태를 유지한다.
        state = previous;
      }
      rethrow;
    }
  }

  List<NotificationToggleType> _enabledChildToggles(
    NotificationSettings settings,
  ) {
    return [
      if (settings.postMealEnabled) NotificationToggleType.postMeal,
      if (settings.dailyRecordEnabled) NotificationToggleType.dailyRecord,
      if (settings.weeklyReportEnabled) NotificationToggleType.weeklyReport,
    ];
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
