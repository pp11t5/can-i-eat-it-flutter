// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthSession {
  String get userId;
  AuthProvider get provider;
  bool get hasAgreedTerms;
  bool get hasCompletedOnboarding;
  AccountStatus get accountStatus;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthSessionCopyWith<AuthSession> get copyWith =>
      _$AuthSessionCopyWithImpl<AuthSession>(this as AuthSession, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthSession &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.hasAgreedTerms, hasAgreedTerms) ||
                other.hasAgreedTerms == hasAgreedTerms) &&
            (identical(other.hasCompletedOnboarding, hasCompletedOnboarding) ||
                other.hasCompletedOnboarding == hasCompletedOnboarding) &&
            (identical(other.accountStatus, accountStatus) ||
                other.accountStatus == accountStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, provider, hasAgreedTerms,
      hasCompletedOnboarding, accountStatus);

  @override
  String toString() {
    return 'AuthSession(userId: $userId, provider: $provider, hasAgreedTerms: $hasAgreedTerms, hasCompletedOnboarding: $hasCompletedOnboarding, accountStatus: $accountStatus)';
  }
}

/// @nodoc
abstract mixin class $AuthSessionCopyWith<$Res> {
  factory $AuthSessionCopyWith(
          AuthSession value, $Res Function(AuthSession) _then) =
      _$AuthSessionCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      AuthProvider provider,
      bool hasAgreedTerms,
      bool hasCompletedOnboarding,
      AccountStatus accountStatus});
}

/// @nodoc
class _$AuthSessionCopyWithImpl<$Res> implements $AuthSessionCopyWith<$Res> {
  _$AuthSessionCopyWithImpl(this._self, this._then);

  final AuthSession _self;
  final $Res Function(AuthSession) _then;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? provider = null,
    Object? hasAgreedTerms = null,
    Object? hasCompletedOnboarding = null,
    Object? accountStatus = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
      hasAgreedTerms: null == hasAgreedTerms
          ? _self.hasAgreedTerms
          : hasAgreedTerms // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCompletedOnboarding: null == hasCompletedOnboarding
          ? _self.hasCompletedOnboarding
          : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
      accountStatus: null == accountStatus
          ? _self.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as AccountStatus,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthSession].
extension AuthSessionPatterns on AuthSession {
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
    TResult Function(_AuthSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthSession() when $default != null:
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
    TResult Function(_AuthSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthSession():
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
    TResult? Function(_AuthSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthSession() when $default != null:
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
    TResult Function(String userId, AuthProvider provider, bool hasAgreedTerms,
            bool hasCompletedOnboarding, AccountStatus accountStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthSession() when $default != null:
        return $default(_that.userId, _that.provider, _that.hasAgreedTerms,
            _that.hasCompletedOnboarding, _that.accountStatus);
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
    TResult Function(String userId, AuthProvider provider, bool hasAgreedTerms,
            bool hasCompletedOnboarding, AccountStatus accountStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthSession():
        return $default(_that.userId, _that.provider, _that.hasAgreedTerms,
            _that.hasCompletedOnboarding, _that.accountStatus);
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
    TResult? Function(String userId, AuthProvider provider, bool hasAgreedTerms,
            bool hasCompletedOnboarding, AccountStatus accountStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthSession() when $default != null:
        return $default(_that.userId, _that.provider, _that.hasAgreedTerms,
            _that.hasCompletedOnboarding, _that.accountStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AuthSession implements AuthSession {
  const _AuthSession(
      {required this.userId,
      required this.provider,
      this.hasAgreedTerms = false,
      this.hasCompletedOnboarding = false,
      this.accountStatus = AccountStatus.active});

  @override
  final String userId;
  @override
  final AuthProvider provider;
  @override
  @JsonKey()
  final bool hasAgreedTerms;
  @override
  @JsonKey()
  final bool hasCompletedOnboarding;
  @override
  @JsonKey()
  final AccountStatus accountStatus;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthSessionCopyWith<_AuthSession> get copyWith =>
      __$AuthSessionCopyWithImpl<_AuthSession>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthSession &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.hasAgreedTerms, hasAgreedTerms) ||
                other.hasAgreedTerms == hasAgreedTerms) &&
            (identical(other.hasCompletedOnboarding, hasCompletedOnboarding) ||
                other.hasCompletedOnboarding == hasCompletedOnboarding) &&
            (identical(other.accountStatus, accountStatus) ||
                other.accountStatus == accountStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, provider, hasAgreedTerms,
      hasCompletedOnboarding, accountStatus);

  @override
  String toString() {
    return 'AuthSession(userId: $userId, provider: $provider, hasAgreedTerms: $hasAgreedTerms, hasCompletedOnboarding: $hasCompletedOnboarding, accountStatus: $accountStatus)';
  }
}

/// @nodoc
abstract mixin class _$AuthSessionCopyWith<$Res>
    implements $AuthSessionCopyWith<$Res> {
  factory _$AuthSessionCopyWith(
          _AuthSession value, $Res Function(_AuthSession) _then) =
      __$AuthSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      AuthProvider provider,
      bool hasAgreedTerms,
      bool hasCompletedOnboarding,
      AccountStatus accountStatus});
}

/// @nodoc
class __$AuthSessionCopyWithImpl<$Res> implements _$AuthSessionCopyWith<$Res> {
  __$AuthSessionCopyWithImpl(this._self, this._then);

  final _AuthSession _self;
  final $Res Function(_AuthSession) _then;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? provider = null,
    Object? hasAgreedTerms = null,
    Object? hasCompletedOnboarding = null,
    Object? accountStatus = null,
  }) {
    return _then(_AuthSession(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
      hasAgreedTerms: null == hasAgreedTerms
          ? _self.hasAgreedTerms
          : hasAgreedTerms // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCompletedOnboarding: null == hasCompletedOnboarding
          ? _self.hasCompletedOnboarding
          : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
      accountStatus: null == accountStatus
          ? _self.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as AccountStatus,
    ));
  }
}

// dart format on
