// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_symptom_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodSymptomRepositoryHash() =>
    r'a038a1a5cb5f18e81d033162c042b1dbffe73e7a';

/// [FoodSymptomRepository] 공급자.
///
/// 기본값: [FoodSymptomRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodSymptomRepositoryProvider.overrideWithValue(MockFoodSymptomRepository.seeded())]
///
/// Copied from [foodSymptomRepository].
@ProviderFor(foodSymptomRepository)
final foodSymptomRepositoryProvider =
    AutoDisposeProvider<FoodSymptomRepository>.internal(
  foodSymptomRepository,
  name: r'foodSymptomRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodSymptomRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodSymptomRepositoryRef
    = AutoDisposeProviderRef<FoodSymptomRepository>;
String _$foodSymptomsHash() => r'c0ebc43bee8415f148f114eb922aed3a4c7eddfb';

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

/// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
///
/// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
///
/// Copied from [foodSymptoms].
@ProviderFor(foodSymptoms)
const foodSymptomsProvider = FoodSymptomsFamily();

/// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
///
/// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
///
/// Copied from [foodSymptoms].
class FoodSymptomsFamily extends Family<AsyncValue<List<FoodSymptom>>> {
  /// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
  ///
  /// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
  ///
  /// Copied from [foodSymptoms].
  const FoodSymptomsFamily();

  /// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
  ///
  /// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
  ///
  /// Copied from [foodSymptoms].
  FoodSymptomsProvider call(
    String foodExternalId,
  ) {
    return FoodSymptomsProvider(
      foodExternalId,
    );
  }

  @override
  FoodSymptomsProvider getProviderOverride(
    covariant FoodSymptomsProvider provider,
  ) {
    return call(
      provider.foodExternalId,
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
  String? get name => r'foodSymptomsProvider';
}

/// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
///
/// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
///
/// Copied from [foodSymptoms].
class FoodSymptomsProvider
    extends AutoDisposeFutureProvider<List<FoodSymptom>> {
  /// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
  ///
  /// 판정 상세 "이전 증상 이력" 섹션 디자인 확정 시 배선 예정 — 현재 구독처 없음.
  ///
  /// Copied from [foodSymptoms].
  FoodSymptomsProvider(
    String foodExternalId,
  ) : this._internal(
          (ref) => foodSymptoms(
            ref as FoodSymptomsRef,
            foodExternalId,
          ),
          from: foodSymptomsProvider,
          name: r'foodSymptomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$foodSymptomsHash,
          dependencies: FoodSymptomsFamily._dependencies,
          allTransitiveDependencies:
              FoodSymptomsFamily._allTransitiveDependencies,
          foodExternalId: foodExternalId,
        );

  FoodSymptomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.foodExternalId,
  }) : super.internal();

  final String foodExternalId;

  @override
  Override overrideWith(
    FutureOr<List<FoodSymptom>> Function(FoodSymptomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FoodSymptomsProvider._internal(
        (ref) => create(ref as FoodSymptomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        foodExternalId: foodExternalId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FoodSymptom>> createElement() {
    return _FoodSymptomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodSymptomsProvider &&
        other.foodExternalId == foodExternalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, foodExternalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodSymptomsRef on AutoDisposeFutureProviderRef<List<FoodSymptom>> {
  /// The parameter `foodExternalId` of this provider.
  String get foodExternalId;
}

class _FoodSymptomsProviderElement
    extends AutoDisposeFutureProviderElement<List<FoodSymptom>>
    with FoodSymptomsRef {
  _FoodSymptomsProviderElement(super.provider);

  @override
  String get foodExternalId => (origin as FoodSymptomsProvider).foodExternalId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
