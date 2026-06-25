// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_write_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$symptomWriteControllerHash() =>
    r'd12f9e1e30190ab75dc3ce22f7acf4d6d85309df';

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

abstract class _$SymptomWriteController
    extends BuildlessAutoDisposeNotifier<AsyncValue<void>> {
  late final String? existingSymptomId;

  AsyncValue<void> build(
    String? existingSymptomId,
  );
}

/// 증상 작성/수정 제출 컨트롤러.
///
/// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
/// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
///
/// Copied from [SymptomWriteController].
@ProviderFor(SymptomWriteController)
const symptomWriteControllerProvider = SymptomWriteControllerFamily();

/// 증상 작성/수정 제출 컨트롤러.
///
/// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
/// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
///
/// Copied from [SymptomWriteController].
class SymptomWriteControllerFamily extends Family<AsyncValue<void>> {
  /// 증상 작성/수정 제출 컨트롤러.
  ///
  /// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
  /// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
  ///
  /// Copied from [SymptomWriteController].
  const SymptomWriteControllerFamily();

  /// 증상 작성/수정 제출 컨트롤러.
  ///
  /// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
  /// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
  ///
  /// Copied from [SymptomWriteController].
  SymptomWriteControllerProvider call(
    String? existingSymptomId,
  ) {
    return SymptomWriteControllerProvider(
      existingSymptomId,
    );
  }

  @override
  SymptomWriteControllerProvider getProviderOverride(
    covariant SymptomWriteControllerProvider provider,
  ) {
    return call(
      provider.existingSymptomId,
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
  String? get name => r'symptomWriteControllerProvider';
}

/// 증상 작성/수정 제출 컨트롤러.
///
/// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
/// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
///
/// Copied from [SymptomWriteController].
class SymptomWriteControllerProvider extends AutoDisposeNotifierProviderImpl<
    SymptomWriteController, AsyncValue<void>> {
  /// 증상 작성/수정 제출 컨트롤러.
  ///
  /// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
  /// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
  ///
  /// Copied from [SymptomWriteController].
  SymptomWriteControllerProvider(
    String? existingSymptomId,
  ) : this._internal(
          () => SymptomWriteController()..existingSymptomId = existingSymptomId,
          from: symptomWriteControllerProvider,
          name: r'symptomWriteControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$symptomWriteControllerHash,
          dependencies: SymptomWriteControllerFamily._dependencies,
          allTransitiveDependencies:
              SymptomWriteControllerFamily._allTransitiveDependencies,
          existingSymptomId: existingSymptomId,
        );

  SymptomWriteControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.existingSymptomId,
  }) : super.internal();

  final String? existingSymptomId;

  @override
  AsyncValue<void> runNotifierBuild(
    covariant SymptomWriteController notifier,
  ) {
    return notifier.build(
      existingSymptomId,
    );
  }

  @override
  Override overrideWith(SymptomWriteController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SymptomWriteControllerProvider._internal(
        () => create()..existingSymptomId = existingSymptomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        existingSymptomId: existingSymptomId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SymptomWriteController, AsyncValue<void>>
      createElement() {
    return _SymptomWriteControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SymptomWriteControllerProvider &&
        other.existingSymptomId == existingSymptomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, existingSymptomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SymptomWriteControllerRef
    on AutoDisposeNotifierProviderRef<AsyncValue<void>> {
  /// The parameter `existingSymptomId` of this provider.
  String? get existingSymptomId;
}

class _SymptomWriteControllerProviderElement
    extends AutoDisposeNotifierProviderElement<SymptomWriteController,
        AsyncValue<void>> with SymptomWriteControllerRef {
  _SymptomWriteControllerProviderElement(super.provider);

  @override
  String? get existingSymptomId =>
      (origin as SymptomWriteControllerProvider).existingSymptomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
