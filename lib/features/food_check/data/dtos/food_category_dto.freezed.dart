// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodCategoryDto {
  String get code;
  String get displayName;

  /// Create a copy of FoodCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodCategoryDtoCopyWith<FoodCategoryDto> get copyWith =>
      _$FoodCategoryDtoCopyWithImpl<FoodCategoryDto>(
          this as FoodCategoryDto, _$identity);

  /// Serializes this FoodCategoryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodCategoryDto &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, displayName);

  @override
  String toString() {
    return 'FoodCategoryDto(code: $code, displayName: $displayName)';
  }
}

/// @nodoc
abstract mixin class $FoodCategoryDtoCopyWith<$Res> {
  factory $FoodCategoryDtoCopyWith(
          FoodCategoryDto value, $Res Function(FoodCategoryDto) _then) =
      _$FoodCategoryDtoCopyWithImpl;
  @useResult
  $Res call({String code, String displayName});
}

/// @nodoc
class _$FoodCategoryDtoCopyWithImpl<$Res>
    implements $FoodCategoryDtoCopyWith<$Res> {
  _$FoodCategoryDtoCopyWithImpl(this._self, this._then);

  final FoodCategoryDto _self;
  final $Res Function(FoodCategoryDto) _then;

  /// Create a copy of FoodCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? displayName = null,
  }) {
    return _then(_self.copyWith(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodCategoryDto].
extension FoodCategoryDtoPatterns on FoodCategoryDto {
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
    TResult Function(_FoodCategoryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodCategoryDto() when $default != null:
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
    TResult Function(_FoodCategoryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategoryDto():
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
    TResult? Function(_FoodCategoryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategoryDto() when $default != null:
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
    TResult Function(String code, String displayName)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodCategoryDto() when $default != null:
        return $default(_that.code, _that.displayName);
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
    TResult Function(String code, String displayName) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategoryDto():
        return $default(_that.code, _that.displayName);
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
    TResult? Function(String code, String displayName)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategoryDto() when $default != null:
        return $default(_that.code, _that.displayName);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FoodCategoryDto implements FoodCategoryDto {
  const _FoodCategoryDto({required this.code, required this.displayName});
  factory _FoodCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodCategoryDtoFromJson(json);

  @override
  final String code;
  @override
  final String displayName;

  /// Create a copy of FoodCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodCategoryDtoCopyWith<_FoodCategoryDto> get copyWith =>
      __$FoodCategoryDtoCopyWithImpl<_FoodCategoryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FoodCategoryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodCategoryDto &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, displayName);

  @override
  String toString() {
    return 'FoodCategoryDto(code: $code, displayName: $displayName)';
  }
}

/// @nodoc
abstract mixin class _$FoodCategoryDtoCopyWith<$Res>
    implements $FoodCategoryDtoCopyWith<$Res> {
  factory _$FoodCategoryDtoCopyWith(
          _FoodCategoryDto value, $Res Function(_FoodCategoryDto) _then) =
      __$FoodCategoryDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String code, String displayName});
}

/// @nodoc
class __$FoodCategoryDtoCopyWithImpl<$Res>
    implements _$FoodCategoryDtoCopyWith<$Res> {
  __$FoodCategoryDtoCopyWithImpl(this._self, this._then);

  final _FoodCategoryDto _self;
  final $Res Function(_FoodCategoryDto) _then;

  /// Create a copy of FoodCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? displayName = null,
  }) {
    return _then(_FoodCategoryDto(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
