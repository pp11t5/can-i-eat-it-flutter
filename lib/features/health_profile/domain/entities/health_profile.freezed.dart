// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthProfile {
  /// 질환 코드 목록. 예: ['GERD']. 다중 질환 확장 대비.
  List<String> get conditions;

  /// 증상 빈도 목록. 예: ['heartburn_reflux', 'post_meal_cough'].
  List<String> get symptomFrequency;

  /// 의사 진단 여부.
  bool get diagnosed;

  /// 트리거 음식 목록. 예: ['spicy', 'caffeine'].
  List<String> get triggerFoods;

  /// 사용자 직접 입력 트리거. 예: '탄산음료'.
  String? get customTriggers;

  /// 복용약 목록. 예: ['omeprazole'].
  List<String> get medications;

  /// 알레르기 목록. 예: ['shellfish'].
  List<String> get allergies;

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HealthProfileCopyWith<HealthProfile> get copyWith =>
      _$HealthProfileCopyWithImpl<HealthProfile>(
          this as HealthProfile, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HealthProfile &&
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
    return 'HealthProfile(conditions: $conditions, symptomFrequency: $symptomFrequency, diagnosed: $diagnosed, triggerFoods: $triggerFoods, customTriggers: $customTriggers, medications: $medications, allergies: $allergies)';
  }
}

/// @nodoc
abstract mixin class $HealthProfileCopyWith<$Res> {
  factory $HealthProfileCopyWith(
          HealthProfile value, $Res Function(HealthProfile) _then) =
      _$HealthProfileCopyWithImpl;
  @useResult
  $Res call(
      {List<String> conditions,
      List<String> symptomFrequency,
      bool diagnosed,
      List<String> triggerFoods,
      String? customTriggers,
      List<String> medications,
      List<String> allergies});
}

/// @nodoc
class _$HealthProfileCopyWithImpl<$Res>
    implements $HealthProfileCopyWith<$Res> {
  _$HealthProfileCopyWithImpl(this._self, this._then);

  final HealthProfile _self;
  final $Res Function(HealthProfile) _then;

  /// Create a copy of HealthProfile
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

/// Adds pattern-matching-related methods to [HealthProfile].
extension HealthProfilePatterns on HealthProfile {
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
    TResult Function(_HealthProfile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthProfile() when $default != null:
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
    TResult Function(_HealthProfile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfile():
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
    TResult? Function(_HealthProfile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfile() when $default != null:
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
            List<String> symptomFrequency,
            bool diagnosed,
            List<String> triggerFoods,
            String? customTriggers,
            List<String> medications,
            List<String> allergies)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthProfile() when $default != null:
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
            List<String> symptomFrequency,
            bool diagnosed,
            List<String> triggerFoods,
            String? customTriggers,
            List<String> medications,
            List<String> allergies)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfile():
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
            List<String> symptomFrequency,
            bool diagnosed,
            List<String> triggerFoods,
            String? customTriggers,
            List<String> medications,
            List<String> allergies)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthProfile() when $default != null:
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

class _HealthProfile implements HealthProfile {
  const _HealthProfile(
      {final List<String> conditions = const <String>[],
      final List<String> symptomFrequency = const <String>[],
      this.diagnosed = false,
      final List<String> triggerFoods = const <String>[],
      this.customTriggers,
      final List<String> medications = const <String>[],
      final List<String> allergies = const <String>[]})
      : _conditions = conditions,
        _symptomFrequency = symptomFrequency,
        _triggerFoods = triggerFoods,
        _medications = medications,
        _allergies = allergies;

  /// 질환 코드 목록. 예: ['GERD']. 다중 질환 확장 대비.
  final List<String> _conditions;

  /// 질환 코드 목록. 예: ['GERD']. 다중 질환 확장 대비.
  @override
  @JsonKey()
  List<String> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  /// 증상 빈도 목록. 예: ['heartburn_reflux', 'post_meal_cough'].
  final List<String> _symptomFrequency;

  /// 증상 빈도 목록. 예: ['heartburn_reflux', 'post_meal_cough'].
  @override
  @JsonKey()
  List<String> get symptomFrequency {
    if (_symptomFrequency is EqualUnmodifiableListView)
      return _symptomFrequency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomFrequency);
  }

  /// 의사 진단 여부.
  @override
  @JsonKey()
  final bool diagnosed;

  /// 트리거 음식 목록. 예: ['spicy', 'caffeine'].
  final List<String> _triggerFoods;

  /// 트리거 음식 목록. 예: ['spicy', 'caffeine'].
  @override
  @JsonKey()
  List<String> get triggerFoods {
    if (_triggerFoods is EqualUnmodifiableListView) return _triggerFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggerFoods);
  }

  /// 사용자 직접 입력 트리거. 예: '탄산음료'.
  @override
  final String? customTriggers;

  /// 복용약 목록. 예: ['omeprazole'].
  final List<String> _medications;

  /// 복용약 목록. 예: ['omeprazole'].
  @override
  @JsonKey()
  List<String> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  /// 알레르기 목록. 예: ['shellfish'].
  final List<String> _allergies;

  /// 알레르기 목록. 예: ['shellfish'].
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  /// Create a copy of HealthProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HealthProfileCopyWith<_HealthProfile> get copyWith =>
      __$HealthProfileCopyWithImpl<_HealthProfile>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HealthProfile &&
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
    return 'HealthProfile(conditions: $conditions, symptomFrequency: $symptomFrequency, diagnosed: $diagnosed, triggerFoods: $triggerFoods, customTriggers: $customTriggers, medications: $medications, allergies: $allergies)';
  }
}

/// @nodoc
abstract mixin class _$HealthProfileCopyWith<$Res>
    implements $HealthProfileCopyWith<$Res> {
  factory _$HealthProfileCopyWith(
          _HealthProfile value, $Res Function(_HealthProfile) _then) =
      __$HealthProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String> conditions,
      List<String> symptomFrequency,
      bool diagnosed,
      List<String> triggerFoods,
      String? customTriggers,
      List<String> medications,
      List<String> allergies});
}

/// @nodoc
class __$HealthProfileCopyWithImpl<$Res>
    implements _$HealthProfileCopyWith<$Res> {
  __$HealthProfileCopyWithImpl(this._self, this._then);

  final _HealthProfile _self;
  final $Res Function(_HealthProfile) _then;

  /// Create a copy of HealthProfile
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
    return _then(_HealthProfile(
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
