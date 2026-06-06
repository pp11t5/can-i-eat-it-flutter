// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthProfileDto {
  List<String> get conditions;
  @JsonKey(name: 'symptom_frequency')
  List<String> get symptomFrequency;
  bool get diagnosed;
  @JsonKey(name: 'trigger_foods')
  List<String> get triggerFoods;
  @JsonKey(name: 'custom_triggers')
  String? get customTriggers;
  List<String> get medications;
  List<String> get allergies;

  /// Create a copy of HealthProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HealthProfileDtoCopyWith<HealthProfileDto> get copyWith =>
      _$HealthProfileDtoCopyWithImpl<HealthProfileDto>(
          this as HealthProfileDto, _$identity);

  /// Serializes this HealthProfileDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HealthProfileDto &&
            const DeepCollectionEquality()
                .equals(other.conditions, conditions) &&
            const DeepCollectionEquality()
                .equals(other.symptomFrequency, symptomFrequency) &&
            (identical(other.diagnosed, diagnosed) ||
                other.diagnosed == diagnosed) &&
            const DeepCollectionEquality()
                .equals(other.triggerFoods, triggerFoods) &&
            (identical(other.customTriggers, customTriggers) ||
                other.customTriggers == customTriggers) &&
            const DeepCollectionEquality()
                .equals(other.medications, medications) &&
            const DeepCollectionEquality().equals(other.allergies, allergies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(conditions),
      const DeepCollectionEquality().hash(symptomFrequency),
      diagnosed,
      const DeepCollectionEquality().hash(triggerFoods),
      customTriggers,
      const DeepCollectionEquality().hash(medications),
      const DeepCollectionEquality().hash(allergies));

  @override
  String toString() {
    return 'HealthProfileDto(conditions: $conditions, symptomFrequency: $symptomFrequency, diagnosed: $diagnosed, triggerFoods: $triggerFoods, customTriggers: $customTriggers, medications: $medications, allergies: $allergies)';
  }
}

/// @nodoc
abstract mixin class $HealthProfileDtoCopyWith<$Res> {
  factory $HealthProfileDtoCopyWith(
          HealthProfileDto value, $Res Function(HealthProfileDto) _then) =
      _$HealthProfileDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<String> conditions,
      @JsonKey(name: 'symptom_frequency') List<String> symptomFrequency,
      bool diagnosed,
      @JsonKey(name: 'trigger_foods') List<String> triggerFoods,
      @JsonKey(name: 'custom_triggers') String? customTriggers,
      List<String> medications,
      List<String> allergies});
}

/// @nodoc
class _$HealthProfileDtoCopyWithImpl<$Res>
    implements $HealthProfileDtoCopyWith<$Res> {
  _$HealthProfileDtoCopyWithImpl(this._self, this._then);

  final HealthProfileDto _self;
  final $Res Function(HealthProfileDto) _then;

  /// Create a copy of HealthProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conditions = null,
    Object? symptomFrequency = null,
    Object? diagnosed = null,
    Object? triggerFoods = null,
    Object? customTriggers = freezed,
    Object? medications = null,
    Object? allergies = null,
  }) {
    return _then(_self.copyWith(
      conditions: null == conditions
          ? _self.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      symptomFrequency: null == symptomFrequency
          ? _self.symptomFrequency
          : symptomFrequency // ignore: cast_nullable_to_non_nullable
              as List<String>,
      diagnosed: null == diagnosed
          ? _self.diagnosed
          : diagnosed // ignore: cast_nullable_to_non_nullable
              as bool,
      triggerFoods: null == triggerFoods
          ? _self.triggerFoods
          : triggerFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customTriggers: freezed == customTriggers
          ? _self.customTriggers
          : customTriggers // ignore: cast_nullable_to_non_nullable
              as String?,
      medications: null == medications
          ? _self.medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergies: null == allergies
          ? _self.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [HealthProfileDto].
extension HealthProfileDtoPatterns on HealthProfileDto {
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
    TResult Function(_HealthProfileDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthProfileDto() when $default != null:
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
    TResult Function(_HealthProfileDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfileDto():
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
    TResult? Function(_HealthProfileDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfileDto() when $default != null:
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
            List<String> conditions,
            @JsonKey(name: 'symptom_frequency') List<String> symptomFrequency,
            bool diagnosed,
            @JsonKey(name: 'trigger_foods') List<String> triggerFoods,
            @JsonKey(name: 'custom_triggers') String? customTriggers,
            List<String> medications,
            List<String> allergies)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthProfileDto() when $default != null:
        return $default(
            _that.conditions,
            _that.symptomFrequency,
            _that.diagnosed,
            _that.triggerFoods,
            _that.customTriggers,
            _that.medications,
            _that.allergies);
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
            List<String> conditions,
            @JsonKey(name: 'symptom_frequency') List<String> symptomFrequency,
            bool diagnosed,
            @JsonKey(name: 'trigger_foods') List<String> triggerFoods,
            @JsonKey(name: 'custom_triggers') String? customTriggers,
            List<String> medications,
            List<String> allergies)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfileDto():
        return $default(
            _that.conditions,
            _that.symptomFrequency,
            _that.diagnosed,
            _that.triggerFoods,
            _that.customTriggers,
            _that.medications,
            _that.allergies);
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
            List<String> conditions,
            @JsonKey(name: 'symptom_frequency') List<String> symptomFrequency,
            bool diagnosed,
            @JsonKey(name: 'trigger_foods') List<String> triggerFoods,
            @JsonKey(name: 'custom_triggers') String? customTriggers,
            List<String> medications,
            List<String> allergies)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfileDto() when $default != null:
        return $default(
            _that.conditions,
            _that.symptomFrequency,
            _that.diagnosed,
            _that.triggerFoods,
            _that.customTriggers,
            _that.medications,
            _that.allergies);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HealthProfileDto extends HealthProfileDto {
  const _HealthProfileDto(
      {final List<String> conditions = const <String>[],
      @JsonKey(name: 'symptom_frequency')
      final List<String> symptomFrequency = const <String>[],
      this.diagnosed = false,
      @JsonKey(name: 'trigger_foods')
      final List<String> triggerFoods = const <String>[],
      @JsonKey(name: 'custom_triggers') this.customTriggers,
      final List<String> medications = const <String>[],
      final List<String> allergies = const <String>[]})
      : _conditions = conditions,
        _symptomFrequency = symptomFrequency,
        _triggerFoods = triggerFoods,
        _medications = medications,
        _allergies = allergies,
        super._();
  factory _HealthProfileDto.fromJson(Map<String, dynamic> json) =>
      _$HealthProfileDtoFromJson(json);

  final List<String> _conditions;
  @override
  @JsonKey()
  List<String> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  final List<String> _symptomFrequency;
  @override
  @JsonKey(name: 'symptom_frequency')
  List<String> get symptomFrequency {
    if (_symptomFrequency is EqualUnmodifiableListView)
      return _symptomFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomFrequency);
  }

  @override
  @JsonKey()
  final bool diagnosed;
  final List<String> _triggerFoods;
  @override
  @JsonKey(name: 'trigger_foods')
  List<String> get triggerFoods {
    if (_triggerFoods is EqualUnmodifiableListView) return _triggerFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggerFoods);
  }

  @override
  @JsonKey(name: 'custom_triggers')
  final String? customTriggers;
  final List<String> _medications;
  @override
  @JsonKey()
  List<String> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  final List<String> _allergies;
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  /// Create a copy of HealthProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HealthProfileDtoCopyWith<_HealthProfileDto> get copyWith =>
      __$HealthProfileDtoCopyWithImpl<_HealthProfileDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HealthProfileDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HealthProfileDto &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            const DeepCollectionEquality()
                .equals(other._symptomFrequency, _symptomFrequency) &&
            (identical(other.diagnosed, diagnosed) ||
                other.diagnosed == diagnosed) &&
            const DeepCollectionEquality()
                .equals(other._triggerFoods, _triggerFoods) &&
            (identical(other.customTriggers, customTriggers) ||
                other.customTriggers == customTriggers) &&
            const DeepCollectionEquality()
                .equals(other._medications, _medications) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_conditions),
      const DeepCollectionEquality().hash(_symptomFrequency),
      diagnosed,
      const DeepCollectionEquality().hash(_triggerFoods),
      customTriggers,
      const DeepCollectionEquality().hash(_medications),
      const DeepCollectionEquality().hash(_allergies));

  @override
  String toString() {
    return 'HealthProfileDto(conditions: $conditions, symptomFrequency: $symptomFrequency, diagnosed: $diagnosed, triggerFoods: $triggerFoods, customTriggers: $customTriggers, medications: $medications, allergies: $allergies)';
  }
}

/// @nodoc
abstract mixin class _$HealthProfileDtoCopyWith<$Res>
    implements $HealthProfileDtoCopyWith<$Res> {
  factory _$HealthProfileDtoCopyWith(
          _HealthProfileDto value, $Res Function(_HealthProfileDto) _then) =
      __$HealthProfileDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String> conditions,
      @JsonKey(name: 'symptom_frequency') List<String> symptomFrequency,
      bool diagnosed,
      @JsonKey(name: 'trigger_foods') List<String> triggerFoods,
      @JsonKey(name: 'custom_triggers') String? customTriggers,
      List<String> medications,
      List<String> allergies});
}

/// @nodoc
class __$HealthProfileDtoCopyWithImpl<$Res>
    implements _$HealthProfileDtoCopyWith<$Res> {
  __$HealthProfileDtoCopyWithImpl(this._self, this._then);

  final _HealthProfileDto _self;
  final $Res Function(_HealthProfileDto) _then;

  /// Create a copy of HealthProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? conditions = null,
    Object? symptomFrequency = null,
    Object? diagnosed = null,
    Object? triggerFoods = null,
    Object? customTriggers = freezed,
    Object? medications = null,
    Object? allergies = null,
  }) {
    return _then(_HealthProfileDto(
      conditions: null == conditions
          ? _self._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      symptomFrequency: null == symptomFrequency
          ? _self._symptomFrequency
          : symptomFrequency // ignore: cast_nullable_to_non_nullable
              as List<String>,
      diagnosed: null == diagnosed
          ? _self.diagnosed
          : diagnosed // ignore: cast_nullable_to_non_nullable
              as bool,
      triggerFoods: null == triggerFoods
          ? _self._triggerFoods
          : triggerFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customTriggers: freezed == customTriggers
          ? _self.customTriggers
          : customTriggers // ignore: cast_nullable_to_non_nullable
              as String?,
      medications: null == medications
          ? _self._medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergies: null == allergies
          ? _self._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
