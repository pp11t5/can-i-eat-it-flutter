// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_symptom_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSymptomDto {
  String get symptomId;
  String get symptomState;
  List<String> get symptomTypes;
  String get occurredAt;
  String get mealRecordId;
  int get afterMealMinutes;

  /// Create a copy of FoodSymptomDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodSymptomDtoCopyWith<FoodSymptomDto> get copyWith =>
      _$FoodSymptomDtoCopyWithImpl<FoodSymptomDto>(
          this as FoodSymptomDto, _$identity);

  /// Serializes this FoodSymptomDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodSymptomDto &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            const DeepCollectionEquality()
                .equals(other.symptomTypes, symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.afterMealMinutes, afterMealMinutes) ||
                other.afterMealMinutes == afterMealMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      const DeepCollectionEquality().hash(symptomTypes),
      occurredAt,
      mealRecordId,
      afterMealMinutes);

  @override
  String toString() {
    return 'FoodSymptomDto(symptomId: $symptomId, symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, afterMealMinutes: $afterMealMinutes)';
  }
}

/// @nodoc
abstract mixin class $FoodSymptomDtoCopyWith<$Res> {
  factory $FoodSymptomDtoCopyWith(
          FoodSymptomDto value, $Res Function(FoodSymptomDto) _then) =
      _$FoodSymptomDtoCopyWithImpl;
  @useResult
  $Res call(
      {String symptomId,
      String symptomState,
      List<String> symptomTypes,
      String occurredAt,
      String mealRecordId,
      int afterMealMinutes});
}

/// @nodoc
class _$FoodSymptomDtoCopyWithImpl<$Res>
    implements $FoodSymptomDtoCopyWith<$Res> {
  _$FoodSymptomDtoCopyWithImpl(this._self, this._then);

  final FoodSymptomDto _self;
  final $Res Function(FoodSymptomDto) _then;

  /// Create a copy of FoodSymptomDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? mealRecordId = null,
    Object? afterMealMinutes = null,
  }) {
    return _then(_self.copyWith(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self.symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      afterMealMinutes: null == afterMealMinutes
          ? _self.afterMealMinutes
          : afterMealMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodSymptomDto].
extension FoodSymptomDtoPatterns on FoodSymptomDto {
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
    TResult Function(_FoodSymptomDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSymptomDto() when $default != null:
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
    TResult Function(_FoodSymptomDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptomDto():
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
    TResult? Function(_FoodSymptomDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptomDto() when $default != null:
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
            String symptomId,
            String symptomState,
            List<String> symptomTypes,
            String occurredAt,
            String mealRecordId,
            int afterMealMinutes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSymptomDto() when $default != null:
        return $default(_that.symptomId, _that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.afterMealMinutes);
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
            String symptomId,
            String symptomState,
            List<String> symptomTypes,
            String occurredAt,
            String mealRecordId,
            int afterMealMinutes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptomDto():
        return $default(_that.symptomId, _that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.afterMealMinutes);
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
            String symptomId,
            String symptomState,
            List<String> symptomTypes,
            String occurredAt,
            String mealRecordId,
            int afterMealMinutes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptomDto() when $default != null:
        return $default(_that.symptomId, _that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.afterMealMinutes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FoodSymptomDto implements FoodSymptomDto {
  const _FoodSymptomDto(
      {required this.symptomId,
      required this.symptomState,
      final List<String> symptomTypes = const <String>[],
      required this.occurredAt,
      required this.mealRecordId,
      this.afterMealMinutes = 0})
      : _symptomTypes = symptomTypes;
  factory _FoodSymptomDto.fromJson(Map<String, dynamic> json) =>
      _$FoodSymptomDtoFromJson(json);

  @override
  final String symptomId;
  @override
  final String symptomState;
  final List<String> _symptomTypes;
  @override
  @JsonKey()
  List<String> get symptomTypes {
    if (_symptomTypes is EqualUnmodifiableListView) return _symptomTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomTypes);
  }

  @override
  final String occurredAt;
  @override
  final String mealRecordId;
  @override
  @JsonKey()
  final int afterMealMinutes;

  /// Create a copy of FoodSymptomDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodSymptomDtoCopyWith<_FoodSymptomDto> get copyWith =>
      __$FoodSymptomDtoCopyWithImpl<_FoodSymptomDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FoodSymptomDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodSymptomDto &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            const DeepCollectionEquality()
                .equals(other._symptomTypes, _symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.afterMealMinutes, afterMealMinutes) ||
                other.afterMealMinutes == afterMealMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      const DeepCollectionEquality().hash(_symptomTypes),
      occurredAt,
      mealRecordId,
      afterMealMinutes);

  @override
  String toString() {
    return 'FoodSymptomDto(symptomId: $symptomId, symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, afterMealMinutes: $afterMealMinutes)';
  }
}

/// @nodoc
abstract mixin class _$FoodSymptomDtoCopyWith<$Res>
    implements $FoodSymptomDtoCopyWith<$Res> {
  factory _$FoodSymptomDtoCopyWith(
          _FoodSymptomDto value, $Res Function(_FoodSymptomDto) _then) =
      __$FoodSymptomDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomId,
      String symptomState,
      List<String> symptomTypes,
      String occurredAt,
      String mealRecordId,
      int afterMealMinutes});
}

/// @nodoc
class __$FoodSymptomDtoCopyWithImpl<$Res>
    implements _$FoodSymptomDtoCopyWith<$Res> {
  __$FoodSymptomDtoCopyWithImpl(this._self, this._then);

  final _FoodSymptomDto _self;
  final $Res Function(_FoodSymptomDto) _then;

  /// Create a copy of FoodSymptomDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? mealRecordId = null,
    Object? afterMealMinutes = null,
  }) {
    return _then(_FoodSymptomDto(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self._symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      afterMealMinutes: null == afterMealMinutes
          ? _self.afterMealMinutes
          : afterMealMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
