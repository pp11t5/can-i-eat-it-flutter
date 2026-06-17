// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSummaryDto {
  String get externalId;
  String get name;
  String? get category;

  /// Create a copy of FoodSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodSummaryDtoCopyWith<FoodSummaryDto> get copyWith =>
      _$FoodSummaryDtoCopyWithImpl<FoodSummaryDto>(
          this as FoodSummaryDto, _$identity);

  /// Serializes this FoodSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodSummaryDto &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, externalId, name, category);

  @override
  String toString() {
    return 'FoodSummaryDto(externalId: $externalId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class $FoodSummaryDtoCopyWith<$Res> {
  factory $FoodSummaryDtoCopyWith(
          FoodSummaryDto value, $Res Function(FoodSummaryDto) _then) =
      _$FoodSummaryDtoCopyWithImpl;
  @useResult
  $Res call({String externalId, String name, String? category});
}

/// @nodoc
class _$FoodSummaryDtoCopyWithImpl<$Res>
    implements $FoodSummaryDtoCopyWith<$Res> {
  _$FoodSummaryDtoCopyWithImpl(this._self, this._then);

  final FoodSummaryDto _self;
  final $Res Function(FoodSummaryDto) _then;

  /// Create a copy of FoodSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodSummaryDto].
extension FoodSummaryDtoPatterns on FoodSummaryDto {
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
    TResult Function(_FoodSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSummaryDto() when $default != null:
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
    TResult Function(_FoodSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummaryDto():
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
    TResult? Function(_FoodSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummaryDto() when $default != null:
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
    TResult Function(String externalId, String name, String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodSummaryDto() when $default != null:
        return $default(_that.externalId, _that.name, _that.category);
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
    TResult Function(String externalId, String name, String? category) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummaryDto():
        return $default(_that.externalId, _that.name, _that.category);
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
    TResult? Function(String externalId, String name, String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodSummaryDto() when $default != null:
        return $default(_that.externalId, _that.name, _that.category);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FoodSummaryDto implements FoodSummaryDto {
  const _FoodSummaryDto(
      {required this.externalId, required this.name, this.category});
  factory _FoodSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodSummaryDtoFromJson(json);

  @override
  final String externalId;
  @override
  final String name;
  @override
  final String? category;

  /// Create a copy of FoodSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodSummaryDtoCopyWith<_FoodSummaryDto> get copyWith =>
      __$FoodSummaryDtoCopyWithImpl<_FoodSummaryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FoodSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodSummaryDto &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, externalId, name, category);

  @override
  String toString() {
    return 'FoodSummaryDto(externalId: $externalId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$FoodSummaryDtoCopyWith<$Res>
    implements $FoodSummaryDtoCopyWith<$Res> {
  factory _$FoodSummaryDtoCopyWith(
          _FoodSummaryDto value, $Res Function(_FoodSummaryDto) _then) =
      __$FoodSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String externalId, String name, String? category});
}

/// @nodoc
class __$FoodSummaryDtoCopyWithImpl<$Res>
    implements _$FoodSummaryDtoCopyWith<$Res> {
  __$FoodSummaryDtoCopyWithImpl(this._self, this._then);

  final _FoodSummaryDto _self;
  final $Res Function(_FoodSummaryDto) _then;

  /// Create a copy of FoodSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? externalId = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_FoodSummaryDto(
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
    ));
  }
}

// dart format on
