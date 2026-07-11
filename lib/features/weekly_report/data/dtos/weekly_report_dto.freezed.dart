// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_report_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComfortableStateDto {
  int get streakCount;
  int get recommendedMealCount;
  double get percentage;

  /// Create a copy of ComfortableStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ComfortableStateDtoCopyWith<ComfortableStateDto> get copyWith =>
      _$ComfortableStateDtoCopyWithImpl<ComfortableStateDto>(
          this as ComfortableStateDto, _$identity);

  /// Serializes this ComfortableStateDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ComfortableStateDto &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.recommendedMealCount, recommendedMealCount) ||
                other.recommendedMealCount == recommendedMealCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, streakCount, recommendedMealCount, percentage);

  @override
  String toString() {
    return 'ComfortableStateDto(streakCount: $streakCount, recommendedMealCount: $recommendedMealCount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $ComfortableStateDtoCopyWith<$Res> {
  factory $ComfortableStateDtoCopyWith(
          ComfortableStateDto value, $Res Function(ComfortableStateDto) _then) =
      _$ComfortableStateDtoCopyWithImpl;
  @useResult
  $Res call({int streakCount, int recommendedMealCount, double percentage});
}

/// @nodoc
class _$ComfortableStateDtoCopyWithImpl<$Res>
    implements $ComfortableStateDtoCopyWith<$Res> {
  _$ComfortableStateDtoCopyWithImpl(this._self, this._then);

  final ComfortableStateDto _self;
  final $Res Function(ComfortableStateDto) _then;

  /// Create a copy of ComfortableStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streakCount = null,
    Object? recommendedMealCount = null,
    Object? percentage = null,
  }) {
    return _then(_self.copyWith(
      streakCount: null == streakCount
          ? _self.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedMealCount: null == recommendedMealCount
          ? _self.recommendedMealCount
          : recommendedMealCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ComfortableStateDto].
extension ComfortableStateDtoPatterns on ComfortableStateDto {
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
    TResult Function(_ComfortableStateDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComfortableStateDto() when $default != null:
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
    TResult Function(_ComfortableStateDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableStateDto():
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
    TResult? Function(_ComfortableStateDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableStateDto() when $default != null:
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
            int streakCount, int recommendedMealCount, double percentage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComfortableStateDto() when $default != null:
        return $default(
            _that.streakCount, _that.recommendedMealCount, _that.percentage);
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
            int streakCount, int recommendedMealCount, double percentage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableStateDto():
        return $default(
            _that.streakCount, _that.recommendedMealCount, _that.percentage);
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
            int streakCount, int recommendedMealCount, double percentage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComfortableStateDto() when $default != null:
        return $default(
            _that.streakCount, _that.recommendedMealCount, _that.percentage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ComfortableStateDto implements ComfortableStateDto {
  const _ComfortableStateDto(
      {this.streakCount = 0,
      this.recommendedMealCount = 0,
      this.percentage = 0});
  factory _ComfortableStateDto.fromJson(Map<String, dynamic> json) =>
      _$ComfortableStateDtoFromJson(json);

  @override
  @JsonKey()
  final int streakCount;
  @override
  @JsonKey()
  final int recommendedMealCount;
  @override
  @JsonKey()
  final double percentage;

  /// Create a copy of ComfortableStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ComfortableStateDtoCopyWith<_ComfortableStateDto> get copyWith =>
      __$ComfortableStateDtoCopyWithImpl<_ComfortableStateDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ComfortableStateDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ComfortableStateDto &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.recommendedMealCount, recommendedMealCount) ||
                other.recommendedMealCount == recommendedMealCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, streakCount, recommendedMealCount, percentage);

  @override
  String toString() {
    return 'ComfortableStateDto(streakCount: $streakCount, recommendedMealCount: $recommendedMealCount, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$ComfortableStateDtoCopyWith<$Res>
    implements $ComfortableStateDtoCopyWith<$Res> {
  factory _$ComfortableStateDtoCopyWith(_ComfortableStateDto value,
          $Res Function(_ComfortableStateDto) _then) =
      __$ComfortableStateDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int streakCount, int recommendedMealCount, double percentage});
}

/// @nodoc
class __$ComfortableStateDtoCopyWithImpl<$Res>
    implements _$ComfortableStateDtoCopyWith<$Res> {
  __$ComfortableStateDtoCopyWithImpl(this._self, this._then);

  final _ComfortableStateDto _self;
  final $Res Function(_ComfortableStateDto) _then;

  /// Create a copy of ComfortableStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? streakCount = null,
    Object? recommendedMealCount = null,
    Object? percentage = null,
  }) {
    return _then(_ComfortableStateDto(
      streakCount: null == streakCount
          ? _self.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedMealCount: null == recommendedMealCount
          ? _self.recommendedMealCount
          : recommendedMealCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$MealCountDto {
  int get recommendCount;
  int get cautionCount;
  int get riskCount;
  int get unknownCount;

  /// Create a copy of MealCountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCountDtoCopyWith<MealCountDto> get copyWith =>
      _$MealCountDtoCopyWithImpl<MealCountDto>(
          this as MealCountDto, _$identity);

  /// Serializes this MealCountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealCountDto &&
            (identical(other.recommendCount, recommendCount) ||
                other.recommendCount == recommendCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount) &&
            (identical(other.riskCount, riskCount) ||
                other.riskCount == riskCount) &&
            (identical(other.unknownCount, unknownCount) ||
                other.unknownCount == unknownCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, recommendCount, cautionCount, riskCount, unknownCount);

  @override
  String toString() {
    return 'MealCountDto(recommendCount: $recommendCount, cautionCount: $cautionCount, riskCount: $riskCount, unknownCount: $unknownCount)';
  }
}

/// @nodoc
abstract mixin class $MealCountDtoCopyWith<$Res> {
  factory $MealCountDtoCopyWith(
          MealCountDto value, $Res Function(MealCountDto) _then) =
      _$MealCountDtoCopyWithImpl;
  @useResult
  $Res call(
      {int recommendCount, int cautionCount, int riskCount, int unknownCount});
}

/// @nodoc
class _$MealCountDtoCopyWithImpl<$Res> implements $MealCountDtoCopyWith<$Res> {
  _$MealCountDtoCopyWithImpl(this._self, this._then);

  final MealCountDto _self;
  final $Res Function(MealCountDto) _then;

  /// Create a copy of MealCountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendCount = null,
    Object? cautionCount = null,
    Object? riskCount = null,
    Object? unknownCount = null,
  }) {
    return _then(_self.copyWith(
      recommendCount: null == recommendCount
          ? _self.recommendCount
          : recommendCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionCount: null == cautionCount
          ? _self.cautionCount
          : cautionCount // ignore: cast_nullable_to_non_nullable
              as int,
      riskCount: null == riskCount
          ? _self.riskCount
          : riskCount // ignore: cast_nullable_to_non_nullable
              as int,
      unknownCount: null == unknownCount
          ? _self.unknownCount
          : unknownCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealCountDto].
extension MealCountDtoPatterns on MealCountDto {
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
    TResult Function(_MealCountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCountDto() when $default != null:
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
    TResult Function(_MealCountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCountDto():
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
    TResult? Function(_MealCountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCountDto() when $default != null:
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
    TResult Function(int recommendCount, int cautionCount, int riskCount,
            int unknownCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCountDto() when $default != null:
        return $default(_that.recommendCount, _that.cautionCount,
            _that.riskCount, _that.unknownCount);
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
    TResult Function(int recommendCount, int cautionCount, int riskCount,
            int unknownCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCountDto():
        return $default(_that.recommendCount, _that.cautionCount,
            _that.riskCount, _that.unknownCount);
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
    TResult? Function(int recommendCount, int cautionCount, int riskCount,
            int unknownCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCountDto() when $default != null:
        return $default(_that.recommendCount, _that.cautionCount,
            _that.riskCount, _that.unknownCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealCountDto implements MealCountDto {
  const _MealCountDto(
      {this.recommendCount = 0,
      this.cautionCount = 0,
      this.riskCount = 0,
      this.unknownCount = 0});
  factory _MealCountDto.fromJson(Map<String, dynamic> json) =>
      _$MealCountDtoFromJson(json);

  @override
  @JsonKey()
  final int recommendCount;
  @override
  @JsonKey()
  final int cautionCount;
  @override
  @JsonKey()
  final int riskCount;
  @override
  @JsonKey()
  final int unknownCount;

  /// Create a copy of MealCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCountDtoCopyWith<_MealCountDto> get copyWith =>
      __$MealCountDtoCopyWithImpl<_MealCountDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealCountDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealCountDto &&
            (identical(other.recommendCount, recommendCount) ||
                other.recommendCount == recommendCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount) &&
            (identical(other.riskCount, riskCount) ||
                other.riskCount == riskCount) &&
            (identical(other.unknownCount, unknownCount) ||
                other.unknownCount == unknownCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, recommendCount, cautionCount, riskCount, unknownCount);

  @override
  String toString() {
    return 'MealCountDto(recommendCount: $recommendCount, cautionCount: $cautionCount, riskCount: $riskCount, unknownCount: $unknownCount)';
  }
}

/// @nodoc
abstract mixin class _$MealCountDtoCopyWith<$Res>
    implements $MealCountDtoCopyWith<$Res> {
  factory _$MealCountDtoCopyWith(
          _MealCountDto value, $Res Function(_MealCountDto) _then) =
      __$MealCountDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int recommendCount, int cautionCount, int riskCount, int unknownCount});
}

/// @nodoc
class __$MealCountDtoCopyWithImpl<$Res>
    implements _$MealCountDtoCopyWith<$Res> {
  __$MealCountDtoCopyWithImpl(this._self, this._then);

  final _MealCountDto _self;
  final $Res Function(_MealCountDto) _then;

  /// Create a copy of MealCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? recommendCount = null,
    Object? cautionCount = null,
    Object? riskCount = null,
    Object? unknownCount = null,
  }) {
    return _then(_MealCountDto(
      recommendCount: null == recommendCount
          ? _self.recommendCount
          : recommendCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionCount: null == cautionCount
          ? _self.cautionCount
          : cautionCount // ignore: cast_nullable_to_non_nullable
              as int,
      riskCount: null == riskCount
          ? _self.riskCount
          : riskCount // ignore: cast_nullable_to_non_nullable
              as int,
      unknownCount: null == unknownCount
          ? _self.unknownCount
          : unknownCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$SymptomTypeCountDto {
  String get type;
  String get label;
  int get count;

  /// Create a copy of SymptomTypeCountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomTypeCountDtoCopyWith<SymptomTypeCountDto> get copyWith =>
      _$SymptomTypeCountDtoCopyWithImpl<SymptomTypeCountDto>(
          this as SymptomTypeCountDto, _$identity);

  /// Serializes this SymptomTypeCountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomTypeCountDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, label, count);

  @override
  String toString() {
    return 'SymptomTypeCountDto(type: $type, label: $label, count: $count)';
  }
}

/// @nodoc
abstract mixin class $SymptomTypeCountDtoCopyWith<$Res> {
  factory $SymptomTypeCountDtoCopyWith(
          SymptomTypeCountDto value, $Res Function(SymptomTypeCountDto) _then) =
      _$SymptomTypeCountDtoCopyWithImpl;
  @useResult
  $Res call({String type, String label, int count});
}

/// @nodoc
class _$SymptomTypeCountDtoCopyWithImpl<$Res>
    implements $SymptomTypeCountDtoCopyWith<$Res> {
  _$SymptomTypeCountDtoCopyWithImpl(this._self, this._then);

  final SymptomTypeCountDto _self;
  final $Res Function(SymptomTypeCountDto) _then;

  /// Create a copy of SymptomTypeCountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomTypeCountDto].
extension SymptomTypeCountDtoPatterns on SymptomTypeCountDto {
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
    TResult Function(_SymptomTypeCountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomTypeCountDto() when $default != null:
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
    TResult Function(_SymptomTypeCountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomTypeCountDto():
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
    TResult? Function(_SymptomTypeCountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomTypeCountDto() when $default != null:
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
    TResult Function(String type, String label, int count)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomTypeCountDto() when $default != null:
        return $default(_that.type, _that.label, _that.count);
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
    TResult Function(String type, String label, int count) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomTypeCountDto():
        return $default(_that.type, _that.label, _that.count);
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
    TResult? Function(String type, String label, int count)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomTypeCountDto() when $default != null:
        return $default(_that.type, _that.label, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomTypeCountDto implements SymptomTypeCountDto {
  const _SymptomTypeCountDto({this.type = '', this.label = '', this.count = 0});
  factory _SymptomTypeCountDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomTypeCountDtoFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String label;
  @override
  @JsonKey()
  final int count;

  /// Create a copy of SymptomTypeCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomTypeCountDtoCopyWith<_SymptomTypeCountDto> get copyWith =>
      __$SymptomTypeCountDtoCopyWithImpl<_SymptomTypeCountDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomTypeCountDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomTypeCountDto &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, label, count);

  @override
  String toString() {
    return 'SymptomTypeCountDto(type: $type, label: $label, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$SymptomTypeCountDtoCopyWith<$Res>
    implements $SymptomTypeCountDtoCopyWith<$Res> {
  factory _$SymptomTypeCountDtoCopyWith(_SymptomTypeCountDto value,
          $Res Function(_SymptomTypeCountDto) _then) =
      __$SymptomTypeCountDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String type, String label, int count});
}

/// @nodoc
class __$SymptomTypeCountDtoCopyWithImpl<$Res>
    implements _$SymptomTypeCountDtoCopyWith<$Res> {
  __$SymptomTypeCountDtoCopyWithImpl(this._self, this._then);

  final _SymptomTypeCountDto _self;
  final $Res Function(_SymptomTypeCountDto) _then;

  /// Create a copy of SymptomTypeCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? label = null,
    Object? count = null,
  }) {
    return _then(_SymptomTypeCountDto(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$SymptomReportDto {
  int get recordedCount;
  String? get averageTimeLabel;
  int? get averageIntensity;
  List<SymptomTypeCountDto> get typeCounts;

  /// Create a copy of SymptomReportDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomReportDtoCopyWith<SymptomReportDto> get copyWith =>
      _$SymptomReportDtoCopyWithImpl<SymptomReportDto>(
          this as SymptomReportDto, _$identity);

  /// Serializes this SymptomReportDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomReportDto &&
            (identical(other.recordedCount, recordedCount) ||
                other.recordedCount == recordedCount) &&
            (identical(other.averageTimeLabel, averageTimeLabel) ||
                other.averageTimeLabel == averageTimeLabel) &&
            (identical(other.averageIntensity, averageIntensity) ||
                other.averageIntensity == averageIntensity) &&
            const DeepCollectionEquality()
                .equals(other.typeCounts, typeCounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recordedCount, averageTimeLabel,
      averageIntensity, const DeepCollectionEquality().hash(typeCounts));

  @override
  String toString() {
    return 'SymptomReportDto(recordedCount: $recordedCount, averageTimeLabel: $averageTimeLabel, averageIntensity: $averageIntensity, typeCounts: $typeCounts)';
  }
}

/// @nodoc
abstract mixin class $SymptomReportDtoCopyWith<$Res> {
  factory $SymptomReportDtoCopyWith(
          SymptomReportDto value, $Res Function(SymptomReportDto) _then) =
      _$SymptomReportDtoCopyWithImpl;
  @useResult
  $Res call(
      {int recordedCount,
      String? averageTimeLabel,
      int? averageIntensity,
      List<SymptomTypeCountDto> typeCounts});
}

/// @nodoc
class _$SymptomReportDtoCopyWithImpl<$Res>
    implements $SymptomReportDtoCopyWith<$Res> {
  _$SymptomReportDtoCopyWithImpl(this._self, this._then);

  final SymptomReportDto _self;
  final $Res Function(SymptomReportDto) _then;

  /// Create a copy of SymptomReportDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordedCount = null,
    Object? averageTimeLabel = freezed,
    Object? averageIntensity = freezed,
    Object? typeCounts = null,
  }) {
    return _then(_self.copyWith(
      recordedCount: null == recordedCount
          ? _self.recordedCount
          : recordedCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageTimeLabel: freezed == averageTimeLabel
          ? _self.averageTimeLabel
          : averageTimeLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      averageIntensity: freezed == averageIntensity
          ? _self.averageIntensity
          : averageIntensity // ignore: cast_nullable_to_non_nullable
              as int?,
      typeCounts: null == typeCounts
          ? _self.typeCounts
          : typeCounts // ignore: cast_nullable_to_non_nullable
              as List<SymptomTypeCountDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomReportDto].
extension SymptomReportDtoPatterns on SymptomReportDto {
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
    TResult Function(_SymptomReportDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomReportDto() when $default != null:
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
    TResult Function(_SymptomReportDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomReportDto():
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
    TResult? Function(_SymptomReportDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomReportDto() when $default != null:
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
    TResult Function(int recordedCount, String? averageTimeLabel,
            int? averageIntensity, List<SymptomTypeCountDto> typeCounts)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomReportDto() when $default != null:
        return $default(_that.recordedCount, _that.averageTimeLabel,
            _that.averageIntensity, _that.typeCounts);
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
    TResult Function(int recordedCount, String? averageTimeLabel,
            int? averageIntensity, List<SymptomTypeCountDto> typeCounts)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomReportDto():
        return $default(_that.recordedCount, _that.averageTimeLabel,
            _that.averageIntensity, _that.typeCounts);
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
    TResult? Function(int recordedCount, String? averageTimeLabel,
            int? averageIntensity, List<SymptomTypeCountDto> typeCounts)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomReportDto() when $default != null:
        return $default(_that.recordedCount, _that.averageTimeLabel,
            _that.averageIntensity, _that.typeCounts);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomReportDto implements SymptomReportDto {
  const _SymptomReportDto(
      {this.recordedCount = 0,
      this.averageTimeLabel,
      this.averageIntensity,
      final List<SymptomTypeCountDto> typeCounts = const []})
      : _typeCounts = typeCounts;
  factory _SymptomReportDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomReportDtoFromJson(json);

  @override
  @JsonKey()
  final int recordedCount;
  @override
  final String? averageTimeLabel;
  @override
  final int? averageIntensity;
  final List<SymptomTypeCountDto> _typeCounts;
  @override
  @JsonKey()
  List<SymptomTypeCountDto> get typeCounts {
    if (_typeCounts is EqualUnmodifiableListView) return _typeCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typeCounts);
  }

  /// Create a copy of SymptomReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomReportDtoCopyWith<_SymptomReportDto> get copyWith =>
      __$SymptomReportDtoCopyWithImpl<_SymptomReportDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomReportDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomReportDto &&
            (identical(other.recordedCount, recordedCount) ||
                other.recordedCount == recordedCount) &&
            (identical(other.averageTimeLabel, averageTimeLabel) ||
                other.averageTimeLabel == averageTimeLabel) &&
            (identical(other.averageIntensity, averageIntensity) ||
                other.averageIntensity == averageIntensity) &&
            const DeepCollectionEquality()
                .equals(other._typeCounts, _typeCounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recordedCount, averageTimeLabel,
      averageIntensity, const DeepCollectionEquality().hash(_typeCounts));

  @override
  String toString() {
    return 'SymptomReportDto(recordedCount: $recordedCount, averageTimeLabel: $averageTimeLabel, averageIntensity: $averageIntensity, typeCounts: $typeCounts)';
  }
}

/// @nodoc
abstract mixin class _$SymptomReportDtoCopyWith<$Res>
    implements $SymptomReportDtoCopyWith<$Res> {
  factory _$SymptomReportDtoCopyWith(
          _SymptomReportDto value, $Res Function(_SymptomReportDto) _then) =
      __$SymptomReportDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int recordedCount,
      String? averageTimeLabel,
      int? averageIntensity,
      List<SymptomTypeCountDto> typeCounts});
}

/// @nodoc
class __$SymptomReportDtoCopyWithImpl<$Res>
    implements _$SymptomReportDtoCopyWith<$Res> {
  __$SymptomReportDtoCopyWithImpl(this._self, this._then);

  final _SymptomReportDto _self;
  final $Res Function(_SymptomReportDto) _then;

  /// Create a copy of SymptomReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? recordedCount = null,
    Object? averageTimeLabel = freezed,
    Object? averageIntensity = freezed,
    Object? typeCounts = null,
  }) {
    return _then(_SymptomReportDto(
      recordedCount: null == recordedCount
          ? _self.recordedCount
          : recordedCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageTimeLabel: freezed == averageTimeLabel
          ? _self.averageTimeLabel
          : averageTimeLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      averageIntensity: freezed == averageIntensity
          ? _self.averageIntensity
          : averageIntensity // ignore: cast_nullable_to_non_nullable
              as int?,
      typeCounts: null == typeCounts
          ? _self._typeCounts
          : typeCounts // ignore: cast_nullable_to_non_nullable
              as List<SymptomTypeCountDto>,
    ));
  }
}

/// @nodoc
mixin _$WeeklyReportDto {
  String get startDate;
  String get endDate;
  String get weekLabel;
  ComfortableStateDto get comfortableState;
  MealCountDto get mealCount;

  /// 서버 응답에 없으면 null — [SymptomReport] 빈상태로 렌더.
  SymptomReportDto? get symptomReport;

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklyReportDtoCopyWith<WeeklyReportDto> get copyWith =>
      _$WeeklyReportDtoCopyWithImpl<WeeklyReportDto>(
          this as WeeklyReportDto, _$identity);

  /// Serializes this WeeklyReportDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklyReportDto &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.weekLabel, weekLabel) ||
                other.weekLabel == weekLabel) &&
            (identical(other.comfortableState, comfortableState) ||
                other.comfortableState == comfortableState) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount) &&
            (identical(other.symptomReport, symptomReport) ||
                other.symptomReport == symptomReport));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate, weekLabel,
      comfortableState, mealCount, symptomReport);

  @override
  String toString() {
    return 'WeeklyReportDto(startDate: $startDate, endDate: $endDate, weekLabel: $weekLabel, comfortableState: $comfortableState, mealCount: $mealCount, symptomReport: $symptomReport)';
  }
}

/// @nodoc
abstract mixin class $WeeklyReportDtoCopyWith<$Res> {
  factory $WeeklyReportDtoCopyWith(
          WeeklyReportDto value, $Res Function(WeeklyReportDto) _then) =
      _$WeeklyReportDtoCopyWithImpl;
  @useResult
  $Res call(
      {String startDate,
      String endDate,
      String weekLabel,
      ComfortableStateDto comfortableState,
      MealCountDto mealCount,
      SymptomReportDto? symptomReport});

  $ComfortableStateDtoCopyWith<$Res> get comfortableState;
  $MealCountDtoCopyWith<$Res> get mealCount;
  $SymptomReportDtoCopyWith<$Res>? get symptomReport;
}

/// @nodoc
class _$WeeklyReportDtoCopyWithImpl<$Res>
    implements $WeeklyReportDtoCopyWith<$Res> {
  _$WeeklyReportDtoCopyWithImpl(this._self, this._then);

  final WeeklyReportDto _self;
  final $Res Function(WeeklyReportDto) _then;

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? weekLabel = null,
    Object? comfortableState = null,
    Object? mealCount = null,
    Object? symptomReport = freezed,
  }) {
    return _then(_self.copyWith(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      weekLabel: null == weekLabel
          ? _self.weekLabel
          : weekLabel // ignore: cast_nullable_to_non_nullable
              as String,
      comfortableState: null == comfortableState
          ? _self.comfortableState
          : comfortableState // ignore: cast_nullable_to_non_nullable
              as ComfortableStateDto,
      mealCount: null == mealCount
          ? _self.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as MealCountDto,
      symptomReport: freezed == symptomReport
          ? _self.symptomReport
          : symptomReport // ignore: cast_nullable_to_non_nullable
              as SymptomReportDto?,
    ));
  }

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComfortableStateDtoCopyWith<$Res> get comfortableState {
    return $ComfortableStateDtoCopyWith<$Res>(_self.comfortableState, (value) {
      return _then(_self.copyWith(comfortableState: value));
    });
  }

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountDtoCopyWith<$Res> get mealCount {
    return $MealCountDtoCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomReportDtoCopyWith<$Res>? get symptomReport {
    if (_self.symptomReport == null) {
      return null;
    }

    return $SymptomReportDtoCopyWith<$Res>(_self.symptomReport!, (value) {
      return _then(_self.copyWith(symptomReport: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WeeklyReportDto].
extension WeeklyReportDtoPatterns on WeeklyReportDto {
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
    TResult Function(_WeeklyReportDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportDto() when $default != null:
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
    TResult Function(_WeeklyReportDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportDto():
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
    TResult? Function(_WeeklyReportDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportDto() when $default != null:
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
            String startDate,
            String endDate,
            String weekLabel,
            ComfortableStateDto comfortableState,
            MealCountDto mealCount,
            SymptomReportDto? symptomReport)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportDto() when $default != null:
        return $default(_that.startDate, _that.endDate, _that.weekLabel,
            _that.comfortableState, _that.mealCount, _that.symptomReport);
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
            String startDate,
            String endDate,
            String weekLabel,
            ComfortableStateDto comfortableState,
            MealCountDto mealCount,
            SymptomReportDto? symptomReport)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportDto():
        return $default(_that.startDate, _that.endDate, _that.weekLabel,
            _that.comfortableState, _that.mealCount, _that.symptomReport);
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
            String startDate,
            String endDate,
            String weekLabel,
            ComfortableStateDto comfortableState,
            MealCountDto mealCount,
            SymptomReportDto? symptomReport)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyReportDto() when $default != null:
        return $default(_that.startDate, _that.endDate, _that.weekLabel,
            _that.comfortableState, _that.mealCount, _that.symptomReport);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WeeklyReportDto implements WeeklyReportDto {
  const _WeeklyReportDto(
      {required this.startDate,
      required this.endDate,
      required this.weekLabel,
      required this.comfortableState,
      required this.mealCount,
      this.symptomReport});
  factory _WeeklyReportDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportDtoFromJson(json);

  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String weekLabel;
  @override
  final ComfortableStateDto comfortableState;
  @override
  final MealCountDto mealCount;

  /// 서버 응답에 없으면 null — [SymptomReport] 빈상태로 렌더.
  @override
  final SymptomReportDto? symptomReport;

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklyReportDtoCopyWith<_WeeklyReportDto> get copyWith =>
      __$WeeklyReportDtoCopyWithImpl<_WeeklyReportDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeeklyReportDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklyReportDto &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.weekLabel, weekLabel) ||
                other.weekLabel == weekLabel) &&
            (identical(other.comfortableState, comfortableState) ||
                other.comfortableState == comfortableState) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount) &&
            (identical(other.symptomReport, symptomReport) ||
                other.symptomReport == symptomReport));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate, weekLabel,
      comfortableState, mealCount, symptomReport);

  @override
  String toString() {
    return 'WeeklyReportDto(startDate: $startDate, endDate: $endDate, weekLabel: $weekLabel, comfortableState: $comfortableState, mealCount: $mealCount, symptomReport: $symptomReport)';
  }
}

/// @nodoc
abstract mixin class _$WeeklyReportDtoCopyWith<$Res>
    implements $WeeklyReportDtoCopyWith<$Res> {
  factory _$WeeklyReportDtoCopyWith(
          _WeeklyReportDto value, $Res Function(_WeeklyReportDto) _then) =
      __$WeeklyReportDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String startDate,
      String endDate,
      String weekLabel,
      ComfortableStateDto comfortableState,
      MealCountDto mealCount,
      SymptomReportDto? symptomReport});

  @override
  $ComfortableStateDtoCopyWith<$Res> get comfortableState;
  @override
  $MealCountDtoCopyWith<$Res> get mealCount;
  @override
  $SymptomReportDtoCopyWith<$Res>? get symptomReport;
}

/// @nodoc
class __$WeeklyReportDtoCopyWithImpl<$Res>
    implements _$WeeklyReportDtoCopyWith<$Res> {
  __$WeeklyReportDtoCopyWithImpl(this._self, this._then);

  final _WeeklyReportDto _self;
  final $Res Function(_WeeklyReportDto) _then;

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? weekLabel = null,
    Object? comfortableState = null,
    Object? mealCount = null,
    Object? symptomReport = freezed,
  }) {
    return _then(_WeeklyReportDto(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      weekLabel: null == weekLabel
          ? _self.weekLabel
          : weekLabel // ignore: cast_nullable_to_non_nullable
              as String,
      comfortableState: null == comfortableState
          ? _self.comfortableState
          : comfortableState // ignore: cast_nullable_to_non_nullable
              as ComfortableStateDto,
      mealCount: null == mealCount
          ? _self.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as MealCountDto,
      symptomReport: freezed == symptomReport
          ? _self.symptomReport
          : symptomReport // ignore: cast_nullable_to_non_nullable
              as SymptomReportDto?,
    ));
  }

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComfortableStateDtoCopyWith<$Res> get comfortableState {
    return $ComfortableStateDtoCopyWith<$Res>(_self.comfortableState, (value) {
      return _then(_self.copyWith(comfortableState: value));
    });
  }

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountDtoCopyWith<$Res> get mealCount {
    return $MealCountDtoCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }

  /// Create a copy of WeeklyReportDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomReportDtoCopyWith<$Res>? get symptomReport {
    if (_self.symptomReport == null) {
      return null;
    }

    return $SymptomReportDtoCopyWith<$Res>(_self.symptomReport!, (value) {
      return _then(_self.copyWith(symptomReport: value));
    });
  }
}

// dart format on
