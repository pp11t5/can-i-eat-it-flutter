// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consent_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsentRequestDto {
  bool get tos;
  bool get privacy;
  bool get healthSensitive;
  bool get marketing;

  /// Create a copy of ConsentRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConsentRequestDtoCopyWith<ConsentRequestDto> get copyWith =>
      _$ConsentRequestDtoCopyWithImpl<ConsentRequestDto>(
          this as ConsentRequestDto, _$identity);

  /// Serializes this ConsentRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConsentRequestDto &&
            (identical(other.tos, tos) || other.tos == tos) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.healthSensitive, healthSensitive) ||
                other.healthSensitive == healthSensitive) &&
            (identical(other.marketing, marketing) ||
                other.marketing == marketing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tos, privacy, healthSensitive, marketing);

  @override
  String toString() {
    return 'ConsentRequestDto(tos: $tos, privacy: $privacy, healthSensitive: $healthSensitive, marketing: $marketing)';
  }
}

/// @nodoc
abstract mixin class $ConsentRequestDtoCopyWith<$Res> {
  factory $ConsentRequestDtoCopyWith(
          ConsentRequestDto value, $Res Function(ConsentRequestDto) _then) =
      _$ConsentRequestDtoCopyWithImpl;
  @useResult
  $Res call({bool tos, bool privacy, bool healthSensitive, bool marketing});
}

/// @nodoc
class _$ConsentRequestDtoCopyWithImpl<$Res>
    implements $ConsentRequestDtoCopyWith<$Res> {
  _$ConsentRequestDtoCopyWithImpl(this._self, this._then);

  final ConsentRequestDto _self;
  final $Res Function(ConsentRequestDto) _then;

  /// Create a copy of ConsentRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tos = null,
    Object? privacy = null,
    Object? healthSensitive = null,
    Object? marketing = null,
  }) {
    return _then(_self.copyWith(
      tos: null == tos
          ? _self.tos
          : tos // ignore: cast_nullable_to_non_nullable
              as bool,
      privacy: null == privacy
          ? _self.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as bool,
      healthSensitive: null == healthSensitive
          ? _self.healthSensitive
          : healthSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      marketing: null == marketing
          ? _self.marketing
          : marketing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConsentRequestDto].
extension ConsentRequestDtoPatterns on ConsentRequestDto {
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
    TResult Function(_ConsentRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto() when $default != null:
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
    TResult Function(_ConsentRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto():
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
    TResult? Function(_ConsentRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto() when $default != null:
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
            bool tos, bool privacy, bool healthSensitive, bool marketing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto() when $default != null:
        return $default(
            _that.tos, _that.privacy, _that.healthSensitive, _that.marketing);
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
            bool tos, bool privacy, bool healthSensitive, bool marketing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto():
        return $default(
            _that.tos, _that.privacy, _that.healthSensitive, _that.marketing);
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
            bool tos, bool privacy, bool healthSensitive, bool marketing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto() when $default != null:
        return $default(
            _that.tos, _that.privacy, _that.healthSensitive, _that.marketing);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConsentRequestDto extends ConsentRequestDto {
  const _ConsentRequestDto(
      {required this.tos,
      required this.privacy,
      required this.healthSensitive,
      required this.marketing})
      : super._();
  factory _ConsentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentRequestDtoFromJson(json);

  @override
  final bool tos;
  @override
  final bool privacy;
  @override
  final bool healthSensitive;
  @override
  final bool marketing;

  /// Create a copy of ConsentRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConsentRequestDtoCopyWith<_ConsentRequestDto> get copyWith =>
      __$ConsentRequestDtoCopyWithImpl<_ConsentRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConsentRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConsentRequestDto &&
            (identical(other.tos, tos) || other.tos == tos) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.healthSensitive, healthSensitive) ||
                other.healthSensitive == healthSensitive) &&
            (identical(other.marketing, marketing) ||
                other.marketing == marketing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tos, privacy, healthSensitive, marketing);

  @override
  String toString() {
    return 'ConsentRequestDto(tos: $tos, privacy: $privacy, healthSensitive: $healthSensitive, marketing: $marketing)';
  }
}

/// @nodoc
abstract mixin class _$ConsentRequestDtoCopyWith<$Res>
    implements $ConsentRequestDtoCopyWith<$Res> {
  factory _$ConsentRequestDtoCopyWith(
          _ConsentRequestDto value, $Res Function(_ConsentRequestDto) _then) =
      __$ConsentRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({bool tos, bool privacy, bool healthSensitive, bool marketing});
}

/// @nodoc
class __$ConsentRequestDtoCopyWithImpl<$Res>
    implements _$ConsentRequestDtoCopyWith<$Res> {
  __$ConsentRequestDtoCopyWithImpl(this._self, this._then);

  final _ConsentRequestDto _self;
  final $Res Function(_ConsentRequestDto) _then;

  /// Create a copy of ConsentRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tos = null,
    Object? privacy = null,
    Object? healthSensitive = null,
    Object? marketing = null,
  }) {
    return _then(_ConsentRequestDto(
      tos: null == tos
          ? _self.tos
          : tos // ignore: cast_nullable_to_non_nullable
              as bool,
      privacy: null == privacy
          ? _self.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as bool,
      healthSensitive: null == healthSensitive
          ? _self.healthSensitive
          : healthSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      marketing: null == marketing
          ? _self.marketing
          : marketing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
