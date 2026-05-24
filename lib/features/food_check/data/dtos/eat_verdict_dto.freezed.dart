// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eat_verdict_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EatVerdictDto {
  String get level;
  String get reason;
  List<String> get sources;

  /// Create a copy of EatVerdictDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EatVerdictDtoCopyWith<EatVerdictDto> get copyWith =>
      _$EatVerdictDtoCopyWithImpl<EatVerdictDto>(
          this as EatVerdictDto, _$identity);

  /// Serializes this EatVerdictDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EatVerdictDto &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other.sources, sources));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, level, reason, const DeepCollectionEquality().hash(sources));

  @override
  String toString() {
    return 'EatVerdictDto(level: $level, reason: $reason, sources: $sources)';
  }
}

/// @nodoc
abstract mixin class $EatVerdictDtoCopyWith<$Res> {
  factory $EatVerdictDtoCopyWith(
          EatVerdictDto value, $Res Function(EatVerdictDto) _then) =
      _$EatVerdictDtoCopyWithImpl;
  @useResult
  $Res call({String level, String reason, List<String> sources});
}

/// @nodoc
class _$EatVerdictDtoCopyWithImpl<$Res>
    implements $EatVerdictDtoCopyWith<$Res> {
  _$EatVerdictDtoCopyWithImpl(this._self, this._then);

  final EatVerdictDto _self;
  final $Res Function(EatVerdictDto) _then;

  /// Create a copy of EatVerdictDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? reason = null,
    Object? sources = null,
  }) {
    return _then(_self.copyWith(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      sources: null == sources
          ? _self.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [EatVerdictDto].
extension EatVerdictDtoPatterns on EatVerdictDto {
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
    TResult Function(_EatVerdictDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EatVerdictDto() when $default != null:
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
    TResult Function(_EatVerdictDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdictDto():
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
    TResult? Function(_EatVerdictDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdictDto() when $default != null:
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
    TResult Function(String level, String reason, List<String> sources)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EatVerdictDto() when $default != null:
        return $default(_that.level, _that.reason, _that.sources);
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
    TResult Function(String level, String reason, List<String> sources)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdictDto():
        return $default(_that.level, _that.reason, _that.sources);
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
    TResult? Function(String level, String reason, List<String> sources)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdictDto() when $default != null:
        return $default(_that.level, _that.reason, _that.sources);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EatVerdictDto extends EatVerdictDto {
  const _EatVerdictDto(
      {required this.level,
      required this.reason,
      final List<String> sources = const <String>[]})
      : _sources = sources,
        super._();
  factory _EatVerdictDto.fromJson(Map<String, dynamic> json) =>
      _$EatVerdictDtoFromJson(json);

  @override
  final String level;
  @override
  final String reason;
  final List<String> _sources;
  @override
  @JsonKey()
  List<String> get sources {
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sources);
  }

  /// Create a copy of EatVerdictDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EatVerdictDtoCopyWith<_EatVerdictDto> get copyWith =>
      __$EatVerdictDtoCopyWithImpl<_EatVerdictDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EatVerdictDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EatVerdictDto &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other._sources, _sources));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, reason,
      const DeepCollectionEquality().hash(_sources));

  @override
  String toString() {
    return 'EatVerdictDto(level: $level, reason: $reason, sources: $sources)';
  }
}

/// @nodoc
abstract mixin class _$EatVerdictDtoCopyWith<$Res>
    implements $EatVerdictDtoCopyWith<$Res> {
  factory _$EatVerdictDtoCopyWith(
          _EatVerdictDto value, $Res Function(_EatVerdictDto) _then) =
      __$EatVerdictDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String level, String reason, List<String> sources});
}

/// @nodoc
class __$EatVerdictDtoCopyWithImpl<$Res>
    implements _$EatVerdictDtoCopyWith<$Res> {
  __$EatVerdictDtoCopyWithImpl(this._self, this._then);

  final _EatVerdictDto _self;
  final $Res Function(_EatVerdictDto) _then;

  /// Create a copy of EatVerdictDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = null,
    Object? reason = null,
    Object? sources = null,
  }) {
    return _then(_EatVerdictDto(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      sources: null == sources
          ? _self._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
