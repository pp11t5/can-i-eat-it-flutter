// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealRepositoryHash() => r'7becc2405cb492ff1b0e459fd20c7152b999ccdd';

/// [MealRepository] 공급자.
///
/// 기본값: [MealRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())]
///
/// Copied from [mealRepository].
@ProviderFor(mealRepository)
final mealRepositoryProvider = AutoDisposeProvider<MealRepository>.internal(
  mealRepository,
  name: r'mealRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealRepositoryRef = AutoDisposeProviderRef<MealRepository>;
String _$timelineControllerHash() =>
    r'a433f908f80626b55bf0b9947b7ae1408103c616';

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

abstract class _$TimelineController
    extends BuildlessAutoDisposeAsyncNotifier<List<MealGroup>> {
  late final DateTime date;

  FutureOr<List<MealGroup>> build(
    DateTime date,
  );
}

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
///
/// - 기본 선택일: 오늘(KST).
/// - [changeDate]: 선택일 변경 → 즉시 재조회.
/// - [refresh]: 현재 선택일 강제 재조회.
///
/// ProviderScope override 예시 (테스트):
///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
///
/// Copied from [TimelineController].
@ProviderFor(TimelineController)
const timelineControllerProvider = TimelineControllerFamily();

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
///
/// - 기본 선택일: 오늘(KST).
/// - [changeDate]: 선택일 변경 → 즉시 재조회.
/// - [refresh]: 현재 선택일 강제 재조회.
///
/// ProviderScope override 예시 (테스트):
///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
///
/// Copied from [TimelineController].
class TimelineControllerFamily extends Family<AsyncValue<List<MealGroup>>> {
  /// 타임라인 컨트롤러.
  ///
  /// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
  ///
  /// - 기본 선택일: 오늘(KST).
  /// - [changeDate]: 선택일 변경 → 즉시 재조회.
  /// - [refresh]: 현재 선택일 강제 재조회.
  ///
  /// ProviderScope override 예시 (테스트):
  ///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
  ///
  /// Copied from [TimelineController].
  const TimelineControllerFamily();

  /// 타임라인 컨트롤러.
  ///
  /// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
  ///
  /// - 기본 선택일: 오늘(KST).
  /// - [changeDate]: 선택일 변경 → 즉시 재조회.
  /// - [refresh]: 현재 선택일 강제 재조회.
  ///
  /// ProviderScope override 예시 (테스트):
  ///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
  ///
  /// Copied from [TimelineController].
  TimelineControllerProvider call(
    DateTime date,
  ) {
    return TimelineControllerProvider(
      date,
    );
  }

  @override
  TimelineControllerProvider getProviderOverride(
    covariant TimelineControllerProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'timelineControllerProvider';
}

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
///
/// - 기본 선택일: 오늘(KST).
/// - [changeDate]: 선택일 변경 → 즉시 재조회.
/// - [refresh]: 현재 선택일 강제 재조회.
///
/// ProviderScope override 예시 (테스트):
///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
///
/// Copied from [TimelineController].
class TimelineControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TimelineController, List<MealGroup>> {
  /// 타임라인 컨트롤러.
  ///
  /// 선택된 날짜([date])의 끼니 그룹 목록을 조회한다.
  ///
  /// - 기본 선택일: 오늘(KST).
  /// - [changeDate]: 선택일 변경 → 즉시 재조회.
  /// - [refresh]: 현재 선택일 강제 재조회.
  ///
  /// ProviderScope override 예시 (테스트):
  ///   mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded())
  ///
  /// Copied from [TimelineController].
  TimelineControllerProvider(
    DateTime date,
  ) : this._internal(
          () => TimelineController()..date = date,
          from: timelineControllerProvider,
          name: r'timelineControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timelineControllerHash,
          dependencies: TimelineControllerFamily._dependencies,
          allTransitiveDependencies:
              TimelineControllerFamily._allTransitiveDependencies,
          date: date,
        );

  TimelineControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  FutureOr<List<MealGroup>> runNotifierBuild(
    covariant TimelineController notifier,
  ) {
    return notifier.build(
      date,
    );
  }

  @override
  Override overrideWith(TimelineController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TimelineControllerProvider._internal(
        () => create()..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TimelineController, List<MealGroup>>
      createElement() {
    return _TimelineControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineControllerProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TimelineControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<MealGroup>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _TimelineControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TimelineController,
        List<MealGroup>> with TimelineControllerRef {
  _TimelineControllerProviderElement(super.provider);

  @override
  DateTime get date => (origin as TimelineControllerProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
