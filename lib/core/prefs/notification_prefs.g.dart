// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPrefsHash() => r'da3f5c5761933aa5bf2509eafdcb301afdd8e44b';

/// 앱 전역 [NotificationPrefs] provider.
///
/// Copied from [notificationPrefs].
@ProviderFor(notificationPrefs)
final notificationPrefsProvider = Provider<NotificationPrefs>.internal(
  notificationPrefs,
  name: r'notificationPrefsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPrefsRef = ProviderRef<NotificationPrefs>;
String _$notificationEnabledHash() =>
    r'b4a1de9bf2d08a8d47078969c07a8ccb716ff113';

/// 알림 활성화 여부 computed provider.
///
/// Copied from [notificationEnabled].
@ProviderFor(notificationEnabled)
final notificationEnabledProvider = AutoDisposeFutureProvider<bool>.internal(
  notificationEnabled,
  name: r'notificationEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationEnabledRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
