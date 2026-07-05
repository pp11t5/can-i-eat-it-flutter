// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_symptom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSymptom {
  String get symptomId;
  SymptomState get symptomState;
  List<String> get symptomTypes;
  String get occurredAt;
  String get mealRecordId;
  int get afterMealMinutes;

  /// Create a copy of FoodSymptom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodSymptomCopyWith<FoodSymptom> get copyWith =>
      _$FoodSymptomCopyWithImpl<FoodSymptom>(this as FoodSymptom, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodSymptom &&
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
    return 'FoodSymptom(symptomId: $symptomId, symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, afterMealMinutes: $afterMealMinutes)';
  }
}

/// @nodoc
abstract mixin class $FoodSymptomCopyWith<$Res> {
  factory $FoodSymptomCopyWith(
          FoodSymptom value, $Res Function(FoodSymptom) _then) =
      _$FoodSymptomCopyWithImpl;
  @useResult
  $Res call(
      {String symptomId,
      SymptomState symptomState,
      List<String> symptomTypes,
      String occurredAt,
      String mealRecordId,
      int afterMealMinutes});
}

/// @nodoc
class _$FoodSymptomCopyWithImpl<$Res> implements $FoodSymptomCopyWith<$Res> {
  _$FoodSymptomCopyWithImpl(this._self, this._then);

  final FoodSymptom _self;
  final $Res Function(FoodSymptom) _then;

  /// Create a copy of FoodSymptom
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
              as SymptomState,
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

/// Adds pattern-matching-related methods to [FoodSymptom].
extension FoodSymptomPatterns on FoodSymptom {
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
    TResult Function(_FoodSymptom value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSymptom() when $default != null:
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
    TResult Function(_FoodSymptom value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptom():
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
    TResult? Function(_FoodSymptom value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptom() when $default != null:
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
            SymptomState symptomState,
            List<String> symptomTypes,
            String occurredAt,
            String mealRecordId,
            int afterMealMinutes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSymptom() when $default != null:
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
            SymptomState symptomState,
            List<String> symptomTypes,
            String occurredAt,
            String mealRecordId,
            int afterMealMinutes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptom():
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
            SymptomState symptomState,
            List<String> symptomTypes,
            String occurredAt,
            String mealRecordId,
            int afterMealMinutes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSymptom() when $default != null:
        return $default(_that.symptomId, _that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.afterMealMinutes);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodSymptom implements FoodSymptom {
  const _FoodSymptom(
      {required this.symptomId,
      required this.symptomState,
      final List<String> symptomTypes = const <String>[],
      required this.occurredAt,
      required this.mealRecordId,
      this.afterMealMinutes = 0})
      : _symptomTypes = symptomTypes;

  @override
  final String symptomId;
  @override
  final SymptomState symptomState;
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

  /// Create a copy of FoodSymptom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodSymptomCopyWith<_FoodSymptom> get copyWith =>
      __$FoodSymptomCopyWithImpl<_FoodSymptom>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodSymptom &&
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
    return 'FoodSymptom(symptomId: $symptomId, symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, afterMealMinutes: $afterMealMinutes)';
  }
}

/// @nodoc
abstract mixin class _$FoodSymptomCopyWith<$Res>
    implements $FoodSymptomCopyWith<$Res> {
  factory _$FoodSymptomCopyWith(
          _FoodSymptom value, $Res Function(_FoodSymptom) _then) =
      __$FoodSymptomCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomId,
      SymptomState symptomState,
      List<String> symptomTypes,
      String occurredAt,
      String mealRecordId,
      int afterMealMinutes});
}

/// @nodoc
class __$FoodSymptomCopyWithImpl<$Res> implements _$FoodSymptomCopyWith<$Res> {
  __$FoodSymptomCopyWithImpl(this._self, this._then);

  final _FoodSymptom _self;
  final $Res Function(_FoodSymptom) _then;

  /// Create a copy of FoodSymptom
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
    return _then(_FoodSymptom(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as SymptomState,
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
