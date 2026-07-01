// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyReport {
  /// 리포트 시작일 (서버 원문 문자열, 'YYYY-MM-DD').
  String get startDate;

  /// 리포트 종료일 (서버 원문 문자열, 'YYYY-MM-DD').
  String get endDate;

  /// 주차 표시 라벨 (예: '이번 주').
  String get weekLabel;

  /// 연속 편안 상태.
  ComfortableState get comfortableState;

  /// 도넛 분포용 식사 판정 카운트.
  MealCount get mealCount;

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklyReportCopyWith<WeeklyReport> get copyWith =>
      _$WeeklyReportCopyWithImpl<WeeklyReport>(
          this as WeeklyReport, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklyReport &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.weekLabel, weekLabel) ||
                other.weekLabel == weekLabel) &&
            (identical(other.comfortableState, comfortableState) ||
                other.comfortableState == comfortableState) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, startDate, endDate, weekLabel, comfortableState, mealCount);

  @override
  String toString() {
    return 'WeeklyReport(startDate: $startDate, endDate: $endDate, weekLabel: $weekLabel, comfortableState: $comfortableState, mealCount: $mealCount)';
  }
}

/// @nodoc
abstract mixin class $WeeklyReportCopyWith<$Res> {
  factory $WeeklyReportCopyWith(
          WeeklyReport value, $Res Function(WeeklyReport) _then) =
      _$WeeklyReportCopyWithImpl;
  @useResult
  $Res call(
      {String startDate,
      String endDate,
      String weekLabel,
      ComfortableState comfortableState,
      MealCount mealCount});

  $ComfortableStateCopyWith<$Res> get comfortableState;
  $MealCountCopyWith<$Res> get mealCount;
}

/// @nodoc
class _$WeeklyReportCopyWithImpl<$Res> implements $WeeklyReportCopyWith<$Res> {
  _$WeeklyReportCopyWithImpl(this._self, this._then);

  final WeeklyReport _self;
  final $Res Function(WeeklyReport) _then;

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? weekLabel = null,
    Object? comfortableState = null,
    Object? mealCount = null,
  }) {
    return _then(_self.copyWith(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      weekLabel: null == weekLabel
          ? _self.weekLabel
          : weekLabel // ignore: cast_nullable_to_non_nullable
              as String,
      comfortableState: null == comfortableState
          ? _self.comfortableState
          : comfortableState // ignore: cast_nullable_to_non_nullable
              as ComfortableState,
      mealCount: null == mealCount
          ? _self.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as MealCount,
    ));
  }

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComfortableStateCopyWith<$Res> get comfortableState {
    return $ComfortableStateCopyWith<$Res>(_self.comfortableState, (value) {
      return _then(_self.copyWith(comfortableState: value));
    });
  }

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountCopyWith<$Res> get mealCount {
    return $MealCountCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WeeklyReport].
extension WeeklyReportPatterns on WeeklyReport {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WeeklyReport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyReport() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WeeklyReport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReport():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WeeklyReport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReport() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String startDate, String endDate, String weekLabel,
            ComfortableState comfortableState, MealCount mealCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyReport() when $default != null:
        return $default(_that.startDate, _that.endDate, _that.weekLabel,
            _that.comfortableState, _that.mealCount);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String startDate, String endDate, String weekLabel,
            ComfortableState comfortableState, MealCount mealCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReport():
        return $default(_that.startDate, _that.endDate, _that.weekLabel,
            _that.comfortableState, _that.mealCount);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String startDate, String endDate, String weekLabel,
            ComfortableState comfortableState, MealCount mealCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReport() when $default != null:
        return $default(_that.startDate, _that.endDate, _that.weekLabel,
            _that.comfortableState, _that.mealCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WeeklyReport implements WeeklyReport {
  const _WeeklyReport(
      {required this.startDate,
      required this.endDate,
      required this.weekLabel,
      required this.comfortableState,
      required this.mealCount});

  /// 리포트 시작일 (서버 원문 문자열, 'YYYY-MM-DD').
  @override
  final String startDate;

  /// 리포트 종료일 (서버 원문 문자열, 'YYYY-MM-DD').
  @override
  final String endDate;

  /// 주차 표시 라벨 (예: '이번 주').
  @override
  final String weekLabel;

  /// 연속 편안 상태.
  @override
  final ComfortableState comfortableState;

  /// 도넛 분포용 식사 판정 카운트.
  @override
  final MealCount mealCount;

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklyReportCopyWith<_WeeklyReport> get copyWith =>
      __$WeeklyReportCopyWithImpl<_WeeklyReport>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklyReport &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.weekLabel, weekLabel) ||
                other.weekLabel == weekLabel) &&
            (identical(other.comfortableState, comfortableState) ||
                other.comfortableState == comfortableState) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, startDate, endDate, weekLabel, comfortableState, mealCount);

  @override
  String toString() {
    return 'WeeklyReport(startDate: $startDate, endDate: $endDate, weekLabel: $weekLabel, comfortableState: $comfortableState, mealCount: $mealCount)';
  }
}

/// @nodoc
abstract mixin class _$WeeklyReportCopyWith<$Res>
    implements $WeeklyReportCopyWith<$Res> {
  factory _$WeeklyReportCopyWith(
          _WeeklyReport value, $Res Function(_WeeklyReport) _then) =
      __$WeeklyReportCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String startDate,
      String endDate,
      String weekLabel,
      ComfortableState comfortableState,
      MealCount mealCount});

  @override
  $ComfortableStateCopyWith<$Res> get comfortableState;
  @override
  $MealCountCopyWith<$Res> get mealCount;
}

/// @nodoc
class __$WeeklyReportCopyWithImpl<$Res>
    implements _$WeeklyReportCopyWith<$Res> {
  __$WeeklyReportCopyWithImpl(this._self, this._then);

  final _WeeklyReport _self;
  final $Res Function(_WeeklyReport) _then;

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? weekLabel = null,
    Object? comfortableState = null,
    Object? mealCount = null,
  }) {
    return _then(_WeeklyReport(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      weekLabel: null == weekLabel
          ? _self.weekLabel
          : weekLabel // ignore: cast_nullable_to_non_nullable
              as String,
      comfortableState: null == comfortableState
          ? _self.comfortableState
          : comfortableState // ignore: cast_nullable_to_non_nullable
              as ComfortableState,
      mealCount: null == mealCount
          ? _self.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as MealCount,
    ));
  }

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComfortableStateCopyWith<$Res> get comfortableState {
    return $ComfortableStateCopyWith<$Res>(_self.comfortableState, (value) {
      return _then(_self.copyWith(comfortableState: value));
    });
  }

  /// Create a copy of WeeklyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountCopyWith<$Res> get mealCount {
    return $MealCountCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }
}

/// @nodoc
mixin _$ComfortableState {
  /// 연속 편안 일수(스트릭).
  int get streakCount;

  /// 권장 식사 수.
  int get recommendedMealCount;

  /// 편안 비율(%).
  double get percentage;

  /// Create a copy of ComfortableState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ComfortableStateCopyWith<ComfortableState> get copyWith =>
      _$ComfortableStateCopyWithImpl<ComfortableState>(
          this as ComfortableState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ComfortableState &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.recommendedMealCount, recommendedMealCount) ||
                other.recommendedMealCount == recommendedMealCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, streakCount, recommendedMealCount, percentage);

  @override
  String toString() {
    return 'ComfortableState(streakCount: $streakCount, recommendedMealCount: $recommendedMealCount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $ComfortableStateCopyWith<$Res> {
  factory $ComfortableStateCopyWith(
          ComfortableState value, $Res Function(ComfortableState) _then) =
      _$ComfortableStateCopyWithImpl;
  @useResult
  $Res call({int streakCount, int recommendedMealCount, double percentage});
}

/// @nodoc
class _$ComfortableStateCopyWithImpl<$Res>
    implements $ComfortableStateCopyWith<$Res> {
  _$ComfortableStateCopyWithImpl(this._self, this._then);

  final ComfortableState _self;
  final $Res Function(ComfortableState) _then;

  /// Create a copy of ComfortableState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streakCount = null,
    Object? recommendedMealCount = null,
    Object? percentage = null,
  }) {
    return _then(_self.copyWith(
      streakCount: null == streakCount
          ? _self.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedMealCount: null == recommendedMealCount
          ? _self.recommendedMealCount
          : recommendedMealCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ComfortableState].
extension ComfortableStatePatterns on ComfortableState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ComfortableState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComfortableState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ComfortableState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ComfortableState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int streakCount, int recommendedMealCount, double percentage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComfortableState() when $default != null:
        return $default(
            _that.streakCount, _that.recommendedMealCount, _that.percentage);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int streakCount, int recommendedMealCount, double percentage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableState():
        return $default(
            _that.streakCount, _that.recommendedMealCount, _that.percentage);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int streakCount, int recommendedMealCount, double percentage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableState() when $default != null:
        return $default(
            _that.streakCount, _that.recommendedMealCount, _that.percentage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ComfortableState implements ComfortableState {
  const _ComfortableState(
      {required this.streakCount,
      required this.recommendedMealCount,
      required this.percentage});

  /// 연속 편안 일수(스트릭).
  @override
  final int streakCount;

  /// 권장 식사 수.
  @override
  final int recommendedMealCount;

  /// 편안 비율(%).
  @override
  final double percentage;

  /// Create a copy of ComfortableState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ComfortableStateCopyWith<_ComfortableState> get copyWith =>
      __$ComfortableStateCopyWithImpl<_ComfortableState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ComfortableState &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.recommendedMealCount, recommendedMealCount) ||
                other.recommendedMealCount == recommendedMealCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, streakCount, recommendedMealCount, percentage);

  @override
  String toString() {
    return 'ComfortableState(streakCount: $streakCount, recommendedMealCount: $recommendedMealCount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$ComfortableStateCopyWith<$Res>
    implements $ComfortableStateCopyWith<$Res> {
  factory _$ComfortableStateCopyWith(
          _ComfortableState value, $Res Function(_ComfortableState) _then) =
      __$ComfortableStateCopyWithImpl;
  @override
  @useResult
  $Res call({int streakCount, int recommendedMealCount, double percentage});
}

/// @nodoc
class __$ComfortableStateCopyWithImpl<$Res>
    implements _$ComfortableStateCopyWith<$Res> {
  __$ComfortableStateCopyWithImpl(this._self, this._then);

  final _ComfortableState _self;
  final $Res Function(_ComfortableState) _then;

  /// Create a copy of ComfortableState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? streakCount = null,
    Object? recommendedMealCount = null,
    Object? percentage = null,
  }) {
    return _then(_ComfortableState(
      streakCount: null == streakCount
          ? _self.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedMealCount: null == recommendedMealCount
          ? _self.recommendedMealCount
          : recommendedMealCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$MealCount {
  /// 권장 식사 수.
  int get recommendCount;

  /// 주의 식사 수.
  int get cautionCount;

  /// 위험 식사 수.
  int get riskCount;

  /// Create a copy of MealCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCountCopyWith<MealCount> get copyWith =>
      _$MealCountCopyWithImpl<MealCount>(this as MealCount, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealCount &&
            (identical(other.recommendCount, recommendCount) ||
                other.recommendCount == recommendCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount) &&
            (identical(other.riskCount, riskCount) ||
                other.riskCount == riskCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, recommendCount, cautionCount, riskCount);

  @override
  String toString() {
    return 'MealCount(recommendCount: $recommendCount, cautionCount: $cautionCount, riskCount: $riskCount)';
  }
}

/// @nodoc
abstract mixin class $MealCountCopyWith<$Res> {
  factory $MealCountCopyWith(MealCount value, $Res Function(MealCount) _then) =
      _$MealCountCopyWithImpl;
  @useResult
  $Res call({int recommendCount, int cautionCount, int riskCount});
}

/// @nodoc
class _$MealCountCopyWithImpl<$Res> implements $MealCountCopyWith<$Res> {
  _$MealCountCopyWithImpl(this._self, this._then);

  final MealCount _self;
  final $Res Function(MealCount) _then;

  /// Create a copy of MealCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendCount = null,
    Object? cautionCount = null,
    Object? riskCount = null,
  }) {
    return _then(_self.copyWith(
      recommendCount: null == recommendCount
          ? _self.recommendCount
          : recommendCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionCount: null == cautionCount
          ? _self.cautionCount
          : cautionCount // ignore: cast_nullable_to_non_nullable
              as int,
      riskCount: null == riskCount
          ? _self.riskCount
          : riskCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealCount].
extension MealCountPatterns on MealCount {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealCount value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCount() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealCount value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCount():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealCount value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCount() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int recommendCount, int cautionCount, int riskCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCount() when $default != null:
        return $default(
            _that.recommendCount, _that.cautionCount, _that.riskCount);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int recommendCount, int cautionCount, int riskCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCount():
        return $default(
            _that.recommendCount, _that.cautionCount, _that.riskCount);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int recommendCount, int cautionCount, int riskCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCount() when $default != null:
        return $default(
            _that.recommendCount, _that.cautionCount, _that.riskCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealCount implements MealCount {
  const _MealCount(
      {required this.recommendCount,
      required this.cautionCount,
      required this.riskCount});

  /// 권장 식사 수.
  @override
  final int recommendCount;

  /// 주의 식사 수.
  @override
  final int cautionCount;

  /// 위험 식사 수.
  @override
  final int riskCount;

  /// Create a copy of MealCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCountCopyWith<_MealCount> get copyWith =>
      __$MealCountCopyWithImpl<_MealCount>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealCount &&
            (identical(other.recommendCount, recommendCount) ||
                other.recommendCount == recommendCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount) &&
            (identical(other.riskCount, riskCount) ||
                other.riskCount == riskCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, recommendCount, cautionCount, riskCount);

  @override
  String toString() {
    return 'MealCount(recommendCount: $recommendCount, cautionCount: $cautionCount, riskCount: $riskCount)';
  }
}

/// @nodoc
abstract mixin class _$MealCountCopyWith<$Res>
    implements $MealCountCopyWith<$Res> {
  factory _$MealCountCopyWith(
          _MealCount value, $Res Function(_MealCount) _then) =
      __$MealCountCopyWithImpl;
  @override
  @useResult
  $Res call({int recommendCount, int cautionCount, int riskCount});
}

/// @nodoc
class __$MealCountCopyWithImpl<$Res> implements _$MealCountCopyWith<$Res> {
  __$MealCountCopyWithImpl(this._self, this._then);

  final _MealCount _self;
  final $Res Function(_MealCount) _then;

  /// Create a copy of MealCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? recommendCount = null,
    Object? cautionCount = null,
    Object? riskCount = null,
  }) {
    return _then(_MealCount(
      recommendCount: null == recommendCount
          ? _self.recommendCount
          : recommendCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionCount: null == cautionCount
          ? _self.cautionCount
          : cautionCount // ignore: cast_nullable_to_non_nullable
              as int,
      riskCount: null == riskCount
          ? _self.riskCount
          : riskCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
