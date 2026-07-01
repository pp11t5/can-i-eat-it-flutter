// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dictionary_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SafeFoodItemDto {
  String get foodId;
  String get name;
  String? get code;

  /// Create a copy of SafeFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SafeFoodItemDtoCopyWith<SafeFoodItemDto> get copyWith =>
      _$SafeFoodItemDtoCopyWithImpl<SafeFoodItemDto>(
          this as SafeFoodItemDto, _$identity);

  /// Serializes this SafeFoodItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SafeFoodItemDto &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodId, name, code);

  @override
  String toString() {
    return 'SafeFoodItemDto(foodId: $foodId, name: $name, code: $code)';
  }
}

/// @nodoc
abstract mixin class $SafeFoodItemDtoCopyWith<$Res> {
  factory $SafeFoodItemDtoCopyWith(
          SafeFoodItemDto value, $Res Function(SafeFoodItemDto) _then) =
      _$SafeFoodItemDtoCopyWithImpl;
  @useResult
  $Res call({String foodId, String name, String? code});
}

/// @nodoc
class _$SafeFoodItemDtoCopyWithImpl<$Res>
    implements $SafeFoodItemDtoCopyWith<$Res> {
  _$SafeFoodItemDtoCopyWithImpl(this._self, this._then);

  final SafeFoodItemDto _self;
  final $Res Function(SafeFoodItemDto) _then;

  /// Create a copy of SafeFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? code = freezed,
  }) {
    return _then(_self.copyWith(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SafeFoodItemDto].
extension SafeFoodItemDtoPatterns on SafeFoodItemDto {
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
    TResult Function(_SafeFoodItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SafeFoodItemDto() when $default != null:
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
    TResult Function(_SafeFoodItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeFoodItemDto():
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
    TResult? Function(_SafeFoodItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeFoodItemDto() when $default != null:
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
    TResult Function(String foodId, String name, String? code)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SafeFoodItemDto() when $default != null:
        return $default(_that.foodId, _that.name, _that.code);
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
    TResult Function(String foodId, String name, String? code) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeFoodItemDto():
        return $default(_that.foodId, _that.name, _that.code);
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
    TResult? Function(String foodId, String name, String? code)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeFoodItemDto() when $default != null:
        return $default(_that.foodId, _that.name, _that.code);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SafeFoodItemDto implements SafeFoodItemDto {
  const _SafeFoodItemDto({required this.foodId, required this.name, this.code});
  factory _SafeFoodItemDto.fromJson(Map<String, dynamic> json) =>
      _$SafeFoodItemDtoFromJson(json);

  @override
  final String foodId;
  @override
  final String name;
  @override
  final String? code;

  /// Create a copy of SafeFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SafeFoodItemDtoCopyWith<_SafeFoodItemDto> get copyWith =>
      __$SafeFoodItemDtoCopyWithImpl<_SafeFoodItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SafeFoodItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SafeFoodItemDto &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodId, name, code);

  @override
  String toString() {
    return 'SafeFoodItemDto(foodId: $foodId, name: $name, code: $code)';
  }
}

/// @nodoc
abstract mixin class _$SafeFoodItemDtoCopyWith<$Res>
    implements $SafeFoodItemDtoCopyWith<$Res> {
  factory _$SafeFoodItemDtoCopyWith(
          _SafeFoodItemDto value, $Res Function(_SafeFoodItemDto) _then) =
      __$SafeFoodItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String foodId, String name, String? code});
}

/// @nodoc
class __$SafeFoodItemDtoCopyWithImpl<$Res>
    implements _$SafeFoodItemDtoCopyWith<$Res> {
  __$SafeFoodItemDtoCopyWithImpl(this._self, this._then);

  final _SafeFoodItemDto _self;
  final $Res Function(_SafeFoodItemDto) _then;

  /// Create a copy of SafeFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? code = freezed,
  }) {
    return _then(_SafeFoodItemDto(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CautionRiskFoodItemDto {
  String get foodId;
  String get name;
  String? get code;
  String get type;

  /// Create a copy of CautionRiskFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CautionRiskFoodItemDtoCopyWith<CautionRiskFoodItemDto> get copyWith =>
      _$CautionRiskFoodItemDtoCopyWithImpl<CautionRiskFoodItemDto>(
          this as CautionRiskFoodItemDto, _$identity);

  /// Serializes this CautionRiskFoodItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CautionRiskFoodItemDto &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodId, name, code, type);

  @override
  String toString() {
    return 'CautionRiskFoodItemDto(foodId: $foodId, name: $name, code: $code, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CautionRiskFoodItemDtoCopyWith<$Res> {
  factory $CautionRiskFoodItemDtoCopyWith(CautionRiskFoodItemDto value,
          $Res Function(CautionRiskFoodItemDto) _then) =
      _$CautionRiskFoodItemDtoCopyWithImpl;
  @useResult
  $Res call({String foodId, String name, String? code, String type});
}

/// @nodoc
class _$CautionRiskFoodItemDtoCopyWithImpl<$Res>
    implements $CautionRiskFoodItemDtoCopyWith<$Res> {
  _$CautionRiskFoodItemDtoCopyWithImpl(this._self, this._then);

  final CautionRiskFoodItemDto _self;
  final $Res Function(CautionRiskFoodItemDto) _then;

  /// Create a copy of CautionRiskFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? code = freezed,
    Object? type = null,
  }) {
    return _then(_self.copyWith(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [CautionRiskFoodItemDto].
extension CautionRiskFoodItemDtoPatterns on CautionRiskFoodItemDto {
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
    TResult Function(_CautionRiskFoodItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CautionRiskFoodItemDto() when $default != null:
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
    TResult Function(_CautionRiskFoodItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskFoodItemDto():
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
    TResult? Function(_CautionRiskFoodItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskFoodItemDto() when $default != null:
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
    TResult Function(String foodId, String name, String? code, String type)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CautionRiskFoodItemDto() when $default != null:
        return $default(_that.foodId, _that.name, _that.code, _that.type);
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
    TResult Function(String foodId, String name, String? code, String type)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskFoodItemDto():
        return $default(_that.foodId, _that.name, _that.code, _that.type);
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
    TResult? Function(String foodId, String name, String? code, String type)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskFoodItemDto() when $default != null:
        return $default(_that.foodId, _that.name, _that.code, _that.type);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CautionRiskFoodItemDto implements CautionRiskFoodItemDto {
  const _CautionRiskFoodItemDto(
      {required this.foodId,
      required this.name,
      this.code,
      required this.type});
  factory _CautionRiskFoodItemDto.fromJson(Map<String, dynamic> json) =>
      _$CautionRiskFoodItemDtoFromJson(json);

  @override
  final String foodId;
  @override
  final String name;
  @override
  final String? code;
  @override
  final String type;

  /// Create a copy of CautionRiskFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CautionRiskFoodItemDtoCopyWith<_CautionRiskFoodItemDto> get copyWith =>
      __$CautionRiskFoodItemDtoCopyWithImpl<_CautionRiskFoodItemDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CautionRiskFoodItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CautionRiskFoodItemDto &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodId, name, code, type);

  @override
  String toString() {
    return 'CautionRiskFoodItemDto(foodId: $foodId, name: $name, code: $code, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$CautionRiskFoodItemDtoCopyWith<$Res>
    implements $CautionRiskFoodItemDtoCopyWith<$Res> {
  factory _$CautionRiskFoodItemDtoCopyWith(_CautionRiskFoodItemDto value,
          $Res Function(_CautionRiskFoodItemDto) _then) =
      __$CautionRiskFoodItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String foodId, String name, String? code, String type});
}

/// @nodoc
class __$CautionRiskFoodItemDtoCopyWithImpl<$Res>
    implements _$CautionRiskFoodItemDtoCopyWith<$Res> {
  __$CautionRiskFoodItemDtoCopyWithImpl(this._self, this._then);

  final _CautionRiskFoodItemDto _self;
  final $Res Function(_CautionRiskFoodItemDto) _then;

  /// Create a copy of CautionRiskFoodItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? code = freezed,
    Object? type = null,
  }) {
    return _then(_CautionRiskFoodItemDto(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$SafeDictionaryPageDto {
  List<SafeFoodItemDto> get items;
  int? get nextCursor;
  bool get hasNext;

  /// Create a copy of SafeDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SafeDictionaryPageDtoCopyWith<SafeDictionaryPageDto> get copyWith =>
      _$SafeDictionaryPageDtoCopyWithImpl<SafeDictionaryPageDto>(
          this as SafeDictionaryPageDto, _$identity);

  /// Serializes this SafeDictionaryPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SafeDictionaryPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), nextCursor, hasNext);

  @override
  String toString() {
    return 'SafeDictionaryPageDto(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class $SafeDictionaryPageDtoCopyWith<$Res> {
  factory $SafeDictionaryPageDtoCopyWith(SafeDictionaryPageDto value,
          $Res Function(SafeDictionaryPageDto) _then) =
      _$SafeDictionaryPageDtoCopyWithImpl;
  @useResult
  $Res call({List<SafeFoodItemDto> items, int? nextCursor, bool hasNext});
}

/// @nodoc
class _$SafeDictionaryPageDtoCopyWithImpl<$Res>
    implements $SafeDictionaryPageDtoCopyWith<$Res> {
  _$SafeDictionaryPageDtoCopyWithImpl(this._self, this._then);

  final SafeDictionaryPageDto _self;
  final $Res Function(SafeDictionaryPageDto) _then;

  /// Create a copy of SafeDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SafeFoodItemDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SafeDictionaryPageDto].
extension SafeDictionaryPageDtoPatterns on SafeDictionaryPageDto {
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
    TResult Function(_SafeDictionaryPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SafeDictionaryPageDto() when $default != null:
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
    TResult Function(_SafeDictionaryPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeDictionaryPageDto():
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
    TResult? Function(_SafeDictionaryPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeDictionaryPageDto() when $default != null:
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
            List<SafeFoodItemDto> items, int? nextCursor, bool hasNext)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SafeDictionaryPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
    TResult Function(List<SafeFoodItemDto> items, int? nextCursor, bool hasNext)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeDictionaryPageDto():
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
            List<SafeFoodItemDto> items, int? nextCursor, bool hasNext)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafeDictionaryPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SafeDictionaryPageDto implements SafeDictionaryPageDto {
  const _SafeDictionaryPageDto(
      {final List<SafeFoodItemDto> items = const <SafeFoodItemDto>[],
      this.nextCursor,
      this.hasNext = false})
      : _items = items;
  factory _SafeDictionaryPageDto.fromJson(Map<String, dynamic> json) =>
      _$SafeDictionaryPageDtoFromJson(json);

  final List<SafeFoodItemDto> _items;
  @override
  @JsonKey()
  List<SafeFoodItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int? nextCursor;
  @override
  @JsonKey()
  final bool hasNext;

  /// Create a copy of SafeDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SafeDictionaryPageDtoCopyWith<_SafeDictionaryPageDto> get copyWith =>
      __$SafeDictionaryPageDtoCopyWithImpl<_SafeDictionaryPageDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SafeDictionaryPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SafeDictionaryPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, hasNext);

  @override
  String toString() {
    return 'SafeDictionaryPageDto(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class _$SafeDictionaryPageDtoCopyWith<$Res>
    implements $SafeDictionaryPageDtoCopyWith<$Res> {
  factory _$SafeDictionaryPageDtoCopyWith(_SafeDictionaryPageDto value,
          $Res Function(_SafeDictionaryPageDto) _then) =
      __$SafeDictionaryPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<SafeFoodItemDto> items, int? nextCursor, bool hasNext});
}

/// @nodoc
class __$SafeDictionaryPageDtoCopyWithImpl<$Res>
    implements _$SafeDictionaryPageDtoCopyWith<$Res> {
  __$SafeDictionaryPageDtoCopyWithImpl(this._self, this._then);

  final _SafeDictionaryPageDto _self;
  final $Res Function(_SafeDictionaryPageDto) _then;

  /// Create a copy of SafeDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_SafeDictionaryPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SafeFoodItemDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$CautionRiskDictionaryPageDto {
  List<CautionRiskFoodItemDto> get items;
  int? get nextCursor;
  bool get hasNext;

  /// Create a copy of CautionRiskDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CautionRiskDictionaryPageDtoCopyWith<CautionRiskDictionaryPageDto>
      get copyWith => _$CautionRiskDictionaryPageDtoCopyWithImpl<
              CautionRiskDictionaryPageDto>(
          this as CautionRiskDictionaryPageDto, _$identity);

  /// Serializes this CautionRiskDictionaryPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CautionRiskDictionaryPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), nextCursor, hasNext);

  @override
  String toString() {
    return 'CautionRiskDictionaryPageDto(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class $CautionRiskDictionaryPageDtoCopyWith<$Res> {
  factory $CautionRiskDictionaryPageDtoCopyWith(
          CautionRiskDictionaryPageDto value,
          $Res Function(CautionRiskDictionaryPageDto) _then) =
      _$CautionRiskDictionaryPageDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<CautionRiskFoodItemDto> items, int? nextCursor, bool hasNext});
}

/// @nodoc
class _$CautionRiskDictionaryPageDtoCopyWithImpl<$Res>
    implements $CautionRiskDictionaryPageDtoCopyWith<$Res> {
  _$CautionRiskDictionaryPageDtoCopyWithImpl(this._self, this._then);

  final CautionRiskDictionaryPageDto _self;
  final $Res Function(CautionRiskDictionaryPageDto) _then;

  /// Create a copy of CautionRiskDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CautionRiskFoodItemDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CautionRiskDictionaryPageDto].
extension CautionRiskDictionaryPageDtoPatterns on CautionRiskDictionaryPageDto {
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
    TResult Function(_CautionRiskDictionaryPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CautionRiskDictionaryPageDto() when $default != null:
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
    TResult Function(_CautionRiskDictionaryPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskDictionaryPageDto():
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
    TResult? Function(_CautionRiskDictionaryPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskDictionaryPageDto() when $default != null:
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
            List<CautionRiskFoodItemDto> items, int? nextCursor, bool hasNext)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CautionRiskDictionaryPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
            List<CautionRiskFoodItemDto> items, int? nextCursor, bool hasNext)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskDictionaryPageDto():
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
            List<CautionRiskFoodItemDto> items, int? nextCursor, bool hasNext)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CautionRiskDictionaryPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CautionRiskDictionaryPageDto implements CautionRiskDictionaryPageDto {
  const _CautionRiskDictionaryPageDto(
      {final List<CautionRiskFoodItemDto> items =
          const <CautionRiskFoodItemDto>[],
      this.nextCursor,
      this.hasNext = false})
      : _items = items;
  factory _CautionRiskDictionaryPageDto.fromJson(Map<String, dynamic> json) =>
      _$CautionRiskDictionaryPageDtoFromJson(json);

  final List<CautionRiskFoodItemDto> _items;
  @override
  @JsonKey()
  List<CautionRiskFoodItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int? nextCursor;
  @override
  @JsonKey()
  final bool hasNext;

  /// Create a copy of CautionRiskDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CautionRiskDictionaryPageDtoCopyWith<_CautionRiskDictionaryPageDto>
      get copyWith => __$CautionRiskDictionaryPageDtoCopyWithImpl<
          _CautionRiskDictionaryPageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CautionRiskDictionaryPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CautionRiskDictionaryPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, hasNext);

  @override
  String toString() {
    return 'CautionRiskDictionaryPageDto(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class _$CautionRiskDictionaryPageDtoCopyWith<$Res>
    implements $CautionRiskDictionaryPageDtoCopyWith<$Res> {
  factory _$CautionRiskDictionaryPageDtoCopyWith(
          _CautionRiskDictionaryPageDto value,
          $Res Function(_CautionRiskDictionaryPageDto) _then) =
      __$CautionRiskDictionaryPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<CautionRiskFoodItemDto> items, int? nextCursor, bool hasNext});
}

/// @nodoc
class __$CautionRiskDictionaryPageDtoCopyWithImpl<$Res>
    implements _$CautionRiskDictionaryPageDtoCopyWith<$Res> {
  __$CautionRiskDictionaryPageDtoCopyWithImpl(this._self, this._then);

  final _CautionRiskDictionaryPageDto _self;
  final $Res Function(_CautionRiskDictionaryPageDto) _then;

  /// Create a copy of CautionRiskDictionaryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_CautionRiskDictionaryPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CautionRiskFoodItemDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$DictionaryCountDto {
  int get safeCount;
  int get cautionRiskCount;

  /// Create a copy of DictionaryCountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DictionaryCountDtoCopyWith<DictionaryCountDto> get copyWith =>
      _$DictionaryCountDtoCopyWithImpl<DictionaryCountDto>(
          this as DictionaryCountDto, _$identity);

  /// Serializes this DictionaryCountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DictionaryCountDto &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionRiskCount, cautionRiskCount) ||
                other.cautionRiskCount == cautionRiskCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionRiskCount);

  @override
  String toString() {
    return 'DictionaryCountDto(safeCount: $safeCount, cautionRiskCount: $cautionRiskCount)';
  }
}

/// @nodoc
abstract mixin class $DictionaryCountDtoCopyWith<$Res> {
  factory $DictionaryCountDtoCopyWith(
          DictionaryCountDto value, $Res Function(DictionaryCountDto) _then) =
      _$DictionaryCountDtoCopyWithImpl;
  @useResult
  $Res call({int safeCount, int cautionRiskCount});
}

/// @nodoc
class _$DictionaryCountDtoCopyWithImpl<$Res>
    implements $DictionaryCountDtoCopyWith<$Res> {
  _$DictionaryCountDtoCopyWithImpl(this._self, this._then);

  final DictionaryCountDto _self;
  final $Res Function(DictionaryCountDto) _then;

  /// Create a copy of DictionaryCountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? safeCount = null,
    Object? cautionRiskCount = null,
  }) {
    return _then(_self.copyWith(
      safeCount: null == safeCount
          ? _self.safeCount
          : safeCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionRiskCount: null == cautionRiskCount
          ? _self.cautionRiskCount
          : cautionRiskCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [DictionaryCountDto].
extension DictionaryCountDtoPatterns on DictionaryCountDto {
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
    TResult Function(_DictionaryCountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryCountDto() when $default != null:
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
    TResult Function(_DictionaryCountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCountDto():
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
    TResult? Function(_DictionaryCountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCountDto() when $default != null:
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
    TResult Function(int safeCount, int cautionRiskCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryCountDto() when $default != null:
        return $default(_that.safeCount, _that.cautionRiskCount);
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
    TResult Function(int safeCount, int cautionRiskCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCountDto():
        return $default(_that.safeCount, _that.cautionRiskCount);
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
    TResult? Function(int safeCount, int cautionRiskCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCountDto() when $default != null:
        return $default(_that.safeCount, _that.cautionRiskCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DictionaryCountDto implements DictionaryCountDto {
  const _DictionaryCountDto({this.safeCount = 0, this.cautionRiskCount = 0});
  factory _DictionaryCountDto.fromJson(Map<String, dynamic> json) =>
      _$DictionaryCountDtoFromJson(json);

  @override
  @JsonKey()
  final int safeCount;
  @override
  @JsonKey()
  final int cautionRiskCount;

  /// Create a copy of DictionaryCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DictionaryCountDtoCopyWith<_DictionaryCountDto> get copyWith =>
      __$DictionaryCountDtoCopyWithImpl<_DictionaryCountDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DictionaryCountDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DictionaryCountDto &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionRiskCount, cautionRiskCount) ||
                other.cautionRiskCount == cautionRiskCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionRiskCount);

  @override
  String toString() {
    return 'DictionaryCountDto(safeCount: $safeCount, cautionRiskCount: $cautionRiskCount)';
  }
}

/// @nodoc
abstract mixin class _$DictionaryCountDtoCopyWith<$Res>
    implements $DictionaryCountDtoCopyWith<$Res> {
  factory _$DictionaryCountDtoCopyWith(
          _DictionaryCountDto value, $Res Function(_DictionaryCountDto) _then) =
      __$DictionaryCountDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int safeCount, int cautionRiskCount});
}

/// @nodoc
class __$DictionaryCountDtoCopyWithImpl<$Res>
    implements _$DictionaryCountDtoCopyWith<$Res> {
  __$DictionaryCountDtoCopyWithImpl(this._self, this._then);

  final _DictionaryCountDto _self;
  final $Res Function(_DictionaryCountDto) _then;

  /// Create a copy of DictionaryCountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? safeCount = null,
    Object? cautionRiskCount = null,
  }) {
    return _then(_DictionaryCountDto(
      safeCount: null == safeCount
          ? _self.safeCount
          : safeCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionRiskCount: null == cautionRiskCount
          ? _self.cautionRiskCount
          : cautionRiskCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
