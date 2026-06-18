// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StateRecordDto {
  String get label;
  String get date;
  String get timing;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateRecordDtoCopyWith<StateRecordDto> get copyWith =>
      _$StateRecordDtoCopyWithImpl<StateRecordDto>(
          this as StateRecordDto, _$identity);

  /// Serializes this StateRecordDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateRecordDto &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, date, timing);

  @override
  String toString() {
    return 'StateRecordDto(label: $label, date: $date, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class $StateRecordDtoCopyWith<$Res> {
  factory $StateRecordDtoCopyWith(
          StateRecordDto value, $Res Function(StateRecordDto) _then) =
      _$StateRecordDtoCopyWithImpl;
  @useResult
  $Res call({String label, String date, String timing});
}

/// @nodoc
class _$StateRecordDtoCopyWithImpl<$Res>
    implements $StateRecordDtoCopyWith<$Res> {
  _$StateRecordDtoCopyWithImpl(this._self, this._then);

  final StateRecordDto _self;
  final $Res Function(StateRecordDto) _then;

  /// Create a copy of StateRecordDto
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

/// Adds pattern-matching-related methods to [StateRecordDto].
extension StateRecordDtoPatterns on StateRecordDto {
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
    TResult Function(_StateRecordDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
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
    TResult Function(_StateRecordDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto():
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
    TResult? Function(_StateRecordDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
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
      case _StateRecordDto() when $default != null:
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
      case _StateRecordDto():
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
      case _StateRecordDto() when $default != null:
        return $default(_that.label, _that.date, _that.timing);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StateRecordDto implements StateRecordDto {
  const _StateRecordDto(
      {required this.label, required this.date, required this.timing});
  factory _StateRecordDto.fromJson(Map<String, dynamic> json) =>
      _$StateRecordDtoFromJson(json);

  @override
  final String label;
  @override
  final String date;
  @override
  final String timing;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StateRecordDtoCopyWith<_StateRecordDto> get copyWith =>
      __$StateRecordDtoCopyWithImpl<_StateRecordDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StateRecordDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StateRecordDto &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, date, timing);

  @override
  String toString() {
    return 'StateRecordDto(label: $label, date: $date, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class _$StateRecordDtoCopyWith<$Res>
    implements $StateRecordDtoCopyWith<$Res> {
  factory _$StateRecordDtoCopyWith(
          _StateRecordDto value, $Res Function(_StateRecordDto) _then) =
      __$StateRecordDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String label, String date, String timing});
}

/// @nodoc
class __$StateRecordDtoCopyWithImpl<$Res>
    implements _$StateRecordDtoCopyWith<$Res> {
  __$StateRecordDtoCopyWithImpl(this._self, this._then);

  final _StateRecordDto _self;
  final $Res Function(_StateRecordDto) _then;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? date = null,
    Object? timing = null,
  }) {
    return _then(_StateRecordDto(
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
mixin _$MealFoodDetailDto {
  String get externalId;
  String get name;
  String? get category;
  String? get description;

  /// Create a copy of MealFoodDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealFoodDetailDtoCopyWith<MealFoodDetailDto> get copyWith =>
      _$MealFoodDetailDtoCopyWithImpl<MealFoodDetailDto>(
          this as MealFoodDetailDto, _$identity);

  /// Serializes this MealFoodDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealFoodDetailDto &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, externalId, name, category, description);

  @override
  String toString() {
    return 'MealFoodDetailDto(externalId: $externalId, name: $name, category: $category, description: $description)';
  }
}

/// @nodoc
abstract mixin class $MealFoodDetailDtoCopyWith<$Res> {
  factory $MealFoodDetailDtoCopyWith(
          MealFoodDetailDto value, $Res Function(MealFoodDetailDto) _then) =
      _$MealFoodDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String externalId, String name, String? category, String? description});
}

/// @nodoc
class _$MealFoodDetailDtoCopyWithImpl<$Res>
    implements $MealFoodDetailDtoCopyWith<$Res> {
  _$MealFoodDetailDtoCopyWithImpl(this._self, this._then);

  final MealFoodDetailDto _self;
  final $Res Function(MealFoodDetailDto) _then;

  /// Create a copy of MealFoodDetailDto
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

/// Adds pattern-matching-related methods to [MealFoodDetailDto].
extension MealFoodDetailDtoPatterns on MealFoodDetailDto {
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
    TResult Function(_MealFoodDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFoodDetailDto() when $default != null:
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
    TResult Function(_MealFoodDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodDetailDto():
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
    TResult? Function(_MealFoodDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodDetailDto() when $default != null:
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
      case _MealFoodDetailDto() when $default != null:
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
      case _MealFoodDetailDto():
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
      case _MealFoodDetailDto() when $default != null:
        return $default(
            _that.externalId, _that.name, _that.category, _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealFoodDetailDto implements MealFoodDetailDto {
  const _MealFoodDetailDto(
      {required this.externalId,
      required this.name,
      this.category,
      this.description});
  factory _MealFoodDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealFoodDetailDtoFromJson(json);

  @override
  final String externalId;
  @override
  final String name;
  @override
  final String? category;
  @override
  final String? description;

  /// Create a copy of MealFoodDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealFoodDetailDtoCopyWith<_MealFoodDetailDto> get copyWith =>
      __$MealFoodDetailDtoCopyWithImpl<_MealFoodDetailDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealFoodDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealFoodDetailDto &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, externalId, name, category, description);

  @override
  String toString() {
    return 'MealFoodDetailDto(externalId: $externalId, name: $name, category: $category, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$MealFoodDetailDtoCopyWith<$Res>
    implements $MealFoodDetailDtoCopyWith<$Res> {
  factory _$MealFoodDetailDtoCopyWith(
          _MealFoodDetailDto value, $Res Function(_MealFoodDetailDto) _then) =
      __$MealFoodDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String externalId, String name, String? category, String? description});
}

/// @nodoc
class __$MealFoodDetailDtoCopyWithImpl<$Res>
    implements _$MealFoodDetailDtoCopyWith<$Res> {
  __$MealFoodDetailDtoCopyWithImpl(this._self, this._then);

  final _MealFoodDetailDto _self;
  final $Res Function(_MealFoodDetailDto) _then;

  /// Create a copy of MealFoodDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
    Object? description = freezed,
  }) {
    return _then(_MealFoodDetailDto(
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
mixin _$MealRecordSummaryDto {
  String get mealId;
  String get mealGroupId;
  String get eatenAt;
  FoodSummaryDto get food;
  String? get judgedGrade;

  /// Create a copy of MealRecordSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealRecordSummaryDtoCopyWith<MealRecordSummaryDto> get copyWith =>
      _$MealRecordSummaryDtoCopyWithImpl<MealRecordSummaryDto>(
          this as MealRecordSummaryDto, _$identity);

  /// Serializes this MealRecordSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealRecordSummaryDto &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mealId, mealGroupId, eatenAt, food, judgedGrade);

  @override
  String toString() {
    return 'MealRecordSummaryDto(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, food: $food, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class $MealRecordSummaryDtoCopyWith<$Res> {
  factory $MealRecordSummaryDtoCopyWith(MealRecordSummaryDto value,
          $Res Function(MealRecordSummaryDto) _then) =
      _$MealRecordSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      FoodSummaryDto food,
      String? judgedGrade});

  $FoodSummaryDtoCopyWith<$Res> get food;
}

/// @nodoc
class _$MealRecordSummaryDtoCopyWithImpl<$Res>
    implements $MealRecordSummaryDtoCopyWith<$Res> {
  _$MealRecordSummaryDtoCopyWithImpl(this._self, this._then);

  final MealRecordSummaryDto _self;
  final $Res Function(MealRecordSummaryDto) _then;

  /// Create a copy of MealRecordSummaryDto
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
              as FoodSummaryDto,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of MealRecordSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodSummaryDtoCopyWith<$Res> get food {
    return $FoodSummaryDtoCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealRecordSummaryDto].
extension MealRecordSummaryDtoPatterns on MealRecordSummaryDto {
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
    TResult Function(_MealRecordSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecordSummaryDto() when $default != null:
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
    TResult Function(_MealRecordSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordSummaryDto():
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
    TResult? Function(_MealRecordSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordSummaryDto() when $default != null:
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
            FoodSummaryDto food, String? judgedGrade)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecordSummaryDto() when $default != null:
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
            FoodSummaryDto food, String? judgedGrade)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordSummaryDto():
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
            FoodSummaryDto food, String? judgedGrade)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordSummaryDto() when $default != null:
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.food, _that.judgedGrade);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealRecordSummaryDto implements MealRecordSummaryDto {
  const _MealRecordSummaryDto(
      {required this.mealId,
      required this.mealGroupId,
      required this.eatenAt,
      required this.food,
      this.judgedGrade});
  factory _MealRecordSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordSummaryDtoFromJson(json);

  @override
  final String mealId;
  @override
  final String mealGroupId;
  @override
  final String eatenAt;
  @override
  final FoodSummaryDto food;
  @override
  final String? judgedGrade;

  /// Create a copy of MealRecordSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealRecordSummaryDtoCopyWith<_MealRecordSummaryDto> get copyWith =>
      __$MealRecordSummaryDtoCopyWithImpl<_MealRecordSummaryDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealRecordSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealRecordSummaryDto &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mealId, mealGroupId, eatenAt, food, judgedGrade);

  @override
  String toString() {
    return 'MealRecordSummaryDto(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, food: $food, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class _$MealRecordSummaryDtoCopyWith<$Res>
    implements $MealRecordSummaryDtoCopyWith<$Res> {
  factory _$MealRecordSummaryDtoCopyWith(_MealRecordSummaryDto value,
          $Res Function(_MealRecordSummaryDto) _then) =
      __$MealRecordSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      FoodSummaryDto food,
      String? judgedGrade});

  @override
  $FoodSummaryDtoCopyWith<$Res> get food;
}

/// @nodoc
class __$MealRecordSummaryDtoCopyWithImpl<$Res>
    implements _$MealRecordSummaryDtoCopyWith<$Res> {
  __$MealRecordSummaryDtoCopyWithImpl(this._self, this._then);

  final _MealRecordSummaryDto _self;
  final $Res Function(_MealRecordSummaryDto) _then;

  /// Create a copy of MealRecordSummaryDto
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
    return _then(_MealRecordSummaryDto(
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
              as FoodSummaryDto,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of MealRecordSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodSummaryDtoCopyWith<$Res> get food {
    return $FoodSummaryDtoCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// @nodoc
mixin _$MealRecordDetailDto {
  String get mealId;
  String get mealGroupId;
  String get eatenAt;
  String? get memo;
  String? get judgedGrade;
  MealFoodDetailDto get food;
  List<StateRecordDto> get stateRecords;

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealRecordDetailDtoCopyWith<MealRecordDetailDto> get copyWith =>
      _$MealRecordDetailDtoCopyWithImpl<MealRecordDetailDto>(
          this as MealRecordDetailDto, _$identity);

  /// Serializes this MealRecordDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealRecordDetailDto &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'MealRecordDetailDto(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, memo: $memo, judgedGrade: $judgedGrade, food: $food, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class $MealRecordDetailDtoCopyWith<$Res> {
  factory $MealRecordDetailDtoCopyWith(
          MealRecordDetailDto value, $Res Function(MealRecordDetailDto) _then) =
      _$MealRecordDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      String? memo,
      String? judgedGrade,
      MealFoodDetailDto food,
      List<StateRecordDto> stateRecords});

  $MealFoodDetailDtoCopyWith<$Res> get food;
}

/// @nodoc
class _$MealRecordDetailDtoCopyWithImpl<$Res>
    implements $MealRecordDetailDtoCopyWith<$Res> {
  _$MealRecordDetailDtoCopyWithImpl(this._self, this._then);

  final MealRecordDetailDto _self;
  final $Res Function(MealRecordDetailDto) _then;

  /// Create a copy of MealRecordDetailDto
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
              as String?,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as MealFoodDetailDto,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecordDto>,
    ));
  }

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodDetailDtoCopyWith<$Res> get food {
    return $MealFoodDetailDtoCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealRecordDetailDto].
extension MealRecordDetailDtoPatterns on MealRecordDetailDto {
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
    TResult Function(_MealRecordDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
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
    TResult Function(_MealRecordDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto():
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
    TResult? Function(_MealRecordDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
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
            String? judgedGrade,
            MealFoodDetailDto food,
            List<StateRecordDto> stateRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
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
            String? judgedGrade,
            MealFoodDetailDto food,
            List<StateRecordDto> stateRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto():
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
            String? judgedGrade,
            MealFoodDetailDto food,
            List<StateRecordDto> stateRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
        return $default(_that.mealId, _that.mealGroupId, _that.eatenAt,
            _that.memo, _that.judgedGrade, _that.food, _that.stateRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealRecordDetailDto implements MealRecordDetailDto {
  const _MealRecordDetailDto(
      {required this.mealId,
      required this.mealGroupId,
      required this.eatenAt,
      this.memo,
      this.judgedGrade,
      required this.food,
      final List<StateRecordDto> stateRecords = const <StateRecordDto>[]})
      : _stateRecords = stateRecords;
  factory _MealRecordDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordDetailDtoFromJson(json);

  @override
  final String mealId;
  @override
  final String mealGroupId;
  @override
  final String eatenAt;
  @override
  final String? memo;
  @override
  final String? judgedGrade;
  @override
  final MealFoodDetailDto food;
  final List<StateRecordDto> _stateRecords;
  @override
  @JsonKey()
  List<StateRecordDto> get stateRecords {
    if (_stateRecords is EqualUnmodifiableListView) return _stateRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stateRecords);
  }

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealRecordDetailDtoCopyWith<_MealRecordDetailDto> get copyWith =>
      __$MealRecordDetailDtoCopyWithImpl<_MealRecordDetailDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealRecordDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealRecordDetailDto &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'MealRecordDetailDto(mealId: $mealId, mealGroupId: $mealGroupId, eatenAt: $eatenAt, memo: $memo, judgedGrade: $judgedGrade, food: $food, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class _$MealRecordDetailDtoCopyWith<$Res>
    implements $MealRecordDetailDtoCopyWith<$Res> {
  factory _$MealRecordDetailDtoCopyWith(_MealRecordDetailDto value,
          $Res Function(_MealRecordDetailDto) _then) =
      __$MealRecordDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealId,
      String mealGroupId,
      String eatenAt,
      String? memo,
      String? judgedGrade,
      MealFoodDetailDto food,
      List<StateRecordDto> stateRecords});

  @override
  $MealFoodDetailDtoCopyWith<$Res> get food;
}

/// @nodoc
class __$MealRecordDetailDtoCopyWithImpl<$Res>
    implements _$MealRecordDetailDtoCopyWith<$Res> {
  __$MealRecordDetailDtoCopyWithImpl(this._self, this._then);

  final _MealRecordDetailDto _self;
  final $Res Function(_MealRecordDetailDto) _then;

  /// Create a copy of MealRecordDetailDto
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
    return _then(_MealRecordDetailDto(
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
              as String?,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as MealFoodDetailDto,
      stateRecords: null == stateRecords
          ? _self._stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecordDto>,
    ));
  }

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodDetailDtoCopyWith<$Res> get food {
    return $MealFoodDetailDtoCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }
}

/// @nodoc
mixin _$MealGroupDto {
  String get mealGroupId;
  String get eatenAt;
  List<MealRecordSummaryDto> get records;

  /// Create a copy of MealGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealGroupDtoCopyWith<MealGroupDto> get copyWith =>
      _$MealGroupDtoCopyWithImpl<MealGroupDto>(
          this as MealGroupDto, _$identity);

  /// Serializes this MealGroupDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealGroupDto &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other.records, records));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mealGroupId, eatenAt,
      const DeepCollectionEquality().hash(records));

  @override
  String toString() {
    return 'MealGroupDto(mealGroupId: $mealGroupId, eatenAt: $eatenAt, records: $records)';
  }
}

/// @nodoc
abstract mixin class $MealGroupDtoCopyWith<$Res> {
  factory $MealGroupDtoCopyWith(
          MealGroupDto value, $Res Function(MealGroupDto) _then) =
      _$MealGroupDtoCopyWithImpl;
  @useResult
  $Res call(
      {String mealGroupId, String eatenAt, List<MealRecordSummaryDto> records});
}

/// @nodoc
class _$MealGroupDtoCopyWithImpl<$Res> implements $MealGroupDtoCopyWith<$Res> {
  _$MealGroupDtoCopyWithImpl(this._self, this._then);

  final MealGroupDto _self;
  final $Res Function(MealGroupDto) _then;

  /// Create a copy of MealGroupDto
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
              as List<MealRecordSummaryDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealGroupDto].
extension MealGroupDtoPatterns on MealGroupDto {
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
    TResult Function(_MealGroupDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealGroupDto() when $default != null:
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
    TResult Function(_MealGroupDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroupDto():
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
    TResult? Function(_MealGroupDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroupDto() when $default != null:
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
    TResult Function(String mealGroupId, String eatenAt,
            List<MealRecordSummaryDto> records)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealGroupDto() when $default != null:
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
    TResult Function(String mealGroupId, String eatenAt,
            List<MealRecordSummaryDto> records)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroupDto():
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
    TResult? Function(String mealGroupId, String eatenAt,
            List<MealRecordSummaryDto> records)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealGroupDto() when $default != null:
        return $default(_that.mealGroupId, _that.eatenAt, _that.records);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealGroupDto implements MealGroupDto {
  const _MealGroupDto(
      {required this.mealGroupId,
      required this.eatenAt,
      final List<MealRecordSummaryDto> records =
          const <MealRecordSummaryDto>[]})
      : _records = records;
  factory _MealGroupDto.fromJson(Map<String, dynamic> json) =>
      _$MealGroupDtoFromJson(json);

  @override
  final String mealGroupId;
  @override
  final String eatenAt;
  final List<MealRecordSummaryDto> _records;
  @override
  @JsonKey()
  List<MealRecordSummaryDto> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

  /// Create a copy of MealGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealGroupDtoCopyWith<_MealGroupDto> get copyWith =>
      __$MealGroupDtoCopyWithImpl<_MealGroupDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealGroupDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealGroupDto &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mealGroupId, eatenAt,
      const DeepCollectionEquality().hash(_records));

  @override
  String toString() {
    return 'MealGroupDto(mealGroupId: $mealGroupId, eatenAt: $eatenAt, records: $records)';
  }
}

/// @nodoc
abstract mixin class _$MealGroupDtoCopyWith<$Res>
    implements $MealGroupDtoCopyWith<$Res> {
  factory _$MealGroupDtoCopyWith(
          _MealGroupDto value, $Res Function(_MealGroupDto) _then) =
      __$MealGroupDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealGroupId, String eatenAt, List<MealRecordSummaryDto> records});
}

/// @nodoc
class __$MealGroupDtoCopyWithImpl<$Res>
    implements _$MealGroupDtoCopyWith<$Res> {
  __$MealGroupDtoCopyWithImpl(this._self, this._then);

  final _MealGroupDto _self;
  final $Res Function(_MealGroupDto) _then;

  /// Create a copy of MealGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealGroupId = null,
    Object? eatenAt = null,
    Object? records = null,
  }) {
    return _then(_MealGroupDto(
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
              as List<MealRecordSummaryDto>,
    ));
  }
}

/// @nodoc
mixin _$CreateMealRecordRequestDto {
  String get foodExternalId;
  String? get eatenAt;
  String? get mealGroupId;
  String? get judgedGrade;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateMealRecordRequestDtoCopyWith<CreateMealRecordRequestDto>
      get copyWith =>
          _$CreateMealRecordRequestDtoCopyWithImpl<CreateMealRecordRequestDto>(
              this as CreateMealRecordRequestDto, _$identity);

  /// Serializes this CreateMealRecordRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateMealRecordRequestDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodExternalId, eatenAt, mealGroupId, judgedGrade);

  @override
  String toString() {
    return 'CreateMealRecordRequestDto(foodExternalId: $foodExternalId, eatenAt: $eatenAt, mealGroupId: $mealGroupId, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class $CreateMealRecordRequestDtoCopyWith<$Res> {
  factory $CreateMealRecordRequestDtoCopyWith(CreateMealRecordRequestDto value,
          $Res Function(CreateMealRecordRequestDto) _then) =
      _$CreateMealRecordRequestDtoCopyWithImpl;
  @useResult
  $Res call(
      {String foodExternalId,
      String? eatenAt,
      String? mealGroupId,
      String? judgedGrade});
}

/// @nodoc
class _$CreateMealRecordRequestDtoCopyWithImpl<$Res>
    implements $CreateMealRecordRequestDtoCopyWith<$Res> {
  _$CreateMealRecordRequestDtoCopyWithImpl(this._self, this._then);

  final CreateMealRecordRequestDto _self;
  final $Res Function(CreateMealRecordRequestDto) _then;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodExternalId = null,
    Object? eatenAt = freezed,
    Object? mealGroupId = freezed,
    Object? judgedGrade = freezed,
  }) {
    return _then(_self.copyWith(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: freezed == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealGroupId: freezed == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateMealRecordRequestDto].
extension CreateMealRecordRequestDtoPatterns on CreateMealRecordRequestDto {
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
    TResult Function(_CreateMealRecordRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
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
    TResult Function(_CreateMealRecordRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto():
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
    TResult? Function(_CreateMealRecordRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
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
    TResult Function(String foodExternalId, String? eatenAt,
            String? mealGroupId, String? judgedGrade)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
        return $default(_that.foodExternalId, _that.eatenAt, _that.mealGroupId,
            _that.judgedGrade);
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
    TResult Function(String foodExternalId, String? eatenAt,
            String? mealGroupId, String? judgedGrade)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto():
        return $default(_that.foodExternalId, _that.eatenAt, _that.mealGroupId,
            _that.judgedGrade);
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
    TResult? Function(String foodExternalId, String? eatenAt,
            String? mealGroupId, String? judgedGrade)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
        return $default(_that.foodExternalId, _that.eatenAt, _that.mealGroupId,
            _that.judgedGrade);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateMealRecordRequestDto implements CreateMealRecordRequestDto {
  const _CreateMealRecordRequestDto(
      {required this.foodExternalId,
      this.eatenAt,
      this.mealGroupId,
      this.judgedGrade});
  factory _CreateMealRecordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMealRecordRequestDtoFromJson(json);

  @override
  final String foodExternalId;
  @override
  final String? eatenAt;
  @override
  final String? mealGroupId;
  @override
  final String? judgedGrade;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateMealRecordRequestDtoCopyWith<_CreateMealRecordRequestDto>
      get copyWith => __$CreateMealRecordRequestDtoCopyWithImpl<
          _CreateMealRecordRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateMealRecordRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateMealRecordRequestDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodExternalId, eatenAt, mealGroupId, judgedGrade);

  @override
  String toString() {
    return 'CreateMealRecordRequestDto(foodExternalId: $foodExternalId, eatenAt: $eatenAt, mealGroupId: $mealGroupId, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class _$CreateMealRecordRequestDtoCopyWith<$Res>
    implements $CreateMealRecordRequestDtoCopyWith<$Res> {
  factory _$CreateMealRecordRequestDtoCopyWith(
          _CreateMealRecordRequestDto value,
          $Res Function(_CreateMealRecordRequestDto) _then) =
      __$CreateMealRecordRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodExternalId,
      String? eatenAt,
      String? mealGroupId,
      String? judgedGrade});
}

/// @nodoc
class __$CreateMealRecordRequestDtoCopyWithImpl<$Res>
    implements _$CreateMealRecordRequestDtoCopyWith<$Res> {
  __$CreateMealRecordRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateMealRecordRequestDto _self;
  final $Res Function(_CreateMealRecordRequestDto) _then;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodExternalId = null,
    Object? eatenAt = freezed,
    Object? mealGroupId = freezed,
    Object? judgedGrade = freezed,
  }) {
    return _then(_CreateMealRecordRequestDto(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: freezed == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealGroupId: freezed == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CreateMealByTextRequestDto {
  String get foodTextInput;
  String? get eatenAt;
  String? get mealGroupId;
  String? get judgedGrade;

  /// Create a copy of CreateMealByTextRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateMealByTextRequestDtoCopyWith<CreateMealByTextRequestDto>
      get copyWith =>
          _$CreateMealByTextRequestDtoCopyWithImpl<CreateMealByTextRequestDto>(
              this as CreateMealByTextRequestDto, _$identity);

  /// Serializes this CreateMealByTextRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateMealByTextRequestDto &&
            (identical(other.foodTextInput, foodTextInput) ||
                other.foodTextInput == foodTextInput) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodTextInput, eatenAt, mealGroupId, judgedGrade);

  @override
  String toString() {
    return 'CreateMealByTextRequestDto(foodTextInput: $foodTextInput, eatenAt: $eatenAt, mealGroupId: $mealGroupId, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class $CreateMealByTextRequestDtoCopyWith<$Res> {
  factory $CreateMealByTextRequestDtoCopyWith(CreateMealByTextRequestDto value,
          $Res Function(CreateMealByTextRequestDto) _then) =
      _$CreateMealByTextRequestDtoCopyWithImpl;
  @useResult
  $Res call(
      {String foodTextInput,
      String? eatenAt,
      String? mealGroupId,
      String? judgedGrade});
}

/// @nodoc
class _$CreateMealByTextRequestDtoCopyWithImpl<$Res>
    implements $CreateMealByTextRequestDtoCopyWith<$Res> {
  _$CreateMealByTextRequestDtoCopyWithImpl(this._self, this._then);

  final CreateMealByTextRequestDto _self;
  final $Res Function(CreateMealByTextRequestDto) _then;

  /// Create a copy of CreateMealByTextRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodTextInput = null,
    Object? eatenAt = freezed,
    Object? mealGroupId = freezed,
    Object? judgedGrade = freezed,
  }) {
    return _then(_self.copyWith(
      foodTextInput: null == foodTextInput
          ? _self.foodTextInput
          : foodTextInput // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: freezed == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealGroupId: freezed == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateMealByTextRequestDto].
extension CreateMealByTextRequestDtoPatterns on CreateMealByTextRequestDto {
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
    TResult Function(_CreateMealByTextRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateMealByTextRequestDto() when $default != null:
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
    TResult Function(_CreateMealByTextRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealByTextRequestDto():
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
    TResult? Function(_CreateMealByTextRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealByTextRequestDto() when $default != null:
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
    TResult Function(String foodTextInput, String? eatenAt, String? mealGroupId,
            String? judgedGrade)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateMealByTextRequestDto() when $default != null:
        return $default(_that.foodTextInput, _that.eatenAt, _that.mealGroupId,
            _that.judgedGrade);
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
    TResult Function(String foodTextInput, String? eatenAt, String? mealGroupId,
            String? judgedGrade)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealByTextRequestDto():
        return $default(_that.foodTextInput, _that.eatenAt, _that.mealGroupId,
            _that.judgedGrade);
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
    TResult? Function(String foodTextInput, String? eatenAt,
            String? mealGroupId, String? judgedGrade)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealByTextRequestDto() when $default != null:
        return $default(_that.foodTextInput, _that.eatenAt, _that.mealGroupId,
            _that.judgedGrade);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateMealByTextRequestDto implements CreateMealByTextRequestDto {
  const _CreateMealByTextRequestDto(
      {required this.foodTextInput,
      this.eatenAt,
      this.mealGroupId,
      this.judgedGrade});
  factory _CreateMealByTextRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMealByTextRequestDtoFromJson(json);

  @override
  final String foodTextInput;
  @override
  final String? eatenAt;
  @override
  final String? mealGroupId;
  @override
  final String? judgedGrade;

  /// Create a copy of CreateMealByTextRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateMealByTextRequestDtoCopyWith<_CreateMealByTextRequestDto>
      get copyWith => __$CreateMealByTextRequestDtoCopyWithImpl<
          _CreateMealByTextRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateMealByTextRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateMealByTextRequestDto &&
            (identical(other.foodTextInput, foodTextInput) ||
                other.foodTextInput == foodTextInput) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealGroupId, mealGroupId) ||
                other.mealGroupId == mealGroupId) &&
            (identical(other.judgedGrade, judgedGrade) ||
                other.judgedGrade == judgedGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodTextInput, eatenAt, mealGroupId, judgedGrade);

  @override
  String toString() {
    return 'CreateMealByTextRequestDto(foodTextInput: $foodTextInput, eatenAt: $eatenAt, mealGroupId: $mealGroupId, judgedGrade: $judgedGrade)';
  }
}

/// @nodoc
abstract mixin class _$CreateMealByTextRequestDtoCopyWith<$Res>
    implements $CreateMealByTextRequestDtoCopyWith<$Res> {
  factory _$CreateMealByTextRequestDtoCopyWith(
          _CreateMealByTextRequestDto value,
          $Res Function(_CreateMealByTextRequestDto) _then) =
      __$CreateMealByTextRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodTextInput,
      String? eatenAt,
      String? mealGroupId,
      String? judgedGrade});
}

/// @nodoc
class __$CreateMealByTextRequestDtoCopyWithImpl<$Res>
    implements _$CreateMealByTextRequestDtoCopyWith<$Res> {
  __$CreateMealByTextRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateMealByTextRequestDto _self;
  final $Res Function(_CreateMealByTextRequestDto) _then;

  /// Create a copy of CreateMealByTextRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodTextInput = null,
    Object? eatenAt = freezed,
    Object? mealGroupId = freezed,
    Object? judgedGrade = freezed,
  }) {
    return _then(_CreateMealByTextRequestDto(
      foodTextInput: null == foodTextInput
          ? _self.foodTextInput
          : foodTextInput // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: freezed == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealGroupId: freezed == mealGroupId
          ? _self.mealGroupId
          : mealGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      judgedGrade: freezed == judgedGrade
          ? _self.judgedGrade
          : judgedGrade // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$UpdateMealMemoRequestDto {
  String? get memo;

  /// Create a copy of UpdateMealMemoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateMealMemoRequestDtoCopyWith<UpdateMealMemoRequestDto> get copyWith =>
      _$UpdateMealMemoRequestDtoCopyWithImpl<UpdateMealMemoRequestDto>(
          this as UpdateMealMemoRequestDto, _$identity);

  /// Serializes this UpdateMealMemoRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateMealMemoRequestDto &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memo);

  @override
  String toString() {
    return 'UpdateMealMemoRequestDto(memo: $memo)';
  }
}

/// @nodoc
abstract mixin class $UpdateMealMemoRequestDtoCopyWith<$Res> {
  factory $UpdateMealMemoRequestDtoCopyWith(UpdateMealMemoRequestDto value,
          $Res Function(UpdateMealMemoRequestDto) _then) =
      _$UpdateMealMemoRequestDtoCopyWithImpl;
  @useResult
  $Res call({String? memo});
}

/// @nodoc
class _$UpdateMealMemoRequestDtoCopyWithImpl<$Res>
    implements $UpdateMealMemoRequestDtoCopyWith<$Res> {
  _$UpdateMealMemoRequestDtoCopyWithImpl(this._self, this._then);

  final UpdateMealMemoRequestDto _self;
  final $Res Function(UpdateMealMemoRequestDto) _then;

  /// Create a copy of UpdateMealMemoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memo = freezed,
  }) {
    return _then(_self.copyWith(
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateMealMemoRequestDto].
extension UpdateMealMemoRequestDtoPatterns on UpdateMealMemoRequestDto {
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
    TResult Function(_UpdateMealMemoRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateMealMemoRequestDto() when $default != null:
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
    TResult Function(_UpdateMealMemoRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateMealMemoRequestDto():
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
    TResult? Function(_UpdateMealMemoRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateMealMemoRequestDto() when $default != null:
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
    TResult Function(String? memo)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateMealMemoRequestDto() when $default != null:
        return $default(_that.memo);
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
    TResult Function(String? memo) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateMealMemoRequestDto():
        return $default(_that.memo);
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
    TResult? Function(String? memo)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateMealMemoRequestDto() when $default != null:
        return $default(_that.memo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UpdateMealMemoRequestDto implements UpdateMealMemoRequestDto {
  const _UpdateMealMemoRequestDto({this.memo});
  factory _UpdateMealMemoRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMealMemoRequestDtoFromJson(json);

  @override
  final String? memo;

  /// Create a copy of UpdateMealMemoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateMealMemoRequestDtoCopyWith<_UpdateMealMemoRequestDto> get copyWith =>
      __$UpdateMealMemoRequestDtoCopyWithImpl<_UpdateMealMemoRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdateMealMemoRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateMealMemoRequestDto &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memo);

  @override
  String toString() {
    return 'UpdateMealMemoRequestDto(memo: $memo)';
  }
}

/// @nodoc
abstract mixin class _$UpdateMealMemoRequestDtoCopyWith<$Res>
    implements $UpdateMealMemoRequestDtoCopyWith<$Res> {
  factory _$UpdateMealMemoRequestDtoCopyWith(_UpdateMealMemoRequestDto value,
          $Res Function(_UpdateMealMemoRequestDto) _then) =
      __$UpdateMealMemoRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String? memo});
}

/// @nodoc
class __$UpdateMealMemoRequestDtoCopyWithImpl<$Res>
    implements _$UpdateMealMemoRequestDtoCopyWith<$Res> {
  __$UpdateMealMemoRequestDtoCopyWithImpl(this._self, this._then);

  final _UpdateMealMemoRequestDto _self;
  final $Res Function(_UpdateMealMemoRequestDto) _then;

  /// Create a copy of UpdateMealMemoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memo = freezed,
  }) {
    return _then(_UpdateMealMemoRequestDto(
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
