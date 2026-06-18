// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StateRecord {
  /// 증상 라벨 (예: '속쓰림').
  String get label;

  /// 기록 날짜 ('YYYY-MM-DD' 문자열 그대로).
  String get date;

  /// 섭취 시점 (예: '식후 30분').
  String get timing;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateRecordCopyWith<StateRecord> get copyWith =>
      _$StateRecordCopyWithImpl<StateRecord>(this as StateRecord, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateRecord &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, date, timing);

  @override
  String toString() {
    return 'StateRecord(label: $label, date: $date, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class $StateRecordCopyWith<$Res> {
  factory $StateRecordCopyWith(
          StateRecord value, $Res Function(StateRecord) _then) =
      _$StateRecordCopyWithImpl;
  @useResult
  $Res call({String label, String date, String timing});
}

/// @nodoc
class _$StateRecordCopyWithImpl<$Res> implements $StateRecordCopyWith<$Res> {
  _$StateRecordCopyWithImpl(this._self, this._then);

  final StateRecord _self;
  final $Res Function(StateRecord) _then;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? date = null,
    Object? timing = null,
  }) {
    return _then(_self.copyWith(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _self.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [StateRecord].
extension StateRecordPatterns on StateRecord {
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
    TResult Function(_StateRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecord() when $default != null:
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
    TResult Function(_StateRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecord():
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
    TResult? Function(_StateRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecord() when $default != null:
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
    TResult Function(String label, String date, String timing)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecord() when $default != null:
        return $default(_that.label, _that.date, _that.timing);
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
    TResult Function(String label, String date, String timing) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecord():
        return $default(_that.label, _that.date, _that.timing);
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
    TResult? Function(String label, String date, String timing)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecord() when $default != null:
        return $default(_that.label, _that.date, _that.timing);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StateRecord implements StateRecord {
  const _StateRecord(
      {required this.label, required this.date, required this.timing});

  /// 증상 라벨 (예: '속쓰림').
  @override
  final String label;

  /// 기록 날짜 ('YYYY-MM-DD' 문자열 그대로).
  @override
  final String date;

  /// 섭취 시점 (예: '식후 30분').
  @override
  final String timing;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StateRecordCopyWith<_StateRecord> get copyWith =>
      __$StateRecordCopyWithImpl<_StateRecord>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StateRecord &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, date, timing);

  @override
  String toString() {
    return 'StateRecord(label: $label, date: $date, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class _$StateRecordCopyWith<$Res>
    implements $StateRecordCopyWith<$Res> {
  factory _$StateRecordCopyWith(
          _StateRecord value, $Res Function(_StateRecord) _then) =
      __$StateRecordCopyWithImpl;
  @override
  @useResult
  $Res call({String label, String date, String timing});
}

/// @nodoc
class __$StateRecordCopyWithImpl<$Res> implements _$StateRecordCopyWith<$Res> {
  __$StateRecordCopyWithImpl(this._self, this._then);

  final _StateRecord _self;
  final $Res Function(_StateRecord) _then;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? date = null,
    Object? timing = null,
  }) {
    return _then(_StateRecord(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _self.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$MealFood {
  /// 서버측 음식 식별자.
  String get externalId;

  /// 음식 표시 이름.
  String get name;

  /// 음식 카테고리. 서버가 없으면 null.
  String? get category;

  /// 음식 설명. 서버가 없으면 null.
  String? get description;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealFoodCopyWith<MealFood> get copyWith =>
      _$MealFoodCopyWithImpl<MealFood>(this as MealFood, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealFood &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, externalId, name, category, description);

  @override
  String toString() {
    return 'MealFood(externalId: $externalId, name: $name, category: $category, description: $description)';
  }
}

/// @nodoc
abstract mixin class $MealFoodCopyWith<$Res> {
  factory $MealFoodCopyWith(MealFood value, $Res Function(MealFood) _then) =
      _$MealFoodCopyWithImpl;
  @useResult
  $Res call(
      {String externalId, String name, String? category, String? description});
}

/// @nodoc
class _$MealFoodCopyWithImpl<$Res> implements $MealFoodCopyWith<$Res> {
  _$MealFoodCopyWithImpl(this._self, this._then);

  final MealFood _self;
  final $Res Function(MealFood) _then;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
    Object? description = freezed,
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
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealFood].
extension MealFoodPatterns on MealFood {
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
    TResult Function(_MealFood value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
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
    TResult Function(_MealFood value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood():
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
    TResult? Function(_MealFood value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
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
    TResult Function(String externalId, String name, String? category,
            String? description)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
        return $default(
            _that.externalId, _that.name, _that.category, _that.description);
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
    TResult Function(String externalId, String name, String? category,
            String? description)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood():
        return $default(
            _that.externalId, _that.name, _that.category, _that.description);
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
    TResult? Function(String externalId, String name, String? category,
            String? description)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
        return $default(
            _that.externalId, _that.name, _that.category, _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealFood implements MealFood {
  const _MealFood(
      {required this.externalId,
      required this.name,
      this.category,
      this.description});

  /// 서버측 음식 식별자.
  @override
  final String externalId;

  /// 음식 표시 이름.
  @override
  final String name;

  /// 음식 카테고리. 서버가 없으면 null.
  @override
  final String? category;

  /// 음식 설명. 서버가 없으면 null.
  @override
  final String? description;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealFoodCopyWith<_MealFood> get copyWith =>
      __$MealFoodCopyWithImpl<_MealFood>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealFood &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, externalId, name, category, description);

  @override
  String toString() {
    return 'MealFood(externalId: $externalId, name: $name, category: $category, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$MealFoodCopyWith<$Res>
    implements $MealFoodCopyWith<$Res> {
  factory _$MealFoodCopyWith(_MealFood value, $Res Function(_MealFood) _then) =
      __$MealFoodCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String externalId, String name, String? category, String? description});
}

/// @nodoc
class __$MealFoodCopyWithImpl<$Res> implements _$MealFoodCopyWith<$Res> {
  __$MealFoodCopyWithImpl(this._self, this._then);

  final _MealFood _self;
  final $Res Function(_MealFood) _then;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
    Object? description = freezed,
  }) {
    return _then(_MealFood(
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
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$MealRecord {
  /// 식사 기록 식별자.
  String get mealId;

  /// 소속 끼니 그룹 식별자.
  String get mealGroupId;

  /// 섭취 시각 (ISO-8601 문자열 그대로).
  String get eatenAt;

  /// 음식 요약 정보.
  FoodSummary get food;

  /// 판정 등급. 미판정이면 null.
  VerdictLevel? get judgedGrade;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealRecordCopyWith<MealRecord> get copyWith =>
      _$MealRecordCopyWithImpl<MealRecord>(this as MealRecord, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealRecord &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, mealId, mealGroupId, eatenAt, food, judgedGrade);

  @override
  String toString() {
    return 'MealRecord(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, food: $food, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class $MealRecordCopyWith<$Res> {
  factory $MealRecordCopyWith(
          MealRecord value, $Res Function(MealRecord) _then) =
      _$MealRecordCopyWithImpl;
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      FoodSummary food,
      VerdictLevel? judgedGrade});

  $FoodSummaryCopyWith<$Res> get food;
}

/// @nodoc
class _$MealRecordCopyWithImpl<$Res> implements $MealRecordCopyWith<$Res> {
  _$MealRecordCopyWithImpl(this._self, this._then);

  final MealRecord _self;
  final $Res Function(MealRecord) _then;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealId = null,
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? food = null,
    Object? judgedGrade = freezed,
  }) {
    return _then(_self.copyWith(
      mealId: null == mealId
          ? _self.mealId
          : mealId // ignore: cast_nullable_to_non_nullable
              as String,
      mealGroupId: null == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as FoodSummary,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel?,
    ));
  }

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodSummaryCopyWith<$Res> get food {
    return $FoodSummaryCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealRecord].
extension MealRecordPatterns on MealRecord {
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
    TResult Function(_MealRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
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
    TResult Function(_MealRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord():
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
    TResult? Function(_MealRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
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
    TResult Function(String mealId, String mealGroupId, String eatenAt,
            FoodSummary food, VerdictLevel? judgedGrade)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.food, _that.judgedGrade);
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
    TResult Function(String mealId, String mealGroupId, String eatenAt,
            FoodSummary food, VerdictLevel? judgedGrade)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord():
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.food, _that.judgedGrade);
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
    TResult? Function(String mealId, String mealGroupId, String eatenAt,
            FoodSummary food, VerdictLevel? judgedGrade)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.food, _that.judgedGrade);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealRecord implements MealRecord {
  const _MealRecord(
      {required this.mealId,
      required this.mealGroupId,
      required this.eatenAt,
      required this.food,
      this.judgedGrade});

  /// 식사 기록 식별자.
  @override
  final String mealId;

  /// 소속 끼니 그룹 식별자.
  @override
  final String mealGroupId;

  /// 섭취 시각 (ISO-8601 문자열 그대로).
  @override
  final String eatenAt;

  /// 음식 요약 정보.
  @override
  final FoodSummary food;

  /// 판정 등급. 미판정이면 null.
  @override
  final VerdictLevel? judgedGrade;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealRecordCopyWith<_MealRecord> get copyWith =>
      __$MealRecordCopyWithImpl<_MealRecord>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealRecord &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, mealId, mealGroupId, eatenAt, food, judgedGrade);

  @override
  String toString() {
    return 'MealRecord(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, food: $food, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class _$MealRecordCopyWith<$Res>
    implements $MealRecordCopyWith<$Res> {
  factory _$MealRecordCopyWith(
          _MealRecord value, $Res Function(_MealRecord) _then) =
      __$MealRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      FoodSummary food,
      VerdictLevel? judgedGrade});

  @override
  $FoodSummaryCopyWith<$Res> get food;
}

/// @nodoc
class __$MealRecordCopyWithImpl<$Res> implements _$MealRecordCopyWith<$Res> {
  __$MealRecordCopyWithImpl(this._self, this._then);

  final _MealRecord _self;
  final $Res Function(_MealRecord) _then;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealId = null,
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? food = null,
    Object? judgedGrade = freezed,
  }) {
    return _then(_MealRecord(
      mealId: null == mealId
          ? _self.mealId
          : mealId // ignore: cast_nullable_to_non_nullable
              as String,
      mealGroupId: null == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as FoodSummary,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel?,
    ));
  }

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodSummaryCopyWith<$Res> get food {
    return $FoodSummaryCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// @nodoc
mixin _$MealDetail {
  /// 식사 기록 식별자.
  String get mealId;

  /// 소속 끼니 그룹 식별자.
  String get mealGroupId;

  /// 섭취 시각 (ISO-8601 문자열 그대로).
  String get eatenAt;

  /// 메모. null 또는 빈 문자열이면 미작성 상태.
  String? get memo;

  /// 판정 등급. 미판정이면 null.
  VerdictLevel? get judgedGrade;

  /// 음식 상세 정보.
  MealFood get food;

  /// 연관 증상 기록 목록 (읽기전용).
  List<StateRecord> get stateRecords;

  /// Create a copy of MealDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealDetailCopyWith<MealDetail> get copyWith =>
      _$MealDetailCopyWithImpl<MealDetail>(this as MealDetail, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealDetail &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade) &&
            (identical(other.food, food) || other.food == food) &&
            const DeepCollectionEquality()
                .equals(other.stateRecords, stateRecords));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealId,
      mealGroupId,
      eatenAt,
      memo,
      judgedGrade,
      food,
      const DeepCollectionEquality().hash(stateRecords));

  @override
  String toString() {
    return 'MealDetail(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, memo: $memo, judgedGrade: $judgedGrade, food: $food, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class $MealDetailCopyWith<$Res> {
  factory $MealDetailCopyWith(
          MealDetail value, $Res Function(MealDetail) _then) =
      _$MealDetailCopyWithImpl;
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      String? memo,
      VerdictLevel? judgedGrade,
      MealFood food,
      List<StateRecord> stateRecords});

  $MealFoodCopyWith<$Res> get food;
}

/// @nodoc
class _$MealDetailCopyWithImpl<$Res> implements $MealDetailCopyWith<$Res> {
  _$MealDetailCopyWithImpl(this._self, this._then);

  final MealDetail _self;
  final $Res Function(MealDetail) _then;

  /// Create a copy of MealDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealId = null,
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? memo = freezed,
    Object? judgedGrade = freezed,
    Object? food = null,
    Object? stateRecords = null,
  }) {
    return _then(_self.copyWith(
      mealId: null == mealId
          ? _self.mealId
          : mealId // ignore: cast_nullable_to_non_nullable
              as String,
      mealGroupId: null == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel?,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as MealFood,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecord>,
    ));
  }

  /// Create a copy of MealDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodCopyWith<$Res> get food {
    return $MealFoodCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealDetail].
extension MealDetailPatterns on MealDetail {
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
    TResult Function(_MealDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealDetail() when $default != null:
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
    TResult Function(_MealDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetail():
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
    TResult? Function(_MealDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetail() when $default != null:
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
            String mealId,
            String mealGroupId,
            String eatenAt,
            String? memo,
            VerdictLevel? judgedGrade,
            MealFood food,
            List<StateRecord> stateRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealDetail() when $default != null:
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.memo, _that.judgedGrade, _that.food, _that.stateRecords);
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
            String mealId,
            String mealGroupId,
            String eatenAt,
            String? memo,
            VerdictLevel? judgedGrade,
            MealFood food,
            List<StateRecord> stateRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetail():
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.memo, _that.judgedGrade, _that.food, _that.stateRecords);
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
            String mealId,
            String mealGroupId,
            String eatenAt,
            String? memo,
            VerdictLevel? judgedGrade,
            MealFood food,
            List<StateRecord> stateRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetail() when $default != null:
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.memo, _that.judgedGrade, _that.food, _that.stateRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealDetail implements MealDetail {
  const _MealDetail(
      {required this.mealId,
      required this.mealGroupId,
      required this.eatenAt,
      this.memo,
      this.judgedGrade,
      required this.food,
      final List<StateRecord> stateRecords = const <StateRecord>[]})
      : _stateRecords = stateRecords;

  /// 식사 기록 식별자.
  @override
  final String mealId;

  /// 소속 끼니 그룹 식별자.
  @override
  final String mealGroupId;

  /// 섭취 시각 (ISO-8601 문자열 그대로).
  @override
  final String eatenAt;

  /// 메모. null 또는 빈 문자열이면 미작성 상태.
  @override
  final String? memo;

  /// 판정 등급. 미판정이면 null.
  @override
  final VerdictLevel? judgedGrade;

  /// 음식 상세 정보.
  @override
  final MealFood food;

  /// 연관 증상 기록 목록 (읽기전용).
  final List<StateRecord> _stateRecords;

  /// 연관 증상 기록 목록 (읽기전용).
  @override
  @JsonKey()
  List<StateRecord> get stateRecords {
    if (_stateRecords is EqualUnmodifiableListView) return _stateRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stateRecords);
  }

  /// Create a copy of MealDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealDetailCopyWith<_MealDetail> get copyWith =>
      __$MealDetailCopyWithImpl<_MealDetail>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealDetail &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade) &&
            (identical(other.food, food) || other.food == food) &&
            const DeepCollectionEquality()
                .equals(other._stateRecords, _stateRecords));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealId,
      mealGroupId,
      eatenAt,
      memo,
      judgedGrade,
      food,
      const DeepCollectionEquality().hash(_stateRecords));

  @override
  String toString() {
    return 'MealDetail(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, memo: $memo, judgedGrade: $judgedGrade, food: $food, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class _$MealDetailCopyWith<$Res>
    implements $MealDetailCopyWith<$Res> {
  factory _$MealDetailCopyWith(
          _MealDetail value, $Res Function(_MealDetail) _then) =
      __$MealDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      String? memo,
      VerdictLevel? judgedGrade,
      MealFood food,
      List<StateRecord> stateRecords});

  @override
  $MealFoodCopyWith<$Res> get food;
}

/// @nodoc
class __$MealDetailCopyWithImpl<$Res> implements _$MealDetailCopyWith<$Res> {
  __$MealDetailCopyWithImpl(this._self, this._then);

  final _MealDetail _self;
  final $Res Function(_MealDetail) _then;

  /// Create a copy of MealDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealId = null,
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? memo = freezed,
    Object? judgedGrade = freezed,
    Object? food = null,
    Object? stateRecords = null,
  }) {
    return _then(_MealDetail(
      mealId: null == mealId
          ? _self.mealId
          : mealId // ignore: cast_nullable_to_non_nullable
              as String,
      mealGroupId: null == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel?,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as MealFood,
      stateRecords: null == stateRecords
          ? _self._stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecord>,
    ));
  }

  /// Create a copy of MealDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodCopyWith<$Res> get food {
    return $MealFoodCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// @nodoc
mixin _$MealGroup {
  /// 끼니 그룹 식별자.
  String get mealGroupId;

  /// 섭취 시각 (ISO-8601 문자열 그대로).
  String get eatenAt;

  /// 그룹 내 식사 기록 목록.
  List<MealRecord> get records;

  /// Create a copy of MealGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealGroupCopyWith<MealGroup> get copyWith =>
      _$MealGroupCopyWithImpl<MealGroup>(this as MealGroup, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealGroup &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other.records, records));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealGroupId, eatenAt,
      const DeepCollectionEquality().hash(records));

  @override
  String toString() {
    return 'MealGroup(mealGroupId: $mealGroupId, eatenAt: $eatenAt, records: $records)';
  }
}

/// @nodoc
abstract mixin class $MealGroupCopyWith<$Res> {
  factory $MealGroupCopyWith(MealGroup value, $Res Function(MealGroup) _then) =
      _$MealGroupCopyWithImpl;
  @useResult
  $Res call({String mealGroupId, String eatenAt, List<MealRecord> records});
}

/// @nodoc
class _$MealGroupCopyWithImpl<$Res> implements $MealGroupCopyWith<$Res> {
  _$MealGroupCopyWithImpl(this._self, this._then);

  final MealGroup _self;
  final $Res Function(MealGroup) _then;

  /// Create a copy of MealGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? records = null,
  }) {
    return _then(_self.copyWith(
      mealGroupId: null == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      records: null == records
          ? _self.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<MealRecord>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealGroup].
extension MealGroupPatterns on MealGroup {
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
    TResult Function(_MealGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealGroup() when $default != null:
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
    TResult Function(_MealGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroup():
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
    TResult? Function(_MealGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroup() when $default != null:
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
            String mealGroupId, String eatenAt, List<MealRecord> records)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealGroup() when $default != null:
        return $default(_that.mealGroupId, _that.eatenAt, _that.records);
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
            String mealGroupId, String eatenAt, List<MealRecord> records)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroup():
        return $default(_that.mealGroupId, _that.eatenAt, _that.records);
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
            String mealGroupId, String eatenAt, List<MealRecord> records)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroup() when $default != null:
        return $default(_that.mealGroupId, _that.eatenAt, _that.records);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealGroup implements MealGroup {
  const _MealGroup(
      {required this.mealGroupId,
      required this.eatenAt,
      final List<MealRecord> records = const <MealRecord>[]})
      : _records = records;

  /// 끼니 그룹 식별자.
  @override
  final String mealGroupId;

  /// 섭취 시각 (ISO-8601 문자열 그대로).
  @override
  final String eatenAt;

  /// 그룹 내 식사 기록 목록.
  final List<MealRecord> _records;

  /// 그룹 내 식사 기록 목록.
  @override
  @JsonKey()
  List<MealRecord> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

  /// Create a copy of MealGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealGroupCopyWith<_MealGroup> get copyWith =>
      __$MealGroupCopyWithImpl<_MealGroup>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealGroup &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealGroupId, eatenAt,
      const DeepCollectionEquality().hash(_records));

  @override
  String toString() {
    return 'MealGroup(mealGroupId: $mealGroupId, eatenAt: $eatenAt, records: $records)';
  }
}

/// @nodoc
abstract mixin class _$MealGroupCopyWith<$Res>
    implements $MealGroupCopyWith<$Res> {
  factory _$MealGroupCopyWith(
          _MealGroup value, $Res Function(_MealGroup) _then) =
      __$MealGroupCopyWithImpl;
  @override
  @useResult
  $Res call({String mealGroupId, String eatenAt, List<MealRecord> records});
}

/// @nodoc
class __$MealGroupCopyWithImpl<$Res> implements _$MealGroupCopyWith<$Res> {
  __$MealGroupCopyWithImpl(this._self, this._then);

  final _MealGroup _self;
  final $Res Function(_MealGroup) _then;

  /// Create a copy of MealGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? records = null,
  }) {
    return _then(_MealGroup(
      mealGroupId: null == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      records: null == records
          ? _self._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<MealRecord>,
    ));
  }
}

// dart format on
