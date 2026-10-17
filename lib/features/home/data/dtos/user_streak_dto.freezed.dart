// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_streak_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStreakDto {
  int get streak;
  @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
  CharacterStatus get characterStatus;

  /// Create a copy of UserStreakDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserStreakDtoCopyWith<UserStreakDto> get copyWith =>
      _$UserStreakDtoCopyWithImpl<UserStreakDto>(
          this as UserStreakDto, _$identity);

  /// Serializes this UserStreakDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserStreakDto &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.characterStatus, characterStatus) ||
                other.characterStatus == characterStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, streak, characterStatus);

  @override
  String toString() {
    return 'UserStreakDto(streak: $streak, characterStatus: $characterStatus)';
  }
}

/// @nodoc
abstract mixin class $UserStreakDtoCopyWith<$Res> {
  factory $UserStreakDtoCopyWith(
          UserStreakDto value, $Res Function(UserStreakDto) _then) =
      _$UserStreakDtoCopyWithImpl;
  @useResult
  $Res call(
      {int streak,
      @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
      CharacterStatus characterStatus});
}

/// @nodoc
class _$UserStreakDtoCopyWithImpl<$Res>
    implements $UserStreakDtoCopyWith<$Res> {
  _$UserStreakDtoCopyWithImpl(this._self, this._then);

  final UserStreakDto _self;
  final $Res Function(UserStreakDto) _then;

  /// Create a copy of UserStreakDto
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

/// Adds pattern-matching-related methods to [UserStreakDto].
extension UserStreakDtoPatterns on UserStreakDto {
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
    TResult Function(_UserStreakDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserStreakDto() when $default != null:
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
    TResult Function(_UserStreakDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreakDto():
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
    TResult? Function(_UserStreakDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreakDto() when $default != null:
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
            int streak,
            @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
            CharacterStatus characterStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserStreakDto() when $default != null:
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
    TResult Function(
            int streak,
            @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
            CharacterStatus characterStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreakDto():
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
    TResult? Function(
            int streak,
            @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
            CharacterStatus characterStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserStreakDto() when $default != null:
        return $default(_that.streak, _that.characterStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserStreakDto implements UserStreakDto {
  const _UserStreakDto(
      {this.streak = 0,
      @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
      this.characterStatus = CharacterStatus.statisfied});
  factory _UserStreakDto.fromJson(Map<String, dynamic> json) =>
      _$UserStreakDtoFromJson(json);

  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
  final CharacterStatus characterStatus;

  /// Create a copy of UserStreakDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserStreakDtoCopyWith<_UserStreakDto> get copyWith =>
      __$UserStreakDtoCopyWithImpl<_UserStreakDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserStreakDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserStreakDto &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.characterStatus, characterStatus) ||
                other.characterStatus == characterStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, streak, characterStatus);

  @override
  String toString() {
    return 'UserStreakDto(streak: $streak, characterStatus: $characterStatus)';
  }
}

/// @nodoc
abstract mixin class _$UserStreakDtoCopyWith<$Res>
    implements $UserStreakDtoCopyWith<$Res> {
  factory _$UserStreakDtoCopyWith(
          _UserStreakDto value, $Res Function(_UserStreakDto) _then) =
      __$UserStreakDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int streak,
      @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
      CharacterStatus characterStatus});
}

/// @nodoc
class __$UserStreakDtoCopyWithImpl<$Res>
    implements _$UserStreakDtoCopyWith<$Res> {
  __$UserStreakDtoCopyWithImpl(this._self, this._then);

  final _UserStreakDto _self;
  final $Res Function(_UserStreakDto) _then;

  /// Create a copy of UserStreakDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? streak = null,
    Object? characterStatus = null,
  }) {
    return _then(_UserStreakDto(
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
