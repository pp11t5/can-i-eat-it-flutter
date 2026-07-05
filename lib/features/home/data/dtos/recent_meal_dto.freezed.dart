// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_meal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentMealDto {
  String get foodName;
  String? get category;
  String get eatenAt;
  String? get symptomState;

  /// Create a copy of RecentMealDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecentMealDtoCopyWith<RecentMealDto> get copyWith =>
      _$RecentMealDtoCopyWithImpl<RecentMealDto>(
          this as RecentMealDto, _$identity);

  /// Serializes this RecentMealDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecentMealDto &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, foodName, category, eatenAt, symptomState);

  @override
  String toString() {
    return 'RecentMealDto(foodName: $foodName, category: $category, eatenAt: $eatenAt, symptomState: $symptomState)';
  }
}

/// @nodoc
abstract mixin class $RecentMealDtoCopyWith<$Res> {
  factory $RecentMealDtoCopyWith(
          RecentMealDto value, $Res Function(RecentMealDto) _then) =
      _$RecentMealDtoCopyWithImpl;
  @useResult
  $Res call(
      {String foodName,
      String? category,
      String eatenAt,
      String? symptomState});
}

/// @nodoc
class _$RecentMealDtoCopyWithImpl<$Res>
    implements $RecentMealDtoCopyWith<$Res> {
  _$RecentMealDtoCopyWithImpl(this._self, this._then);

  final RecentMealDto _self;
  final $Res Function(RecentMealDto) _then;

  /// Create a copy of RecentMealDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? category = freezed,
    Object? eatenAt = null,
    Object? symptomState = freezed,
  }) {
    return _then(_self.copyWith(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: freezed == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecentMealDto].
extension RecentMealDtoPatterns on RecentMealDto {
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
    TResult Function(_RecentMealDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentMealDto() when $default != null:
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
    TResult Function(_RecentMealDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMealDto():
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
    TResult? Function(_RecentMealDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMealDto() when $default != null:
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
    TResult Function(String foodName, String? category, String eatenAt,
            String? symptomState)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentMealDto() when $default != null:
        return $default(
            _that.foodName, _that.category, _that.eatenAt, _that.symptomState);
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
    TResult Function(String foodName, String? category, String eatenAt,
            String? symptomState)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMealDto():
        return $default(
            _that.foodName, _that.category, _that.eatenAt, _that.symptomState);
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
    TResult? Function(String foodName, String? category, String eatenAt,
            String? symptomState)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMealDto() when $default != null:
        return $default(
            _that.foodName, _that.category, _that.eatenAt, _that.symptomState);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecentMealDto implements RecentMealDto {
  const _RecentMealDto(
      {required this.foodName,
      this.category,
      required this.eatenAt,
      this.symptomState});
  factory _RecentMealDto.fromJson(Map<String, dynamic> json) =>
      _$RecentMealDtoFromJson(json);

  @override
  final String foodName;
  @override
  final String? category;
  @override
  final String eatenAt;
  @override
  final String? symptomState;

  /// Create a copy of RecentMealDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecentMealDtoCopyWith<_RecentMealDto> get copyWith =>
      __$RecentMealDtoCopyWithImpl<_RecentMealDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecentMealDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecentMealDto &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, foodName, category, eatenAt, symptomState);

  @override
  String toString() {
    return 'RecentMealDto(foodName: $foodName, category: $category, eatenAt: $eatenAt, symptomState: $symptomState)';
  }
}

/// @nodoc
abstract mixin class _$RecentMealDtoCopyWith<$Res>
    implements $RecentMealDtoCopyWith<$Res> {
  factory _$RecentMealDtoCopyWith(
          _RecentMealDto value, $Res Function(_RecentMealDto) _then) =
      __$RecentMealDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodName,
      String? category,
      String eatenAt,
      String? symptomState});
}

/// @nodoc
class __$RecentMealDtoCopyWithImpl<$Res>
    implements _$RecentMealDtoCopyWith<$Res> {
  __$RecentMealDtoCopyWithImpl(this._self, this._then);

  final _RecentMealDto _self;
  final $Res Function(_RecentMealDto) _then;

  /// Create a copy of RecentMealDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodName = null,
    Object? category = freezed,
    Object? eatenAt = null,
    Object? symptomState = freezed,
  }) {
    return _then(_RecentMealDto(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: freezed == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
