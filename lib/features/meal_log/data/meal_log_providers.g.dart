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
    r'659823fb009836e6a5b84cc430dd30f4ada28ba7';

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
    extends BuildlessAutoDisposeAsyncNotifier<List<TimelineItem>> {
  late final DateTime date;

  FutureOr<List<TimelineItem>> build(
    DateTime date,
  );
}

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
///
/// Copied from [TimelineController].
@ProviderFor(TimelineController)
const timelineControllerProvider = TimelineControllerFamily();

/// 타임라인 컨트롤러.
///
/// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
///
/// Copied from [TimelineController].
class TimelineControllerFamily extends Family<AsyncValue<List<TimelineItem>>> {
  /// 타임라인 컨트롤러.
  ///
  /// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
  ///
  /// Copied from [TimelineController].
  const TimelineControllerFamily();

  /// 타임라인 컨트롤러.
  ///
  /// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
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
/// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
///
/// Copied from [TimelineController].
class TimelineControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TimelineController, List<TimelineItem>> {
  /// 타임라인 컨트롤러.
  ///
  /// 선택된 날짜([date])의 [TimelineItem] 목록(single/group/symptom)을 조회한다.
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
  FutureOr<List<TimelineItem>> runNotifierBuild(
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
  AutoDisposeAsyncNotifierProviderElement<TimelineController,
      List<TimelineItem>> createElement() {
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
    on AutoDisposeAsyncNotifierProviderRef<List<TimelineItem>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _TimelineControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TimelineController,
        List<TimelineItem>> with TimelineControllerRef {
  _TimelineControllerProviderElement(super.provider);

  @override
  DateTime get date => (origin as TimelineControllerProvider).date;
}

String _$weeklyControllerHash() => r'0db06eb54d1c43b92a1d74e4c81297b49dc56822';

abstract class _$WeeklyController
    extends BuildlessAutoDisposeAsyncNotifier<List<WeeklyDay>> {
  late final DateTime weekStart;

  FutureOr<List<WeeklyDay>> build(
    DateTime weekStart,
  );
}

/// 주간 도트 컨트롤러.
///
/// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
///
/// Copied from [WeeklyController].
@ProviderFor(WeeklyController)
const weeklyControllerProvider = WeeklyControllerFamily();

/// 주간 도트 컨트롤러.
///
/// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
///
/// Copied from [WeeklyController].
class WeeklyControllerFamily extends Family<AsyncValue<List<WeeklyDay>>> {
  /// 주간 도트 컨트롤러.
  ///
  /// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
  ///
  /// Copied from [WeeklyController].
  const WeeklyControllerFamily();

  /// 주간 도트 컨트롤러.
  ///
  /// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
  ///
  /// Copied from [WeeklyController].
  WeeklyControllerProvider call(
    DateTime weekStart,
  ) {
    return WeeklyControllerProvider(
      weekStart,
    );
  }

  @override
  WeeklyControllerProvider getProviderOverride(
    covariant WeeklyControllerProvider provider,
  ) {
    return call(
      provider.weekStart,
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
  String? get name => r'weeklyControllerProvider';
}

/// 주간 도트 컨트롤러.
///
/// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
///
/// Copied from [WeeklyController].
class WeeklyControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    WeeklyController, List<WeeklyDay>> {
  /// 주간 도트 컨트롤러.
  ///
  /// [weekStart] 가 속한 주의 [WeeklyDay] 목록을 조회한다.
  ///
  /// Copied from [WeeklyController].
  WeeklyControllerProvider(
    DateTime weekStart,
  ) : this._internal(
          () => WeeklyController()..weekStart = weekStart,
          from: weeklyControllerProvider,
          name: r'weeklyControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weeklyControllerHash,
          dependencies: WeeklyControllerFamily._dependencies,
          allTransitiveDependencies:
              WeeklyControllerFamily._allTransitiveDependencies,
          weekStart: weekStart,
        );

  WeeklyControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weekStart,
  }) : super.internal();

  final DateTime weekStart;

  @override
  FutureOr<List<WeeklyDay>> runNotifierBuild(
    covariant WeeklyController notifier,
  ) {
    return notifier.build(
      weekStart,
    );
  }

  @override
  Override overrideWith(WeeklyController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeeklyControllerProvider._internal(
        () => create()..weekStart = weekStart,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weekStart: weekStart,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WeeklyController, List<WeeklyDay>>
      createElement() {
    return _WeeklyControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyControllerProvider && other.weekStart == weekStart;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weekStart.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeeklyControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<WeeklyDay>> {
  /// The parameter `weekStart` of this provider.
  DateTime get weekStart;
}

class _WeeklyControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WeeklyController,
        List<WeeklyDay>> with WeeklyControllerRef {
  _WeeklyControllerProviderElement(super.provider);

  @override
  DateTime get weekStart => (origin as WeeklyControllerProvider).weekStart;
}

String _$mealRecordDetailControllerHash() =>
    r'1e952c17a225b07ed46f85f907dccd34cb650d23';

abstract class _$MealRecordDetailController
    extends BuildlessAutoDisposeAsyncNotifier<MealRecord> {
  late final String mealRecordId;

  FutureOr<MealRecord> build(
    String mealRecordId,
  );
}

/// 식사 상세 컨트롤러.
///
/// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
/// 삭제 액션을 제공한다.
///
/// Copied from [MealRecordDetailController].
@ProviderFor(MealRecordDetailController)
const mealRecordDetailControllerProvider = MealRecordDetailControllerFamily();

/// 식사 상세 컨트롤러.
///
/// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
/// 삭제 액션을 제공한다.
///
/// Copied from [MealRecordDetailController].
class MealRecordDetailControllerFamily extends Family<AsyncValue<MealRecord>> {
  /// 식사 상세 컨트롤러.
  ///
  /// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
  /// 삭제 액션을 제공한다.
  ///
  /// Copied from [MealRecordDetailController].
  const MealRecordDetailControllerFamily();

  /// 식사 상세 컨트롤러.
  ///
  /// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
  /// 삭제 액션을 제공한다.
  ///
  /// Copied from [MealRecordDetailController].
  MealRecordDetailControllerProvider call(
    String mealRecordId,
  ) {
    return MealRecordDetailControllerProvider(
      mealRecordId,
    );
  }

  @override
  MealRecordDetailControllerProvider getProviderOverride(
    covariant MealRecordDetailControllerProvider provider,
  ) {
    return call(
      provider.mealRecordId,
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
  String? get name => r'mealRecordDetailControllerProvider';
}

/// 식사 상세 컨트롤러.
///
/// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
/// 삭제 액션을 제공한다.
///
/// Copied from [MealRecordDetailController].
class MealRecordDetailControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MealRecordDetailController,
        MealRecord> {
  /// 식사 상세 컨트롤러.
  ///
  /// [mealRecordId] 에 해당하는 [MealRecord](음식 목록 + 상태기록)를 로드하고
  /// 삭제 액션을 제공한다.
  ///
  /// Copied from [MealRecordDetailController].
  MealRecordDetailControllerProvider(
    String mealRecordId,
  ) : this._internal(
          () => MealRecordDetailController()..mealRecordId = mealRecordId,
          from: mealRecordDetailControllerProvider,
          name: r'mealRecordDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealRecordDetailControllerHash,
          dependencies: MealRecordDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              MealRecordDetailControllerFamily._allTransitiveDependencies,
          mealRecordId: mealRecordId,
        );

  MealRecordDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealRecordId,
  }) : super.internal();

  final String mealRecordId;

  @override
  FutureOr<MealRecord> runNotifierBuild(
    covariant MealRecordDetailController notifier,
  ) {
    return notifier.build(
      mealRecordId,
    );
  }

  @override
  Override overrideWith(MealRecordDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MealRecordDetailControllerProvider._internal(
        () => create()..mealRecordId = mealRecordId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealRecordId: mealRecordId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MealRecordDetailController,
      MealRecord> createElement() {
    return _MealRecordDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealRecordDetailControllerProvider &&
        other.mealRecordId == mealRecordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealRecordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealRecordDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<MealRecord> {
  /// The parameter `mealRecordId` of this provider.
  String get mealRecordId;
}

class _MealRecordDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MealRecordDetailController,
        MealRecord> with MealRecordDetailControllerRef {
  _MealRecordDetailControllerProviderElement(super.provider);

  @override
  String get mealRecordId =>
      (origin as MealRecordDetailControllerProvider).mealRecordId;
}

String _$mealFoodDetailControllerHash() =>
    r'1ceef4a4d01313921c62351964e7b75459406b90';

abstract class _$MealFoodDetailController
    extends BuildlessAutoDisposeAsyncNotifier<MealFood> {
  late final String mealFoodId;

  FutureOr<MealFood> build(
    String mealFoodId,
  );
}

/// 음식 상세 컨트롤러.
///
/// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
/// 제공한다.
///
/// Copied from [MealFoodDetailController].
@ProviderFor(MealFoodDetailController)
const mealFoodDetailControllerProvider = MealFoodDetailControllerFamily();

/// 음식 상세 컨트롤러.
///
/// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
/// 제공한다.
///
/// Copied from [MealFoodDetailController].
class MealFoodDetailControllerFamily extends Family<AsyncValue<MealFood>> {
  /// 음식 상세 컨트롤러.
  ///
  /// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
  /// 제공한다.
  ///
  /// Copied from [MealFoodDetailController].
  const MealFoodDetailControllerFamily();

  /// 음식 상세 컨트롤러.
  ///
  /// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
  /// 제공한다.
  ///
  /// Copied from [MealFoodDetailController].
  MealFoodDetailControllerProvider call(
    String mealFoodId,
  ) {
    return MealFoodDetailControllerProvider(
      mealFoodId,
    );
  }

  @override
  MealFoodDetailControllerProvider getProviderOverride(
    covariant MealFoodDetailControllerProvider provider,
  ) {
    return call(
      provider.mealFoodId,
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
  String? get name => r'mealFoodDetailControllerProvider';
}

/// 음식 상세 컨트롤러.
///
/// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
/// 제공한다.
///
/// Copied from [MealFoodDetailController].
class MealFoodDetailControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MealFoodDetailController,
        MealFood> {
  /// 음식 상세 컨트롤러.
  ///
  /// [mealFoodId] 에 해당하는 [MealFood](analysis 포함)를 로드하고 삭제 액션을
  /// 제공한다.
  ///
  /// Copied from [MealFoodDetailController].
  MealFoodDetailControllerProvider(
    String mealFoodId,
  ) : this._internal(
          () => MealFoodDetailController()..mealFoodId = mealFoodId,
          from: mealFoodDetailControllerProvider,
          name: r'mealFoodDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealFoodDetailControllerHash,
          dependencies: MealFoodDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              MealFoodDetailControllerFamily._allTransitiveDependencies,
          mealFoodId: mealFoodId,
        );

  MealFoodDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealFoodId,
  }) : super.internal();

  final String mealFoodId;

  @override
  FutureOr<MealFood> runNotifierBuild(
    covariant MealFoodDetailController notifier,
  ) {
    return notifier.build(
      mealFoodId,
    );
  }

  @override
  Override overrideWith(MealFoodDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MealFoodDetailControllerProvider._internal(
        () => create()..mealFoodId = mealFoodId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealFoodId: mealFoodId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MealFoodDetailController, MealFood>
      createElement() {
    return _MealFoodDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealFoodDetailControllerProvider &&
        other.mealFoodId == mealFoodId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealFoodId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealFoodDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<MealFood> {
  /// The parameter `mealFoodId` of this provider.
  String get mealFoodId;
}

class _MealFoodDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MealFoodDetailController,
        MealFood> with MealFoodDetailControllerRef {
  _MealFoodDetailControllerProviderElement(super.provider);

  @override
  String get mealFoodId =>
      (origin as MealFoodDetailControllerProvider).mealFoodId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
