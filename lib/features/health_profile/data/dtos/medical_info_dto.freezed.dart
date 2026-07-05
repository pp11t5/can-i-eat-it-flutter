// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicalInfoDto {
  List<String> get allergies;
  List<String> get medications;

  /// Create a copy of MedicalInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicalInfoDtoCopyWith<MedicalInfoDto> get copyWith =>
      _$MedicalInfoDtoCopyWithImpl<MedicalInfoDto>(
          this as MedicalInfoDto, _$identity);

  /// Serializes this MedicalInfoDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicalInfoDto &&
            const DeepCollectionEquality().equals(other.allergies, allergies) &&
            const DeepCollectionEquality()
                .equals(other.medications, medications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(allergies),
      const DeepCollectionEquality().hash(medications));

  @override
  String toString() {
    return 'MedicalInfoDto(allergies: $allergies, medications: $medications)';
  }
}

/// @nodoc
abstract mixin class $MedicalInfoDtoCopyWith<$Res> {
  factory $MedicalInfoDtoCopyWith(
          MedicalInfoDto value, $Res Function(MedicalInfoDto) _then) =
      _$MedicalInfoDtoCopyWithImpl;
  @useResult
  $Res call({List<String> allergies, List<String> medications});
}

/// @nodoc
class _$MedicalInfoDtoCopyWithImpl<$Res>
    implements $MedicalInfoDtoCopyWith<$Res> {
  _$MedicalInfoDtoCopyWithImpl(this._self, this._then);

  final MedicalInfoDto _self;
  final $Res Function(MedicalInfoDto) _then;

  /// Create a copy of MedicalInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allergies = null,
    Object? medications = null,
  }) {
    return _then(_self.copyWith(
      allergies: null == allergies
          ? _self.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medications: null == medications
          ? _self.medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicalInfoDto].
extension MedicalInfoDtoPatterns on MedicalInfoDto {
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
    TResult Function(_MedicalInfoDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoDto() when $default != null:
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
    TResult Function(_MedicalInfoDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoDto():
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
    TResult? Function(_MedicalInfoDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoDto() when $default != null:
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
    TResult Function(List<String> allergies, List<String> medications)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoDto() when $default != null:
        return $default(_that.allergies, _that.medications);
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
    TResult Function(List<String> allergies, List<String> medications) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoDto():
        return $default(_that.allergies, _that.medications);
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
    TResult? Function(List<String> allergies, List<String> medications)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoDto() when $default != null:
        return $default(_that.allergies, _that.medications);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicalInfoDto implements MedicalInfoDto {
  const _MedicalInfoDto(
      {final List<String> allergies = const <String>[],
      final List<String> medications = const <String>[]})
      : _allergies = allergies,
        _medications = medications;
  factory _MedicalInfoDto.fromJson(Map<String, dynamic> json) =>
      _$MedicalInfoDtoFromJson(json);

  final List<String> _allergies;
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  final List<String> _medications;
  @override
  @JsonKey()
  List<String> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  /// Create a copy of MedicalInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicalInfoDtoCopyWith<_MedicalInfoDto> get copyWith =>
      __$MedicalInfoDtoCopyWithImpl<_MedicalInfoDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicalInfoDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicalInfoDto &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            const DeepCollectionEquality()
                .equals(other._medications, _medications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allergies),
      const DeepCollectionEquality().hash(_medications));

  @override
  String toString() {
    return 'MedicalInfoDto(allergies: $allergies, medications: $medications)';
  }
}

/// @nodoc
abstract mixin class _$MedicalInfoDtoCopyWith<$Res>
    implements $MedicalInfoDtoCopyWith<$Res> {
  factory _$MedicalInfoDtoCopyWith(
          _MedicalInfoDto value, $Res Function(_MedicalInfoDto) _then) =
      __$MedicalInfoDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> allergies, List<String> medications});
}

/// @nodoc
class __$MedicalInfoDtoCopyWithImpl<$Res>
    implements _$MedicalInfoDtoCopyWith<$Res> {
  __$MedicalInfoDtoCopyWithImpl(this._self, this._then);

  final _MedicalInfoDto _self;
  final $Res Function(_MedicalInfoDto) _then;

  /// Create a copy of MedicalInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? allergies = null,
    Object? medications = null,
  }) {
    return _then(_MedicalInfoDto(
      allergies: null == allergies
          ? _self._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medications: null == medications
          ? _self._medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$MedicalInfoUpdateRequestDto {
  List<String> get allergens;
  List<String> get medications;

  /// Create a copy of MedicalInfoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicalInfoUpdateRequestDtoCopyWith<MedicalInfoUpdateRequestDto>
      get copyWith => _$MedicalInfoUpdateRequestDtoCopyWithImpl<
              MedicalInfoUpdateRequestDto>(
          this as MedicalInfoUpdateRequestDto, _$identity);

  /// Serializes this MedicalInfoUpdateRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicalInfoUpdateRequestDto &&
            const DeepCollectionEquality().equals(other.allergens, allergens) &&
            const DeepCollectionEquality()
                .equals(other.medications, medications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(allergens),
      const DeepCollectionEquality().hash(medications));

  @override
  String toString() {
    return 'MedicalInfoUpdateRequestDto(allergens: $allergens, medications: $medications)';
  }
}

/// @nodoc
abstract mixin class $MedicalInfoUpdateRequestDtoCopyWith<$Res> {
  factory $MedicalInfoUpdateRequestDtoCopyWith(
          MedicalInfoUpdateRequestDto value,
          $Res Function(MedicalInfoUpdateRequestDto) _then) =
      _$MedicalInfoUpdateRequestDtoCopyWithImpl;
  @useResult
  $Res call({List<String> allergens, List<String> medications});
}

/// @nodoc
class _$MedicalInfoUpdateRequestDtoCopyWithImpl<$Res>
    implements $MedicalInfoUpdateRequestDtoCopyWith<$Res> {
  _$MedicalInfoUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final MedicalInfoUpdateRequestDto _self;
  final $Res Function(MedicalInfoUpdateRequestDto) _then;

  /// Create a copy of MedicalInfoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allergens = null,
    Object? medications = null,
  }) {
    return _then(_self.copyWith(
      allergens: null == allergens
          ? _self.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medications: null == medications
          ? _self.medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicalInfoUpdateRequestDto].
extension MedicalInfoUpdateRequestDtoPatterns on MedicalInfoUpdateRequestDto {
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
    TResult Function(_MedicalInfoUpdateRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoUpdateRequestDto() when $default != null:
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
    TResult Function(_MedicalInfoUpdateRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoUpdateRequestDto():
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
    TResult? Function(_MedicalInfoUpdateRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoUpdateRequestDto() when $default != null:
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
    TResult Function(List<String> allergens, List<String> medications)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoUpdateRequestDto() when $default != null:
        return $default(_that.allergens, _that.medications);
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
    TResult Function(List<String> allergens, List<String> medications) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoUpdateRequestDto():
        return $default(_that.allergens, _that.medications);
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
    TResult? Function(List<String> allergens, List<String> medications)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicalInfoUpdateRequestDto() when $default != null:
        return $default(_that.allergens, _that.medications);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicalInfoUpdateRequestDto implements MedicalInfoUpdateRequestDto {
  const _MedicalInfoUpdateRequestDto(
      {final List<String> allergens = const <String>[],
      final List<String> medications = const <String>[]})
      : _allergens = allergens,
        _medications = medications;
  factory _MedicalInfoUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MedicalInfoUpdateRequestDtoFromJson(json);

  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  final List<String> _medications;
  @override
  @JsonKey()
  List<String> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  /// Create a copy of MedicalInfoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicalInfoUpdateRequestDtoCopyWith<_MedicalInfoUpdateRequestDto>
      get copyWith => __$MedicalInfoUpdateRequestDtoCopyWithImpl<
          _MedicalInfoUpdateRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicalInfoUpdateRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicalInfoUpdateRequestDto &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._medications, _medications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allergens),
      const DeepCollectionEquality().hash(_medications));

  @override
  String toString() {
    return 'MedicalInfoUpdateRequestDto(allergens: $allergens, medications: $medications)';
  }
}

/// @nodoc
abstract mixin class _$MedicalInfoUpdateRequestDtoCopyWith<$Res>
    implements $MedicalInfoUpdateRequestDtoCopyWith<$Res> {
  factory _$MedicalInfoUpdateRequestDtoCopyWith(
          _MedicalInfoUpdateRequestDto value,
          $Res Function(_MedicalInfoUpdateRequestDto) _then) =
      __$MedicalInfoUpdateRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> allergens, List<String> medications});
}

/// @nodoc
class __$MedicalInfoUpdateRequestDtoCopyWithImpl<$Res>
    implements _$MedicalInfoUpdateRequestDtoCopyWith<$Res> {
  __$MedicalInfoUpdateRequestDtoCopyWithImpl(this._self, this._then);

  final _MedicalInfoUpdateRequestDto _self;
  final $Res Function(_MedicalInfoUpdateRequestDto) _then;

  /// Create a copy of MedicalInfoUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? allergens = null,
    Object? medications = null,
  }) {
    return _then(_MedicalInfoUpdateRequestDto(
      allergens: null == allergens
          ? _self._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medications: null == medications
          ? _self._medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
