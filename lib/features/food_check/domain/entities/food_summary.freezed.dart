// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSummary {
  /// 서버측 음식 식별자.
  String get externalId;

  /// 음식 표시 이름.
  String get name;

  /// 음식 카테고리. 예: '한식'. 서버가 없으면 null.
  String? get category;

  /// Create a copy of FoodSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodSummaryCopyWith<FoodSummary> get copyWith =>
      _$FoodSummaryCopyWithImpl<FoodSummary>(this as FoodSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodSummary &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, externalId, name, category);

  @override
  String toString() {
    return 'FoodSummary(externalId: $externalId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class $FoodSummaryCopyWith<$Res> {
  factory $FoodSummaryCopyWith(
          FoodSummary value, $Res Function(FoodSummary) _then) =
      _$FoodSummaryCopyWithImpl;
  @useResult
  $Res call({String externalId, String name, String? category});
}

/// @nodoc
class _$FoodSummaryCopyWithImpl<$Res> implements $FoodSummaryCopyWith<$Res> {
  _$FoodSummaryCopyWithImpl(this._self, this._then);

  final FoodSummary _self;
  final $Res Function(FoodSummary) _then;

  /// Create a copy of FoodSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_self.copyWith(
      externalId: null == externalId
          ? _self.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodSummary].
extension FoodSummaryPatterns on FoodSummary {
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
    TResult Function(_FoodSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSummary() when $default != null:
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
    TResult Function(_FoodSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummary():
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
    TResult? Function(_FoodSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummary() when $default != null:
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
    TResult Function(String externalId, String name, String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSummary() when $default != null:
        return $default(_that.externalId, _that.name, _that.category);
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
    TResult Function(String externalId, String name, String? category) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummary():
        return $default(_that.externalId, _that.name, _that.category);
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
    TResult? Function(String externalId, String name, String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummary() when $default != null:
        return $default(_that.externalId, _that.name, _that.category);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodSummary implements FoodSummary {
  const _FoodSummary(
      {required this.externalId, required this.name, this.category});

  /// 서버측 음식 식별자.
  @override
  final String externalId;

  /// 음식 표시 이름.
  @override
  final String name;

  /// 음식 카테고리. 예: '한식'. 서버가 없으면 null.
  @override
  final String? category;

  /// Create a copy of FoodSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodSummaryCopyWith<_FoodSummary> get copyWith =>
      __$FoodSummaryCopyWithImpl<_FoodSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodSummary &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, externalId, name, category);

  @override
  String toString() {
    return 'FoodSummary(externalId: $externalId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$FoodSummaryCopyWith<$Res>
    implements $FoodSummaryCopyWith<$Res> {
  factory _$FoodSummaryCopyWith(
          _FoodSummary value, $Res Function(_FoodSummary) _then) =
      __$FoodSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({String externalId, String name, String? category});
}

/// @nodoc
class __$FoodSummaryCopyWithImpl<$Res> implements _$FoodSummaryCopyWith<$Res> {
  __$FoodSummaryCopyWithImpl(this._self, this._then);

  final _FoodSummary _self;
  final $Res Function(_FoodSummary) _then;

  /// Create a copy of FoodSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_FoodSummary(
      externalId: null == externalId
          ? _self.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
