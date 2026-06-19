// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteRepositoryHash() =>
    r'cd4c656f57213c6f7b574c2c6dc9400d2ac05ff4';

/// [FavoriteRepository] 공급자.
///
/// 기본값: [LocalFavoriteRepository] (shared_preferences).
/// 테스트 override:
///   ProviderScope overrides: [favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository())]
///
/// Copied from [favoriteRepository].
@ProviderFor(favoriteRepository)
final favoriteRepositoryProvider =
    AutoDisposeProvider<FavoriteRepository>.internal(
  favoriteRepository,
  name: r'favoriteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteRepositoryRef = AutoDisposeProviderRef<FavoriteRepository>;
String _$favoriteControllerHash() =>
    r'cb7905dd17a7d9fc36c00dc840006a30b1abb341';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FavoriteController
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String foodName;

  FutureOr<bool> build(
    String foodName,
  );
}

/// 즐겨찾기 토글 컨트롤러.
///
/// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
/// toggle: 즐겨찾기 추가 ↔ 제거 전환.
///
/// Copied from [FavoriteController].
@ProviderFor(FavoriteController)
const favoriteControllerProvider = FavoriteControllerFamily();

/// 즐겨찾기 토글 컨트롤러.
///
/// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
/// toggle: 즐겨찾기 추가 ↔ 제거 전환.
///
/// Copied from [FavoriteController].
class FavoriteControllerFamily extends Family<AsyncValue<bool>> {
  /// 즐겨찾기 토글 컨트롤러.
  ///
  /// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
  /// toggle: 즐겨찾기 추가 ↔ 제거 전환.
  ///
  /// Copied from [FavoriteController].
  const FavoriteControllerFamily();

  /// 즐겨찾기 토글 컨트롤러.
  ///
  /// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
  /// toggle: 즐겨찾기 추가 ↔ 제거 전환.
  ///
  /// Copied from [FavoriteController].
  FavoriteControllerProvider call(
    String foodName,
  ) {
    return FavoriteControllerProvider(
      foodName,
    );
  }

  @override
  FavoriteControllerProvider getProviderOverride(
    covariant FavoriteControllerProvider provider,
  ) {
    return call(
      provider.foodName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'favoriteControllerProvider';
}

/// 즐겨찾기 토글 컨트롤러.
///
/// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
/// toggle: 즐겨찾기 추가 ↔ 제거 전환.
///
/// Copied from [FavoriteController].
class FavoriteControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FavoriteController, bool> {
  /// 즐겨찾기 토글 컨트롤러.
  ///
  /// build: [foodName] 기준 현재 즐겨찾기 여부(bool) 반환.
  /// toggle: 즐겨찾기 추가 ↔ 제거 전환.
  ///
  /// Copied from [FavoriteController].
  FavoriteControllerProvider(
    String foodName,
  ) : this._internal(
          () => FavoriteController()..foodName = foodName,
          from: favoriteControllerProvider,
          name: r'favoriteControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$favoriteControllerHash,
          dependencies: FavoriteControllerFamily._dependencies,
          allTransitiveDependencies:
              FavoriteControllerFamily._allTransitiveDependencies,
          foodName: foodName,
        );

  FavoriteControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.foodName,
  }) : super.internal();

  final String foodName;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant FavoriteController notifier,
  ) {
    return notifier.build(
      foodName,
    );
  }

  @override
  Override overrideWith(FavoriteController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FavoriteControllerProvider._internal(
        () => create()..foodName = foodName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        foodName: foodName,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FavoriteController, bool>
      createElement() {
    return _FavoriteControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteControllerProvider && other.foodName == foodName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, foodName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FavoriteControllerRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `foodName` of this provider.
  String get foodName;
}

class _FavoriteControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FavoriteController, bool>
    with FavoriteControllerRef {
  _FavoriteControllerProviderElement(super.provider);

  @override
  String get foodName => (origin as FavoriteControllerProvider).foodName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
