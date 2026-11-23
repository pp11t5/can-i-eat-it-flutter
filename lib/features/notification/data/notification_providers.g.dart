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
    r'5f488719af954aeb115fbd85ede3cc23047787a4';

/// 알림 설정 화면 상태 = 마케팅 정보 수신 동의 여부.
///
/// 앱 알림은 OS 권한으로만 제어하므로 이 컨트롤러는 마케팅 동의만 다룬다(#261).
///
/// Copied from [NotificationSettingsController].
@ProviderFor(NotificationSettingsController)
final notificationSettingsControllerProvider = AutoDisposeAsyncNotifierProvider<
    NotificationSettingsController, bool>.internal(
  NotificationSettingsController.new,
  name: r'notificationSettingsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationSettingsController = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
