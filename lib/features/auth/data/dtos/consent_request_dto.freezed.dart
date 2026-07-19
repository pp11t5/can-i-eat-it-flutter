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
mixin _$ConsentItemDto {
  int get termId;
  bool get agreed;

  /// Create a copy of ConsentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConsentItemDtoCopyWith<ConsentItemDto> get copyWith =>
      _$ConsentItemDtoCopyWithImpl<ConsentItemDto>(
          this as ConsentItemDto, _$identity);

  /// Serializes this ConsentItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConsentItemDto &&
            (identical(other.termId, termId) || other.termId == termId) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, termId, agreed);

  @override
  String toString() {
    return 'ConsentItemDto(termId: $termId, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class $ConsentItemDtoCopyWith<$Res> {
  factory $ConsentItemDtoCopyWith(
          ConsentItemDto value, $Res Function(ConsentItemDto) _then) =
      _$ConsentItemDtoCopyWithImpl;
  @useResult
  $Res call({int termId, bool agreed});
}

/// @nodoc
class _$ConsentItemDtoCopyWithImpl<$Res>
    implements $ConsentItemDtoCopyWith<$Res> {
  _$ConsentItemDtoCopyWithImpl(this._self, this._then);

  final ConsentItemDto _self;
  final $Res Function(ConsentItemDto) _then;

  /// Create a copy of ConsentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termId = null,
    Object? agreed = null,
  }) {
    return _then(_self.copyWith(
      termId: null == termId
          ? _self.termId
          : termId // ignore: cast_nullable_to_non_nullable
              as int,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConsentItemDto].
extension ConsentItemDtoPatterns on ConsentItemDto {
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
    TResult Function(_ConsentItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentItemDto() when $default != null:
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
    TResult Function(_ConsentItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentItemDto():
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
    TResult? Function(_ConsentItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentItemDto() when $default != null:
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
    TResult Function(int termId, bool agreed)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentItemDto() when $default != null:
        return $default(_that.termId, _that.agreed);
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
    TResult Function(int termId, bool agreed) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentItemDto():
        return $default(_that.termId, _that.agreed);
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
    TResult? Function(int termId, bool agreed)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentItemDto() when $default != null:
        return $default(_that.termId, _that.agreed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConsentItemDto implements ConsentItemDto {
  const _ConsentItemDto({required this.termId, required this.agreed});
  factory _ConsentItemDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentItemDtoFromJson(json);

  @override
  final int termId;
  @override
  final bool agreed;

  /// Create a copy of ConsentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConsentItemDtoCopyWith<_ConsentItemDto> get copyWith =>
      __$ConsentItemDtoCopyWithImpl<_ConsentItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConsentItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConsentItemDto &&
            (identical(other.termId, termId) || other.termId == termId) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, termId, agreed);

  @override
  String toString() {
    return 'ConsentItemDto(termId: $termId, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class _$ConsentItemDtoCopyWith<$Res>
    implements $ConsentItemDtoCopyWith<$Res> {
  factory _$ConsentItemDtoCopyWith(
          _ConsentItemDto value, $Res Function(_ConsentItemDto) _then) =
      __$ConsentItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int termId, bool agreed});
}

/// @nodoc
class __$ConsentItemDtoCopyWithImpl<$Res>
    implements _$ConsentItemDtoCopyWith<$Res> {
  __$ConsentItemDtoCopyWithImpl(this._self, this._then);

  final _ConsentItemDto _self;
  final $Res Function(_ConsentItemDto) _then;

  /// Create a copy of ConsentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? termId = null,
    Object? agreed = null,
  }) {
    return _then(_ConsentItemDto(
      termId: null == termId
          ? _self.termId
          : termId // ignore: cast_nullable_to_non_nullable
              as int,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$ConsentRequestDto {
  List<ConsentItemDto> get consents;

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
            const DeepCollectionEquality().equals(other.consents, consents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(consents));

  @override
  String toString() {
    return 'ConsentRequestDto(consents: $consents)';
  }
}

/// @nodoc
abstract mixin class $ConsentRequestDtoCopyWith<$Res> {
  factory $ConsentRequestDtoCopyWith(
          ConsentRequestDto value, $Res Function(ConsentRequestDto) _then) =
      _$ConsentRequestDtoCopyWithImpl;
  @useResult
  $Res call({List<ConsentItemDto> consents});
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
    Object? consents = null,
  }) {
    return _then(_self.copyWith(
      consents: null == consents
          ? _self.consents
          : consents // ignore: cast_nullable_to_non_nullable
              as List<ConsentItemDto>,
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
    TResult Function(List<ConsentItemDto> consents)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto() when $default != null:
        return $default(_that.consents);
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
    TResult Function(List<ConsentItemDto> consents) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto():
        return $default(_that.consents);
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
    TResult? Function(List<ConsentItemDto> consents)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentRequestDto() when $default != null:
        return $default(_that.consents);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConsentRequestDto implements ConsentRequestDto {
  const _ConsentRequestDto({required final List<ConsentItemDto> consents})
      : _consents = consents;
  factory _ConsentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentRequestDtoFromJson(json);

  final List<ConsentItemDto> _consents;
  @override
  List<ConsentItemDto> get consents {
    if (_consents is EqualUnmodifiableListView) return _consents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consents);
  }

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
            const DeepCollectionEquality().equals(other._consents, _consents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_consents));

  @override
  String toString() {
    return 'ConsentRequestDto(consents: $consents)';
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
  $Res call({List<ConsentItemDto> consents});
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
    Object? consents = null,
  }) {
    return _then(_ConsentRequestDto(
      consents: null == consents
          ? _self._consents
          : consents // ignore: cast_nullable_to_non_nullable
              as List<ConsentItemDto>,
    ));
  }
}

// dart format on
