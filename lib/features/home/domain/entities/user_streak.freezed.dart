// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStreak {
  int get streak;
  CharacterStatus get characterStatus;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserStreakCopyWith<UserStreak> get copyWith =>
      _$UserStreakCopyWithImpl<UserStreak>(this as UserStreak, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserStreak &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.characterStatus, characterStatus) ||
                other.characterStatus == characterStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, streak, characterStatus);

  @override
  String toString() {
    return 'UserStreak(streak: $streak, characterStatus: $characterStatus)';
  }
}

/// @nodoc
abstract mixin class $UserStreakCopyWith<$Res> {
  factory $UserStreakCopyWith(
          UserStreak value, $Res Function(UserStreak) _then) =
      _$UserStreakCopyWithImpl;
  @useResult
  $Res call({int streak, CharacterStatus characterStatus});
}

/// @nodoc
class _$UserStreakCopyWithImpl<$Res> implements $UserStreakCopyWith<$Res> {
  _$UserStreakCopyWithImpl(this._self, this._then);

  final UserStreak _self;
  final $Res Function(UserStreak) _then;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streak = null,
    Object? characterStatus = null,
  }) {
    return _then(_self.copyWith(
      streak: null == streak
          ? _self.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      characterStatus: null == characterStatus
          ? _self.characterStatus
          : characterStatus // ignore: cast_nullable_to_non_nullable
              as CharacterStatus,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserStreak].
extension UserStreakPatterns on UserStreak {
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
    TResult Function(_UserStreak value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserStreak() when $default != null:
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
    TResult Function(_UserStreak value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreak():
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
    TResult? Function(_UserStreak value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreak() when $default != null:
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
    TResult Function(int streak, CharacterStatus characterStatus)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserStreak() when $default != null:
        return $default(_that.streak, _that.characterStatus);
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
    TResult Function(int streak, CharacterStatus characterStatus) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreak():
        return $default(_that.streak, _that.characterStatus);
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
    TResult? Function(int streak, CharacterStatus characterStatus)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreak() when $default != null:
        return $default(_that.streak, _that.characterStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UserStreak implements UserStreak {
  const _UserStreak(
      {this.streak = 0, this.characterStatus = CharacterStatus.statisfied});

  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey()
  final CharacterStatus characterStatus;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserStreakCopyWith<_UserStreak> get copyWith =>
      __$UserStreakCopyWithImpl<_UserStreak>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserStreak &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.characterStatus, characterStatus) ||
                other.characterStatus == characterStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, streak, characterStatus);

  @override
  String toString() {
    return 'UserStreak(streak: $streak, characterStatus: $characterStatus)';
  }
}

/// @nodoc
abstract mixin class _$UserStreakCopyWith<$Res>
    implements $UserStreakCopyWith<$Res> {
  factory _$UserStreakCopyWith(
          _UserStreak value, $Res Function(_UserStreak) _then) =
      __$UserStreakCopyWithImpl;
  @override
  @useResult
  $Res call({int streak, CharacterStatus characterStatus});
}

/// @nodoc
class __$UserStreakCopyWithImpl<$Res> implements _$UserStreakCopyWith<$Res> {
  __$UserStreakCopyWithImpl(this._self, this._then);

  final _UserStreak _self;
  final $Res Function(_UserStreak) _then;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? streak = null,
    Object? characterStatus = null,
  }) {
    return _then(_UserStreak(
      streak: null == streak
          ? _self.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      characterStatus: null == characterStatus
          ? _self.characterStatus
          : characterStatus // ignore: cast_nullable_to_non_nullable
              as CharacterStatus,
    ));
  }
}

// dart format on
