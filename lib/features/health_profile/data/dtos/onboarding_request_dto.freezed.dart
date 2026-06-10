// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingRequestDto {
  List<String> get symptoms;
  List<String> get symptomFrequency;
  bool get diagnosed;
  List<String> get triggers;
  List<String> get medications;
  List<String> get allergens;

  /// Create a copy of OnboardingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardingRequestDtoCopyWith<OnboardingRequestDto> get copyWith =>
      _$OnboardingRequestDtoCopyWithImpl<OnboardingRequestDto>(
          this as OnboardingRequestDto, _$identity);

  /// Serializes this OnboardingRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardingRequestDto &&
            const DeepCollectionEquality().equals(other.symptoms, symptoms) &&
            const DeepCollectionEquality()
                .equals(other.symptomFrequency, symptomFrequency) &&
            (identical(other.diagnosed, diagnosed) ||
                other.diagnosed == diagnosed) &&
            const DeepCollectionEquality().equals(other.triggers, triggers) &&
            const DeepCollectionEquality()
                .equals(other.medications, medications) &&
            const DeepCollectionEquality().equals(other.allergens, allergens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(symptoms),
      const DeepCollectionEquality().hash(symptomFrequency),
      diagnosed,
      const DeepCollectionEquality().hash(triggers),
      const DeepCollectionEquality().hash(medications),
      const DeepCollectionEquality().hash(allergens));

  @override
  String toString() {
    return 'OnboardingRequestDto(symptoms: $symptoms, symptomFrequency: $symptomFrequency, diagnosed: $diagnosed, triggers: $triggers, medications: $medications, allergens: $allergens)';
  }
}

/// @nodoc
abstract mixin class $OnboardingRequestDtoCopyWith<$Res> {
  factory $OnboardingRequestDtoCopyWith(OnboardingRequestDto value,
          $Res Function(OnboardingRequestDto) _then) =
      _$OnboardingRequestDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<String> symptoms,
      List<String> symptomFrequency,
      bool diagnosed,
      List<String> triggers,
      List<String> medications,
      List<String> allergens});
}

/// @nodoc
class _$OnboardingRequestDtoCopyWithImpl<$Res>
    implements $OnboardingRequestDtoCopyWith<$Res> {
  _$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final OnboardingRequestDto _self;
  final $Res Function(OnboardingRequestDto) _then;

  /// Create a copy of OnboardingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptoms = null,
    Object? symptomFrequency = null,
    Object? diagnosed = null,
    Object? triggers = null,
    Object? medications = null,
    Object? allergens = null,
  }) {
    return _then(_self.copyWith(
      symptoms: null == symptoms
          ? _self.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      symptomFrequency: null == symptomFrequency
          ? _self.symptomFrequency
          : symptomFrequency // ignore: cast_nullable_to_non_nullable
              as List<String>,
      diagnosed: null == diagnosed
          ? _self.diagnosed
          : diagnosed // ignore: cast_nullable_to_non_nullable
              as bool,
      triggers: null == triggers
          ? _self.triggers
          : triggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medications: null == medications
          ? _self.medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _self.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [OnboardingRequestDto].
extension OnboardingRequestDtoPatterns on OnboardingRequestDto {
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
    TResult Function(_OnboardingRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingRequestDto() when $default != null:
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
    TResult Function(_OnboardingRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingRequestDto():
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
    TResult? Function(_OnboardingRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingRequestDto() when $default != null:
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
            List<String> symptoms,
            List<String> symptomFrequency,
            bool diagnosed,
            List<String> triggers,
            List<String> medications,
            List<String> allergens)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingRequestDto() when $default != null:
        return $default(_that.symptoms, _that.symptomFrequency, _that.diagnosed,
            _that.triggers, _that.medications, _that.allergens);
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
            List<String> symptoms,
            List<String> symptomFrequency,
            bool diagnosed,
            List<String> triggers,
            List<String> medications,
            List<String> allergens)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingRequestDto():
        return $default(_that.symptoms, _that.symptomFrequency, _that.diagnosed,
            _that.triggers, _that.medications, _that.allergens);
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
            List<String> symptoms,
            List<String> symptomFrequency,
            bool diagnosed,
            List<String> triggers,
            List<String> medications,
            List<String> allergens)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingRequestDto() when $default != null:
        return $default(_that.symptoms, _that.symptomFrequency, _that.diagnosed,
            _that.triggers, _that.medications, _that.allergens);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OnboardingRequestDto extends OnboardingRequestDto {
  const _OnboardingRequestDto(
      {final List<String> symptoms = const <String>[],
      final List<String> symptomFrequency = const <String>[],
      this.diagnosed = false,
      final List<String> triggers = const <String>[],
      final List<String> medications = const <String>[],
      final List<String> allergens = const <String>[]})
      : _symptoms = symptoms,
        _symptomFrequency = symptomFrequency,
        _triggers = triggers,
        _medications = medications,
        _allergens = allergens,
        super._();
  factory _OnboardingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestDtoFromJson(json);

  final List<String> _symptoms;
  @override
  @JsonKey()
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  final List<String> _symptomFrequency;
  @override
  @JsonKey()
  List<String> get symptomFrequency {
    if (_symptomFrequency is EqualUnmodifiableListView)
      return _symptomFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomFrequency);
  }

  @override
  @JsonKey()
  final bool diagnosed;
  final List<String> _triggers;
  @override
  @JsonKey()
  List<String> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  final List<String> _medications;
  @override
  @JsonKey()
  List<String> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  /// Create a copy of OnboardingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OnboardingRequestDtoCopyWith<_OnboardingRequestDto> get copyWith =>
      __$OnboardingRequestDtoCopyWithImpl<_OnboardingRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OnboardingRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnboardingRequestDto &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality()
                .equals(other._symptomFrequency, _symptomFrequency) &&
            (identical(other.diagnosed, diagnosed) ||
                other.diagnosed == diagnosed) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            const DeepCollectionEquality()
                .equals(other._medications, _medications) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_symptoms),
      const DeepCollectionEquality().hash(_symptomFrequency),
      diagnosed,
      const DeepCollectionEquality().hash(_triggers),
      const DeepCollectionEquality().hash(_medications),
      const DeepCollectionEquality().hash(_allergens));

  @override
  String toString() {
    return 'OnboardingRequestDto(symptoms: $symptoms, symptomFrequency: $symptomFrequency, diagnosed: $diagnosed, triggers: $triggers, medications: $medications, allergens: $allergens)';
  }
}

/// @nodoc
abstract mixin class _$OnboardingRequestDtoCopyWith<$Res>
    implements $OnboardingRequestDtoCopyWith<$Res> {
  factory _$OnboardingRequestDtoCopyWith(_OnboardingRequestDto value,
          $Res Function(_OnboardingRequestDto) _then) =
      __$OnboardingRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String> symptoms,
      List<String> symptomFrequency,
      bool diagnosed,
      List<String> triggers,
      List<String> medications,
      List<String> allergens});
}

/// @nodoc
class __$OnboardingRequestDtoCopyWithImpl<$Res>
    implements _$OnboardingRequestDtoCopyWith<$Res> {
  __$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final _OnboardingRequestDto _self;
  final $Res Function(_OnboardingRequestDto) _then;

  /// Create a copy of OnboardingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptoms = null,
    Object? symptomFrequency = null,
    Object? diagnosed = null,
    Object? triggers = null,
    Object? medications = null,
    Object? allergens = null,
  }) {
    return _then(_OnboardingRequestDto(
      symptoms: null == symptoms
          ? _self._symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      symptomFrequency: null == symptomFrequency
          ? _self._symptomFrequency
          : symptomFrequency // ignore: cast_nullable_to_non_nullable
              as List<String>,
      diagnosed: null == diagnosed
          ? _self.diagnosed
          : diagnosed // ignore: cast_nullable_to_non_nullable
              as bool,
      triggers: null == triggers
          ? _self._triggers
          : triggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medications: null == medications
          ? _self._medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _self._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
