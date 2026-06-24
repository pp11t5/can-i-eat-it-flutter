// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalysisSectionDto {
  String get ment;
  String get content;

  /// Create a copy of AnalysisSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnalysisSectionDtoCopyWith<AnalysisSectionDto> get copyWith =>
      _$AnalysisSectionDtoCopyWithImpl<AnalysisSectionDto>(
          this as AnalysisSectionDto, _$identity);

  /// Serializes this AnalysisSectionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnalysisSectionDto &&
            (identical(other.ment, ment) || other.ment == ment) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ment, content);

  @override
  String toString() {
    return 'AnalysisSectionDto(ment: $ment, content: $content)';
  }
}

/// @nodoc
abstract mixin class $AnalysisSectionDtoCopyWith<$Res> {
  factory $AnalysisSectionDtoCopyWith(
          AnalysisSectionDto value, $Res Function(AnalysisSectionDto) _then) =
      _$AnalysisSectionDtoCopyWithImpl;
  @useResult
  $Res call({String ment, String content});
}

/// @nodoc
class _$AnalysisSectionDtoCopyWithImpl<$Res>
    implements $AnalysisSectionDtoCopyWith<$Res> {
  _$AnalysisSectionDtoCopyWithImpl(this._self, this._then);

  final AnalysisSectionDto _self;
  final $Res Function(AnalysisSectionDto) _then;

  /// Create a copy of AnalysisSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ment = null,
    Object? content = null,
  }) {
    return _then(_self.copyWith(
      ment: null == ment
          ? _self.ment
          : ment // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AnalysisSectionDto].
extension AnalysisSectionDtoPatterns on AnalysisSectionDto {
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
    TResult Function(_AnalysisSectionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AnalysisSectionDto() when $default != null:
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
    TResult Function(_AnalysisSectionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnalysisSectionDto():
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
    TResult? Function(_AnalysisSectionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnalysisSectionDto() when $default != null:
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
    TResult Function(String ment, String content)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AnalysisSectionDto() when $default != null:
        return $default(_that.ment, _that.content);
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
    TResult Function(String ment, String content) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnalysisSectionDto():
        return $default(_that.ment, _that.content);
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
    TResult? Function(String ment, String content)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnalysisSectionDto() when $default != null:
        return $default(_that.ment, _that.content);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AnalysisSectionDto implements AnalysisSectionDto {
  const _AnalysisSectionDto({required this.ment, required this.content});
  factory _AnalysisSectionDto.fromJson(Map<String, dynamic> json) =>
      _$AnalysisSectionDtoFromJson(json);

  @override
  final String ment;
  @override
  final String content;

  /// Create a copy of AnalysisSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnalysisSectionDtoCopyWith<_AnalysisSectionDto> get copyWith =>
      __$AnalysisSectionDtoCopyWithImpl<_AnalysisSectionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AnalysisSectionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnalysisSectionDto &&
            (identical(other.ment, ment) || other.ment == ment) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ment, content);

  @override
  String toString() {
    return 'AnalysisSectionDto(ment: $ment, content: $content)';
  }
}

/// @nodoc
abstract mixin class _$AnalysisSectionDtoCopyWith<$Res>
    implements $AnalysisSectionDtoCopyWith<$Res> {
  factory _$AnalysisSectionDtoCopyWith(
          _AnalysisSectionDto value, $Res Function(_AnalysisSectionDto) _then) =
      __$AnalysisSectionDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String ment, String content});
}

/// @nodoc
class __$AnalysisSectionDtoCopyWithImpl<$Res>
    implements _$AnalysisSectionDtoCopyWith<$Res> {
  __$AnalysisSectionDtoCopyWithImpl(this._self, this._then);

  final _AnalysisSectionDto _self;
  final $Res Function(_AnalysisSectionDto) _then;

  /// Create a copy of AnalysisSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ment = null,
    Object? content = null,
  }) {
    return _then(_AnalysisSectionDto(
      ment: null == ment
          ? _self.ment
          : ment // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$MealAnalysisDto {
  String get judgmentGrade;
  AnalysisSectionDto? get triggerAnalysis;
  AnalysisSectionDto? get allergyAnalysis;

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealAnalysisDtoCopyWith<MealAnalysisDto> get copyWith =>
      _$MealAnalysisDtoCopyWithImpl<MealAnalysisDto>(
          this as MealAnalysisDto, _$identity);

  /// Serializes this MealAnalysisDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealAnalysisDto &&
            (identical(other.judgmentGrade, judgmentGrade) ||
                other.judgmentGrade == judgmentGrade) &&
            (identical(other.triggerAnalysis, triggerAnalysis) ||
                other.triggerAnalysis == triggerAnalysis) &&
            (identical(other.allergyAnalysis, allergyAnalysis) ||
                other.allergyAnalysis == allergyAnalysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, judgmentGrade, triggerAnalysis, allergyAnalysis);

  @override
  String toString() {
    return 'MealAnalysisDto(judgmentGrade: $judgmentGrade, triggerAnalysis: $triggerAnalysis, allergyAnalysis: $allergyAnalysis)';
  }
}

/// @nodoc
abstract mixin class $MealAnalysisDtoCopyWith<$Res> {
  factory $MealAnalysisDtoCopyWith(
          MealAnalysisDto value, $Res Function(MealAnalysisDto) _then) =
      _$MealAnalysisDtoCopyWithImpl;
  @useResult
  $Res call(
      {String judgmentGrade,
      AnalysisSectionDto? triggerAnalysis,
      AnalysisSectionDto? allergyAnalysis});

  $AnalysisSectionDtoCopyWith<$Res>? get triggerAnalysis;
  $AnalysisSectionDtoCopyWith<$Res>? get allergyAnalysis;
}

/// @nodoc
class _$MealAnalysisDtoCopyWithImpl<$Res>
    implements $MealAnalysisDtoCopyWith<$Res> {
  _$MealAnalysisDtoCopyWithImpl(this._self, this._then);

  final MealAnalysisDto _self;
  final $Res Function(MealAnalysisDto) _then;

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? judgmentGrade = null,
    Object? triggerAnalysis = freezed,
    Object? allergyAnalysis = freezed,
  }) {
    return _then(_self.copyWith(
      judgmentGrade: null == judgmentGrade
          ? _self.judgmentGrade
          : judgmentGrade // ignore: cast_nullable_to_non_nullable
              as String,
      triggerAnalysis: freezed == triggerAnalysis
          ? _self.triggerAnalysis
          : triggerAnalysis // ignore: cast_nullable_to_non_nullable
              as AnalysisSectionDto?,
      allergyAnalysis: freezed == allergyAnalysis
          ? _self.allergyAnalysis
          : allergyAnalysis // ignore: cast_nullable_to_non_nullable
              as AnalysisSectionDto?,
    ));
  }

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionDtoCopyWith<$Res>? get triggerAnalysis {
    if (_self.triggerAnalysis == null) {
      return null;
    }

    return $AnalysisSectionDtoCopyWith<$Res>(_self.triggerAnalysis!, (value) {
      return _then(_self.copyWith(triggerAnalysis: value));
    });
  }

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionDtoCopyWith<$Res>? get allergyAnalysis {
    if (_self.allergyAnalysis == null) {
      return null;
    }

    return $AnalysisSectionDtoCopyWith<$Res>(_self.allergyAnalysis!, (value) {
      return _then(_self.copyWith(allergyAnalysis: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealAnalysisDto].
extension MealAnalysisDtoPatterns on MealAnalysisDto {
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
    TResult Function(_MealAnalysisDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealAnalysisDto() when $default != null:
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
    TResult Function(_MealAnalysisDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysisDto():
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
    TResult? Function(_MealAnalysisDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysisDto() when $default != null:
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
    TResult Function(String judgmentGrade, AnalysisSectionDto? triggerAnalysis,
            AnalysisSectionDto? allergyAnalysis)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealAnalysisDto() when $default != null:
        return $default(
            _that.judgmentGrade, _that.triggerAnalysis, _that.allergyAnalysis);
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
    TResult Function(String judgmentGrade, AnalysisSectionDto? triggerAnalysis,
            AnalysisSectionDto? allergyAnalysis)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysisDto():
        return $default(
            _that.judgmentGrade, _that.triggerAnalysis, _that.allergyAnalysis);
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
    TResult? Function(String judgmentGrade, AnalysisSectionDto? triggerAnalysis,
            AnalysisSectionDto? allergyAnalysis)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysisDto() when $default != null:
        return $default(
            _that.judgmentGrade, _that.triggerAnalysis, _that.allergyAnalysis);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealAnalysisDto implements MealAnalysisDto {
  const _MealAnalysisDto(
      {required this.judgmentGrade,
      this.triggerAnalysis,
      this.allergyAnalysis});
  factory _MealAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$MealAnalysisDtoFromJson(json);

  @override
  final String judgmentGrade;
  @override
  final AnalysisSectionDto? triggerAnalysis;
  @override
  final AnalysisSectionDto? allergyAnalysis;

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealAnalysisDtoCopyWith<_MealAnalysisDto> get copyWith =>
      __$MealAnalysisDtoCopyWithImpl<_MealAnalysisDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealAnalysisDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealAnalysisDto &&
            (identical(other.judgmentGrade, judgmentGrade) ||
                other.judgmentGrade == judgmentGrade) &&
            (identical(other.triggerAnalysis, triggerAnalysis) ||
                other.triggerAnalysis == triggerAnalysis) &&
            (identical(other.allergyAnalysis, allergyAnalysis) ||
                other.allergyAnalysis == allergyAnalysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, judgmentGrade, triggerAnalysis, allergyAnalysis);

  @override
  String toString() {
    return 'MealAnalysisDto(judgmentGrade: $judgmentGrade, triggerAnalysis: $triggerAnalysis, allergyAnalysis: $allergyAnalysis)';
  }
}

/// @nodoc
abstract mixin class _$MealAnalysisDtoCopyWith<$Res>
    implements $MealAnalysisDtoCopyWith<$Res> {
  factory _$MealAnalysisDtoCopyWith(
          _MealAnalysisDto value, $Res Function(_MealAnalysisDto) _then) =
      __$MealAnalysisDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String judgmentGrade,
      AnalysisSectionDto? triggerAnalysis,
      AnalysisSectionDto? allergyAnalysis});

  @override
  $AnalysisSectionDtoCopyWith<$Res>? get triggerAnalysis;
  @override
  $AnalysisSectionDtoCopyWith<$Res>? get allergyAnalysis;
}

/// @nodoc
class __$MealAnalysisDtoCopyWithImpl<$Res>
    implements _$MealAnalysisDtoCopyWith<$Res> {
  __$MealAnalysisDtoCopyWithImpl(this._self, this._then);

  final _MealAnalysisDto _self;
  final $Res Function(_MealAnalysisDto) _then;

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? judgmentGrade = null,
    Object? triggerAnalysis = freezed,
    Object? allergyAnalysis = freezed,
  }) {
    return _then(_MealAnalysisDto(
      judgmentGrade: null == judgmentGrade
          ? _self.judgmentGrade
          : judgmentGrade // ignore: cast_nullable_to_non_nullable
              as String,
      triggerAnalysis: freezed == triggerAnalysis
          ? _self.triggerAnalysis
          : triggerAnalysis // ignore: cast_nullable_to_non_nullable
              as AnalysisSectionDto?,
      allergyAnalysis: freezed == allergyAnalysis
          ? _self.allergyAnalysis
          : allergyAnalysis // ignore: cast_nullable_to_non_nullable
              as AnalysisSectionDto?,
    ));
  }

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionDtoCopyWith<$Res>? get triggerAnalysis {
    if (_self.triggerAnalysis == null) {
      return null;
    }

    return $AnalysisSectionDtoCopyWith<$Res>(_self.triggerAnalysis!, (value) {
      return _then(_self.copyWith(triggerAnalysis: value));
    });
  }

  /// Create a copy of MealAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionDtoCopyWith<$Res>? get allergyAnalysis {
    if (_self.allergyAnalysis == null) {
      return null;
    }

    return $AnalysisSectionDtoCopyWith<$Res>(_self.allergyAnalysis!, (value) {
      return _then(_self.copyWith(allergyAnalysis: value));
    });
  }
}

/// @nodoc
mixin _$StateRecordDto {
  String get stateRecordId;
  String get label;
  String get date;
  int get timingMinutes;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateRecordDtoCopyWith<StateRecordDto> get copyWith =>
      _$StateRecordDtoCopyWithImpl<StateRecordDto>(
          this as StateRecordDto, _$identity);

  /// Serializes this StateRecordDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateRecordDto &&
            (identical(other.stateRecordId, stateRecordId) ||
                other.stateRecordId == stateRecordId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timingMinutes, timingMinutes) ||
                other.timingMinutes == timingMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stateRecordId, label, date, timingMinutes);

  @override
  String toString() {
    return 'StateRecordDto(stateRecordId: $stateRecordId, label: $label, date: $date, timingMinutes: $timingMinutes)';
  }
}

/// @nodoc
abstract mixin class $StateRecordDtoCopyWith<$Res> {
  factory $StateRecordDtoCopyWith(
          StateRecordDto value, $Res Function(StateRecordDto) _then) =
      _$StateRecordDtoCopyWithImpl;
  @useResult
  $Res call(
      {String stateRecordId, String label, String date, int timingMinutes});
}

/// @nodoc
class _$StateRecordDtoCopyWithImpl<$Res>
    implements $StateRecordDtoCopyWith<$Res> {
  _$StateRecordDtoCopyWithImpl(this._self, this._then);

  final StateRecordDto _self;
  final $Res Function(StateRecordDto) _then;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stateRecordId = null,
    Object? label = null,
    Object? date = null,
    Object? timingMinutes = null,
  }) {
    return _then(_self.copyWith(
      stateRecordId: null == stateRecordId
          ? _self.stateRecordId
          : stateRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timingMinutes: null == timingMinutes
          ? _self.timingMinutes
          : timingMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [StateRecordDto].
extension StateRecordDtoPatterns on StateRecordDto {
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
    TResult Function(_StateRecordDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
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
    TResult Function(_StateRecordDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto():
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
    TResult? Function(_StateRecordDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
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
            String stateRecordId, String label, String date, int timingMinutes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
        return $default(
            _that.stateRecordId, _that.label, _that.date, _that.timingMinutes);
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
            String stateRecordId, String label, String date, int timingMinutes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto():
        return $default(
            _that.stateRecordId, _that.label, _that.date, _that.timingMinutes);
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
            String stateRecordId, String label, String date, int timingMinutes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
        return $default(
            _that.stateRecordId, _that.label, _that.date, _that.timingMinutes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StateRecordDto implements StateRecordDto {
  const _StateRecordDto(
      {required this.stateRecordId,
      required this.label,
      required this.date,
      required this.timingMinutes});
  factory _StateRecordDto.fromJson(Map<String, dynamic> json) =>
      _$StateRecordDtoFromJson(json);

  @override
  final String stateRecordId;
  @override
  final String label;
  @override
  final String date;
  @override
  final int timingMinutes;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StateRecordDtoCopyWith<_StateRecordDto> get copyWith =>
      __$StateRecordDtoCopyWithImpl<_StateRecordDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StateRecordDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StateRecordDto &&
            (identical(other.stateRecordId, stateRecordId) ||
                other.stateRecordId == stateRecordId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timingMinutes, timingMinutes) ||
                other.timingMinutes == timingMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stateRecordId, label, date, timingMinutes);

  @override
  String toString() {
    return 'StateRecordDto(stateRecordId: $stateRecordId, label: $label, date: $date, timingMinutes: $timingMinutes)';
  }
}

/// @nodoc
abstract mixin class _$StateRecordDtoCopyWith<$Res>
    implements $StateRecordDtoCopyWith<$Res> {
  factory _$StateRecordDtoCopyWith(
          _StateRecordDto value, $Res Function(_StateRecordDto) _then) =
      __$StateRecordDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String stateRecordId, String label, String date, int timingMinutes});
}

/// @nodoc
class __$StateRecordDtoCopyWithImpl<$Res>
    implements _$StateRecordDtoCopyWith<$Res> {
  __$StateRecordDtoCopyWithImpl(this._self, this._then);

  final _StateRecordDto _self;
  final $Res Function(_StateRecordDto) _then;

  /// Create a copy of StateRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stateRecordId = null,
    Object? label = null,
    Object? date = null,
    Object? timingMinutes = null,
  }) {
    return _then(_StateRecordDto(
      stateRecordId: null == stateRecordId
          ? _self.stateRecordId
          : stateRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timingMinutes: null == timingMinutes
          ? _self.timingMinutes
          : timingMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$MealFoodNestedDto {
  String? get mealRecordExternalId;
  String get name;
  String? get category;

  /// Create a copy of MealFoodNestedDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealFoodNestedDtoCopyWith<MealFoodNestedDto> get copyWith =>
      _$MealFoodNestedDtoCopyWithImpl<MealFoodNestedDto>(
          this as MealFoodNestedDto, _$identity);

  /// Serializes this MealFoodNestedDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealFoodNestedDto &&
            (identical(other.mealRecordExternalId, mealRecordExternalId) ||
                other.mealRecordExternalId == mealRecordExternalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mealRecordExternalId, name, category);

  @override
  String toString() {
    return 'MealFoodNestedDto(mealRecordExternalId: $mealRecordExternalId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class $MealFoodNestedDtoCopyWith<$Res> {
  factory $MealFoodNestedDtoCopyWith(
          MealFoodNestedDto value, $Res Function(MealFoodNestedDto) _then) =
      _$MealFoodNestedDtoCopyWithImpl;
  @useResult
  $Res call({String? mealRecordExternalId, String name, String? category});
}

/// @nodoc
class _$MealFoodNestedDtoCopyWithImpl<$Res>
    implements $MealFoodNestedDtoCopyWith<$Res> {
  _$MealFoodNestedDtoCopyWithImpl(this._self, this._then);

  final MealFoodNestedDto _self;
  final $Res Function(MealFoodNestedDto) _then;

  /// Create a copy of MealFoodNestedDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordExternalId = freezed,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_self.copyWith(
      mealRecordExternalId: freezed == mealRecordExternalId
          ? _self.mealRecordExternalId
          : mealRecordExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealFoodNestedDto].
extension MealFoodNestedDtoPatterns on MealFoodNestedDto {
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
    TResult Function(_MealFoodNestedDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFoodNestedDto() when $default != null:
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
    TResult Function(_MealFoodNestedDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodNestedDto():
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
    TResult? Function(_MealFoodNestedDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodNestedDto() when $default != null:
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
            String? mealRecordExternalId, String name, String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFoodNestedDto() when $default != null:
        return $default(_that.mealRecordExternalId, _that.name, _that.category);
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
            String? mealRecordExternalId, String name, String? category)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodNestedDto():
        return $default(_that.mealRecordExternalId, _that.name, _that.category);
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
            String? mealRecordExternalId, String name, String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodNestedDto() when $default != null:
        return $default(_that.mealRecordExternalId, _that.name, _that.category);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealFoodNestedDto implements MealFoodNestedDto {
  const _MealFoodNestedDto(
      {this.mealRecordExternalId, required this.name, this.category});
  factory _MealFoodNestedDto.fromJson(Map<String, dynamic> json) =>
      _$MealFoodNestedDtoFromJson(json);

  @override
  final String? mealRecordExternalId;
  @override
  final String name;
  @override
  final String? category;

  /// Create a copy of MealFoodNestedDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealFoodNestedDtoCopyWith<_MealFoodNestedDto> get copyWith =>
      __$MealFoodNestedDtoCopyWithImpl<_MealFoodNestedDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealFoodNestedDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealFoodNestedDto &&
            (identical(other.mealRecordExternalId, mealRecordExternalId) ||
                other.mealRecordExternalId == mealRecordExternalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mealRecordExternalId, name, category);

  @override
  String toString() {
    return 'MealFoodNestedDto(mealRecordExternalId: $mealRecordExternalId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$MealFoodNestedDtoCopyWith<$Res>
    implements $MealFoodNestedDtoCopyWith<$Res> {
  factory _$MealFoodNestedDtoCopyWith(
          _MealFoodNestedDto value, $Res Function(_MealFoodNestedDto) _then) =
      __$MealFoodNestedDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String? mealRecordExternalId, String name, String? category});
}

/// @nodoc
class __$MealFoodNestedDtoCopyWithImpl<$Res>
    implements _$MealFoodNestedDtoCopyWith<$Res> {
  __$MealFoodNestedDtoCopyWithImpl(this._self, this._then);

  final _MealFoodNestedDto _self;
  final $Res Function(_MealFoodNestedDto) _then;

  /// Create a copy of MealFoodNestedDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordExternalId = freezed,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_MealFoodNestedDto(
      mealRecordExternalId: freezed == mealRecordExternalId
          ? _self.mealRecordExternalId
          : mealRecordExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$MealFoodRecordDetailDto {
  String get mealFoodId;
  String get eatenAt;
  MealFoodNestedDto get food;
  MealAnalysisDto? get analysis;
  StateRecordDto? get stateRecord;

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealFoodRecordDetailDtoCopyWith<MealFoodRecordDetailDto> get copyWith =>
      _$MealFoodRecordDetailDtoCopyWithImpl<MealFoodRecordDetailDto>(
          this as MealFoodRecordDetailDto, _$identity);

  /// Serializes this MealFoodRecordDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealFoodRecordDetailDto &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.stateRecord, stateRecord) ||
                other.stateRecord == stateRecord));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealFoodId, eatenAt, food, analysis, stateRecord);

  @override
  String toString() {
    return 'MealFoodRecordDetailDto(mealFoodId: $mealFoodId, eatenAt: $eatenAt, food: $food, analysis: $analysis, stateRecord: $stateRecord)';
  }
}

/// @nodoc
abstract mixin class $MealFoodRecordDetailDtoCopyWith<$Res> {
  factory $MealFoodRecordDetailDtoCopyWith(MealFoodRecordDetailDto value,
          $Res Function(MealFoodRecordDetailDto) _then) =
      _$MealFoodRecordDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String mealFoodId,
      String eatenAt,
      MealFoodNestedDto food,
      MealAnalysisDto? analysis,
      StateRecordDto? stateRecord});

  $MealFoodNestedDtoCopyWith<$Res> get food;
  $MealAnalysisDtoCopyWith<$Res>? get analysis;
  $StateRecordDtoCopyWith<$Res>? get stateRecord;
}

/// @nodoc
class _$MealFoodRecordDetailDtoCopyWithImpl<$Res>
    implements $MealFoodRecordDetailDtoCopyWith<$Res> {
  _$MealFoodRecordDetailDtoCopyWithImpl(this._self, this._then);

  final MealFoodRecordDetailDto _self;
  final $Res Function(MealFoodRecordDetailDto) _then;

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealFoodId = null,
    Object? eatenAt = null,
    Object? food = null,
    Object? analysis = freezed,
    Object? stateRecord = freezed,
  }) {
    return _then(_self.copyWith(
      mealFoodId: null == mealFoodId
          ? _self.mealFoodId
          : mealFoodId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as MealFoodNestedDto,
      analysis: freezed == analysis
          ? _self.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as MealAnalysisDto?,
      stateRecord: freezed == stateRecord
          ? _self.stateRecord
          : stateRecord // ignore: cast_nullable_to_non_nullable
              as StateRecordDto?,
    ));
  }

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodNestedDtoCopyWith<$Res> get food {
    return $MealFoodNestedDtoCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealAnalysisDtoCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
      return null;
    }

    return $MealAnalysisDtoCopyWith<$Res>(_self.analysis!, (value) {
      return _then(_self.copyWith(analysis: value));
    });
  }

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateRecordDtoCopyWith<$Res>? get stateRecord {
    if (_self.stateRecord == null) {
      return null;
    }

    return $StateRecordDtoCopyWith<$Res>(_self.stateRecord!, (value) {
      return _then(_self.copyWith(stateRecord: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealFoodRecordDetailDto].
extension MealFoodRecordDetailDtoPatterns on MealFoodRecordDetailDto {
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
    TResult Function(_MealFoodRecordDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFoodRecordDetailDto() when $default != null:
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
    TResult Function(_MealFoodRecordDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodRecordDetailDto():
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
    TResult? Function(_MealFoodRecordDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodRecordDetailDto() when $default != null:
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
    TResult Function(String mealFoodId, String eatenAt, MealFoodNestedDto food,
            MealAnalysisDto? analysis, StateRecordDto? stateRecord)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFoodRecordDetailDto() when $default != null:
        return $default(_that.mealFoodId, _that.eatenAt, _that.food,
            _that.analysis, _that.stateRecord);
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
    TResult Function(String mealFoodId, String eatenAt, MealFoodNestedDto food,
            MealAnalysisDto? analysis, StateRecordDto? stateRecord)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodRecordDetailDto():
        return $default(_that.mealFoodId, _that.eatenAt, _that.food,
            _that.analysis, _that.stateRecord);
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
    TResult? Function(String mealFoodId, String eatenAt, MealFoodNestedDto food,
            MealAnalysisDto? analysis, StateRecordDto? stateRecord)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFoodRecordDetailDto() when $default != null:
        return $default(_that.mealFoodId, _that.eatenAt, _that.food,
            _that.analysis, _that.stateRecord);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealFoodRecordDetailDto implements MealFoodRecordDetailDto {
  const _MealFoodRecordDetailDto(
      {required this.mealFoodId,
      required this.eatenAt,
      required this.food,
      this.analysis,
      this.stateRecord});
  factory _MealFoodRecordDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealFoodRecordDetailDtoFromJson(json);

  @override
  final String mealFoodId;
  @override
  final String eatenAt;
  @override
  final MealFoodNestedDto food;
  @override
  final MealAnalysisDto? analysis;
  @override
  final StateRecordDto? stateRecord;

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealFoodRecordDetailDtoCopyWith<_MealFoodRecordDetailDto> get copyWith =>
      __$MealFoodRecordDetailDtoCopyWithImpl<_MealFoodRecordDetailDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealFoodRecordDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealFoodRecordDetailDto &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.food, food) || other.food == food) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.stateRecord, stateRecord) ||
                other.stateRecord == stateRecord));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealFoodId, eatenAt, food, analysis, stateRecord);

  @override
  String toString() {
    return 'MealFoodRecordDetailDto(mealFoodId: $mealFoodId, eatenAt: $eatenAt, food: $food, analysis: $analysis, stateRecord: $stateRecord)';
  }
}

/// @nodoc
abstract mixin class _$MealFoodRecordDetailDtoCopyWith<$Res>
    implements $MealFoodRecordDetailDtoCopyWith<$Res> {
  factory _$MealFoodRecordDetailDtoCopyWith(_MealFoodRecordDetailDto value,
          $Res Function(_MealFoodRecordDetailDto) _then) =
      __$MealFoodRecordDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealFoodId,
      String eatenAt,
      MealFoodNestedDto food,
      MealAnalysisDto? analysis,
      StateRecordDto? stateRecord});

  @override
  $MealFoodNestedDtoCopyWith<$Res> get food;
  @override
  $MealAnalysisDtoCopyWith<$Res>? get analysis;
  @override
  $StateRecordDtoCopyWith<$Res>? get stateRecord;
}

/// @nodoc
class __$MealFoodRecordDetailDtoCopyWithImpl<$Res>
    implements _$MealFoodRecordDetailDtoCopyWith<$Res> {
  __$MealFoodRecordDetailDtoCopyWithImpl(this._self, this._then);

  final _MealFoodRecordDetailDto _self;
  final $Res Function(_MealFoodRecordDetailDto) _then;

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealFoodId = null,
    Object? eatenAt = null,
    Object? food = null,
    Object? analysis = freezed,
    Object? stateRecord = freezed,
  }) {
    return _then(_MealFoodRecordDetailDto(
      mealFoodId: null == mealFoodId
          ? _self.mealFoodId
          : mealFoodId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      food: null == food
          ? _self.food
          : food // ignore: cast_nullable_to_non_nullable
              as MealFoodNestedDto,
      analysis: freezed == analysis
          ? _self.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as MealAnalysisDto?,
      stateRecord: freezed == stateRecord
          ? _self.stateRecord
          : stateRecord // ignore: cast_nullable_to_non_nullable
              as StateRecordDto?,
    ));
  }

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodNestedDtoCopyWith<$Res> get food {
    return $MealFoodNestedDtoCopyWith<$Res>(_self.food, (value) {
      return _then(_self.copyWith(food: value));
    });
  }

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealAnalysisDtoCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
      return null;
    }

    return $MealAnalysisDtoCopyWith<$Res>(_self.analysis!, (value) {
      return _then(_self.copyWith(analysis: value));
    });
  }

  /// Create a copy of MealFoodRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateRecordDtoCopyWith<$Res>? get stateRecord {
    if (_self.stateRecord == null) {
      return null;
    }

    return $StateRecordDtoCopyWith<$Res>(_self.stateRecord!, (value) {
      return _then(_self.copyWith(stateRecord: value));
    });
  }
}

/// @nodoc
mixin _$MealDetailFoodDto {
  String get mealFoodId;
  String get name;
  String? get category;
  String get eatenAt;

  /// Create a copy of MealDetailFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealDetailFoodDtoCopyWith<MealDetailFoodDto> get copyWith =>
      _$MealDetailFoodDtoCopyWithImpl<MealDetailFoodDto>(
          this as MealDetailFoodDto, _$identity);

  /// Serializes this MealDetailFoodDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealDetailFoodDto &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mealFoodId, name, category, eatenAt);

  @override
  String toString() {
    return 'MealDetailFoodDto(mealFoodId: $mealFoodId, name: $name, category: $category, eatenAt: $eatenAt)';
  }
}

/// @nodoc
abstract mixin class $MealDetailFoodDtoCopyWith<$Res> {
  factory $MealDetailFoodDtoCopyWith(
          MealDetailFoodDto value, $Res Function(MealDetailFoodDto) _then) =
      _$MealDetailFoodDtoCopyWithImpl;
  @useResult
  $Res call({String mealFoodId, String name, String? category, String eatenAt});
}

/// @nodoc
class _$MealDetailFoodDtoCopyWithImpl<$Res>
    implements $MealDetailFoodDtoCopyWith<$Res> {
  _$MealDetailFoodDtoCopyWithImpl(this._self, this._then);

  final MealDetailFoodDto _self;
  final $Res Function(MealDetailFoodDto) _then;

  /// Create a copy of MealDetailFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
    Object? eatenAt = null,
  }) {
    return _then(_self.copyWith(
      mealFoodId: null == mealFoodId
          ? _self.mealFoodId
          : mealFoodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealDetailFoodDto].
extension MealDetailFoodDtoPatterns on MealDetailFoodDto {
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
    TResult Function(_MealDetailFoodDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealDetailFoodDto() when $default != null:
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
    TResult Function(_MealDetailFoodDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetailFoodDto():
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
    TResult? Function(_MealDetailFoodDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetailFoodDto() when $default != null:
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
            String mealFoodId, String name, String? category, String eatenAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealDetailFoodDto() when $default != null:
        return $default(
            _that.mealFoodId, _that.name, _that.category, _that.eatenAt);
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
            String mealFoodId, String name, String? category, String eatenAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetailFoodDto():
        return $default(
            _that.mealFoodId, _that.name, _that.category, _that.eatenAt);
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
            String mealFoodId, String name, String? category, String eatenAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealDetailFoodDto() when $default != null:
        return $default(
            _that.mealFoodId, _that.name, _that.category, _that.eatenAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealDetailFoodDto implements MealDetailFoodDto {
  const _MealDetailFoodDto(
      {required this.mealFoodId,
      required this.name,
      this.category,
      required this.eatenAt});
  factory _MealDetailFoodDto.fromJson(Map<String, dynamic> json) =>
      _$MealDetailFoodDtoFromJson(json);

  @override
  final String mealFoodId;
  @override
  final String name;
  @override
  final String? category;
  @override
  final String eatenAt;

  /// Create a copy of MealDetailFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealDetailFoodDtoCopyWith<_MealDetailFoodDto> get copyWith =>
      __$MealDetailFoodDtoCopyWithImpl<_MealDetailFoodDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealDetailFoodDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealDetailFoodDto &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mealFoodId, name, category, eatenAt);

  @override
  String toString() {
    return 'MealDetailFoodDto(mealFoodId: $mealFoodId, name: $name, category: $category, eatenAt: $eatenAt)';
  }
}

/// @nodoc
abstract mixin class _$MealDetailFoodDtoCopyWith<$Res>
    implements $MealDetailFoodDtoCopyWith<$Res> {
  factory _$MealDetailFoodDtoCopyWith(
          _MealDetailFoodDto value, $Res Function(_MealDetailFoodDto) _then) =
      __$MealDetailFoodDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String mealFoodId, String name, String? category, String eatenAt});
}

/// @nodoc
class __$MealDetailFoodDtoCopyWithImpl<$Res>
    implements _$MealDetailFoodDtoCopyWith<$Res> {
  __$MealDetailFoodDtoCopyWithImpl(this._self, this._then);

  final _MealDetailFoodDto _self;
  final $Res Function(_MealDetailFoodDto) _then;

  /// Create a copy of MealDetailFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
    Object? eatenAt = null,
  }) {
    return _then(_MealDetailFoodDto(
      mealFoodId: null == mealFoodId
          ? _self.mealFoodId
          : mealFoodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$MealRecordDetailDto {
  String get mealRecordId;
  String get eatenAt;
  List<MealDetailFoodDto>
      get meals; // stateRecords?: 명시 null까지 방어하기 위해 nullable + toEntity에서 ?? []
  List<StateRecordDto>? get stateRecords;

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealRecordDetailDtoCopyWith<MealRecordDetailDto> get copyWith =>
      _$MealRecordDetailDtoCopyWithImpl<MealRecordDetailDto>(
          this as MealRecordDetailDto, _$identity);

  /// Serializes this MealRecordDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealRecordDetailDto &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other.meals, meals) &&
            const DeepCollectionEquality()
                .equals(other.stateRecords, stateRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      eatenAt,
      const DeepCollectionEquality().hash(meals),
      const DeepCollectionEquality().hash(stateRecords));

  @override
  String toString() {
    return 'MealRecordDetailDto(mealRecordId: $mealRecordId, eatenAt: $eatenAt, meals: $meals, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class $MealRecordDetailDtoCopyWith<$Res> {
  factory $MealRecordDetailDtoCopyWith(
          MealRecordDetailDto value, $Res Function(MealRecordDetailDto) _then) =
      _$MealRecordDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String mealRecordId,
      String eatenAt,
      List<MealDetailFoodDto> meals,
      List<StateRecordDto>? stateRecords});
}

/// @nodoc
class _$MealRecordDetailDtoCopyWithImpl<$Res>
    implements $MealRecordDetailDtoCopyWith<$Res> {
  _$MealRecordDetailDtoCopyWithImpl(this._self, this._then);

  final MealRecordDetailDto _self;
  final $Res Function(MealRecordDetailDto) _then;

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordId = null,
    Object? eatenAt = null,
    Object? meals = null,
    Object? stateRecords = freezed,
  }) {
    return _then(_self.copyWith(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      meals: null == meals
          ? _self.meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealDetailFoodDto>,
      stateRecords: freezed == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecordDto>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealRecordDetailDto].
extension MealRecordDetailDtoPatterns on MealRecordDetailDto {
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
    TResult Function(_MealRecordDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
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
    TResult Function(_MealRecordDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto():
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
    TResult? Function(_MealRecordDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
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
    TResult Function(String mealRecordId, String eatenAt,
            List<MealDetailFoodDto> meals, List<StateRecordDto>? stateRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
        return $default(
            _that.mealRecordId, _that.eatenAt, _that.meals, _that.stateRecords);
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
    TResult Function(String mealRecordId, String eatenAt,
            List<MealDetailFoodDto> meals, List<StateRecordDto>? stateRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto():
        return $default(
            _that.mealRecordId, _that.eatenAt, _that.meals, _that.stateRecords);
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
    TResult? Function(String mealRecordId, String eatenAt,
            List<MealDetailFoodDto> meals, List<StateRecordDto>? stateRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecordDetailDto() when $default != null:
        return $default(
            _that.mealRecordId, _that.eatenAt, _that.meals, _that.stateRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealRecordDetailDto implements MealRecordDetailDto {
  const _MealRecordDetailDto(
      {required this.mealRecordId,
      required this.eatenAt,
      final List<MealDetailFoodDto> meals = const <MealDetailFoodDto>[],
      final List<StateRecordDto>? stateRecords})
      : _meals = meals,
        _stateRecords = stateRecords;
  factory _MealRecordDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealRecordDetailDtoFromJson(json);

  @override
  final String mealRecordId;
  @override
  final String eatenAt;
  final List<MealDetailFoodDto> _meals;
  @override
  @JsonKey()
  List<MealDetailFoodDto> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

// stateRecords?: 명시 null까지 방어하기 위해 nullable + toEntity에서 ?? []
  final List<StateRecordDto>? _stateRecords;
// stateRecords?: 명시 null까지 방어하기 위해 nullable + toEntity에서 ?? []
  @override
  List<StateRecordDto>? get stateRecords {
    final value = _stateRecords;
    if (value == null) return null;
    if (_stateRecords is EqualUnmodifiableListView) return _stateRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealRecordDetailDtoCopyWith<_MealRecordDetailDto> get copyWith =>
      __$MealRecordDetailDtoCopyWithImpl<_MealRecordDetailDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealRecordDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealRecordDetailDto &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            const DeepCollectionEquality()
                .equals(other._stateRecords, _stateRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      eatenAt,
      const DeepCollectionEquality().hash(_meals),
      const DeepCollectionEquality().hash(_stateRecords));

  @override
  String toString() {
    return 'MealRecordDetailDto(mealRecordId: $mealRecordId, eatenAt: $eatenAt, meals: $meals, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class _$MealRecordDetailDtoCopyWith<$Res>
    implements $MealRecordDetailDtoCopyWith<$Res> {
  factory _$MealRecordDetailDtoCopyWith(_MealRecordDetailDto value,
          $Res Function(_MealRecordDetailDto) _then) =
      __$MealRecordDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealRecordId,
      String eatenAt,
      List<MealDetailFoodDto> meals,
      List<StateRecordDto>? stateRecords});
}

/// @nodoc
class __$MealRecordDetailDtoCopyWithImpl<$Res>
    implements _$MealRecordDetailDtoCopyWith<$Res> {
  __$MealRecordDetailDtoCopyWithImpl(this._self, this._then);

  final _MealRecordDetailDto _self;
  final $Res Function(_MealRecordDetailDto) _then;

  /// Create a copy of MealRecordDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? eatenAt = null,
    Object? meals = null,
    Object? stateRecords = freezed,
  }) {
    return _then(_MealRecordDetailDto(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      meals: null == meals
          ? _self._meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealDetailFoodDto>,
      stateRecords: freezed == stateRecords
          ? _self._stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecordDto>?,
    ));
  }
}

/// @nodoc
mixin _$WeeklyDayDto {
  String get date;
  String get dayOfWeek; // 서버 키 'judgementList'와 필드명 동일 → JsonKey 불필요.
  List<String> get judgementList;

  /// Create a copy of WeeklyDayDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklyDayDtoCopyWith<WeeklyDayDto> get copyWith =>
      _$WeeklyDayDtoCopyWithImpl<WeeklyDayDto>(
          this as WeeklyDayDto, _$identity);

  /// Serializes this WeeklyDayDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklyDayDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            const DeepCollectionEquality()
                .equals(other.judgementList, judgementList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, dayOfWeek,
      const DeepCollectionEquality().hash(judgementList));

  @override
  String toString() {
    return 'WeeklyDayDto(date: $date, dayOfWeek: $dayOfWeek, judgementList: $judgementList)';
  }
}

/// @nodoc
abstract mixin class $WeeklyDayDtoCopyWith<$Res> {
  factory $WeeklyDayDtoCopyWith(
          WeeklyDayDto value, $Res Function(WeeklyDayDto) _then) =
      _$WeeklyDayDtoCopyWithImpl;
  @useResult
  $Res call({String date, String dayOfWeek, List<String> judgementList});
}

/// @nodoc
class _$WeeklyDayDtoCopyWithImpl<$Res> implements $WeeklyDayDtoCopyWith<$Res> {
  _$WeeklyDayDtoCopyWithImpl(this._self, this._then);

  final WeeklyDayDto _self;
  final $Res Function(WeeklyDayDto) _then;

  /// Create a copy of WeeklyDayDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dayOfWeek = null,
    Object? judgementList = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _self.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as String,
      judgementList: null == judgementList
          ? _self.judgementList
          : judgementList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WeeklyDayDto].
extension WeeklyDayDtoPatterns on WeeklyDayDto {
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
    TResult Function(_WeeklyDayDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyDayDto() when $default != null:
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
    TResult Function(_WeeklyDayDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyDayDto():
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
    TResult? Function(_WeeklyDayDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyDayDto() when $default != null:
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
    TResult Function(String date, String dayOfWeek, List<String> judgementList)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyDayDto() when $default != null:
        return $default(_that.date, _that.dayOfWeek, _that.judgementList);
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
    TResult Function(String date, String dayOfWeek, List<String> judgementList)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyDayDto():
        return $default(_that.date, _that.dayOfWeek, _that.judgementList);
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
            String date, String dayOfWeek, List<String> judgementList)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyDayDto() when $default != null:
        return $default(_that.date, _that.dayOfWeek, _that.judgementList);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WeeklyDayDto implements WeeklyDayDto {
  const _WeeklyDayDto(
      {required this.date,
      required this.dayOfWeek,
      final List<String> judgementList = const <String>[]})
      : _judgementList = judgementList;
  factory _WeeklyDayDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyDayDtoFromJson(json);

  @override
  final String date;
  @override
  final String dayOfWeek;
// 서버 키 'judgementList'와 필드명 동일 → JsonKey 불필요.
  final List<String> _judgementList;
// 서버 키 'judgementList'와 필드명 동일 → JsonKey 불필요.
  @override
  @JsonKey()
  List<String> get judgementList {
    if (_judgementList is EqualUnmodifiableListView) return _judgementList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_judgementList);
  }

  /// Create a copy of WeeklyDayDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklyDayDtoCopyWith<_WeeklyDayDto> get copyWith =>
      __$WeeklyDayDtoCopyWithImpl<_WeeklyDayDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeeklyDayDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklyDayDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            const DeepCollectionEquality()
                .equals(other._judgementList, _judgementList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, dayOfWeek,
      const DeepCollectionEquality().hash(_judgementList));

  @override
  String toString() {
    return 'WeeklyDayDto(date: $date, dayOfWeek: $dayOfWeek, judgementList: $judgementList)';
  }
}

/// @nodoc
abstract mixin class _$WeeklyDayDtoCopyWith<$Res>
    implements $WeeklyDayDtoCopyWith<$Res> {
  factory _$WeeklyDayDtoCopyWith(
          _WeeklyDayDto value, $Res Function(_WeeklyDayDto) _then) =
      __$WeeklyDayDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String date, String dayOfWeek, List<String> judgementList});
}

/// @nodoc
class __$WeeklyDayDtoCopyWithImpl<$Res>
    implements _$WeeklyDayDtoCopyWith<$Res> {
  __$WeeklyDayDtoCopyWithImpl(this._self, this._then);

  final _WeeklyDayDto _self;
  final $Res Function(_WeeklyDayDto) _then;

  /// Create a copy of WeeklyDayDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? dayOfWeek = null,
    Object? judgementList = null,
  }) {
    return _then(_WeeklyDayDto(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _self.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as String,
      judgementList: null == judgementList
          ? _self._judgementList
          : judgementList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$MealCandidateDto {
  String get mealRecordId;
  MealFoodNestedDto get representativeFood;
  int get otherFoodCount;
  String get eatenAt;

  /// Create a copy of MealCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCandidateDtoCopyWith<MealCandidateDto> get copyWith =>
      _$MealCandidateDtoCopyWithImpl<MealCandidateDto>(
          this as MealCandidateDto, _$identity);

  /// Serializes this MealCandidateDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealCandidateDto &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.representativeFood, representativeFood) ||
                other.representativeFood == representativeFood) &&
            (identical(other.otherFoodCount, otherFoodCount) ||
                other.otherFoodCount == otherFoodCount) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordId, representativeFood, otherFoodCount, eatenAt);

  @override
  String toString() {
    return 'MealCandidateDto(mealRecordId: $mealRecordId, representativeFood: $representativeFood, otherFoodCount: $otherFoodCount, eatenAt: $eatenAt)';
  }
}

/// @nodoc
abstract mixin class $MealCandidateDtoCopyWith<$Res> {
  factory $MealCandidateDtoCopyWith(
          MealCandidateDto value, $Res Function(MealCandidateDto) _then) =
      _$MealCandidateDtoCopyWithImpl;
  @useResult
  $Res call(
      {String mealRecordId,
      MealFoodNestedDto representativeFood,
      int otherFoodCount,
      String eatenAt});

  $MealFoodNestedDtoCopyWith<$Res> get representativeFood;
}

/// @nodoc
class _$MealCandidateDtoCopyWithImpl<$Res>
    implements $MealCandidateDtoCopyWith<$Res> {
  _$MealCandidateDtoCopyWithImpl(this._self, this._then);

  final MealCandidateDto _self;
  final $Res Function(MealCandidateDto) _then;

  /// Create a copy of MealCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordId = null,
    Object? representativeFood = null,
    Object? otherFoodCount = null,
    Object? eatenAt = null,
  }) {
    return _then(_self.copyWith(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFood: null == representativeFood
          ? _self.representativeFood
          : representativeFood // ignore: cast_nullable_to_non_nullable
              as MealFoodNestedDto,
      otherFoodCount: null == otherFoodCount
          ? _self.otherFoodCount
          : otherFoodCount // ignore: cast_nullable_to_non_nullable
              as int,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of MealCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodNestedDtoCopyWith<$Res> get representativeFood {
    return $MealFoodNestedDtoCopyWith<$Res>(_self.representativeFood, (value) {
      return _then(_self.copyWith(representativeFood: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealCandidateDto].
extension MealCandidateDtoPatterns on MealCandidateDto {
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
    TResult Function(_MealCandidateDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidateDto() when $default != null:
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
    TResult Function(_MealCandidateDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidateDto():
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
    TResult? Function(_MealCandidateDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidateDto() when $default != null:
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
    TResult Function(String mealRecordId, MealFoodNestedDto representativeFood,
            int otherFoodCount, String eatenAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidateDto() when $default != null:
        return $default(_that.mealRecordId, _that.representativeFood,
            _that.otherFoodCount, _that.eatenAt);
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
    TResult Function(String mealRecordId, MealFoodNestedDto representativeFood,
            int otherFoodCount, String eatenAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidateDto():
        return $default(_that.mealRecordId, _that.representativeFood,
            _that.otherFoodCount, _that.eatenAt);
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
    TResult? Function(String mealRecordId, MealFoodNestedDto representativeFood,
            int otherFoodCount, String eatenAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidateDto() when $default != null:
        return $default(_that.mealRecordId, _that.representativeFood,
            _that.otherFoodCount, _that.eatenAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealCandidateDto implements MealCandidateDto {
  const _MealCandidateDto(
      {required this.mealRecordId,
      required this.representativeFood,
      this.otherFoodCount = 0,
      required this.eatenAt});
  factory _MealCandidateDto.fromJson(Map<String, dynamic> json) =>
      _$MealCandidateDtoFromJson(json);

  @override
  final String mealRecordId;
  @override
  final MealFoodNestedDto representativeFood;
  @override
  @JsonKey()
  final int otherFoodCount;
  @override
  final String eatenAt;

  /// Create a copy of MealCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCandidateDtoCopyWith<_MealCandidateDto> get copyWith =>
      __$MealCandidateDtoCopyWithImpl<_MealCandidateDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealCandidateDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealCandidateDto &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.representativeFood, representativeFood) ||
                other.representativeFood == representativeFood) &&
            (identical(other.otherFoodCount, otherFoodCount) ||
                other.otherFoodCount == otherFoodCount) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordId, representativeFood, otherFoodCount, eatenAt);

  @override
  String toString() {
    return 'MealCandidateDto(mealRecordId: $mealRecordId, representativeFood: $representativeFood, otherFoodCount: $otherFoodCount, eatenAt: $eatenAt)';
  }
}

/// @nodoc
abstract mixin class _$MealCandidateDtoCopyWith<$Res>
    implements $MealCandidateDtoCopyWith<$Res> {
  factory _$MealCandidateDtoCopyWith(
          _MealCandidateDto value, $Res Function(_MealCandidateDto) _then) =
      __$MealCandidateDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealRecordId,
      MealFoodNestedDto representativeFood,
      int otherFoodCount,
      String eatenAt});

  @override
  $MealFoodNestedDtoCopyWith<$Res> get representativeFood;
}

/// @nodoc
class __$MealCandidateDtoCopyWithImpl<$Res>
    implements _$MealCandidateDtoCopyWith<$Res> {
  __$MealCandidateDtoCopyWithImpl(this._self, this._then);

  final _MealCandidateDto _self;
  final $Res Function(_MealCandidateDto) _then;

  /// Create a copy of MealCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? representativeFood = null,
    Object? otherFoodCount = null,
    Object? eatenAt = null,
  }) {
    return _then(_MealCandidateDto(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFood: null == representativeFood
          ? _self.representativeFood
          : representativeFood // ignore: cast_nullable_to_non_nullable
              as MealFoodNestedDto,
      otherFoodCount: null == otherFoodCount
          ? _self.otherFoodCount
          : otherFoodCount // ignore: cast_nullable_to_non_nullable
              as int,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of MealCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealFoodNestedDtoCopyWith<$Res> get representativeFood {
    return $MealFoodNestedDtoCopyWith<$Res>(_self.representativeFood, (value) {
      return _then(_self.copyWith(representativeFood: value));
    });
  }
}

/// @nodoc
mixin _$MealCandidatesDayDto {
  String get date;
  List<MealCandidateDto> get meals;

  /// Create a copy of MealCandidatesDayDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCandidatesDayDtoCopyWith<MealCandidatesDayDto> get copyWith =>
      _$MealCandidatesDayDtoCopyWithImpl<MealCandidatesDayDto>(
          this as MealCandidatesDayDto, _$identity);

  /// Serializes this MealCandidatesDayDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealCandidatesDayDto &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other.meals, meals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(meals));

  @override
  String toString() {
    return 'MealCandidatesDayDto(date: $date, meals: $meals)';
  }
}

/// @nodoc
abstract mixin class $MealCandidatesDayDtoCopyWith<$Res> {
  factory $MealCandidatesDayDtoCopyWith(MealCandidatesDayDto value,
          $Res Function(MealCandidatesDayDto) _then) =
      _$MealCandidatesDayDtoCopyWithImpl;
  @useResult
  $Res call({String date, List<MealCandidateDto> meals});
}

/// @nodoc
class _$MealCandidatesDayDtoCopyWithImpl<$Res>
    implements $MealCandidatesDayDtoCopyWith<$Res> {
  _$MealCandidatesDayDtoCopyWithImpl(this._self, this._then);

  final MealCandidatesDayDto _self;
  final $Res Function(MealCandidatesDayDto) _then;

  /// Create a copy of MealCandidatesDayDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? meals = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      meals: null == meals
          ? _self.meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealCandidateDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealCandidatesDayDto].
extension MealCandidatesDayDtoPatterns on MealCandidatesDayDto {
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
    TResult Function(_MealCandidatesDayDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDayDto() when $default != null:
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
    TResult Function(_MealCandidatesDayDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDayDto():
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
    TResult? Function(_MealCandidatesDayDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDayDto() when $default != null:
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
    TResult Function(String date, List<MealCandidateDto> meals)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDayDto() when $default != null:
        return $default(_that.date, _that.meals);
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
    TResult Function(String date, List<MealCandidateDto> meals) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDayDto():
        return $default(_that.date, _that.meals);
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
    TResult? Function(String date, List<MealCandidateDto> meals)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDayDto() when $default != null:
        return $default(_that.date, _that.meals);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealCandidatesDayDto implements MealCandidatesDayDto {
  const _MealCandidatesDayDto(
      {required this.date,
      final List<MealCandidateDto> meals = const <MealCandidateDto>[]})
      : _meals = meals;
  factory _MealCandidatesDayDto.fromJson(Map<String, dynamic> json) =>
      _$MealCandidatesDayDtoFromJson(json);

  @override
  final String date;
  final List<MealCandidateDto> _meals;
  @override
  @JsonKey()
  List<MealCandidateDto> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  /// Create a copy of MealCandidatesDayDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCandidatesDayDtoCopyWith<_MealCandidatesDayDto> get copyWith =>
      __$MealCandidatesDayDtoCopyWithImpl<_MealCandidatesDayDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealCandidatesDayDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealCandidatesDayDto &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._meals, _meals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_meals));

  @override
  String toString() {
    return 'MealCandidatesDayDto(date: $date, meals: $meals)';
  }
}

/// @nodoc
abstract mixin class _$MealCandidatesDayDtoCopyWith<$Res>
    implements $MealCandidatesDayDtoCopyWith<$Res> {
  factory _$MealCandidatesDayDtoCopyWith(_MealCandidatesDayDto value,
          $Res Function(_MealCandidatesDayDto) _then) =
      __$MealCandidatesDayDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String date, List<MealCandidateDto> meals});
}

/// @nodoc
class __$MealCandidatesDayDtoCopyWithImpl<$Res>
    implements _$MealCandidatesDayDtoCopyWith<$Res> {
  __$MealCandidatesDayDtoCopyWithImpl(this._self, this._then);

  final _MealCandidatesDayDto _self;
  final $Res Function(_MealCandidatesDayDto) _then;

  /// Create a copy of MealCandidatesDayDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? meals = null,
  }) {
    return _then(_MealCandidatesDayDto(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      meals: null == meals
          ? _self._meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealCandidateDto>,
    ));
  }
}

/// @nodoc
mixin _$CreateMealRecordRequestDto {
  String get foodExternalId;
  String? get eatenAt;
  String? get mealRecordId;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateMealRecordRequestDtoCopyWith<CreateMealRecordRequestDto>
      get copyWith =>
          _$CreateMealRecordRequestDtoCopyWithImpl<CreateMealRecordRequestDto>(
              this as CreateMealRecordRequestDto, _$identity);

  /// Serializes this CreateMealRecordRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateMealRecordRequestDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, foodExternalId, eatenAt, mealRecordId);

  @override
  String toString() {
    return 'CreateMealRecordRequestDto(foodExternalId: $foodExternalId, eatenAt: $eatenAt, mealRecordId: $mealRecordId)';
  }
}

/// @nodoc
abstract mixin class $CreateMealRecordRequestDtoCopyWith<$Res> {
  factory $CreateMealRecordRequestDtoCopyWith(CreateMealRecordRequestDto value,
          $Res Function(CreateMealRecordRequestDto) _then) =
      _$CreateMealRecordRequestDtoCopyWithImpl;
  @useResult
  $Res call({String foodExternalId, String? eatenAt, String? mealRecordId});
}

/// @nodoc
class _$CreateMealRecordRequestDtoCopyWithImpl<$Res>
    implements $CreateMealRecordRequestDtoCopyWith<$Res> {
  _$CreateMealRecordRequestDtoCopyWithImpl(this._self, this._then);

  final CreateMealRecordRequestDto _self;
  final $Res Function(CreateMealRecordRequestDto) _then;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodExternalId = null,
    Object? eatenAt = freezed,
    Object? mealRecordId = freezed,
  }) {
    return _then(_self.copyWith(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: freezed == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealRecordId: freezed == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateMealRecordRequestDto].
extension CreateMealRecordRequestDtoPatterns on CreateMealRecordRequestDto {
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
    TResult Function(_CreateMealRecordRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
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
    TResult Function(_CreateMealRecordRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto():
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
    TResult? Function(_CreateMealRecordRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
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
            String foodExternalId, String? eatenAt, String? mealRecordId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
        return $default(
            _that.foodExternalId, _that.eatenAt, _that.mealRecordId);
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
            String foodExternalId, String? eatenAt, String? mealRecordId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto():
        return $default(
            _that.foodExternalId, _that.eatenAt, _that.mealRecordId);
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
            String foodExternalId, String? eatenAt, String? mealRecordId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateMealRecordRequestDto() when $default != null:
        return $default(
            _that.foodExternalId, _that.eatenAt, _that.mealRecordId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateMealRecordRequestDto implements CreateMealRecordRequestDto {
  const _CreateMealRecordRequestDto(
      {required this.foodExternalId, this.eatenAt, this.mealRecordId});
  factory _CreateMealRecordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMealRecordRequestDtoFromJson(json);

  @override
  final String foodExternalId;
  @override
  final String? eatenAt;
  @override
  final String? mealRecordId;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateMealRecordRequestDtoCopyWith<_CreateMealRecordRequestDto>
      get copyWith => __$CreateMealRecordRequestDtoCopyWithImpl<
          _CreateMealRecordRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateMealRecordRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateMealRecordRequestDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, foodExternalId, eatenAt, mealRecordId);

  @override
  String toString() {
    return 'CreateMealRecordRequestDto(foodExternalId: $foodExternalId, eatenAt: $eatenAt, mealRecordId: $mealRecordId)';
  }
}

/// @nodoc
abstract mixin class _$CreateMealRecordRequestDtoCopyWith<$Res>
    implements $CreateMealRecordRequestDtoCopyWith<$Res> {
  factory _$CreateMealRecordRequestDtoCopyWith(
          _CreateMealRecordRequestDto value,
          $Res Function(_CreateMealRecordRequestDto) _then) =
      __$CreateMealRecordRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String foodExternalId, String? eatenAt, String? mealRecordId});
}

/// @nodoc
class __$CreateMealRecordRequestDtoCopyWithImpl<$Res>
    implements _$CreateMealRecordRequestDtoCopyWith<$Res> {
  __$CreateMealRecordRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateMealRecordRequestDto _self;
  final $Res Function(_CreateMealRecordRequestDto) _then;

  /// Create a copy of CreateMealRecordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodExternalId = null,
    Object? eatenAt = freezed,
    Object? mealRecordId = freezed,
  }) {
    return _then(_CreateMealRecordRequestDto(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: freezed == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mealRecordId: freezed == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
