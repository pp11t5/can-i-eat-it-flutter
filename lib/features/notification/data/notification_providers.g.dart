// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRepositoryHash() =>
    r'1ca0afd17728d53a53fe986934409c79ae154b60';

/// [NotificationRepository] 공급자.
///
/// 기본값: [NotificationRepositoryImpl] — 실 서버 연동 (dioProvider 주입).
/// 테스트 override:
///   ProviderScope overrides: [notificationRepositoryProvider.overrideWithValue(mock)]
///
/// Copied from [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    AutoDisposeProvider<NotificationRepository>.internal(
  notificationRepository,
  name: r'notificationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRepositoryRef
    = AutoDisposeProviderRef<NotificationRepository>;
String _$notificationSettingsControllerHash() =>
    r'c62591231cf430ceffa2d5f84e0d771b843a7ea9';

/// 알림 설정 상태 컨트롤러.
///
/// [build]: GET /notifications/settings fetch.
/// [toggle]: 낙관적 갱신 후 PATCH /toggle 호출. 실패 시 이전 상태 복원.
/// [updateDailyTime]: 낙관적 갱신 후 PATCH /daily-time 호출. 실패 시 복원.
///
/// Copied from [NotificationSettingsController].
@ProviderFor(NotificationSettingsController)
final notificationSettingsControllerProvider = AutoDisposeAsyncNotifierProvider<
    NotificationSettingsController, NotificationSettings>.internal(
  NotificationSettingsController.new,
  name: r'notificationSettingsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationSettingsController
    = AutoDisposeAsyncNotifier<NotificationSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
