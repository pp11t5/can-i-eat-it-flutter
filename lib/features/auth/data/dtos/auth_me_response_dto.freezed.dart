// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_me_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthMeResponseDto {
  String get userId;
  String? get nickname;
  String? get email;
  String? get profileImage;

  /// Create a copy of AuthMeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthMeResponseDtoCopyWith<AuthMeResponseDto> get copyWith =>
      _$AuthMeResponseDtoCopyWithImpl<AuthMeResponseDto>(
          this as AuthMeResponseDto, _$identity);

  /// Serializes this AuthMeResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthMeResponseDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, email, profileImage);

  @override
  String toString() {
    return 'AuthMeResponseDto(userId: $userId, nickname: $nickname, email: $email, profileImage: $profileImage)';
  }
}

/// @nodoc
abstract mixin class $AuthMeResponseDtoCopyWith<$Res> {
  factory $AuthMeResponseDtoCopyWith(
          AuthMeResponseDto value, $Res Function(AuthMeResponseDto) _then) =
      _$AuthMeResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {String userId, String? nickname, String? email, String? profileImage});
}

/// @nodoc
class _$AuthMeResponseDtoCopyWithImpl<$Res>
    implements $AuthMeResponseDtoCopyWith<$Res> {
  _$AuthMeResponseDtoCopyWithImpl(this._self, this._then);

  final AuthMeResponseDto _self;
  final $Res Function(AuthMeResponseDto) _then;

  /// Create a copy of AuthMeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = freezed,
    Object? email = freezed,
    Object? profileImage = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthMeResponseDto].
extension AuthMeResponseDtoPatterns on AuthMeResponseDto {
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
    TResult Function(_AuthMeResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthMeResponseDto() when $default != null:
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
    TResult Function(_AuthMeResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMeResponseDto():
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
    TResult? Function(_AuthMeResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMeResponseDto() when $default != null:
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
    TResult Function(String userId, String? nickname, String? email,
            String? profileImage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthMeResponseDto() when $default != null:
        return $default(
            _that.userId, _that.nickname, _that.email, _that.profileImage);
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
    TResult Function(String userId, String? nickname, String? email,
            String? profileImage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMeResponseDto():
        return $default(
            _that.userId, _that.nickname, _that.email, _that.profileImage);
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
    TResult? Function(String userId, String? nickname, String? email,
            String? profileImage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMeResponseDto() when $default != null:
        return $default(
            _that.userId, _that.nickname, _that.email, _that.profileImage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthMeResponseDto implements AuthMeResponseDto {
  const _AuthMeResponseDto(
      {required this.userId, this.nickname, this.email, this.profileImage});
  factory _AuthMeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseDtoFromJson(json);

  @override
  final String userId;
  @override
  final String? nickname;
  @override
  final String? email;
  @override
  final String? profileImage;

  /// Create a copy of AuthMeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthMeResponseDtoCopyWith<_AuthMeResponseDto> get copyWith =>
      __$AuthMeResponseDtoCopyWithImpl<_AuthMeResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthMeResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthMeResponseDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, email, profileImage);

  @override
  String toString() {
    return 'AuthMeResponseDto(userId: $userId, nickname: $nickname, email: $email, profileImage: $profileImage)';
  }
}

/// @nodoc
abstract mixin class _$AuthMeResponseDtoCopyWith<$Res>
    implements $AuthMeResponseDtoCopyWith<$Res> {
  factory _$AuthMeResponseDtoCopyWith(
          _AuthMeResponseDto value, $Res Function(_AuthMeResponseDto) _then) =
      __$AuthMeResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId, String? nickname, String? email, String? profileImage});
}

/// @nodoc
class __$AuthMeResponseDtoCopyWithImpl<$Res>
    implements _$AuthMeResponseDtoCopyWith<$Res> {
  __$AuthMeResponseDtoCopyWithImpl(this._self, this._then);

  final _AuthMeResponseDto _self;
  final $Res Function(_AuthMeResponseDto) _then;

  /// Create a copy of AuthMeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? nickname = freezed,
    Object? email = freezed,
    Object? profileImage = freezed,
  }) {
    return _then(_AuthMeResponseDto(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
