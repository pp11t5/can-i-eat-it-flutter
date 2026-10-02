// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_recognition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodRecognitionInterpreterHash() =>
    r'2030f1c8609427b22207a1eebe13ea19f9d218ad';

/// MobileNetV3 TFLite [Interpreter]. 앱 전역에서 1회만 로드하고 재사용한다.
///
/// Copied from [foodRecognitionInterpreter].
@ProviderFor(foodRecognitionInterpreter)
final foodRecognitionInterpreterProvider = FutureProvider<Interpreter>.internal(
  foodRecognitionInterpreter,
  name: r'foodRecognitionInterpreterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodRecognitionInterpreterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodRecognitionInterpreterRef = FutureProviderRef<Interpreter>;
String _$foodRecognitionLabelsHash() =>
    r'5f6de536e97e9f7fbc451b0889fe7693ed8baf37';

/// 150개 음식 라벨 목록. 인덱스는 모델 출력 텐서의 클래스 인덱스와 1:1 대응.
///
/// 줄 수가 [_expectedLabelCount](=150, `model_metadata.json` num_classes)와
/// 다르면 라벨-모델 불일치를 조용히 넘기지 않고 즉시 assert로 드러낸다.
///
/// Copied from [foodRecognitionLabels].
@ProviderFor(foodRecognitionLabels)
final foodRecognitionLabelsProvider = FutureProvider<List<String>>.internal(
  foodRecognitionLabels,
  name: r'foodRecognitionLabelsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodRecognitionLabelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodRecognitionLabelsRef = FutureProviderRef<List<String>>;
String _$foodRecognitionRepositoryHash() =>
    r'16ecbbcdc0cd48c243178972b8a0c737929e9348';

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

/// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
///
/// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
/// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
///
/// Copied from [foodRecognitionRepository].
@ProviderFor(foodRecognitionRepository)
const foodRecognitionRepositoryProvider = FoodRecognitionRepositoryFamily();

/// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
///
/// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
/// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
///
/// Copied from [foodRecognitionRepository].
class FoodRecognitionRepositoryFamily
    extends Family<AsyncValue<FoodRecognitionRepository>> {
  /// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
  ///
  /// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
  ///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
  /// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
  ///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
  ///
  /// Copied from [foodRecognitionRepository].
  const FoodRecognitionRepositoryFamily();

  /// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
  ///
  /// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
  ///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
  /// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
  ///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
  ///
  /// Copied from [foodRecognitionRepository].
  FoodRecognitionRepositoryProvider call(
    RecognitionSource engine,
  ) {
    return FoodRecognitionRepositoryProvider(
      engine,
    );
  }

  @override
  FoodRecognitionRepositoryProvider getProviderOverride(
    covariant FoodRecognitionRepositoryProvider provider,
  ) {
    return call(
      provider.engine,
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
  String? get name => r'foodRecognitionRepositoryProvider';
}

/// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
///
/// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
/// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
///
/// Copied from [foodRecognitionRepository].
class FoodRecognitionRepositoryProvider
    extends AutoDisposeFutureProvider<FoodRecognitionRepository> {
  /// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
  ///
  /// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
  ///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
  /// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
  ///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
  ///
  /// Copied from [foodRecognitionRepository].
  FoodRecognitionRepositoryProvider(
    RecognitionSource engine,
  ) : this._internal(
          (ref) => foodRecognitionRepository(
            ref as FoodRecognitionRepositoryRef,
            engine,
          ),
          from: foodRecognitionRepositoryProvider,
          name: r'foodRecognitionRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$foodRecognitionRepositoryHash,
          dependencies: FoodRecognitionRepositoryFamily._dependencies,
          allTransitiveDependencies:
              FoodRecognitionRepositoryFamily._allTransitiveDependencies,
          engine: engine,
        );

  FoodRecognitionRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.engine,
  }) : super.internal();

  final RecognitionSource engine;

  @override
  Override overrideWith(
    FutureOr<FoodRecognitionRepository> Function(
            FoodRecognitionRepositoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FoodRecognitionRepositoryProvider._internal(
        (ref) => create(ref as FoodRecognitionRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        engine: engine,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FoodRecognitionRepository> createElement() {
    return _FoodRecognitionRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodRecognitionRepositoryProvider && other.engine == engine;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, engine.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodRecognitionRepositoryRef
    on AutoDisposeFutureProviderRef<FoodRecognitionRepository> {
  /// The parameter `engine` of this provider.
  RecognitionSource get engine;
}

class _FoodRecognitionRepositoryProviderElement
    extends AutoDisposeFutureProviderElement<FoodRecognitionRepository>
    with FoodRecognitionRepositoryRef {
  _FoodRecognitionRepositoryProviderElement(super.provider);

  @override
  RecognitionSource get engine =>
      (origin as FoodRecognitionRepositoryProvider).engine;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
