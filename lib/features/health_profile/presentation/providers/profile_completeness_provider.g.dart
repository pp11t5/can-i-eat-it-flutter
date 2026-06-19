// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_completeness_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileCompleteHash() => r'5721247df6f198d5b9f9c20d94769303c9abed7a';

/// 현재 건강 프로필 완성 여부 computed provider.
///
/// [healthProfileControllerProvider]를 watch해 [isProfileComplete]로 판별한다.
/// 로딩 중·에러·프로필 없음 → false.
///
/// Copied from [profileComplete].
@ProviderFor(profileComplete)
final profileCompleteProvider = AutoDisposeProvider<bool>.internal(
  profileComplete,
  name: r'profileCompleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileCompleteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileCompleteRef = AutoDisposeProviderRef<bool>;
String _$profileCompletenessPercentageHash() =>
    r'ecda9887f64ad94f96a945d88555f8afdd00f7ee';

/// 현재 건강 프로필 완성도 (0–100) computed provider.
///
/// [healthProfileControllerProvider]를 watch해 [profileCompletenessPercent]로 계산한다.
/// 로딩 중·에러·프로필 없음 → 0.
///
/// Copied from [profileCompletenessPercentage].
@ProviderFor(profileCompletenessPercentage)
final profileCompletenessPercentageProvider = AutoDisposeProvider<int>.internal(
  profileCompletenessPercentage,
  name: r'profileCompletenessPercentageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileCompletenessPercentageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileCompletenessPercentageRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
