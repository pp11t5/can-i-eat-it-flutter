// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shouldShowProfileToastHash() =>
    r'4268063d22fda9e9c7114180eb559116815b12ff';

/// 프로필 완성 유도 토스트 표시 여부.
///
/// 다음 세 조건 모두 충족 시 true:
/// 1. 프로필이 미완성 (`profileCompleteProvider == false`)
/// 2. 앱 내 알림이 활성화 (`notificationEnabledProvider == true`)
/// 3. 토스트가 아직 표시되지 않음 (`firstVisitPrefs.isToastShown() == false`)
///
/// Copied from [shouldShowProfileToast].
@ProviderFor(shouldShowProfileToast)
final shouldShowProfileToastProvider = FutureProvider<bool>.internal(
  shouldShowProfileToast,
  name: r'shouldShowProfileToastProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shouldShowProfileToastHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShouldShowProfileToastRef = FutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
