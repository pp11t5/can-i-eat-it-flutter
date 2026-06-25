// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symptom_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SymptomLinkedFoodDto {
  String get mealFoodId;
  String get name;
  String? get category;

  /// Create a copy of SymptomLinkedFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomLinkedFoodDtoCopyWith<SymptomLinkedFoodDto> get copyWith =>
      _$SymptomLinkedFoodDtoCopyWithImpl<SymptomLinkedFoodDto>(
          this as SymptomLinkedFoodDto, _$identity);

  /// Serializes this SymptomLinkedFoodDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomLinkedFoodDto &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mealFoodId, name, category);

  @override
  String toString() {
    return 'SymptomLinkedFoodDto(mealFoodId: $mealFoodId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class $SymptomLinkedFoodDtoCopyWith<$Res> {
  factory $SymptomLinkedFoodDtoCopyWith(SymptomLinkedFoodDto value,
          $Res Function(SymptomLinkedFoodDto) _then) =
      _$SymptomLinkedFoodDtoCopyWithImpl;
  @useResult
  $Res call({String mealFoodId, String name, String? category});
}

/// @nodoc
class _$SymptomLinkedFoodDtoCopyWithImpl<$Res>
    implements $SymptomLinkedFoodDtoCopyWith<$Res> {
  _$SymptomLinkedFoodDtoCopyWithImpl(this._self, this._then);

  final SymptomLinkedFoodDto _self;
  final $Res Function(SymptomLinkedFoodDto) _then;

  /// Create a copy of SymptomLinkedFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_self.copyWith(
      mealFoodId: null == mealFoodId
          ? _self.mealFoodId
          : mealFoodId // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [SymptomLinkedFoodDto].
extension SymptomLinkedFoodDtoPatterns on SymptomLinkedFoodDto {
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
    TResult Function(_SymptomLinkedFoodDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFoodDto() when $default != null:
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
    TResult Function(_SymptomLinkedFoodDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFoodDto():
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
    TResult? Function(_SymptomLinkedFoodDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFoodDto() when $default != null:
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
    TResult Function(String mealFoodId, String name, String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFoodDto() when $default != null:
        return $default(_that.mealFoodId, _that.name, _that.category);
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
    TResult Function(String mealFoodId, String name, String? category) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFoodDto():
        return $default(_that.mealFoodId, _that.name, _that.category);
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
    TResult? Function(String mealFoodId, String name, String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFoodDto() when $default != null:
        return $default(_that.mealFoodId, _that.name, _that.category);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomLinkedFoodDto implements SymptomLinkedFoodDto {
  const _SymptomLinkedFoodDto(
      {required this.mealFoodId, required this.name, this.category});
  factory _SymptomLinkedFoodDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomLinkedFoodDtoFromJson(json);

  @override
  final String mealFoodId;
  @override
  final String name;
  @override
  final String? category;

  /// Create a copy of SymptomLinkedFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomLinkedFoodDtoCopyWith<_SymptomLinkedFoodDto> get copyWith =>
      __$SymptomLinkedFoodDtoCopyWithImpl<_SymptomLinkedFoodDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomLinkedFoodDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomLinkedFoodDto &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mealFoodId, name, category);

  @override
  String toString() {
    return 'SymptomLinkedFoodDto(mealFoodId: $mealFoodId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$SymptomLinkedFoodDtoCopyWith<$Res>
    implements $SymptomLinkedFoodDtoCopyWith<$Res> {
  factory _$SymptomLinkedFoodDtoCopyWith(_SymptomLinkedFoodDto value,
          $Res Function(_SymptomLinkedFoodDto) _then) =
      __$SymptomLinkedFoodDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String mealFoodId, String name, String? category});
}

/// @nodoc
class __$SymptomLinkedFoodDtoCopyWithImpl<$Res>
    implements _$SymptomLinkedFoodDtoCopyWith<$Res> {
  __$SymptomLinkedFoodDtoCopyWithImpl(this._self, this._then);

  final _SymptomLinkedFoodDto _self;
  final $Res Function(_SymptomLinkedFoodDto) _then;

  /// Create a copy of SymptomLinkedFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_SymptomLinkedFoodDto(
      mealFoodId: null == mealFoodId
          ? _self.mealFoodId
          : mealFoodId // ignore: cast_nullable_to_non_nullable
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

/// @nodoc
mixin _$SymptomLinkedMealDto {
  String get mealRecordId;
  List<SymptomLinkedFoodDto> get foods;

  /// Create a copy of SymptomLinkedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomLinkedMealDtoCopyWith<SymptomLinkedMealDto> get copyWith =>
      _$SymptomLinkedMealDtoCopyWithImpl<SymptomLinkedMealDto>(
          this as SymptomLinkedMealDto, _$identity);

  /// Serializes this SymptomLinkedMealDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomLinkedMealDto &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            const DeepCollectionEquality().equals(other.foods, foods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordId, const DeepCollectionEquality().hash(foods));

  @override
  String toString() {
    return 'SymptomLinkedMealDto(mealRecordId: $mealRecordId, foods: $foods)';
  }
}

/// @nodoc
abstract mixin class $SymptomLinkedMealDtoCopyWith<$Res> {
  factory $SymptomLinkedMealDtoCopyWith(SymptomLinkedMealDto value,
          $Res Function(SymptomLinkedMealDto) _then) =
      _$SymptomLinkedMealDtoCopyWithImpl;
  @useResult
  $Res call({String mealRecordId, List<SymptomLinkedFoodDto> foods});
}

/// @nodoc
class _$SymptomLinkedMealDtoCopyWithImpl<$Res>
    implements $SymptomLinkedMealDtoCopyWith<$Res> {
  _$SymptomLinkedMealDtoCopyWithImpl(this._self, this._then);

  final SymptomLinkedMealDto _self;
  final $Res Function(SymptomLinkedMealDto) _then;

  /// Create a copy of SymptomLinkedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordId = null,
    Object? foods = null,
  }) {
    return _then(_self.copyWith(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _self.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<SymptomLinkedFoodDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomLinkedMealDto].
extension SymptomLinkedMealDtoPatterns on SymptomLinkedMealDto {
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
    TResult Function(_SymptomLinkedMealDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMealDto() when $default != null:
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
    TResult Function(_SymptomLinkedMealDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMealDto():
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
    TResult? Function(_SymptomLinkedMealDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMealDto() when $default != null:
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
    TResult Function(String mealRecordId, List<SymptomLinkedFoodDto> foods)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMealDto() when $default != null:
        return $default(_that.mealRecordId, _that.foods);
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
    TResult Function(String mealRecordId, List<SymptomLinkedFoodDto> foods)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMealDto():
        return $default(_that.mealRecordId, _that.foods);
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
    TResult? Function(String mealRecordId, List<SymptomLinkedFoodDto> foods)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMealDto() when $default != null:
        return $default(_that.mealRecordId, _that.foods);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomLinkedMealDto implements SymptomLinkedMealDto {
  const _SymptomLinkedMealDto(
      {required this.mealRecordId,
      final List<SymptomLinkedFoodDto> foods = const <SymptomLinkedFoodDto>[]})
      : _foods = foods;
  factory _SymptomLinkedMealDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomLinkedMealDtoFromJson(json);

  @override
  final String mealRecordId;
  final List<SymptomLinkedFoodDto> _foods;
  @override
  @JsonKey()
  List<SymptomLinkedFoodDto> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  /// Create a copy of SymptomLinkedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomLinkedMealDtoCopyWith<_SymptomLinkedMealDto> get copyWith =>
      __$SymptomLinkedMealDtoCopyWithImpl<_SymptomLinkedMealDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomLinkedMealDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomLinkedMealDto &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            const DeepCollectionEquality().equals(other._foods, _foods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordId, const DeepCollectionEquality().hash(_foods));

  @override
  String toString() {
    return 'SymptomLinkedMealDto(mealRecordId: $mealRecordId, foods: $foods)';
  }
}

/// @nodoc
abstract mixin class _$SymptomLinkedMealDtoCopyWith<$Res>
    implements $SymptomLinkedMealDtoCopyWith<$Res> {
  factory _$SymptomLinkedMealDtoCopyWith(_SymptomLinkedMealDto value,
          $Res Function(_SymptomLinkedMealDto) _then) =
      __$SymptomLinkedMealDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String mealRecordId, List<SymptomLinkedFoodDto> foods});
}

/// @nodoc
class __$SymptomLinkedMealDtoCopyWithImpl<$Res>
    implements _$SymptomLinkedMealDtoCopyWith<$Res> {
  __$SymptomLinkedMealDtoCopyWithImpl(this._self, this._then);

  final _SymptomLinkedMealDto _self;
  final $Res Function(_SymptomLinkedMealDto) _then;

  /// Create a copy of SymptomLinkedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? foods = null,
  }) {
    return _then(_SymptomLinkedMealDto(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _self._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<SymptomLinkedFoodDto>,
    ));
  }
}

/// @nodoc
mixin _$SymptomAnalysisItemDto {
  String get emphasis;
  String get body;

  /// Create a copy of SymptomAnalysisItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomAnalysisItemDtoCopyWith<SymptomAnalysisItemDto> get copyWith =>
      _$SymptomAnalysisItemDtoCopyWithImpl<SymptomAnalysisItemDto>(
          this as SymptomAnalysisItemDto, _$identity);

  /// Serializes this SymptomAnalysisItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomAnalysisItemDto &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'SymptomAnalysisItemDto(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class $SymptomAnalysisItemDtoCopyWith<$Res> {
  factory $SymptomAnalysisItemDtoCopyWith(SymptomAnalysisItemDto value,
          $Res Function(SymptomAnalysisItemDto) _then) =
      _$SymptomAnalysisItemDtoCopyWithImpl;
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class _$SymptomAnalysisItemDtoCopyWithImpl<$Res>
    implements $SymptomAnalysisItemDtoCopyWith<$Res> {
  _$SymptomAnalysisItemDtoCopyWithImpl(this._self, this._then);

  final SymptomAnalysisItemDto _self;
  final $Res Function(SymptomAnalysisItemDto) _then;

  /// Create a copy of SymptomAnalysisItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emphasis = null,
    Object? body = null,
  }) {
    return _then(_self.copyWith(
      emphasis: null == emphasis
          ? _self.emphasis
          : emphasis // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomAnalysisItemDto].
extension SymptomAnalysisItemDtoPatterns on SymptomAnalysisItemDto {
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
    TResult Function(_SymptomAnalysisItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItemDto() when $default != null:
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
    TResult Function(_SymptomAnalysisItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItemDto():
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
    TResult? Function(_SymptomAnalysisItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItemDto() when $default != null:
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
    TResult Function(String emphasis, String body)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItemDto() when $default != null:
        return $default(_that.emphasis, _that.body);
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
    TResult Function(String emphasis, String body) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItemDto():
        return $default(_that.emphasis, _that.body);
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
    TResult? Function(String emphasis, String body)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItemDto() when $default != null:
        return $default(_that.emphasis, _that.body);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomAnalysisItemDto implements SymptomAnalysisItemDto {
  const _SymptomAnalysisItemDto({required this.emphasis, required this.body});
  factory _SymptomAnalysisItemDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomAnalysisItemDtoFromJson(json);

  @override
  final String emphasis;
  @override
  final String body;

  /// Create a copy of SymptomAnalysisItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomAnalysisItemDtoCopyWith<_SymptomAnalysisItemDto> get copyWith =>
      __$SymptomAnalysisItemDtoCopyWithImpl<_SymptomAnalysisItemDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomAnalysisItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomAnalysisItemDto &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'SymptomAnalysisItemDto(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$SymptomAnalysisItemDtoCopyWith<$Res>
    implements $SymptomAnalysisItemDtoCopyWith<$Res> {
  factory _$SymptomAnalysisItemDtoCopyWith(_SymptomAnalysisItemDto value,
          $Res Function(_SymptomAnalysisItemDto) _then) =
      __$SymptomAnalysisItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class __$SymptomAnalysisItemDtoCopyWithImpl<$Res>
    implements _$SymptomAnalysisItemDtoCopyWith<$Res> {
  __$SymptomAnalysisItemDtoCopyWithImpl(this._self, this._then);

  final _SymptomAnalysisItemDto _self;
  final $Res Function(_SymptomAnalysisItemDto) _then;

  /// Create a copy of SymptomAnalysisItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? emphasis = null,
    Object? body = null,
  }) {
    return _then(_SymptomAnalysisItemDto(
      emphasis: null == emphasis
          ? _self.emphasis
          : emphasis // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$SymptomAnalysisDto {
  List<SymptomAnalysisItemDto> get items;

  /// Create a copy of SymptomAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomAnalysisDtoCopyWith<SymptomAnalysisDto> get copyWith =>
      _$SymptomAnalysisDtoCopyWithImpl<SymptomAnalysisDto>(
          this as SymptomAnalysisDto, _$identity);

  /// Serializes this SymptomAnalysisDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomAnalysisDto &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'SymptomAnalysisDto(items: $items)';
  }
}

/// @nodoc
abstract mixin class $SymptomAnalysisDtoCopyWith<$Res> {
  factory $SymptomAnalysisDtoCopyWith(
          SymptomAnalysisDto value, $Res Function(SymptomAnalysisDto) _then) =
      _$SymptomAnalysisDtoCopyWithImpl;
  @useResult
  $Res call({List<SymptomAnalysisItemDto> items});
}

/// @nodoc
class _$SymptomAnalysisDtoCopyWithImpl<$Res>
    implements $SymptomAnalysisDtoCopyWith<$Res> {
  _$SymptomAnalysisDtoCopyWithImpl(this._self, this._then);

  final SymptomAnalysisDto _self;
  final $Res Function(SymptomAnalysisDto) _then;

  /// Create a copy of SymptomAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SymptomAnalysisItemDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomAnalysisDto].
extension SymptomAnalysisDtoPatterns on SymptomAnalysisDto {
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
    TResult Function(_SymptomAnalysisDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisDto() when $default != null:
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
    TResult Function(_SymptomAnalysisDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisDto():
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
    TResult? Function(_SymptomAnalysisDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisDto() when $default != null:
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
    TResult Function(List<SymptomAnalysisItemDto> items)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisDto() when $default != null:
        return $default(_that.items);
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
    TResult Function(List<SymptomAnalysisItemDto> items) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisDto():
        return $default(_that.items);
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
    TResult? Function(List<SymptomAnalysisItemDto> items)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisDto() when $default != null:
        return $default(_that.items);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomAnalysisDto implements SymptomAnalysisDto {
  const _SymptomAnalysisDto(
      {final List<SymptomAnalysisItemDto> items =
          const <SymptomAnalysisItemDto>[]})
      : _items = items;
  factory _SymptomAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomAnalysisDtoFromJson(json);

  final List<SymptomAnalysisItemDto> _items;
  @override
  @JsonKey()
  List<SymptomAnalysisItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of SymptomAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomAnalysisDtoCopyWith<_SymptomAnalysisDto> get copyWith =>
      __$SymptomAnalysisDtoCopyWithImpl<_SymptomAnalysisDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomAnalysisDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomAnalysisDto &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'SymptomAnalysisDto(items: $items)';
  }
}

/// @nodoc
abstract mixin class _$SymptomAnalysisDtoCopyWith<$Res>
    implements $SymptomAnalysisDtoCopyWith<$Res> {
  factory _$SymptomAnalysisDtoCopyWith(
          _SymptomAnalysisDto value, $Res Function(_SymptomAnalysisDto) _then) =
      __$SymptomAnalysisDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<SymptomAnalysisItemDto> items});
}

/// @nodoc
class __$SymptomAnalysisDtoCopyWithImpl<$Res>
    implements _$SymptomAnalysisDtoCopyWith<$Res> {
  __$SymptomAnalysisDtoCopyWithImpl(this._self, this._then);

  final _SymptomAnalysisDto _self;
  final $Res Function(_SymptomAnalysisDto) _then;

  /// Create a copy of SymptomAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(_SymptomAnalysisDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SymptomAnalysisItemDto>,
    ));
  }
}

/// @nodoc
mixin _$SymptomResponseDto {
  String get symptomId;
  String get symptomState;
  String get stateTitle;
  List<String> get symptomTypes;
  String get occurredAt;
  SymptomLinkedMealDto? get linkedMeal;
  SymptomAnalysisDto? get analysis;

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomResponseDtoCopyWith<SymptomResponseDto> get copyWith =>
      _$SymptomResponseDtoCopyWithImpl<SymptomResponseDto>(
          this as SymptomResponseDto, _$identity);

  /// Serializes this SymptomResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomResponseDto &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.stateTitle, stateTitle) ||
                other.stateTitle == stateTitle) &&
            const DeepCollectionEquality()
                .equals(other.symptomTypes, symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.linkedMeal, linkedMeal) ||
                other.linkedMeal == linkedMeal) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      stateTitle,
      const DeepCollectionEquality().hash(symptomTypes),
      occurredAt,
      linkedMeal,
      analysis);

  @override
  String toString() {
    return 'SymptomResponseDto(symptomId: $symptomId, symptomState: $symptomState, stateTitle: $stateTitle, symptomTypes: $symptomTypes, occurredAt: $occurredAt, linkedMeal: $linkedMeal, analysis: $analysis)';
  }
}

/// @nodoc
abstract mixin class $SymptomResponseDtoCopyWith<$Res> {
  factory $SymptomResponseDtoCopyWith(
          SymptomResponseDto value, $Res Function(SymptomResponseDto) _then) =
      _$SymptomResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {String symptomId,
      String symptomState,
      String stateTitle,
      List<String> symptomTypes,
      String occurredAt,
      SymptomLinkedMealDto? linkedMeal,
      SymptomAnalysisDto? analysis});

  $SymptomLinkedMealDtoCopyWith<$Res>? get linkedMeal;
  $SymptomAnalysisDtoCopyWith<$Res>? get analysis;
}

/// @nodoc
class _$SymptomResponseDtoCopyWithImpl<$Res>
    implements $SymptomResponseDtoCopyWith<$Res> {
  _$SymptomResponseDtoCopyWithImpl(this._self, this._then);

  final SymptomResponseDto _self;
  final $Res Function(SymptomResponseDto) _then;

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? stateTitle = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? linkedMeal = freezed,
    Object? analysis = freezed,
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
      stateTitle: null == stateTitle
          ? _self.stateTitle
          : stateTitle // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self.symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      linkedMeal: freezed == linkedMeal
          ? _self.linkedMeal
          : linkedMeal // ignore: cast_nullable_to_non_nullable
              as SymptomLinkedMealDto?,
      analysis: freezed == analysis
          ? _self.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as SymptomAnalysisDto?,
    ));
  }

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomLinkedMealDtoCopyWith<$Res>? get linkedMeal {
    if (_self.linkedMeal == null) {
      return null;
    }

    return $SymptomLinkedMealDtoCopyWith<$Res>(_self.linkedMeal!, (value) {
      return _then(_self.copyWith(linkedMeal: value));
    });
  }

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomAnalysisDtoCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
      return null;
    }

    return $SymptomAnalysisDtoCopyWith<$Res>(_self.analysis!, (value) {
      return _then(_self.copyWith(analysis: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SymptomResponseDto].
extension SymptomResponseDtoPatterns on SymptomResponseDto {
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
    TResult Function(_SymptomResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomResponseDto() when $default != null:
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
    TResult Function(_SymptomResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomResponseDto():
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
    TResult? Function(_SymptomResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomResponseDto() when $default != null:
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
            String stateTitle,
            List<String> symptomTypes,
            String occurredAt,
            SymptomLinkedMealDto? linkedMeal,
            SymptomAnalysisDto? analysis)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomResponseDto() when $default != null:
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.stateTitle,
            _that.symptomTypes,
            _that.occurredAt,
            _that.linkedMeal,
            _that.analysis);
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
            String stateTitle,
            List<String> symptomTypes,
            String occurredAt,
            SymptomLinkedMealDto? linkedMeal,
            SymptomAnalysisDto? analysis)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomResponseDto():
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.stateTitle,
            _that.symptomTypes,
            _that.occurredAt,
            _that.linkedMeal,
            _that.analysis);
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
            String stateTitle,
            List<String> symptomTypes,
            String occurredAt,
            SymptomLinkedMealDto? linkedMeal,
            SymptomAnalysisDto? analysis)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomResponseDto() when $default != null:
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.stateTitle,
            _that.symptomTypes,
            _that.occurredAt,
            _that.linkedMeal,
            _that.analysis);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomResponseDto implements SymptomResponseDto {
  const _SymptomResponseDto(
      {required this.symptomId,
      required this.symptomState,
      required this.stateTitle,
      final List<String> symptomTypes = const <String>[],
      required this.occurredAt,
      this.linkedMeal,
      this.analysis})
      : _symptomTypes = symptomTypes;
  factory _SymptomResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomResponseDtoFromJson(json);

  @override
  final String symptomId;
  @override
  final String symptomState;
  @override
  final String stateTitle;
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
  final SymptomLinkedMealDto? linkedMeal;
  @override
  final SymptomAnalysisDto? analysis;

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomResponseDtoCopyWith<_SymptomResponseDto> get copyWith =>
      __$SymptomResponseDtoCopyWithImpl<_SymptomResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomResponseDto &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.stateTitle, stateTitle) ||
                other.stateTitle == stateTitle) &&
            const DeepCollectionEquality()
                .equals(other._symptomTypes, _symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.linkedMeal, linkedMeal) ||
                other.linkedMeal == linkedMeal) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      stateTitle,
      const DeepCollectionEquality().hash(_symptomTypes),
      occurredAt,
      linkedMeal,
      analysis);

  @override
  String toString() {
    return 'SymptomResponseDto(symptomId: $symptomId, symptomState: $symptomState, stateTitle: $stateTitle, symptomTypes: $symptomTypes, occurredAt: $occurredAt, linkedMeal: $linkedMeal, analysis: $analysis)';
  }
}

/// @nodoc
abstract mixin class _$SymptomResponseDtoCopyWith<$Res>
    implements $SymptomResponseDtoCopyWith<$Res> {
  factory _$SymptomResponseDtoCopyWith(
          _SymptomResponseDto value, $Res Function(_SymptomResponseDto) _then) =
      __$SymptomResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomId,
      String symptomState,
      String stateTitle,
      List<String> symptomTypes,
      String occurredAt,
      SymptomLinkedMealDto? linkedMeal,
      SymptomAnalysisDto? analysis});

  @override
  $SymptomLinkedMealDtoCopyWith<$Res>? get linkedMeal;
  @override
  $SymptomAnalysisDtoCopyWith<$Res>? get analysis;
}

/// @nodoc
class __$SymptomResponseDtoCopyWithImpl<$Res>
    implements _$SymptomResponseDtoCopyWith<$Res> {
  __$SymptomResponseDtoCopyWithImpl(this._self, this._then);

  final _SymptomResponseDto _self;
  final $Res Function(_SymptomResponseDto) _then;

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? stateTitle = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? linkedMeal = freezed,
    Object? analysis = freezed,
  }) {
    return _then(_SymptomResponseDto(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String,
      stateTitle: null == stateTitle
          ? _self.stateTitle
          : stateTitle // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self._symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      linkedMeal: freezed == linkedMeal
          ? _self.linkedMeal
          : linkedMeal // ignore: cast_nullable_to_non_nullable
              as SymptomLinkedMealDto?,
      analysis: freezed == analysis
          ? _self.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as SymptomAnalysisDto?,
    ));
  }

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomLinkedMealDtoCopyWith<$Res>? get linkedMeal {
    if (_self.linkedMeal == null) {
      return null;
    }

    return $SymptomLinkedMealDtoCopyWith<$Res>(_self.linkedMeal!, (value) {
      return _then(_self.copyWith(linkedMeal: value));
    });
  }

  /// Create a copy of SymptomResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomAnalysisDtoCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
      return null;
    }

    return $SymptomAnalysisDtoCopyWith<$Res>(_self.analysis!, (value) {
      return _then(_self.copyWith(analysis: value));
    });
  }
}

/// @nodoc
mixin _$SymptomCreateRequestDto {
  String get symptomState;
  List<String> get symptomTypes;
  String? get occurredAt;
  String get mealRecordId;
  String? get memo;

  /// Create a copy of SymptomCreateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomCreateRequestDtoCopyWith<SymptomCreateRequestDto> get copyWith =>
      _$SymptomCreateRequestDtoCopyWithImpl<SymptomCreateRequestDto>(
          this as SymptomCreateRequestDto, _$identity);

  /// Serializes this SymptomCreateRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomCreateRequestDto &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            const DeepCollectionEquality()
                .equals(other.symptomTypes, symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomState,
      const DeepCollectionEquality().hash(symptomTypes),
      occurredAt,
      mealRecordId,
      memo);

  @override
  String toString() {
    return 'SymptomCreateRequestDto(symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, memo: $memo)';
  }
}

/// @nodoc
abstract mixin class $SymptomCreateRequestDtoCopyWith<$Res> {
  factory $SymptomCreateRequestDtoCopyWith(SymptomCreateRequestDto value,
          $Res Function(SymptomCreateRequestDto) _then) =
      _$SymptomCreateRequestDtoCopyWithImpl;
  @useResult
  $Res call(
      {String symptomState,
      List<String> symptomTypes,
      String? occurredAt,
      String mealRecordId,
      String? memo});
}

/// @nodoc
class _$SymptomCreateRequestDtoCopyWithImpl<$Res>
    implements $SymptomCreateRequestDtoCopyWith<$Res> {
  _$SymptomCreateRequestDtoCopyWithImpl(this._self, this._then);

  final SymptomCreateRequestDto _self;
  final $Res Function(SymptomCreateRequestDto) _then;

  /// Create a copy of SymptomCreateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomState = null,
    Object? symptomTypes = null,
    Object? occurredAt = freezed,
    Object? mealRecordId = null,
    Object? memo = freezed,
  }) {
    return _then(_self.copyWith(
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self.symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      occurredAt: freezed == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomCreateRequestDto].
extension SymptomCreateRequestDtoPatterns on SymptomCreateRequestDto {
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
    TResult Function(_SymptomCreateRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomCreateRequestDto() when $default != null:
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
    TResult Function(_SymptomCreateRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomCreateRequestDto():
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
    TResult? Function(_SymptomCreateRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomCreateRequestDto() when $default != null:
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
    TResult Function(String symptomState, List<String> symptomTypes,
            String? occurredAt, String mealRecordId, String? memo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomCreateRequestDto() when $default != null:
        return $default(_that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.memo);
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
    TResult Function(String symptomState, List<String> symptomTypes,
            String? occurredAt, String mealRecordId, String? memo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomCreateRequestDto():
        return $default(_that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.memo);
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
    TResult? Function(String symptomState, List<String> symptomTypes,
            String? occurredAt, String mealRecordId, String? memo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomCreateRequestDto() when $default != null:
        return $default(_that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.memo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomCreateRequestDto implements SymptomCreateRequestDto {
  const _SymptomCreateRequestDto(
      {required this.symptomState,
      final List<String> symptomTypes = const <String>[],
      this.occurredAt,
      required this.mealRecordId,
      this.memo})
      : _symptomTypes = symptomTypes;
  factory _SymptomCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomCreateRequestDtoFromJson(json);

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
  final String? occurredAt;
  @override
  final String mealRecordId;
  @override
  final String? memo;

  /// Create a copy of SymptomCreateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomCreateRequestDtoCopyWith<_SymptomCreateRequestDto> get copyWith =>
      __$SymptomCreateRequestDtoCopyWithImpl<_SymptomCreateRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomCreateRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomCreateRequestDto &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            const DeepCollectionEquality()
                .equals(other._symptomTypes, _symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomState,
      const DeepCollectionEquality().hash(_symptomTypes),
      occurredAt,
      mealRecordId,
      memo);

  @override
  String toString() {
    return 'SymptomCreateRequestDto(symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, memo: $memo)';
  }
}

/// @nodoc
abstract mixin class _$SymptomCreateRequestDtoCopyWith<$Res>
    implements $SymptomCreateRequestDtoCopyWith<$Res> {
  factory _$SymptomCreateRequestDtoCopyWith(_SymptomCreateRequestDto value,
          $Res Function(_SymptomCreateRequestDto) _then) =
      __$SymptomCreateRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomState,
      List<String> symptomTypes,
      String? occurredAt,
      String mealRecordId,
      String? memo});
}

/// @nodoc
class __$SymptomCreateRequestDtoCopyWithImpl<$Res>
    implements _$SymptomCreateRequestDtoCopyWith<$Res> {
  __$SymptomCreateRequestDtoCopyWithImpl(this._self, this._then);

  final _SymptomCreateRequestDto _self;
  final $Res Function(_SymptomCreateRequestDto) _then;

  /// Create a copy of SymptomCreateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomState = null,
    Object? symptomTypes = null,
    Object? occurredAt = freezed,
    Object? mealRecordId = null,
    Object? memo = freezed,
  }) {
    return _then(_SymptomCreateRequestDto(
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self._symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      occurredAt: freezed == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SymptomUpdateRequestDto {
  String get symptomState;
  List<String> get symptomTypes;
  String get occurredAt;
  String get mealRecordId;
  String? get memo;

  /// Create a copy of SymptomUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomUpdateRequestDtoCopyWith<SymptomUpdateRequestDto> get copyWith =>
      _$SymptomUpdateRequestDtoCopyWithImpl<SymptomUpdateRequestDto>(
          this as SymptomUpdateRequestDto, _$identity);

  /// Serializes this SymptomUpdateRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomUpdateRequestDto &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            const DeepCollectionEquality()
                .equals(other.symptomTypes, symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomState,
      const DeepCollectionEquality().hash(symptomTypes),
      occurredAt,
      mealRecordId,
      memo);

  @override
  String toString() {
    return 'SymptomUpdateRequestDto(symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, memo: $memo)';
  }
}

/// @nodoc
abstract mixin class $SymptomUpdateRequestDtoCopyWith<$Res> {
  factory $SymptomUpdateRequestDtoCopyWith(SymptomUpdateRequestDto value,
          $Res Function(SymptomUpdateRequestDto) _then) =
      _$SymptomUpdateRequestDtoCopyWithImpl;
  @useResult
  $Res call(
      {String symptomState,
      List<String> symptomTypes,
      String occurredAt,
      String mealRecordId,
      String? memo});
}

/// @nodoc
class _$SymptomUpdateRequestDtoCopyWithImpl<$Res>
    implements $SymptomUpdateRequestDtoCopyWith<$Res> {
  _$SymptomUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final SymptomUpdateRequestDto _self;
  final $Res Function(SymptomUpdateRequestDto) _then;

  /// Create a copy of SymptomUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomState = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? mealRecordId = null,
    Object? memo = freezed,
  }) {
    return _then(_self.copyWith(
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
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomUpdateRequestDto].
extension SymptomUpdateRequestDtoPatterns on SymptomUpdateRequestDto {
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
    TResult Function(_SymptomUpdateRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomUpdateRequestDto() when $default != null:
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
    TResult Function(_SymptomUpdateRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomUpdateRequestDto():
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
    TResult? Function(_SymptomUpdateRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomUpdateRequestDto() when $default != null:
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
    TResult Function(String symptomState, List<String> symptomTypes,
            String occurredAt, String mealRecordId, String? memo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomUpdateRequestDto() when $default != null:
        return $default(_that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.memo);
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
    TResult Function(String symptomState, List<String> symptomTypes,
            String occurredAt, String mealRecordId, String? memo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomUpdateRequestDto():
        return $default(_that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.memo);
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
    TResult? Function(String symptomState, List<String> symptomTypes,
            String occurredAt, String mealRecordId, String? memo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomUpdateRequestDto() when $default != null:
        return $default(_that.symptomState, _that.symptomTypes,
            _that.occurredAt, _that.mealRecordId, _that.memo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomUpdateRequestDto implements SymptomUpdateRequestDto {
  const _SymptomUpdateRequestDto(
      {required this.symptomState,
      final List<String> symptomTypes = const <String>[],
      required this.occurredAt,
      required this.mealRecordId,
      this.memo})
      : _symptomTypes = symptomTypes;
  factory _SymptomUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomUpdateRequestDtoFromJson(json);

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
  final String? memo;

  /// Create a copy of SymptomUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomUpdateRequestDtoCopyWith<_SymptomUpdateRequestDto> get copyWith =>
      __$SymptomUpdateRequestDtoCopyWithImpl<_SymptomUpdateRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomUpdateRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomUpdateRequestDto &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            const DeepCollectionEquality()
                .equals(other._symptomTypes, _symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomState,
      const DeepCollectionEquality().hash(_symptomTypes),
      occurredAt,
      mealRecordId,
      memo);

  @override
  String toString() {
    return 'SymptomUpdateRequestDto(symptomState: $symptomState, symptomTypes: $symptomTypes, occurredAt: $occurredAt, mealRecordId: $mealRecordId, memo: $memo)';
  }
}

/// @nodoc
abstract mixin class _$SymptomUpdateRequestDtoCopyWith<$Res>
    implements $SymptomUpdateRequestDtoCopyWith<$Res> {
  factory _$SymptomUpdateRequestDtoCopyWith(_SymptomUpdateRequestDto value,
          $Res Function(_SymptomUpdateRequestDto) _then) =
      __$SymptomUpdateRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomState,
      List<String> symptomTypes,
      String occurredAt,
      String mealRecordId,
      String? memo});
}

/// @nodoc
class __$SymptomUpdateRequestDtoCopyWithImpl<$Res>
    implements _$SymptomUpdateRequestDtoCopyWith<$Res> {
  __$SymptomUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final _SymptomUpdateRequestDto _self;
  final $Res Function(_SymptomUpdateRequestDto) _then;

  /// Create a copy of SymptomUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomState = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? mealRecordId = null,
    Object? memo = freezed,
  }) {
    return _then(_SymptomUpdateRequestDto(
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
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SymptomMemoUpdateRequestDto {
  String? get memo;

  /// Create a copy of SymptomMemoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomMemoUpdateRequestDtoCopyWith<SymptomMemoUpdateRequestDto>
      get copyWith => _$SymptomMemoUpdateRequestDtoCopyWithImpl<
              SymptomMemoUpdateRequestDto>(
          this as SymptomMemoUpdateRequestDto, _$identity);

  /// Serializes this SymptomMemoUpdateRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomMemoUpdateRequestDto &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memo);

  @override
  String toString() {
    return 'SymptomMemoUpdateRequestDto(memo: $memo)';
  }
}

/// @nodoc
abstract mixin class $SymptomMemoUpdateRequestDtoCopyWith<$Res> {
  factory $SymptomMemoUpdateRequestDtoCopyWith(
          SymptomMemoUpdateRequestDto value,
          $Res Function(SymptomMemoUpdateRequestDto) _then) =
      _$SymptomMemoUpdateRequestDtoCopyWithImpl;
  @useResult
  $Res call({String? memo});
}

/// @nodoc
class _$SymptomMemoUpdateRequestDtoCopyWithImpl<$Res>
    implements $SymptomMemoUpdateRequestDtoCopyWith<$Res> {
  _$SymptomMemoUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final SymptomMemoUpdateRequestDto _self;
  final $Res Function(SymptomMemoUpdateRequestDto) _then;

  /// Create a copy of SymptomMemoUpdateRequestDto
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

/// Adds pattern-matching-related methods to [SymptomMemoUpdateRequestDto].
extension SymptomMemoUpdateRequestDtoPatterns on SymptomMemoUpdateRequestDto {
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
    TResult Function(_SymptomMemoUpdateRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomMemoUpdateRequestDto() when $default != null:
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
    TResult Function(_SymptomMemoUpdateRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomMemoUpdateRequestDto():
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
    TResult? Function(_SymptomMemoUpdateRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomMemoUpdateRequestDto() when $default != null:
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
      case _SymptomMemoUpdateRequestDto() when $default != null:
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
      case _SymptomMemoUpdateRequestDto():
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
      case _SymptomMemoUpdateRequestDto() when $default != null:
        return $default(_that.memo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SymptomMemoUpdateRequestDto implements SymptomMemoUpdateRequestDto {
  const _SymptomMemoUpdateRequestDto({this.memo});
  factory _SymptomMemoUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SymptomMemoUpdateRequestDtoFromJson(json);

  @override
  final String? memo;

  /// Create a copy of SymptomMemoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomMemoUpdateRequestDtoCopyWith<_SymptomMemoUpdateRequestDto>
      get copyWith => __$SymptomMemoUpdateRequestDtoCopyWithImpl<
          _SymptomMemoUpdateRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymptomMemoUpdateRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomMemoUpdateRequestDto &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memo);

  @override
  String toString() {
    return 'SymptomMemoUpdateRequestDto(memo: $memo)';
  }
}

/// @nodoc
abstract mixin class _$SymptomMemoUpdateRequestDtoCopyWith<$Res>
    implements $SymptomMemoUpdateRequestDtoCopyWith<$Res> {
  factory _$SymptomMemoUpdateRequestDtoCopyWith(
          _SymptomMemoUpdateRequestDto value,
          $Res Function(_SymptomMemoUpdateRequestDto) _then) =
      __$SymptomMemoUpdateRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String? memo});
}

/// @nodoc
class __$SymptomMemoUpdateRequestDtoCopyWithImpl<$Res>
    implements _$SymptomMemoUpdateRequestDtoCopyWith<$Res> {
  __$SymptomMemoUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final _SymptomMemoUpdateRequestDto _self;
  final $Res Function(_SymptomMemoUpdateRequestDto) _then;

  /// Create a copy of SymptomMemoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memo = freezed,
  }) {
    return _then(_SymptomMemoUpdateRequestDto(
      memo: freezed == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
