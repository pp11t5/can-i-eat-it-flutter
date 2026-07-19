// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nickname_update_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NicknameUpdateRequestDto {
  String get nickname;

  /// Create a copy of NicknameUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NicknameUpdateRequestDtoCopyWith<NicknameUpdateRequestDto> get copyWith =>
      _$NicknameUpdateRequestDtoCopyWithImpl<NicknameUpdateRequestDto>(
          this as NicknameUpdateRequestDto, _$identity);

  /// Serializes this NicknameUpdateRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NicknameUpdateRequestDto &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickname);

  @override
  String toString() {
    return 'NicknameUpdateRequestDto(nickname: $nickname)';
  }
}

/// @nodoc
abstract mixin class $NicknameUpdateRequestDtoCopyWith<$Res> {
  factory $NicknameUpdateRequestDtoCopyWith(NicknameUpdateRequestDto value,
          $Res Function(NicknameUpdateRequestDto) _then) =
      _$NicknameUpdateRequestDtoCopyWithImpl;
  @useResult
  $Res call({String nickname});
}

/// @nodoc
class _$NicknameUpdateRequestDtoCopyWithImpl<$Res>
    implements $NicknameUpdateRequestDtoCopyWith<$Res> {
  _$NicknameUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final NicknameUpdateRequestDto _self;
  final $Res Function(NicknameUpdateRequestDto) _then;

  /// Create a copy of NicknameUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickname = null,
  }) {
    return _then(_self.copyWith(
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [NicknameUpdateRequestDto].
extension NicknameUpdateRequestDtoPatterns on NicknameUpdateRequestDto {
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
    TResult Function(_NicknameUpdateRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NicknameUpdateRequestDto() when $default != null:
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
    TResult Function(_NicknameUpdateRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NicknameUpdateRequestDto():
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
    TResult? Function(_NicknameUpdateRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NicknameUpdateRequestDto() when $default != null:
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
    TResult Function(String nickname)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NicknameUpdateRequestDto() when $default != null:
        return $default(_that.nickname);
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
    TResult Function(String nickname) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NicknameUpdateRequestDto():
        return $default(_that.nickname);
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
    TResult? Function(String nickname)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NicknameUpdateRequestDto() when $default != null:
        return $default(_that.nickname);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NicknameUpdateRequestDto implements NicknameUpdateRequestDto {
  const _NicknameUpdateRequestDto({required this.nickname});
  factory _NicknameUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$NicknameUpdateRequestDtoFromJson(json);

  @override
  final String nickname;

  /// Create a copy of NicknameUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NicknameUpdateRequestDtoCopyWith<_NicknameUpdateRequestDto> get copyWith =>
      __$NicknameUpdateRequestDtoCopyWithImpl<_NicknameUpdateRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NicknameUpdateRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NicknameUpdateRequestDto &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickname);

  @override
  String toString() {
    return 'NicknameUpdateRequestDto(nickname: $nickname)';
  }
}

/// @nodoc
abstract mixin class _$NicknameUpdateRequestDtoCopyWith<$Res>
    implements $NicknameUpdateRequestDtoCopyWith<$Res> {
  factory _$NicknameUpdateRequestDtoCopyWith(_NicknameUpdateRequestDto value,
          $Res Function(_NicknameUpdateRequestDto) _then) =
      __$NicknameUpdateRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String nickname});
}

/// @nodoc
class __$NicknameUpdateRequestDtoCopyWithImpl<$Res>
    implements _$NicknameUpdateRequestDtoCopyWith<$Res> {
  __$NicknameUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final _NicknameUpdateRequestDto _self;
  final $Res Function(_NicknameUpdateRequestDto) _then;

  /// Create a copy of NicknameUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nickname = null,
  }) {
    return _then(_NicknameUpdateRequestDto(
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
