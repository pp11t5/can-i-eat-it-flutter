// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_status_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingStatusDto {
  bool get onboarded;

  /// Create a copy of OnboardingStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardingStatusDtoCopyWith<OnboardingStatusDto> get copyWith =>
      _$OnboardingStatusDtoCopyWithImpl<OnboardingStatusDto>(
          this as OnboardingStatusDto, _$identity);

  /// Serializes this OnboardingStatusDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardingStatusDto &&
            (identical(other.onboarded, onboarded) ||
                other.onboarded == onboarded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, onboarded);

  @override
  String toString() {
    return 'OnboardingStatusDto(onboarded: $onboarded)';
  }
}

/// @nodoc
abstract mixin class $OnboardingStatusDtoCopyWith<$Res> {
  factory $OnboardingStatusDtoCopyWith(
          OnboardingStatusDto value, $Res Function(OnboardingStatusDto) _then) =
      _$OnboardingStatusDtoCopyWithImpl;
  @useResult
  $Res call({bool onboarded});
}

/// @nodoc
class _$OnboardingStatusDtoCopyWithImpl<$Res>
    implements $OnboardingStatusDtoCopyWith<$Res> {
  _$OnboardingStatusDtoCopyWithImpl(this._self, this._then);

  final OnboardingStatusDto _self;
  final $Res Function(OnboardingStatusDto) _then;

  /// Create a copy of OnboardingStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboarded = null,
  }) {
    return _then(_self.copyWith(
      onboarded: null == onboarded
          ? _self.onboarded
          : onboarded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [OnboardingStatusDto].
extension OnboardingStatusDtoPatterns on OnboardingStatusDto {
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
    TResult Function(_OnboardingStatusDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingStatusDto() when $default != null:
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
    TResult Function(_OnboardingStatusDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingStatusDto():
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
    TResult? Function(_OnboardingStatusDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingStatusDto() when $default != null:
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
    TResult Function(bool onboarded)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingStatusDto() when $default != null:
        return $default(_that.onboarded);
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
    TResult Function(bool onboarded) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingStatusDto():
        return $default(_that.onboarded);
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
    TResult? Function(bool onboarded)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingStatusDto() when $default != null:
        return $default(_that.onboarded);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OnboardingStatusDto implements OnboardingStatusDto {
  const _OnboardingStatusDto({required this.onboarded});
  factory _OnboardingStatusDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusDtoFromJson(json);

  @override
  final bool onboarded;

  /// Create a copy of OnboardingStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OnboardingStatusDtoCopyWith<_OnboardingStatusDto> get copyWith =>
      __$OnboardingStatusDtoCopyWithImpl<_OnboardingStatusDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OnboardingStatusDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnboardingStatusDto &&
            (identical(other.onboarded, onboarded) ||
                other.onboarded == onboarded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, onboarded);

  @override
  String toString() {
    return 'OnboardingStatusDto(onboarded: $onboarded)';
  }
}

/// @nodoc
abstract mixin class _$OnboardingStatusDtoCopyWith<$Res>
    implements $OnboardingStatusDtoCopyWith<$Res> {
  factory _$OnboardingStatusDtoCopyWith(_OnboardingStatusDto value,
          $Res Function(_OnboardingStatusDto) _then) =
      __$OnboardingStatusDtoCopyWithImpl;
  @override
  @useResult
  $Res call({bool onboarded});
}

/// @nodoc
class __$OnboardingStatusDtoCopyWithImpl<$Res>
    implements _$OnboardingStatusDtoCopyWith<$Res> {
  __$OnboardingStatusDtoCopyWithImpl(this._self, this._then);

  final _OnboardingStatusDto _self;
  final $Res Function(_OnboardingStatusDto) _then;

  /// Create a copy of OnboardingStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? onboarded = null,
  }) {
    return _then(_OnboardingStatusDto(
      onboarded: null == onboarded
          ? _self.onboarded
          : onboarded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
