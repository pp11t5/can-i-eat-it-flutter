// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSearchResult {
  List<FoodSummary> get foods;
  bool get hasExactMatch;

  /// Create a copy of FoodSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodSearchResultCopyWith<FoodSearchResult> get copyWith =>
      _$FoodSearchResultCopyWithImpl<FoodSearchResult>(
          this as FoodSearchResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodSearchResult &&
            const DeepCollectionEquality().equals(other.foods, foods) &&
            (identical(other.hasExactMatch, hasExactMatch) ||
                other.hasExactMatch == hasExactMatch));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(foods), hasExactMatch);

  @override
  String toString() {
    return 'FoodSearchResult(foods: $foods, hasExactMatch: $hasExactMatch)';
  }
}

/// @nodoc
abstract mixin class $FoodSearchResultCopyWith<$Res> {
  factory $FoodSearchResultCopyWith(
          FoodSearchResult value, $Res Function(FoodSearchResult) _then) =
      _$FoodSearchResultCopyWithImpl;
  @useResult
  $Res call({List<FoodSummary> foods, bool hasExactMatch});
}

/// @nodoc
class _$FoodSearchResultCopyWithImpl<$Res>
    implements $FoodSearchResultCopyWith<$Res> {
  _$FoodSearchResultCopyWithImpl(this._self, this._then);

  final FoodSearchResult _self;
  final $Res Function(FoodSearchResult) _then;

  /// Create a copy of FoodSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foods = null,
    Object? hasExactMatch = null,
  }) {
    return _then(_self.copyWith(
      foods: null == foods
          ? _self.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodSummary>,
      hasExactMatch: null == hasExactMatch
          ? _self.hasExactMatch
          : hasExactMatch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodSearchResult].
extension FoodSearchResultPatterns on FoodSearchResult {
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
    TResult Function(_FoodSearchResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResult() when $default != null:
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
    TResult Function(_FoodSearchResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResult():
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
    TResult? Function(_FoodSearchResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResult() when $default != null:
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
    TResult Function(List<FoodSummary> foods, bool hasExactMatch)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResult() when $default != null:
        return $default(_that.foods, _that.hasExactMatch);
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
    TResult Function(List<FoodSummary> foods, bool hasExactMatch) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResult():
        return $default(_that.foods, _that.hasExactMatch);
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
    TResult? Function(List<FoodSummary> foods, bool hasExactMatch)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResult() when $default != null:
        return $default(_that.foods, _that.hasExactMatch);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodSearchResult implements FoodSearchResult {
  const _FoodSearchResult(
      {final List<FoodSummary> foods = const <FoodSummary>[],
      this.hasExactMatch = false})
      : _foods = foods;

  final List<FoodSummary> _foods;
  @override
  @JsonKey()
  List<FoodSummary> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  @JsonKey()
  final bool hasExactMatch;

  /// Create a copy of FoodSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodSearchResultCopyWith<_FoodSearchResult> get copyWith =>
      __$FoodSearchResultCopyWithImpl<_FoodSearchResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodSearchResult &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.hasExactMatch, hasExactMatch) ||
                other.hasExactMatch == hasExactMatch));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_foods), hasExactMatch);

  @override
  String toString() {
    return 'FoodSearchResult(foods: $foods, hasExactMatch: $hasExactMatch)';
  }
}

/// @nodoc
abstract mixin class _$FoodSearchResultCopyWith<$Res>
    implements $FoodSearchResultCopyWith<$Res> {
  factory _$FoodSearchResultCopyWith(
          _FoodSearchResult value, $Res Function(_FoodSearchResult) _then) =
      __$FoodSearchResultCopyWithImpl;
  @override
  @useResult
  $Res call({List<FoodSummary> foods, bool hasExactMatch});
}

/// @nodoc
class __$FoodSearchResultCopyWithImpl<$Res>
    implements _$FoodSearchResultCopyWith<$Res> {
  __$FoodSearchResultCopyWithImpl(this._self, this._then);

  final _FoodSearchResult _self;
  final $Res Function(_FoodSearchResult) _then;

  /// Create a copy of FoodSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foods = null,
    Object? hasExactMatch = null,
  }) {
    return _then(_FoodSearchResult(
      foods: null == foods
          ? _self._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodSummary>,
      hasExactMatch: null == hasExactMatch
          ? _self.hasExactMatch
          : hasExactMatch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
