// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_login_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthLoginResponseDto {
  String get accessToken;
  String get refreshToken;
  String get userId;
  String? get email;
  String get role;

  /// Create a copy of AuthLoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthLoginResponseDtoCopyWith<AuthLoginResponseDto> get copyWith =>
      _$AuthLoginResponseDtoCopyWithImpl<AuthLoginResponseDto>(
          this as AuthLoginResponseDto, _$identity);

  /// Serializes this AuthLoginResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthLoginResponseDto &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, userId, email, role);

  @override
  String toString() {
    return 'AuthLoginResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, userId: $userId, email: $email, role: $role)';
  }
}

/// @nodoc
abstract mixin class $AuthLoginResponseDtoCopyWith<$Res> {
  factory $AuthLoginResponseDtoCopyWith(AuthLoginResponseDto value,
          $Res Function(AuthLoginResponseDto) _then) =
      _$AuthLoginResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String userId,
      String? email,
      String role});
}

/// @nodoc
class _$AuthLoginResponseDtoCopyWithImpl<$Res>
    implements $AuthLoginResponseDtoCopyWith<$Res> {
  _$AuthLoginResponseDtoCopyWithImpl(this._self, this._then);

  final AuthLoginResponseDto _self;
  final $Res Function(AuthLoginResponseDto) _then;

  /// Create a copy of AuthLoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? userId = null,
    Object? email = freezed,
    Object? role = null,
  }) {
    return _then(_self.copyWith(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthLoginResponseDto].
extension AuthLoginResponseDtoPatterns on AuthLoginResponseDto {
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
    TResult Function(_AuthLoginResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthLoginResponseDto() when $default != null:
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
    TResult Function(_AuthLoginResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthLoginResponseDto():
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
    TResult? Function(_AuthLoginResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthLoginResponseDto() when $default != null:
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
    TResult Function(String accessToken, String refreshToken, String userId,
            String? email, String role)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthLoginResponseDto() when $default != null:
        return $default(_that.accessToken, _that.refreshToken, _that.userId,
            _that.email, _that.role);
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
    TResult Function(String accessToken, String refreshToken, String userId,
            String? email, String role)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthLoginResponseDto():
        return $default(_that.accessToken, _that.refreshToken, _that.userId,
            _that.email, _that.role);
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
    TResult? Function(String accessToken, String refreshToken, String userId,
            String? email, String role)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthLoginResponseDto() when $default != null:
        return $default(_that.accessToken, _that.refreshToken, _that.userId,
            _that.email, _that.role);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthLoginResponseDto implements AuthLoginResponseDto {
  const _AuthLoginResponseDto(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      this.email,
      required this.role});
  factory _AuthLoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginResponseDtoFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final String userId;
  @override
  final String? email;
  @override
  final String role;

  /// Create a copy of AuthLoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthLoginResponseDtoCopyWith<_AuthLoginResponseDto> get copyWith =>
      __$AuthLoginResponseDtoCopyWithImpl<_AuthLoginResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthLoginResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthLoginResponseDto &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, userId, email, role);

  @override
  String toString() {
    return 'AuthLoginResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, userId: $userId, email: $email, role: $role)';
  }
}

/// @nodoc
abstract mixin class _$AuthLoginResponseDtoCopyWith<$Res>
    implements $AuthLoginResponseDtoCopyWith<$Res> {
  factory _$AuthLoginResponseDtoCopyWith(_AuthLoginResponseDto value,
          $Res Function(_AuthLoginResponseDto) _then) =
      __$AuthLoginResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      String userId,
      String? email,
      String role});
}

/// @nodoc
class __$AuthLoginResponseDtoCopyWithImpl<$Res>
    implements _$AuthLoginResponseDtoCopyWith<$Res> {
  __$AuthLoginResponseDtoCopyWithImpl(this._self, this._then);

  final _AuthLoginResponseDto _self;
  final $Res Function(_AuthLoginResponseDto) _then;

  /// Create a copy of AuthLoginResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? userId = null,
    Object? email = freezed,
    Object? role = null,
  }) {
    return _then(_AuthLoginResponseDto(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
