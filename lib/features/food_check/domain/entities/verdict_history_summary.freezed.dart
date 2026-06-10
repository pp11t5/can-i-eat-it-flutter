// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verdict_history_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerdictHistorySummary {
  /// 과거 섭취 기록 건수.
  int get count;

  /// 평균 심각도 레이블. 서버 문자열 그대로. 없으면 null.
  String? get averageSeverity;

  /// Create a copy of VerdictHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerdictHistorySummaryCopyWith<VerdictHistorySummary> get copyWith =>
      _$VerdictHistorySummaryCopyWithImpl<VerdictHistorySummary>(
          this as VerdictHistorySummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerdictHistorySummary &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.averageSeverity, averageSeverity) ||
                other.averageSeverity == averageSeverity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, averageSeverity);

  @override
  String toString() {
    return 'VerdictHistorySummary(count: $count, averageSeverity: $averageSeverity)';
  }
}

/// @nodoc
abstract mixin class $VerdictHistorySummaryCopyWith<$Res> {
  factory $VerdictHistorySummaryCopyWith(VerdictHistorySummary value,
          $Res Function(VerdictHistorySummary) _then) =
      _$VerdictHistorySummaryCopyWithImpl;
  @useResult
  $Res call({int count, String? averageSeverity});
}

/// @nodoc
class _$VerdictHistorySummaryCopyWithImpl<$Res>
    implements $VerdictHistorySummaryCopyWith<$Res> {
  _$VerdictHistorySummaryCopyWithImpl(this._self, this._then);

  final VerdictHistorySummary _self;
  final $Res Function(VerdictHistorySummary) _then;

  /// Create a copy of VerdictHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? averageSeverity = freezed,
  }) {
    return _then(_self.copyWith(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageSeverity: freezed == averageSeverity
          ? _self.averageSeverity
          : averageSeverity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VerdictHistorySummary].
extension VerdictHistorySummaryPatterns on VerdictHistorySummary {
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
    TResult Function(_VerdictHistorySummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictHistorySummary() when $default != null:
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
    TResult Function(_VerdictHistorySummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistorySummary():
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
    TResult? Function(_VerdictHistorySummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistorySummary() when $default != null:
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
    TResult Function(int count, String? averageSeverity)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictHistorySummary() when $default != null:
        return $default(_that.count, _that.averageSeverity);
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
    TResult Function(int count, String? averageSeverity) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistorySummary():
        return $default(_that.count, _that.averageSeverity);
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
    TResult? Function(int count, String? averageSeverity)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistorySummary() when $default != null:
        return $default(_that.count, _that.averageSeverity);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VerdictHistorySummary implements VerdictHistorySummary {
  const _VerdictHistorySummary({this.count = 0, this.averageSeverity});

  /// 과거 섭취 기록 건수.
  @override
  @JsonKey()
  final int count;

  /// 평균 심각도 레이블. 서버 문자열 그대로. 없으면 null.
  @override
  final String? averageSeverity;

  /// Create a copy of VerdictHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerdictHistorySummaryCopyWith<_VerdictHistorySummary> get copyWith =>
      __$VerdictHistorySummaryCopyWithImpl<_VerdictHistorySummary>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerdictHistorySummary &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.averageSeverity, averageSeverity) ||
                other.averageSeverity == averageSeverity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, averageSeverity);

  @override
  String toString() {
    return 'VerdictHistorySummary(count: $count, averageSeverity: $averageSeverity)';
  }
}

/// @nodoc
abstract mixin class _$VerdictHistorySummaryCopyWith<$Res>
    implements $VerdictHistorySummaryCopyWith<$Res> {
  factory _$VerdictHistorySummaryCopyWith(_VerdictHistorySummary value,
          $Res Function(_VerdictHistorySummary) _then) =
      __$VerdictHistorySummaryCopyWithImpl;
  @override
  @useResult
  $Res call({int count, String? averageSeverity});
}

/// @nodoc
class __$VerdictHistorySummaryCopyWithImpl<$Res>
    implements _$VerdictHistorySummaryCopyWith<$Res> {
  __$VerdictHistorySummaryCopyWithImpl(this._self, this._then);

  final _VerdictHistorySummary _self;
  final $Res Function(_VerdictHistorySummary) _then;

  /// Create a copy of VerdictHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
    Object? averageSeverity = freezed,
  }) {
    return _then(_VerdictHistorySummary(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageSeverity: freezed == averageSeverity
          ? _self.averageSeverity
          : averageSeverity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
