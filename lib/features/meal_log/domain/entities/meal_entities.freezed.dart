// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealAnalysis {
  /// analysis.judgmentGrade (대문자 grade → fromGrade).
  VerdictLevel get judgmentGrade;

  /// analysis.triggerAnalysis. grade=UNKNOWN 등 누락 가능 → nullable.
  AnalysisSection? get trigger;

  /// analysis.allergyAnalysis. 누락 가능 → nullable.
  AnalysisSection? get allergy;

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealAnalysisCopyWith<MealAnalysis> get copyWith =>
      _$MealAnalysisCopyWithImpl<MealAnalysis>(
          this as MealAnalysis, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealAnalysis &&
            (identical(other.judgmentGrade, judgmentGrade) ||
                other.judgmentGrade == judgmentGrade) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            (identical(other.allergy, allergy) || other.allergy == allergy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, judgmentGrade, trigger, allergy);

  @override
  String toString() {
    return 'MealAnalysis(judgmentGrade: $judgmentGrade, trigger: $trigger, allergy: $allergy)';
  }
}

/// @nodoc
abstract mixin class $MealAnalysisCopyWith<$Res> {
  factory $MealAnalysisCopyWith(
          MealAnalysis value, $Res Function(MealAnalysis) _then) =
      _$MealAnalysisCopyWithImpl;
  @useResult
  $Res call(
      {VerdictLevel judgmentGrade,
      AnalysisSection? trigger,
      AnalysisSection? allergy});

  $AnalysisSectionCopyWith<$Res>? get trigger;
  $AnalysisSectionCopyWith<$Res>? get allergy;
}

/// @nodoc
class _$MealAnalysisCopyWithImpl<$Res> implements $MealAnalysisCopyWith<$Res> {
  _$MealAnalysisCopyWithImpl(this._self, this._then);

  final MealAnalysis _self;
  final $Res Function(MealAnalysis) _then;

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? judgmentGrade = null,
    Object? trigger = freezed,
    Object? allergy = freezed,
  }) {
    return _then(_self.copyWith(
      judgmentGrade: null == judgmentGrade
          ? _self.judgmentGrade
          : judgmentGrade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      trigger: freezed == trigger
          ? _self.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as AnalysisSection?,
      allergy: freezed == allergy
          ? _self.allergy
          : allergy // ignore: cast_nullable_to_non_nullable
              as AnalysisSection?,
    ));
  }

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionCopyWith<$Res>? get trigger {
    if (_self.trigger == null) {
      return null;
    }

    return $AnalysisSectionCopyWith<$Res>(_self.trigger!, (value) {
      return _then(_self.copyWith(trigger: value));
    });
  }

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionCopyWith<$Res>? get allergy {
    if (_self.allergy == null) {
      return null;
    }

    return $AnalysisSectionCopyWith<$Res>(_self.allergy!, (value) {
      return _then(_self.copyWith(allergy: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealAnalysis].
extension MealAnalysisPatterns on MealAnalysis {
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
    TResult Function(_MealAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealAnalysis() when $default != null:
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
    TResult Function(_MealAnalysis value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysis():
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
    TResult? Function(_MealAnalysis value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysis() when $default != null:
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
    TResult Function(VerdictLevel judgmentGrade, AnalysisSection? trigger,
            AnalysisSection? allergy)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealAnalysis() when $default != null:
        return $default(_that.judgmentGrade, _that.trigger, _that.allergy);
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
    TResult Function(VerdictLevel judgmentGrade, AnalysisSection? trigger,
            AnalysisSection? allergy)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysis():
        return $default(_that.judgmentGrade, _that.trigger, _that.allergy);
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
    TResult? Function(VerdictLevel judgmentGrade, AnalysisSection? trigger,
            AnalysisSection? allergy)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealAnalysis() when $default != null:
        return $default(_that.judgmentGrade, _that.trigger, _that.allergy);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealAnalysis implements MealAnalysis {
  const _MealAnalysis(
      {required this.judgmentGrade, this.trigger, this.allergy});

  /// analysis.judgmentGrade (대문자 grade → fromGrade).
  @override
  final VerdictLevel judgmentGrade;

  /// analysis.triggerAnalysis. grade=UNKNOWN 등 누락 가능 → nullable.
  @override
  final AnalysisSection? trigger;

  /// analysis.allergyAnalysis. 누락 가능 → nullable.
  @override
  final AnalysisSection? allergy;

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealAnalysisCopyWith<_MealAnalysis> get copyWith =>
      __$MealAnalysisCopyWithImpl<_MealAnalysis>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealAnalysis &&
            (identical(other.judgmentGrade, judgmentGrade) ||
                other.judgmentGrade == judgmentGrade) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            (identical(other.allergy, allergy) || other.allergy == allergy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, judgmentGrade, trigger, allergy);

  @override
  String toString() {
    return 'MealAnalysis(judgmentGrade: $judgmentGrade, trigger: $trigger, allergy: $allergy)';
  }
}

/// @nodoc
abstract mixin class _$MealAnalysisCopyWith<$Res>
    implements $MealAnalysisCopyWith<$Res> {
  factory _$MealAnalysisCopyWith(
          _MealAnalysis value, $Res Function(_MealAnalysis) _then) =
      __$MealAnalysisCopyWithImpl;
  @override
  @useResult
  $Res call(
      {VerdictLevel judgmentGrade,
      AnalysisSection? trigger,
      AnalysisSection? allergy});

  @override
  $AnalysisSectionCopyWith<$Res>? get trigger;
  @override
  $AnalysisSectionCopyWith<$Res>? get allergy;
}

/// @nodoc
class __$MealAnalysisCopyWithImpl<$Res>
    implements _$MealAnalysisCopyWith<$Res> {
  __$MealAnalysisCopyWithImpl(this._self, this._then);

  final _MealAnalysis _self;
  final $Res Function(_MealAnalysis) _then;

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? judgmentGrade = null,
    Object? trigger = freezed,
    Object? allergy = freezed,
  }) {
    return _then(_MealAnalysis(
      judgmentGrade: null == judgmentGrade
          ? _self.judgmentGrade
          : judgmentGrade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      trigger: freezed == trigger
          ? _self.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as AnalysisSection?,
      allergy: freezed == allergy
          ? _self.allergy
          : allergy // ignore: cast_nullable_to_non_nullable
              as AnalysisSection?,
    ));
  }

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionCopyWith<$Res>? get trigger {
    if (_self.trigger == null) {
      return null;
    }

    return $AnalysisSectionCopyWith<$Res>(_self.trigger!, (value) {
      return _then(_self.copyWith(trigger: value));
    });
  }

  /// Create a copy of MealAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisSectionCopyWith<$Res>? get allergy {
    if (_self.allergy == null) {
      return null;
    }

    return $AnalysisSectionCopyWith<$Res>(_self.allergy!, (value) {
      return _then(_self.copyWith(allergy: value));
    });
  }
}

/// @nodoc
mixin _$AnalysisSection {
  /// 강조 문구.
  String get ment;

  /// 본문.
  String get content;

  /// Create a copy of AnalysisSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnalysisSectionCopyWith<AnalysisSection> get copyWith =>
      _$AnalysisSectionCopyWithImpl<AnalysisSection>(
          this as AnalysisSection, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnalysisSection &&
            (identical(other.ment, ment) || other.ment == ment) &&
            (identical(other.content, content) || other.content == content));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ment, content);

  @override
  String toString() {
    return 'AnalysisSection(ment: $ment, content: $content)';
  }
}

/// @nodoc
abstract mixin class $AnalysisSectionCopyWith<$Res> {
  factory $AnalysisSectionCopyWith(
          AnalysisSection value, $Res Function(AnalysisSection) _then) =
      _$AnalysisSectionCopyWithImpl;
  @useResult
  $Res call({String ment, String content});
}

/// @nodoc
class _$AnalysisSectionCopyWithImpl<$Res>
    implements $AnalysisSectionCopyWith<$Res> {
  _$AnalysisSectionCopyWithImpl(this._self, this._then);

  final AnalysisSection _self;
  final $Res Function(AnalysisSection) _then;

  /// Create a copy of AnalysisSection
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

/// Adds pattern-matching-related methods to [AnalysisSection].
extension AnalysisSectionPatterns on AnalysisSection {
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
    TResult Function(_AnalysisSection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AnalysisSection() when $default != null:
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
    TResult Function(_AnalysisSection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnalysisSection():
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
    TResult? Function(_AnalysisSection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AnalysisSection() when $default != null:
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
      case _AnalysisSection() when $default != null:
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
      case _AnalysisSection():
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
      case _AnalysisSection() when $default != null:
        return $default(_that.ment, _that.content);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AnalysisSection implements AnalysisSection {
  const _AnalysisSection({required this.ment, required this.content});

  /// 강조 문구.
  @override
  final String ment;

  /// 본문.
  @override
  final String content;

  /// Create a copy of AnalysisSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnalysisSectionCopyWith<_AnalysisSection> get copyWith =>
      __$AnalysisSectionCopyWithImpl<_AnalysisSection>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnalysisSection &&
            (identical(other.ment, ment) || other.ment == ment) &&
            (identical(other.content, content) || other.content == content));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ment, content);

  @override
  String toString() {
    return 'AnalysisSection(ment: $ment, content: $content)';
  }
}

/// @nodoc
abstract mixin class _$AnalysisSectionCopyWith<$Res>
    implements $AnalysisSectionCopyWith<$Res> {
  factory _$AnalysisSectionCopyWith(
          _AnalysisSection value, $Res Function(_AnalysisSection) _then) =
      __$AnalysisSectionCopyWithImpl;
  @override
  @useResult
  $Res call({String ment, String content});
}

/// @nodoc
class __$AnalysisSectionCopyWithImpl<$Res>
    implements _$AnalysisSectionCopyWith<$Res> {
  __$AnalysisSectionCopyWithImpl(this._self, this._then);

  final _AnalysisSection _self;
  final $Res Function(_AnalysisSection) _then;

  /// Create a copy of AnalysisSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ment = null,
    Object? content = null,
  }) {
    return _then(_AnalysisSection(
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
mixin _$StateRecord {
  /// 서버 stateRecordId.
  String get stateRecordId;

  /// 증상 라벨 (예: '속쓰림').
  String get label;

  /// 기록 날짜 ('YYYY-MM-DD' 문자열 그대로).
  String get date;

  /// 식후 경과 분. "식후 N분" 포맷은 표시 레이어 책임.
  int get timingMinutes;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateRecordCopyWith<StateRecord> get copyWith =>
      _$StateRecordCopyWithImpl<StateRecord>(this as StateRecord, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateRecord &&
            (identical(other.stateRecordId, stateRecordId) ||
                other.stateRecordId == stateRecordId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timingMinutes, timingMinutes) ||
                other.timingMinutes == timingMinutes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, stateRecordId, label, date, timingMinutes);

  @override
  String toString() {
    return 'StateRecord(stateRecordId: $stateRecordId, label: $label, date: $date, timingMinutes: $timingMinutes)';
  }
}

/// @nodoc
abstract mixin class $StateRecordCopyWith<$Res> {
  factory $StateRecordCopyWith(
          StateRecord value, $Res Function(StateRecord) _then) =
      _$StateRecordCopyWithImpl;
  @useResult
  $Res call(
      {String stateRecordId, String label, String date, int timingMinutes});
}

/// @nodoc
class _$StateRecordCopyWithImpl<$Res> implements $StateRecordCopyWith<$Res> {
  _$StateRecordCopyWithImpl(this._self, this._then);

  final StateRecord _self;
  final $Res Function(StateRecord) _then;

  /// Create a copy of StateRecord
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

/// Adds pattern-matching-related methods to [StateRecord].
extension StateRecordPatterns on StateRecord {
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
    TResult Function(_StateRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecord() when $default != null:
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
    TResult Function(_StateRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecord():
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
    TResult? Function(_StateRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecord() when $default != null:
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
      case _StateRecord() when $default != null:
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
      case _StateRecord():
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
      case _StateRecord() when $default != null:
        return $default(
            _that.stateRecordId, _that.label, _that.date, _that.timingMinutes);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StateRecord implements StateRecord {
  const _StateRecord(
      {required this.stateRecordId,
      required this.label,
      required this.date,
      required this.timingMinutes});

  /// 서버 stateRecordId.
  @override
  final String stateRecordId;

  /// 증상 라벨 (예: '속쓰림').
  @override
  final String label;

  /// 기록 날짜 ('YYYY-MM-DD' 문자열 그대로).
  @override
  final String date;

  /// 식후 경과 분. "식후 N분" 포맷은 표시 레이어 책임.
  @override
  final int timingMinutes;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StateRecordCopyWith<_StateRecord> get copyWith =>
      __$StateRecordCopyWithImpl<_StateRecord>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StateRecord &&
            (identical(other.stateRecordId, stateRecordId) ||
                other.stateRecordId == stateRecordId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timingMinutes, timingMinutes) ||
                other.timingMinutes == timingMinutes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, stateRecordId, label, date, timingMinutes);

  @override
  String toString() {
    return 'StateRecord(stateRecordId: $stateRecordId, label: $label, date: $date, timingMinutes: $timingMinutes)';
  }
}

/// @nodoc
abstract mixin class _$StateRecordCopyWith<$Res>
    implements $StateRecordCopyWith<$Res> {
  factory _$StateRecordCopyWith(
          _StateRecord value, $Res Function(_StateRecord) _then) =
      __$StateRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String stateRecordId, String label, String date, int timingMinutes});
}

/// @nodoc
class __$StateRecordCopyWithImpl<$Res> implements _$StateRecordCopyWith<$Res> {
  __$StateRecordCopyWithImpl(this._self, this._then);

  final _StateRecord _self;
  final $Res Function(_StateRecord) _then;

  /// Create a copy of StateRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stateRecordId = null,
    Object? label = null,
    Object? date = null,
    Object? timingMinutes = null,
  }) {
    return _then(_StateRecord(
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
mixin _$MealFood {
  /// 음식 식별자 (구 mealId 대체).
  String get mealFoodId;

  /// 음식 표시 이름.
  String get name;

  /// 음식 카테고리. 서버가 없으면 null → CategoryIcon regular 폴백.
  String? get category;

  /// 섭취 시각 (ISO-8601 문자열 그대로, 표시 전용).
  String get eatenAt;

  /// food.mealRecordExternalId (POST 응답에만 존재, append/재판정용).
  String? get mealRecordExternalId;

  /// analysis. 상세·foodDetail·POST 응답에만. 타임라인/목록엔 null.
  MealAnalysis? get analysis;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealFoodCopyWith<MealFood> get copyWith =>
      _$MealFoodCopyWithImpl<MealFood>(this as MealFood, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealFood &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealRecordExternalId, mealRecordExternalId) ||
                other.mealRecordExternalId == mealRecordExternalId) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealFoodId, name, category,
      eatenAt, mealRecordExternalId, analysis);

  @override
  String toString() {
    return 'MealFood(mealFoodId: $mealFoodId, name: $name, category: $category, eatenAt: $eatenAt, mealRecordExternalId: $mealRecordExternalId, analysis: $analysis)';
  }
}

/// @nodoc
abstract mixin class $MealFoodCopyWith<$Res> {
  factory $MealFoodCopyWith(MealFood value, $Res Function(MealFood) _then) =
      _$MealFoodCopyWithImpl;
  @useResult
  $Res call(
      {String mealFoodId,
      String name,
      String? category,
      String eatenAt,
      String? mealRecordExternalId,
      MealAnalysis? analysis});

  $MealAnalysisCopyWith<$Res>? get analysis;
}

/// @nodoc
class _$MealFoodCopyWithImpl<$Res> implements $MealFoodCopyWith<$Res> {
  _$MealFoodCopyWithImpl(this._self, this._then);

  final MealFood _self;
  final $Res Function(MealFood) _then;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
    Object? eatenAt = null,
    Object? mealRecordExternalId = freezed,
    Object? analysis = freezed,
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
      mealRecordExternalId: freezed == mealRecordExternalId
          ? _self.mealRecordExternalId
          : mealRecordExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
      analysis: freezed == analysis
          ? _self.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as MealAnalysis?,
    ));
  }

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealAnalysisCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
      return null;
    }

    return $MealAnalysisCopyWith<$Res>(_self.analysis!, (value) {
      return _then(_self.copyWith(analysis: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MealFood].
extension MealFoodPatterns on MealFood {
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
    TResult Function(_MealFood value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
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
    TResult Function(_MealFood value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood():
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
    TResult? Function(_MealFood value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
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
            String mealFoodId,
            String name,
            String? category,
            String eatenAt,
            String? mealRecordExternalId,
            MealAnalysis? analysis)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
        return $default(_that.mealFoodId, _that.name, _that.category,
            _that.eatenAt, _that.mealRecordExternalId, _that.analysis);
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
            String mealFoodId,
            String name,
            String? category,
            String eatenAt,
            String? mealRecordExternalId,
            MealAnalysis? analysis)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood():
        return $default(_that.mealFoodId, _that.name, _that.category,
            _that.eatenAt, _that.mealRecordExternalId, _that.analysis);
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
            String mealFoodId,
            String name,
            String? category,
            String eatenAt,
            String? mealRecordExternalId,
            MealAnalysis? analysis)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealFood() when $default != null:
        return $default(_that.mealFoodId, _that.name, _that.category,
            _that.eatenAt, _that.mealRecordExternalId, _that.analysis);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealFood implements MealFood {
  const _MealFood(
      {required this.mealFoodId,
      required this.name,
      this.category,
      required this.eatenAt,
      this.mealRecordExternalId,
      this.analysis});

  /// 음식 식별자 (구 mealId 대체).
  @override
  final String mealFoodId;

  /// 음식 표시 이름.
  @override
  final String name;

  /// 음식 카테고리. 서버가 없으면 null → CategoryIcon regular 폴백.
  @override
  final String? category;

  /// 섭취 시각 (ISO-8601 문자열 그대로, 표시 전용).
  @override
  final String eatenAt;

  /// food.mealRecordExternalId (POST 응답에만 존재, append/재판정용).
  @override
  final String? mealRecordExternalId;

  /// analysis. 상세·foodDetail·POST 응답에만. 타임라인/목록엔 null.
  @override
  final MealAnalysis? analysis;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealFoodCopyWith<_MealFood> get copyWith =>
      __$MealFoodCopyWithImpl<_MealFood>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealFood &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.mealRecordExternalId, mealRecordExternalId) ||
                other.mealRecordExternalId == mealRecordExternalId) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealFoodId, name, category,
      eatenAt, mealRecordExternalId, analysis);

  @override
  String toString() {
    return 'MealFood(mealFoodId: $mealFoodId, name: $name, category: $category, eatenAt: $eatenAt, mealRecordExternalId: $mealRecordExternalId, analysis: $analysis)';
  }
}

/// @nodoc
abstract mixin class _$MealFoodCopyWith<$Res>
    implements $MealFoodCopyWith<$Res> {
  factory _$MealFoodCopyWith(_MealFood value, $Res Function(_MealFood) _then) =
      __$MealFoodCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealFoodId,
      String name,
      String? category,
      String eatenAt,
      String? mealRecordExternalId,
      MealAnalysis? analysis});

  @override
  $MealAnalysisCopyWith<$Res>? get analysis;
}

/// @nodoc
class __$MealFoodCopyWithImpl<$Res> implements _$MealFoodCopyWith<$Res> {
  __$MealFoodCopyWithImpl(this._self, this._then);

  final _MealFood _self;
  final $Res Function(_MealFood) _then;

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
    Object? eatenAt = null,
    Object? mealRecordExternalId = freezed,
    Object? analysis = freezed,
  }) {
    return _then(_MealFood(
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
      mealRecordExternalId: freezed == mealRecordExternalId
          ? _self.mealRecordExternalId
          : mealRecordExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
      analysis: freezed == analysis
          ? _self.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as MealAnalysis?,
    ));
  }

  /// Create a copy of MealFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealAnalysisCopyWith<$Res>? get analysis {
    if (_self.analysis == null) {
      return null;
    }

    return $MealAnalysisCopyWith<$Res>(_self.analysis!, (value) {
      return _then(_self.copyWith(analysis: value));
    });
  }
}

/// @nodoc
mixin _$MealRecord {
  /// 식사 기록 식별자.
  String get mealRecordId;

  /// 식사 대표 섭취 시각 (ISO 그대로).
  String get eatenAt;

  /// 식사 내 음식 목록 (서버 meals[]). 각 음식의 analysis는 null.
  List<MealFood> get foods;

  /// 연관 상태기록 목록.
  List<StateRecord> get stateRecords;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealRecordCopyWith<MealRecord> get copyWith =>
      _$MealRecordCopyWithImpl<MealRecord>(this as MealRecord, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealRecord &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other.foods, foods) &&
            const DeepCollectionEquality()
                .equals(other.stateRecords, stateRecords));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      eatenAt,
      const DeepCollectionEquality().hash(foods),
      const DeepCollectionEquality().hash(stateRecords));

  @override
  String toString() {
    return 'MealRecord(mealRecordId: $mealRecordId, eatenAt: $eatenAt, foods: $foods, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class $MealRecordCopyWith<$Res> {
  factory $MealRecordCopyWith(
          MealRecord value, $Res Function(MealRecord) _then) =
      _$MealRecordCopyWithImpl;
  @useResult
  $Res call(
      {String mealRecordId,
      String eatenAt,
      List<MealFood> foods,
      List<StateRecord> stateRecords});
}

/// @nodoc
class _$MealRecordCopyWithImpl<$Res> implements $MealRecordCopyWith<$Res> {
  _$MealRecordCopyWithImpl(this._self, this._then);

  final MealRecord _self;
  final $Res Function(MealRecord) _then;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordId = null,
    Object? eatenAt = null,
    Object? foods = null,
    Object? stateRecords = null,
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
      foods: null == foods
          ? _self.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<MealFood>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecord>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealRecord].
extension MealRecordPatterns on MealRecord {
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
    TResult Function(_MealRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
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
    TResult Function(_MealRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord():
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
    TResult? Function(_MealRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
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
    TResult Function(String mealRecordId, String eatenAt, List<MealFood> foods,
            List<StateRecord> stateRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
        return $default(
            _that.mealRecordId, _that.eatenAt, _that.foods, _that.stateRecords);
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
    TResult Function(String mealRecordId, String eatenAt, List<MealFood> foods,
            List<StateRecord> stateRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord():
        return $default(
            _that.mealRecordId, _that.eatenAt, _that.foods, _that.stateRecords);
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
    TResult? Function(String mealRecordId, String eatenAt, List<MealFood> foods,
            List<StateRecord> stateRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealRecord() when $default != null:
        return $default(
            _that.mealRecordId, _that.eatenAt, _that.foods, _that.stateRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealRecord implements MealRecord {
  const _MealRecord(
      {required this.mealRecordId,
      required this.eatenAt,
      final List<MealFood> foods = const <MealFood>[],
      final List<StateRecord> stateRecords = const <StateRecord>[]})
      : _foods = foods,
        _stateRecords = stateRecords;

  /// 식사 기록 식별자.
  @override
  final String mealRecordId;

  /// 식사 대표 섭취 시각 (ISO 그대로).
  @override
  final String eatenAt;

  /// 식사 내 음식 목록 (서버 meals[]). 각 음식의 analysis는 null.
  final List<MealFood> _foods;

  /// 식사 내 음식 목록 (서버 meals[]). 각 음식의 analysis는 null.
  @override
  @JsonKey()
  List<MealFood> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  /// 연관 상태기록 목록.
  final List<StateRecord> _stateRecords;

  /// 연관 상태기록 목록.
  @override
  @JsonKey()
  List<StateRecord> get stateRecords {
    if (_stateRecords is EqualUnmodifiableListView) return _stateRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stateRecords);
  }

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealRecordCopyWith<_MealRecord> get copyWith =>
      __$MealRecordCopyWithImpl<_MealRecord>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealRecord &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            const DeepCollectionEquality()
                .equals(other._stateRecords, _stateRecords));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      eatenAt,
      const DeepCollectionEquality().hash(_foods),
      const DeepCollectionEquality().hash(_stateRecords));

  @override
  String toString() {
    return 'MealRecord(mealRecordId: $mealRecordId, eatenAt: $eatenAt, foods: $foods, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class _$MealRecordCopyWith<$Res>
    implements $MealRecordCopyWith<$Res> {
  factory _$MealRecordCopyWith(
          _MealRecord value, $Res Function(_MealRecord) _then) =
      __$MealRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealRecordId,
      String eatenAt,
      List<MealFood> foods,
      List<StateRecord> stateRecords});
}

/// @nodoc
class __$MealRecordCopyWithImpl<$Res> implements _$MealRecordCopyWith<$Res> {
  __$MealRecordCopyWithImpl(this._self, this._then);

  final _MealRecord _self;
  final $Res Function(_MealRecord) _then;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? eatenAt = null,
    Object? foods = null,
    Object? stateRecords = null,
  }) {
    return _then(_MealRecord(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      eatenAt: null == eatenAt
          ? _self.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _self._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<MealFood>,
      stateRecords: null == stateRecords
          ? _self._stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as List<StateRecord>,
    ));
  }
}

/// @nodoc
mixin _$ConnectedSymptoms {
  String get symptomId;
  SymptomState get symptomState;
  int get afterMealMinutes;
  List<String> get representativeSymptoms;
  int get etcCount;

  /// Create a copy of ConnectedSymptoms
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectedSymptomsCopyWith<ConnectedSymptoms> get copyWith =>
      _$ConnectedSymptomsCopyWithImpl<ConnectedSymptoms>(
          this as ConnectedSymptoms, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectedSymptoms &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.afterMealMinutes, afterMealMinutes) ||
                other.afterMealMinutes == afterMealMinutes) &&
            const DeepCollectionEquality()
                .equals(other.representativeSymptoms, representativeSymptoms) &&
            (identical(other.etcCount, etcCount) ||
                other.etcCount == etcCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      afterMealMinutes,
      const DeepCollectionEquality().hash(representativeSymptoms),
      etcCount);

  @override
  String toString() {
    return 'ConnectedSymptoms(symptomId: $symptomId, symptomState: $symptomState, afterMealMinutes: $afterMealMinutes, representativeSymptoms: $representativeSymptoms, etcCount: $etcCount)';
  }
}

/// @nodoc
abstract mixin class $ConnectedSymptomsCopyWith<$Res> {
  factory $ConnectedSymptomsCopyWith(
          ConnectedSymptoms value, $Res Function(ConnectedSymptoms) _then) =
      _$ConnectedSymptomsCopyWithImpl;
  @useResult
  $Res call(
      {String symptomId,
      SymptomState symptomState,
      int afterMealMinutes,
      List<String> representativeSymptoms,
      int etcCount});
}

/// @nodoc
class _$ConnectedSymptomsCopyWithImpl<$Res>
    implements $ConnectedSymptomsCopyWith<$Res> {
  _$ConnectedSymptomsCopyWithImpl(this._self, this._then);

  final ConnectedSymptoms _self;
  final $Res Function(ConnectedSymptoms) _then;

  /// Create a copy of ConnectedSymptoms
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? afterMealMinutes = null,
    Object? representativeSymptoms = null,
    Object? etcCount = null,
  }) {
    return _then(_self.copyWith(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as SymptomState,
      afterMealMinutes: null == afterMealMinutes
          ? _self.afterMealMinutes
          : afterMealMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      representativeSymptoms: null == representativeSymptoms
          ? _self.representativeSymptoms
          : representativeSymptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      etcCount: null == etcCount
          ? _self.etcCount
          : etcCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConnectedSymptoms].
extension ConnectedSymptomsPatterns on ConnectedSymptoms {
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
    TResult Function(_ConnectedSymptoms value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConnectedSymptoms() when $default != null:
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
    TResult Function(_ConnectedSymptoms value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConnectedSymptoms():
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
    TResult? Function(_ConnectedSymptoms value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConnectedSymptoms() when $default != null:
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
            String symptomId,
            SymptomState symptomState,
            int afterMealMinutes,
            List<String> representativeSymptoms,
            int etcCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConnectedSymptoms() when $default != null:
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.afterMealMinutes,
            _that.representativeSymptoms,
            _that.etcCount);
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
            String symptomId,
            SymptomState symptomState,
            int afterMealMinutes,
            List<String> representativeSymptoms,
            int etcCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConnectedSymptoms():
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.afterMealMinutes,
            _that.representativeSymptoms,
            _that.etcCount);
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
            String symptomId,
            SymptomState symptomState,
            int afterMealMinutes,
            List<String> representativeSymptoms,
            int etcCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConnectedSymptoms() when $default != null:
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.afterMealMinutes,
            _that.representativeSymptoms,
            _that.etcCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConnectedSymptoms implements ConnectedSymptoms {
  const _ConnectedSymptoms(
      {required this.symptomId,
      required this.symptomState,
      required this.afterMealMinutes,
      final List<String> representativeSymptoms = const <String>[],
      this.etcCount = 0})
      : _representativeSymptoms = representativeSymptoms;

  @override
  final String symptomId;
  @override
  final SymptomState symptomState;
  @override
  final int afterMealMinutes;
  final List<String> _representativeSymptoms;
  @override
  @JsonKey()
  List<String> get representativeSymptoms {
    if (_representativeSymptoms is EqualUnmodifiableListView)
      return _representativeSymptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_representativeSymptoms);
  }

  @override
  @JsonKey()
  final int etcCount;

  /// Create a copy of ConnectedSymptoms
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConnectedSymptomsCopyWith<_ConnectedSymptoms> get copyWith =>
      __$ConnectedSymptomsCopyWithImpl<_ConnectedSymptoms>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConnectedSymptoms &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.afterMealMinutes, afterMealMinutes) ||
                other.afterMealMinutes == afterMealMinutes) &&
            const DeepCollectionEquality().equals(
                other._representativeSymptoms, _representativeSymptoms) &&
            (identical(other.etcCount, etcCount) ||
                other.etcCount == etcCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      afterMealMinutes,
      const DeepCollectionEquality().hash(_representativeSymptoms),
      etcCount);

  @override
  String toString() {
    return 'ConnectedSymptoms(symptomId: $symptomId, symptomState: $symptomState, afterMealMinutes: $afterMealMinutes, representativeSymptoms: $representativeSymptoms, etcCount: $etcCount)';
  }
}

/// @nodoc
abstract mixin class _$ConnectedSymptomsCopyWith<$Res>
    implements $ConnectedSymptomsCopyWith<$Res> {
  factory _$ConnectedSymptomsCopyWith(
          _ConnectedSymptoms value, $Res Function(_ConnectedSymptoms) _then) =
      __$ConnectedSymptomsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomId,
      SymptomState symptomState,
      int afterMealMinutes,
      List<String> representativeSymptoms,
      int etcCount});
}

/// @nodoc
class __$ConnectedSymptomsCopyWithImpl<$Res>
    implements _$ConnectedSymptomsCopyWith<$Res> {
  __$ConnectedSymptomsCopyWithImpl(this._self, this._then);

  final _ConnectedSymptoms _self;
  final $Res Function(_ConnectedSymptoms) _then;

  /// Create a copy of ConnectedSymptoms
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? afterMealMinutes = null,
    Object? representativeSymptoms = null,
    Object? etcCount = null,
  }) {
    return _then(_ConnectedSymptoms(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as SymptomState,
      afterMealMinutes: null == afterMealMinutes
          ? _self.afterMealMinutes
          : afterMealMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      representativeSymptoms: null == representativeSymptoms
          ? _self._representativeSymptoms
          : representativeSymptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      etcCount: null == etcCount
          ? _self.etcCount
          : etcCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$TimelineItem {
  /// 서버 지정 시간대 아이콘. null 이면 hour 휴리스틱 폴백.
  TimeIcon? get timeIcon;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimelineItemCopyWith<TimelineItem> get copyWith =>
      _$TimelineItemCopyWithImpl<TimelineItem>(
          this as TimelineItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimelineItem &&
            (identical(other.timeIcon, timeIcon) ||
                other.timeIcon == timeIcon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, timeIcon);

  @override
  String toString() {
    return 'TimelineItem(timeIcon: $timeIcon)';
  }
}

/// @nodoc
abstract mixin class $TimelineItemCopyWith<$Res> {
  factory $TimelineItemCopyWith(
          TimelineItem value, $Res Function(TimelineItem) _then) =
      _$TimelineItemCopyWithImpl;
  @useResult
  $Res call({TimeIcon? timeIcon});
}

/// @nodoc
class _$TimelineItemCopyWithImpl<$Res> implements $TimelineItemCopyWith<$Res> {
  _$TimelineItemCopyWithImpl(this._self, this._then);

  final TimelineItem _self;
  final $Res Function(TimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeIcon = freezed,
  }) {
    return _then(_self.copyWith(
      timeIcon: freezed == timeIcon
          ? _self.timeIcon
          : timeIcon // ignore: cast_nullable_to_non_nullable
              as TimeIcon?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TimelineItem].
extension TimelineItemPatterns on TimelineItem {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimelineSingle value)? single,
    TResult Function(TimelineGroup value)? group,
    TResult Function(TimelineSymptom value)? symptom,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TimelineSingle() when single != null:
        return single(_that);
      case TimelineGroup() when group != null:
        return group(_that);
      case TimelineSymptom() when symptom != null:
        return symptom(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(TimelineSingle value) single,
    required TResult Function(TimelineGroup value) group,
    required TResult Function(TimelineSymptom value) symptom,
  }) {
    final _that = this;
    switch (_that) {
      case TimelineSingle():
        return single(_that);
      case TimelineGroup():
        return group(_that);
      case TimelineSymptom():
        return symptom(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimelineSingle value)? single,
    TResult? Function(TimelineGroup value)? group,
    TResult? Function(TimelineSymptom value)? symptom,
  }) {
    final _that = this;
    switch (_that) {
      case TimelineSingle() when single != null:
        return single(_that);
      case TimelineGroup() when group != null:
        return group(_that);
      case TimelineSymptom() when symptom != null:
        return symptom(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String mealRecordId,
            String mealRecordDateTime,
            String mealFoodName,
            VerdictLevel grade,
            int etcCount,
            String? categoryCode,
            TimeIcon? timeIcon,
            ConnectedSymptoms? connectedSymptoms)?
        single,
    TResult Function(
            String mealRecordId,
            String mealRecordDateTime,
            List<String> representativeFoods,
            int etcCount,
            String? categoryCode,
            TimeIcon? timeIcon,
            ConnectedSymptoms? connectedSymptoms)?
        group,
    TResult Function(SymptomState symptomState, int afterMealMinutes,
            String occurredAt, TimeIcon? timeIcon, String? symptomId)?
        symptom,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TimelineSingle() when single != null:
        return single(
            _that.mealRecordId,
            _that.mealRecordDateTime,
            _that.mealFoodName,
            _that.grade,
            _that.etcCount,
            _that.categoryCode,
            _that.timeIcon,
            _that.connectedSymptoms);
      case TimelineGroup() when group != null:
        return group(
            _that.mealRecordId,
            _that.mealRecordDateTime,
            _that.representativeFoods,
            _that.etcCount,
            _that.categoryCode,
            _that.timeIcon,
            _that.connectedSymptoms);
      case TimelineSymptom() when symptom != null:
        return symptom(_that.symptomState, _that.afterMealMinutes,
            _that.occurredAt, _that.timeIcon, _that.symptomId);
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
  TResult when<TResult extends Object?>({
    required TResult Function(
            String mealRecordId,
            String mealRecordDateTime,
            String mealFoodName,
            VerdictLevel grade,
            int etcCount,
            String? categoryCode,
            TimeIcon? timeIcon,
            ConnectedSymptoms? connectedSymptoms)
        single,
    required TResult Function(
            String mealRecordId,
            String mealRecordDateTime,
            List<String> representativeFoods,
            int etcCount,
            String? categoryCode,
            TimeIcon? timeIcon,
            ConnectedSymptoms? connectedSymptoms)
        group,
    required TResult Function(SymptomState symptomState, int afterMealMinutes,
            String occurredAt, TimeIcon? timeIcon, String? symptomId)
        symptom,
  }) {
    final _that = this;
    switch (_that) {
      case TimelineSingle():
        return single(
            _that.mealRecordId,
            _that.mealRecordDateTime,
            _that.mealFoodName,
            _that.grade,
            _that.etcCount,
            _that.categoryCode,
            _that.timeIcon,
            _that.connectedSymptoms);
      case TimelineGroup():
        return group(
            _that.mealRecordId,
            _that.mealRecordDateTime,
            _that.representativeFoods,
            _that.etcCount,
            _that.categoryCode,
            _that.timeIcon,
            _that.connectedSymptoms);
      case TimelineSymptom():
        return symptom(_that.symptomState, _that.afterMealMinutes,
            _that.occurredAt, _that.timeIcon, _that.symptomId);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String mealRecordId,
            String mealRecordDateTime,
            String mealFoodName,
            VerdictLevel grade,
            int etcCount,
            String? categoryCode,
            TimeIcon? timeIcon,
            ConnectedSymptoms? connectedSymptoms)?
        single,
    TResult? Function(
            String mealRecordId,
            String mealRecordDateTime,
            List<String> representativeFoods,
            int etcCount,
            String? categoryCode,
            TimeIcon? timeIcon,
            ConnectedSymptoms? connectedSymptoms)?
        group,
    TResult? Function(SymptomState symptomState, int afterMealMinutes,
            String occurredAt, TimeIcon? timeIcon, String? symptomId)?
        symptom,
  }) {
    final _that = this;
    switch (_that) {
      case TimelineSingle() when single != null:
        return single(
            _that.mealRecordId,
            _that.mealRecordDateTime,
            _that.mealFoodName,
            _that.grade,
            _that.etcCount,
            _that.categoryCode,
            _that.timeIcon,
            _that.connectedSymptoms);
      case TimelineGroup() when group != null:
        return group(
            _that.mealRecordId,
            _that.mealRecordDateTime,
            _that.representativeFoods,
            _that.etcCount,
            _that.categoryCode,
            _that.timeIcon,
            _that.connectedSymptoms);
      case TimelineSymptom() when symptom != null:
        return symptom(_that.symptomState, _that.afterMealMinutes,
            _that.occurredAt, _that.timeIcon, _that.symptomId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class TimelineSingle extends TimelineItem {
  const TimelineSingle(
      {required this.mealRecordId,
      required this.mealRecordDateTime,
      required this.mealFoodName,
      required this.grade,
      this.etcCount = 0,
      this.categoryCode,
      this.timeIcon,
      this.connectedSymptoms})
      : super._();

  final String mealRecordId;
  final String mealRecordDateTime;
  final String mealFoodName;
  final VerdictLevel grade;
  @JsonKey()
  final int etcCount;

  /// 음식 카테고리 코드 (CategoryIcon 표시용). 서버 미제공 시 null → regular 폴백.
  final String? categoryCode;

  /// 서버 지정 시간대 아이콘. null 이면 hour 휴리스틱 폴백.
  @override
  final TimeIcon? timeIcon;

  /// 연결증상. 없으면 칩 미표시.
  final ConnectedSymptoms? connectedSymptoms;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimelineSingleCopyWith<TimelineSingle> get copyWith =>
      _$TimelineSingleCopyWithImpl<TimelineSingle>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimelineSingle &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.mealRecordDateTime, mealRecordDateTime) ||
                other.mealRecordDateTime == mealRecordDateTime) &&
            (identical(other.mealFoodName, mealFoodName) ||
                other.mealFoodName == mealFoodName) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.etcCount, etcCount) ||
                other.etcCount == etcCount) &&
            (identical(other.categoryCode, categoryCode) ||
                other.categoryCode == categoryCode) &&
            (identical(other.timeIcon, timeIcon) ||
                other.timeIcon == timeIcon) &&
            (identical(other.connectedSymptoms, connectedSymptoms) ||
                other.connectedSymptoms == connectedSymptoms));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealRecordId, mealRecordDateTime,
      mealFoodName, grade, etcCount, categoryCode, timeIcon, connectedSymptoms);

  @override
  String toString() {
    return 'TimelineItem.single(mealRecordId: $mealRecordId, mealRecordDateTime: $mealRecordDateTime, mealFoodName: $mealFoodName, grade: $grade, etcCount: $etcCount, categoryCode: $categoryCode, timeIcon: $timeIcon, connectedSymptoms: $connectedSymptoms)';
  }
}

/// @nodoc
abstract mixin class $TimelineSingleCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TimelineSingleCopyWith(
          TimelineSingle value, $Res Function(TimelineSingle) _then) =
      _$TimelineSingleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealRecordId,
      String mealRecordDateTime,
      String mealFoodName,
      VerdictLevel grade,
      int etcCount,
      String? categoryCode,
      TimeIcon? timeIcon,
      ConnectedSymptoms? connectedSymptoms});

  $ConnectedSymptomsCopyWith<$Res>? get connectedSymptoms;
}

/// @nodoc
class _$TimelineSingleCopyWithImpl<$Res>
    implements $TimelineSingleCopyWith<$Res> {
  _$TimelineSingleCopyWithImpl(this._self, this._then);

  final TimelineSingle _self;
  final $Res Function(TimelineSingle) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? mealRecordDateTime = null,
    Object? mealFoodName = null,
    Object? grade = null,
    Object? etcCount = null,
    Object? categoryCode = freezed,
    Object? timeIcon = freezed,
    Object? connectedSymptoms = freezed,
  }) {
    return _then(TimelineSingle(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      mealRecordDateTime: null == mealRecordDateTime
          ? _self.mealRecordDateTime
          : mealRecordDateTime // ignore: cast_nullable_to_non_nullable
              as String,
      mealFoodName: null == mealFoodName
          ? _self.mealFoodName
          : mealFoodName // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      etcCount: null == etcCount
          ? _self.etcCount
          : etcCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryCode: freezed == categoryCode
          ? _self.categoryCode
          : categoryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      timeIcon: freezed == timeIcon
          ? _self.timeIcon
          : timeIcon // ignore: cast_nullable_to_non_nullable
              as TimeIcon?,
      connectedSymptoms: freezed == connectedSymptoms
          ? _self.connectedSymptoms
          : connectedSymptoms // ignore: cast_nullable_to_non_nullable
              as ConnectedSymptoms?,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectedSymptomsCopyWith<$Res>? get connectedSymptoms {
    if (_self.connectedSymptoms == null) {
      return null;
    }

    return $ConnectedSymptomsCopyWith<$Res>(_self.connectedSymptoms!, (value) {
      return _then(_self.copyWith(connectedSymptoms: value));
    });
  }
}

/// @nodoc

class TimelineGroup extends TimelineItem {
  const TimelineGroup(
      {required this.mealRecordId,
      required this.mealRecordDateTime,
      final List<String> representativeFoods = const <String>[],
      this.etcCount = 0,
      this.categoryCode,
      this.timeIcon,
      this.connectedSymptoms})
      : _representativeFoods = representativeFoods,
        super._();

  final String mealRecordId;
  final String mealRecordDateTime;
  final List<String> _representativeFoods;
  @JsonKey()
  List<String> get representativeFoods {
    if (_representativeFoods is EqualUnmodifiableListView)
      return _representativeFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_representativeFoods);
  }

  @JsonKey()
  final int etcCount;

  /// 음식 카테고리 코드 (CategoryIcon 표시용). 서버 미제공 시 null → regular 폴백.
  final String? categoryCode;

  /// 서버 지정 시간대 아이콘. null 이면 hour 휴리스틱 폴백.
  @override
  final TimeIcon? timeIcon;

  /// 연결증상. 없으면 칩 미표시.
  final ConnectedSymptoms? connectedSymptoms;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimelineGroupCopyWith<TimelineGroup> get copyWith =>
      _$TimelineGroupCopyWithImpl<TimelineGroup>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimelineGroup &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.mealRecordDateTime, mealRecordDateTime) ||
                other.mealRecordDateTime == mealRecordDateTime) &&
            const DeepCollectionEquality()
                .equals(other._representativeFoods, _representativeFoods) &&
            (identical(other.etcCount, etcCount) ||
                other.etcCount == etcCount) &&
            (identical(other.categoryCode, categoryCode) ||
                other.categoryCode == categoryCode) &&
            (identical(other.timeIcon, timeIcon) ||
                other.timeIcon == timeIcon) &&
            (identical(other.connectedSymptoms, connectedSymptoms) ||
                other.connectedSymptoms == connectedSymptoms));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      mealRecordDateTime,
      const DeepCollectionEquality().hash(_representativeFoods),
      etcCount,
      categoryCode,
      timeIcon,
      connectedSymptoms);

  @override
  String toString() {
    return 'TimelineItem.group(mealRecordId: $mealRecordId, mealRecordDateTime: $mealRecordDateTime, representativeFoods: $representativeFoods, etcCount: $etcCount, categoryCode: $categoryCode, timeIcon: $timeIcon, connectedSymptoms: $connectedSymptoms)';
  }
}

/// @nodoc
abstract mixin class $TimelineGroupCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TimelineGroupCopyWith(
          TimelineGroup value, $Res Function(TimelineGroup) _then) =
      _$TimelineGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealRecordId,
      String mealRecordDateTime,
      List<String> representativeFoods,
      int etcCount,
      String? categoryCode,
      TimeIcon? timeIcon,
      ConnectedSymptoms? connectedSymptoms});

  $ConnectedSymptomsCopyWith<$Res>? get connectedSymptoms;
}

/// @nodoc
class _$TimelineGroupCopyWithImpl<$Res>
    implements $TimelineGroupCopyWith<$Res> {
  _$TimelineGroupCopyWithImpl(this._self, this._then);

  final TimelineGroup _self;
  final $Res Function(TimelineGroup) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? mealRecordDateTime = null,
    Object? representativeFoods = null,
    Object? etcCount = null,
    Object? categoryCode = freezed,
    Object? timeIcon = freezed,
    Object? connectedSymptoms = freezed,
  }) {
    return _then(TimelineGroup(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      mealRecordDateTime: null == mealRecordDateTime
          ? _self.mealRecordDateTime
          : mealRecordDateTime // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFoods: null == representativeFoods
          ? _self._representativeFoods
          : representativeFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      etcCount: null == etcCount
          ? _self.etcCount
          : etcCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryCode: freezed == categoryCode
          ? _self.categoryCode
          : categoryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      timeIcon: freezed == timeIcon
          ? _self.timeIcon
          : timeIcon // ignore: cast_nullable_to_non_nullable
              as TimeIcon?,
      connectedSymptoms: freezed == connectedSymptoms
          ? _self.connectedSymptoms
          : connectedSymptoms // ignore: cast_nullable_to_non_nullable
              as ConnectedSymptoms?,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectedSymptomsCopyWith<$Res>? get connectedSymptoms {
    if (_self.connectedSymptoms == null) {
      return null;
    }

    return $ConnectedSymptomsCopyWith<$Res>(_self.connectedSymptoms!, (value) {
      return _then(_self.copyWith(connectedSymptoms: value));
    });
  }
}

/// @nodoc

class TimelineSymptom extends TimelineItem {
  const TimelineSymptom(
      {required this.symptomState,
      required this.afterMealMinutes,
      required this.occurredAt,
      this.timeIcon,
      this.symptomId})
      : super._();

  final SymptomState symptomState;
  final int afterMealMinutes;
  final String occurredAt;

  /// 서버 지정 시간대 아이콘. symptom 행은 항상 의료 아이콘을 쓰므로 표시엔
  /// 미사용 — 계약 완전성을 위해 보관만.
  @override
  final TimeIcon? timeIcon;

  /// 증상 상세 식별자. 있으면 탭 가능(구 페이로드 방어 위해 nullable).
  final String? symptomId;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimelineSymptomCopyWith<TimelineSymptom> get copyWith =>
      _$TimelineSymptomCopyWithImpl<TimelineSymptom>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimelineSymptom &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.afterMealMinutes, afterMealMinutes) ||
                other.afterMealMinutes == afterMealMinutes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.timeIcon, timeIcon) ||
                other.timeIcon == timeIcon) &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, symptomState, afterMealMinutes,
      occurredAt, timeIcon, symptomId);

  @override
  String toString() {
    return 'TimelineItem.symptom(symptomState: $symptomState, afterMealMinutes: $afterMealMinutes, occurredAt: $occurredAt, timeIcon: $timeIcon, symptomId: $symptomId)';
  }
}

/// @nodoc
abstract mixin class $TimelineSymptomCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TimelineSymptomCopyWith(
          TimelineSymptom value, $Res Function(TimelineSymptom) _then) =
      _$TimelineSymptomCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SymptomState symptomState,
      int afterMealMinutes,
      String occurredAt,
      TimeIcon? timeIcon,
      String? symptomId});
}

/// @nodoc
class _$TimelineSymptomCopyWithImpl<$Res>
    implements $TimelineSymptomCopyWith<$Res> {
  _$TimelineSymptomCopyWithImpl(this._self, this._then);

  final TimelineSymptom _self;
  final $Res Function(TimelineSymptom) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomState = null,
    Object? afterMealMinutes = null,
    Object? occurredAt = null,
    Object? timeIcon = freezed,
    Object? symptomId = freezed,
  }) {
    return _then(TimelineSymptom(
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as SymptomState,
      afterMealMinutes: null == afterMealMinutes
          ? _self.afterMealMinutes
          : afterMealMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      timeIcon: freezed == timeIcon
          ? _self.timeIcon
          : timeIcon // ignore: cast_nullable_to_non_nullable
              as TimeIcon?,
      symptomId: freezed == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$MonthlyDay {
  /// 해당 월의 일(day). 서버는 date 문자열이 아닌 day:int만 제공한다.
  /// 표시월(연/월)과 조합한 DateTime 조립은 호출부(화면) 책임.
  int get day;

  /// judgementList[], ≤3, 대문자 grade → VerdictLevel.
  List<VerdictLevel> get judgements;

  /// Create a copy of MonthlyDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyDayCopyWith<MonthlyDay> get copyWith =>
      _$MonthlyDayCopyWithImpl<MonthlyDay>(this as MonthlyDay, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyDay &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality()
                .equals(other.judgements, judgements));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, day, const DeepCollectionEquality().hash(judgements));

  @override
  String toString() {
    return 'MonthlyDay(day: $day, judgements: $judgements)';
  }
}

/// @nodoc
abstract mixin class $MonthlyDayCopyWith<$Res> {
  factory $MonthlyDayCopyWith(
          MonthlyDay value, $Res Function(MonthlyDay) _then) =
      _$MonthlyDayCopyWithImpl;
  @useResult
  $Res call({int day, List<VerdictLevel> judgements});
}

/// @nodoc
class _$MonthlyDayCopyWithImpl<$Res> implements $MonthlyDayCopyWith<$Res> {
  _$MonthlyDayCopyWithImpl(this._self, this._then);

  final MonthlyDay _self;
  final $Res Function(MonthlyDay) _then;

  /// Create a copy of MonthlyDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? judgements = null,
  }) {
    return _then(_self.copyWith(
      day: null == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      judgements: null == judgements
          ? _self.judgements
          : judgements // ignore: cast_nullable_to_non_nullable
              as List<VerdictLevel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MonthlyDay].
extension MonthlyDayPatterns on MonthlyDay {
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
    TResult Function(_MonthlyDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyDay() when $default != null:
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
    TResult Function(_MonthlyDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyDay():
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
    TResult? Function(_MonthlyDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyDay() when $default != null:
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
    TResult Function(int day, List<VerdictLevel> judgements)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyDay() when $default != null:
        return $default(_that.day, _that.judgements);
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
    TResult Function(int day, List<VerdictLevel> judgements) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyDay():
        return $default(_that.day, _that.judgements);
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
    TResult? Function(int day, List<VerdictLevel> judgements)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyDay() when $default != null:
        return $default(_that.day, _that.judgements);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MonthlyDay implements MonthlyDay {
  const _MonthlyDay(
      {required this.day,
      final List<VerdictLevel> judgements = const <VerdictLevel>[]})
      : _judgements = judgements;

  /// 해당 월의 일(day). 서버는 date 문자열이 아닌 day:int만 제공한다.
  /// 표시월(연/월)과 조합한 DateTime 조립은 호출부(화면) 책임.
  @override
  final int day;

  /// judgementList[], ≤3, 대문자 grade → VerdictLevel.
  final List<VerdictLevel> _judgements;

  /// judgementList[], ≤3, 대문자 grade → VerdictLevel.
  @override
  @JsonKey()
  List<VerdictLevel> get judgements {
    if (_judgements is EqualUnmodifiableListView) return _judgements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_judgements);
  }

  /// Create a copy of MonthlyDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyDayCopyWith<_MonthlyDay> get copyWith =>
      __$MonthlyDayCopyWithImpl<_MonthlyDay>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyDay &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality()
                .equals(other._judgements, _judgements));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, day, const DeepCollectionEquality().hash(_judgements));

  @override
  String toString() {
    return 'MonthlyDay(day: $day, judgements: $judgements)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyDayCopyWith<$Res>
    implements $MonthlyDayCopyWith<$Res> {
  factory _$MonthlyDayCopyWith(
          _MonthlyDay value, $Res Function(_MonthlyDay) _then) =
      __$MonthlyDayCopyWithImpl;
  @override
  @useResult
  $Res call({int day, List<VerdictLevel> judgements});
}

/// @nodoc
class __$MonthlyDayCopyWithImpl<$Res> implements _$MonthlyDayCopyWith<$Res> {
  __$MonthlyDayCopyWithImpl(this._self, this._then);

  final _MonthlyDay _self;
  final $Res Function(_MonthlyDay) _then;

  /// Create a copy of MonthlyDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? day = null,
    Object? judgements = null,
  }) {
    return _then(_MonthlyDay(
      day: null == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      judgements: null == judgements
          ? _self._judgements
          : judgements // ignore: cast_nullable_to_non_nullable
              as List<VerdictLevel>,
    ));
  }
}

/// @nodoc
mixin _$MealCandidatesDay {
  /// 'yyyy-MM-dd'.
  String get date;
  List<MealCandidate> get meals;

  /// Create a copy of MealCandidatesDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCandidatesDayCopyWith<MealCandidatesDay> get copyWith =>
      _$MealCandidatesDayCopyWithImpl<MealCandidatesDay>(
          this as MealCandidatesDay, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealCandidatesDay &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other.meals, meals));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(meals));

  @override
  String toString() {
    return 'MealCandidatesDay(date: $date, meals: $meals)';
  }
}

/// @nodoc
abstract mixin class $MealCandidatesDayCopyWith<$Res> {
  factory $MealCandidatesDayCopyWith(
          MealCandidatesDay value, $Res Function(MealCandidatesDay) _then) =
      _$MealCandidatesDayCopyWithImpl;
  @useResult
  $Res call({String date, List<MealCandidate> meals});
}

/// @nodoc
class _$MealCandidatesDayCopyWithImpl<$Res>
    implements $MealCandidatesDayCopyWith<$Res> {
  _$MealCandidatesDayCopyWithImpl(this._self, this._then);

  final MealCandidatesDay _self;
  final $Res Function(MealCandidatesDay) _then;

  /// Create a copy of MealCandidatesDay
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
              as List<MealCandidate>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealCandidatesDay].
extension MealCandidatesDayPatterns on MealCandidatesDay {
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
    TResult Function(_MealCandidatesDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDay() when $default != null:
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
    TResult Function(_MealCandidatesDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDay():
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
    TResult? Function(_MealCandidatesDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDay() when $default != null:
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
    TResult Function(String date, List<MealCandidate> meals)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDay() when $default != null:
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
    TResult Function(String date, List<MealCandidate> meals) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDay():
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
    TResult? Function(String date, List<MealCandidate> meals)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidatesDay() when $default != null:
        return $default(_that.date, _that.meals);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealCandidatesDay implements MealCandidatesDay {
  const _MealCandidatesDay(
      {required this.date,
      final List<MealCandidate> meals = const <MealCandidate>[]})
      : _meals = meals;

  /// 'yyyy-MM-dd'.
  @override
  final String date;
  final List<MealCandidate> _meals;
  @override
  @JsonKey()
  List<MealCandidate> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  /// Create a copy of MealCandidatesDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCandidatesDayCopyWith<_MealCandidatesDay> get copyWith =>
      __$MealCandidatesDayCopyWithImpl<_MealCandidatesDay>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealCandidatesDay &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._meals, _meals));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_meals));

  @override
  String toString() {
    return 'MealCandidatesDay(date: $date, meals: $meals)';
  }
}

/// @nodoc
abstract mixin class _$MealCandidatesDayCopyWith<$Res>
    implements $MealCandidatesDayCopyWith<$Res> {
  factory _$MealCandidatesDayCopyWith(
          _MealCandidatesDay value, $Res Function(_MealCandidatesDay) _then) =
      __$MealCandidatesDayCopyWithImpl;
  @override
  @useResult
  $Res call({String date, List<MealCandidate> meals});
}

/// @nodoc
class __$MealCandidatesDayCopyWithImpl<$Res>
    implements _$MealCandidatesDayCopyWith<$Res> {
  __$MealCandidatesDayCopyWithImpl(this._self, this._then);

  final _MealCandidatesDay _self;
  final $Res Function(_MealCandidatesDay) _then;

  /// Create a copy of MealCandidatesDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? meals = null,
  }) {
    return _then(_MealCandidatesDay(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      meals: null == meals
          ? _self._meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealCandidate>,
    ));
  }
}

/// @nodoc
mixin _$MealCandidate {
  String get mealRecordId;

  /// representativeFood.name.
  String get representativeFoodName;

  /// representativeFood.category.
  String? get representativeFoodCategory;

  /// 대표 외 추가 음식 수.
  int get otherFoodCount;

  /// ISO.
  String get eatenAt;

  /// Create a copy of MealCandidate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealCandidateCopyWith<MealCandidate> get copyWith =>
      _$MealCandidateCopyWithImpl<MealCandidate>(
          this as MealCandidate, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealCandidate &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.representativeFoodName, representativeFoodName) ||
                other.representativeFoodName == representativeFoodName) &&
            (identical(other.representativeFoodCategory,
                    representativeFoodCategory) ||
                other.representativeFoodCategory ==
                    representativeFoodCategory) &&
            (identical(other.otherFoodCount, otherFoodCount) ||
                other.otherFoodCount == otherFoodCount) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      representativeFoodName,
      representativeFoodCategory,
      otherFoodCount,
      eatenAt);

  @override
  String toString() {
    return 'MealCandidate(mealRecordId: $mealRecordId, representativeFoodName: $representativeFoodName, representativeFoodCategory: $representativeFoodCategory, otherFoodCount: $otherFoodCount, eatenAt: $eatenAt)';
  }
}

/// @nodoc
abstract mixin class $MealCandidateCopyWith<$Res> {
  factory $MealCandidateCopyWith(
          MealCandidate value, $Res Function(MealCandidate) _then) =
      _$MealCandidateCopyWithImpl;
  @useResult
  $Res call(
      {String mealRecordId,
      String representativeFoodName,
      String? representativeFoodCategory,
      int otherFoodCount,
      String eatenAt});
}

/// @nodoc
class _$MealCandidateCopyWithImpl<$Res>
    implements $MealCandidateCopyWith<$Res> {
  _$MealCandidateCopyWithImpl(this._self, this._then);

  final MealCandidate _self;
  final $Res Function(MealCandidate) _then;

  /// Create a copy of MealCandidate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordId = null,
    Object? representativeFoodName = null,
    Object? representativeFoodCategory = freezed,
    Object? otherFoodCount = null,
    Object? eatenAt = null,
  }) {
    return _then(_self.copyWith(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFoodName: null == representativeFoodName
          ? _self.representativeFoodName
          : representativeFoodName // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFoodCategory: freezed == representativeFoodCategory
          ? _self.representativeFoodCategory
          : representativeFoodCategory // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

/// Adds pattern-matching-related methods to [MealCandidate].
extension MealCandidatePatterns on MealCandidate {
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
    TResult Function(_MealCandidate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidate() when $default != null:
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
    TResult Function(_MealCandidate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidate():
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
    TResult? Function(_MealCandidate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidate() when $default != null:
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
            String mealRecordId,
            String representativeFoodName,
            String? representativeFoodCategory,
            int otherFoodCount,
            String eatenAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealCandidate() when $default != null:
        return $default(
            _that.mealRecordId,
            _that.representativeFoodName,
            _that.representativeFoodCategory,
            _that.otherFoodCount,
            _that.eatenAt);
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
            String mealRecordId,
            String representativeFoodName,
            String? representativeFoodCategory,
            int otherFoodCount,
            String eatenAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidate():
        return $default(
            _that.mealRecordId,
            _that.representativeFoodName,
            _that.representativeFoodCategory,
            _that.otherFoodCount,
            _that.eatenAt);
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
            String mealRecordId,
            String representativeFoodName,
            String? representativeFoodCategory,
            int otherFoodCount,
            String eatenAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealCandidate() when $default != null:
        return $default(
            _that.mealRecordId,
            _that.representativeFoodName,
            _that.representativeFoodCategory,
            _that.otherFoodCount,
            _that.eatenAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealCandidate implements MealCandidate {
  const _MealCandidate(
      {required this.mealRecordId,
      required this.representativeFoodName,
      this.representativeFoodCategory,
      this.otherFoodCount = 0,
      required this.eatenAt});

  @override
  final String mealRecordId;

  /// representativeFood.name.
  @override
  final String representativeFoodName;

  /// representativeFood.category.
  @override
  final String? representativeFoodCategory;

  /// 대표 외 추가 음식 수.
  @override
  @JsonKey()
  final int otherFoodCount;

  /// ISO.
  @override
  final String eatenAt;

  /// Create a copy of MealCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealCandidateCopyWith<_MealCandidate> get copyWith =>
      __$MealCandidateCopyWithImpl<_MealCandidate>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealCandidate &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            (identical(other.representativeFoodName, representativeFoodName) ||
                other.representativeFoodName == representativeFoodName) &&
            (identical(other.representativeFoodCategory,
                    representativeFoodCategory) ||
                other.representativeFoodCategory ==
                    representativeFoodCategory) &&
            (identical(other.otherFoodCount, otherFoodCount) ||
                other.otherFoodCount == otherFoodCount) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealRecordId,
      representativeFoodName,
      representativeFoodCategory,
      otherFoodCount,
      eatenAt);

  @override
  String toString() {
    return 'MealCandidate(mealRecordId: $mealRecordId, representativeFoodName: $representativeFoodName, representativeFoodCategory: $representativeFoodCategory, otherFoodCount: $otherFoodCount, eatenAt: $eatenAt)';
  }
}

/// @nodoc
abstract mixin class _$MealCandidateCopyWith<$Res>
    implements $MealCandidateCopyWith<$Res> {
  factory _$MealCandidateCopyWith(
          _MealCandidate value, $Res Function(_MealCandidate) _then) =
      __$MealCandidateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mealRecordId,
      String representativeFoodName,
      String? representativeFoodCategory,
      int otherFoodCount,
      String eatenAt});
}

/// @nodoc
class __$MealCandidateCopyWithImpl<$Res>
    implements _$MealCandidateCopyWith<$Res> {
  __$MealCandidateCopyWithImpl(this._self, this._then);

  final _MealCandidate _self;
  final $Res Function(_MealCandidate) _then;

  /// Create a copy of MealCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? representativeFoodName = null,
    Object? representativeFoodCategory = freezed,
    Object? otherFoodCount = null,
    Object? eatenAt = null,
  }) {
    return _then(_MealCandidate(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFoodName: null == representativeFoodName
          ? _self.representativeFoodName
          : representativeFoodName // ignore: cast_nullable_to_non_nullable
              as String,
      representativeFoodCategory: freezed == representativeFoodCategory
          ? _self.representativeFoodCategory
          : representativeFoodCategory // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

// dart format on
