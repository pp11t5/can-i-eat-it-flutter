// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$symptomDetailControllerHash() =>
    r'e2d8ed921fe21009c1772ff1534cd09e90d1646a';

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

abstract class _$SymptomDetailController
    extends BuildlessAutoDisposeAsyncNotifier<Symptom> {
  late final String symptomId;

  FutureOr<Symptom> build(
    String symptomId,
  );
}

/// 증상 상세 컨트롤러.
///
/// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
/// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
///
/// Copied from [SymptomDetailController].
@ProviderFor(SymptomDetailController)
const symptomDetailControllerProvider = SymptomDetailControllerFamily();

/// 증상 상세 컨트롤러.
///
/// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
/// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
///
/// Copied from [SymptomDetailController].
class SymptomDetailControllerFamily extends Family<AsyncValue<Symptom>> {
  /// 증상 상세 컨트롤러.
  ///
  /// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
  /// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
  ///
  /// Copied from [SymptomDetailController].
  const SymptomDetailControllerFamily();

  /// 증상 상세 컨트롤러.
  ///
  /// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
  /// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
  ///
  /// Copied from [SymptomDetailController].
  SymptomDetailControllerProvider call(
    String symptomId,
  ) {
    return SymptomDetailControllerProvider(
      symptomId,
    );
  }

  @override
  SymptomDetailControllerProvider getProviderOverride(
    covariant SymptomDetailControllerProvider provider,
  ) {
    return call(
      provider.symptomId,
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
  String? get name => r'symptomDetailControllerProvider';
}

/// 증상 상세 컨트롤러.
///
/// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
/// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
///
/// Copied from [SymptomDetailController].
class SymptomDetailControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SymptomDetailController,
        Symptom> {
  /// 증상 상세 컨트롤러.
  ///
  /// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
  /// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
  ///
  /// Copied from [SymptomDetailController].
  SymptomDetailControllerProvider(
    String symptomId,
  ) : this._internal(
          () => SymptomDetailController()..symptomId = symptomId,
          from: symptomDetailControllerProvider,
          name: r'symptomDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$symptomDetailControllerHash,
          dependencies: SymptomDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              SymptomDetailControllerFamily._allTransitiveDependencies,
          symptomId: symptomId,
        );

  SymptomDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symptomId,
  }) : super.internal();

  final String symptomId;

  @override
  FutureOr<Symptom> runNotifierBuild(
    covariant SymptomDetailController notifier,
  ) {
    return notifier.build(
      symptomId,
    );
  }

  @override
  Override overrideWith(SymptomDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SymptomDetailControllerProvider._internal(
        () => create()..symptomId = symptomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symptomId: symptomId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SymptomDetailController, Symptom>
      createElement() {
    return _SymptomDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SymptomDetailControllerProvider &&
        other.symptomId == symptomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symptomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SymptomDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Symptom> {
  /// The parameter `symptomId` of this provider.
  String get symptomId;
}

class _SymptomDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SymptomDetailController,
        Symptom> with SymptomDetailControllerRef {
  _SymptomDetailControllerProviderElement(super.provider);

  @override
  String get symptomId => (origin as SymptomDetailControllerProvider).symptomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
