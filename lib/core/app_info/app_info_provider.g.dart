// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appInfoHash() => r'5cc0ab57c35cce7602b9ac8f65d9b147e4b61b89';

/// 앱 패키지 정보 provider.
///
/// [PackageInfo.fromPlatform]으로 버전·빌드번호를 가져온다.
/// keepAlive: true — 앱 생명주기 동안 1회만 로드.
///
/// Copied from [appInfo].
@ProviderFor(appInfo)
final appInfoProvider = FutureProvider<PackageInfo>.internal(
  appInfo,
  name: r'appInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppInfoRef = FutureProviderRef<PackageInfo>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
