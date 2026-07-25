// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_search_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSearchResultDto {
  List<FoodSummaryDto> get foods;
  bool get hasExactMatch;

  /// Create a copy of FoodSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodSearchResultDtoCopyWith<FoodSearchResultDto> get copyWith =>
      _$FoodSearchResultDtoCopyWithImpl<FoodSearchResultDto>(
          this as FoodSearchResultDto, _$identity);

  /// Serializes this FoodSearchResultDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodSearchResultDto &&
            const DeepCollectionEquality().equals(other.foods, foods) &&
            (identical(other.hasExactMatch, hasExactMatch) ||
                other.hasExactMatch == hasExactMatch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(foods), hasExactMatch);

  @override
  String toString() {
    return 'FoodSearchResultDto(foods: $foods, hasExactMatch: $hasExactMatch)';
  }
}

/// @nodoc
abstract mixin class $FoodSearchResultDtoCopyWith<$Res> {
  factory $FoodSearchResultDtoCopyWith(
          FoodSearchResultDto value, $Res Function(FoodSearchResultDto) _then) =
      _$FoodSearchResultDtoCopyWithImpl;
  @useResult
  $Res call({List<FoodSummaryDto> foods, bool hasExactMatch});
}

/// @nodoc
class _$FoodSearchResultDtoCopyWithImpl<$Res>
    implements $FoodSearchResultDtoCopyWith<$Res> {
  _$FoodSearchResultDtoCopyWithImpl(this._self, this._then);

  final FoodSearchResultDto _self;
  final $Res Function(FoodSearchResultDto) _then;

  /// Create a copy of FoodSearchResultDto
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
              as List<FoodSummaryDto>,
      hasExactMatch: null == hasExactMatch
          ? _self.hasExactMatch
          : hasExactMatch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodSearchResultDto].
extension FoodSearchResultDtoPatterns on FoodSearchResultDto {
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
    TResult Function(_FoodSearchResultDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResultDto() when $default != null:
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
    TResult Function(_FoodSearchResultDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResultDto():
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
    TResult? Function(_FoodSearchResultDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResultDto() when $default != null:
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
    TResult Function(List<FoodSummaryDto> foods, bool hasExactMatch)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResultDto() when $default != null:
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
    TResult Function(List<FoodSummaryDto> foods, bool hasExactMatch) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResultDto():
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
    TResult? Function(List<FoodSummaryDto> foods, bool hasExactMatch)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSearchResultDto() when $default != null:
        return $default(_that.foods, _that.hasExactMatch);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FoodSearchResultDto implements FoodSearchResultDto {
  const _FoodSearchResultDto(
      {final List<FoodSummaryDto> foods = const <FoodSummaryDto>[],
      this.hasExactMatch = false})
      : _foods = foods;
  factory _FoodSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$FoodSearchResultDtoFromJson(json);

  final List<FoodSummaryDto> _foods;
  @override
  @JsonKey()
  List<FoodSummaryDto> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  @JsonKey()
  final bool hasExactMatch;

  /// Create a copy of FoodSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodSearchResultDtoCopyWith<_FoodSearchResultDto> get copyWith =>
      __$FoodSearchResultDtoCopyWithImpl<_FoodSearchResultDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FoodSearchResultDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodSearchResultDto &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.hasExactMatch, hasExactMatch) ||
                other.hasExactMatch == hasExactMatch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_foods), hasExactMatch);

  @override
  String toString() {
    return 'FoodSearchResultDto(foods: $foods, hasExactMatch: $hasExactMatch)';
  }
}

/// @nodoc
abstract mixin class _$FoodSearchResultDtoCopyWith<$Res>
    implements $FoodSearchResultDtoCopyWith<$Res> {
  factory _$FoodSearchResultDtoCopyWith(_FoodSearchResultDto value,
          $Res Function(_FoodSearchResultDto) _then) =
      __$FoodSearchResultDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<FoodSummaryDto> foods, bool hasExactMatch});
}

/// @nodoc
class __$FoodSearchResultDtoCopyWithImpl<$Res>
    implements _$FoodSearchResultDtoCopyWith<$Res> {
  __$FoodSearchResultDtoCopyWithImpl(this._self, this._then);

  final _FoodSearchResultDto _self;
  final $Res Function(_FoodSearchResultDto) _then;

  /// Create a copy of FoodSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foods = null,
    Object? hasExactMatch = null,
  }) {
    return _then(_FoodSearchResultDto(
      foods: null == foods
          ? _self._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodSummaryDto>,
      hasExactMatch: null == hasExactMatch
          ? _self.hasExactMatch
          : hasExactMatch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
