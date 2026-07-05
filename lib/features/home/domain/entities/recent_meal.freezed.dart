// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentMeal {
  String get foodName;

  /// 음식 카테고리 코드. 서버가 없으면 null.
  String? get category;
  String get eatenAt;

  /// 연결된 증상 상태. 증상 기록이 없으면 null.
  SymptomState? get symptomState;

  /// Create a copy of RecentMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecentMealCopyWith<RecentMeal> get copyWith =>
      _$RecentMealCopyWithImpl<RecentMeal>(this as RecentMeal, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecentMeal &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodName, category, eatenAt, symptomState);

  @override
  String toString() {
    return 'RecentMeal(foodName: $foodName, category: $category, eatenAt: $eatenAt, symptomState: $symptomState)';
  }
}

/// @nodoc
abstract mixin class $RecentMealCopyWith<$Res> {
  factory $RecentMealCopyWith(
          RecentMeal value, $Res Function(RecentMeal) _then) =
      _$RecentMealCopyWithImpl;
  @useResult
  $Res call(
      {String foodName,
      String? category,
      String eatenAt,
      SymptomState? symptomState});
}

/// @nodoc
class _$RecentMealCopyWithImpl<$Res> implements $RecentMealCopyWith<$Res> {
  _$RecentMealCopyWithImpl(this._self, this._then);

  final RecentMeal _self;
  final $Res Function(RecentMeal) _then;

  /// Create a copy of RecentMeal
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
              as SymptomState?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecentMeal].
extension RecentMealPatterns on RecentMeal {
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
    TResult Function(_RecentMeal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentMeal() when $default != null:
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
    TResult Function(_RecentMeal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMeal():
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
    TResult? Function(_RecentMeal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMeal() when $default != null:
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
            SymptomState? symptomState)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentMeal() when $default != null:
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
            SymptomState? symptomState)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMeal():
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
            SymptomState? symptomState)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentMeal() when $default != null:
        return $default(
            _that.foodName, _that.category, _that.eatenAt, _that.symptomState);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RecentMeal implements RecentMeal {
  const _RecentMeal(
      {required this.foodName,
      this.category,
      required this.eatenAt,
      this.symptomState});

  @override
  final String foodName;

  /// 음식 카테고리 코드. 서버가 없으면 null.
  @override
  final String? category;
  @override
  final String eatenAt;

  /// 연결된 증상 상태. 증상 기록이 없으면 null.
  @override
  final SymptomState? symptomState;

  /// Create a copy of RecentMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecentMealCopyWith<_RecentMeal> get copyWith =>
      __$RecentMealCopyWithImpl<_RecentMeal>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecentMeal &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodName, category, eatenAt, symptomState);

  @override
  String toString() {
    return 'RecentMeal(foodName: $foodName, category: $category, eatenAt: $eatenAt, symptomState: $symptomState)';
  }
}

/// @nodoc
abstract mixin class _$RecentMealCopyWith<$Res>
    implements $RecentMealCopyWith<$Res> {
  factory _$RecentMealCopyWith(
          _RecentMeal value, $Res Function(_RecentMeal) _then) =
      __$RecentMealCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodName,
      String? category,
      String eatenAt,
      SymptomState? symptomState});
}

/// @nodoc
class __$RecentMealCopyWithImpl<$Res> implements _$RecentMealCopyWith<$Res> {
  __$RecentMealCopyWithImpl(this._self, this._then);

  final _RecentMeal _self;
  final $Res Function(_RecentMeal) _then;

  /// Create a copy of RecentMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodName = null,
    Object? category = freezed,
    Object? eatenAt = null,
    Object? symptomState = freezed,
  }) {
    return _then(_RecentMeal(
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
              as SymptomState?,
    ));
  }
}

// dart format on
