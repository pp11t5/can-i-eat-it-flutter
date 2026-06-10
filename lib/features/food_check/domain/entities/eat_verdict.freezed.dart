// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eat_verdict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EatVerdict {
  /// 판정 신호.
  VerdictLevel get level;

  /// 분석 대상 음식명.
  String get foodName;

  /// Section 1 — 일반 분석. [unknown]에서는 비어 있을 수 있다.
  String get reasonGeneral;

  /// Section 2 — 개인화 맞춤 분석. [unknown]에서는 비어 있을 수 있다.
  String get reasonPersonal;

  /// 대체 음식 목록 (Section 2 하단).
  ///
  /// [recommend]·[unknown] 에서는 비어 있어야 한다(ADR-0003 §4).
  /// [caution]·[danger] 에서는 서버가 1~3개를 채울 수 있다.
  List<String> get alternatives;

  /// Section 3 — 이 음식 섭취 후 기록 요약. 기록 없으면 [VerdictHistorySummary.empty].
  VerdictHistorySummary get historySummary;

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EatVerdictCopyWith<EatVerdict> get copyWith =>
      _$EatVerdictCopyWithImpl<EatVerdict>(this as EatVerdict, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EatVerdict &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.reasonGeneral, reasonGeneral) ||
                other.reasonGeneral == reasonGeneral) &&
            (identical(other.reasonPersonal, reasonPersonal) ||
                other.reasonPersonal == reasonPersonal) &&
            const DeepCollectionEquality()
                .equals(other.alternatives, alternatives) &&
            (identical(other.historySummary, historySummary) ||
                other.historySummary == historySummary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      level,
      foodName,
      reasonGeneral,
      reasonPersonal,
      const DeepCollectionEquality().hash(alternatives),
      historySummary);

  @override
  String toString() {
    return 'EatVerdict(level: $level, foodName: $foodName, reasonGeneral: $reasonGeneral, reasonPersonal: $reasonPersonal, alternatives: $alternatives, historySummary: $historySummary)';
  }
}

/// @nodoc
abstract mixin class $EatVerdictCopyWith<$Res> {
  factory $EatVerdictCopyWith(
          EatVerdict value, $Res Function(EatVerdict) _then) =
      _$EatVerdictCopyWithImpl;
  @useResult
  $Res call(
      {VerdictLevel level,
      String foodName,
      String reasonGeneral,
      String reasonPersonal,
      List<String> alternatives,
      VerdictHistorySummary historySummary});

  $VerdictHistorySummaryCopyWith<$Res> get historySummary;
}

/// @nodoc
class _$EatVerdictCopyWithImpl<$Res> implements $EatVerdictCopyWith<$Res> {
  _$EatVerdictCopyWithImpl(this._self, this._then);

  final EatVerdict _self;
  final $Res Function(EatVerdict) _then;

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? foodName = null,
    Object? reasonGeneral = null,
    Object? reasonPersonal = null,
    Object? alternatives = null,
    Object? historySummary = null,
  }) {
    return _then(_self.copyWith(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      reasonGeneral: null == reasonGeneral
          ? _self.reasonGeneral
          : reasonGeneral // ignore: cast_nullable_to_non_nullable
              as String,
      reasonPersonal: null == reasonPersonal
          ? _self.reasonPersonal
          : reasonPersonal // ignore: cast_nullable_to_non_nullable
              as String,
      alternatives: null == alternatives
          ? _self.alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      historySummary: null == historySummary
          ? _self.historySummary
          : historySummary // ignore: cast_nullable_to_non_nullable
              as VerdictHistorySummary,
    ));
  }

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerdictHistorySummaryCopyWith<$Res> get historySummary {
    return $VerdictHistorySummaryCopyWith<$Res>(_self.historySummary, (value) {
      return _then(_self.copyWith(historySummary: value));
    });
  }
}

/// Adds pattern-matching-related methods to [EatVerdict].
extension EatVerdictPatterns on EatVerdict {
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
    TResult Function(_EatVerdict value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EatVerdict() when $default != null:
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
    TResult Function(_EatVerdict value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdict():
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
    TResult? Function(_EatVerdict value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdict() when $default != null:
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
            VerdictLevel level,
            String foodName,
            String reasonGeneral,
            String reasonPersonal,
            List<String> alternatives,
            VerdictHistorySummary historySummary)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EatVerdict() when $default != null:
        return $default(_that.level, _that.foodName, _that.reasonGeneral,
            _that.reasonPersonal, _that.alternatives, _that.historySummary);
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
            VerdictLevel level,
            String foodName,
            String reasonGeneral,
            String reasonPersonal,
            List<String> alternatives,
            VerdictHistorySummary historySummary)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdict():
        return $default(_that.level, _that.foodName, _that.reasonGeneral,
            _that.reasonPersonal, _that.alternatives, _that.historySummary);
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
            VerdictLevel level,
            String foodName,
            String reasonGeneral,
            String reasonPersonal,
            List<String> alternatives,
            VerdictHistorySummary historySummary)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdict() when $default != null:
        return $default(_that.level, _that.foodName, _that.reasonGeneral,
            _that.reasonPersonal, _that.alternatives, _that.historySummary);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _EatVerdict implements EatVerdict {
  const _EatVerdict(
      {required this.level,
      required this.foodName,
      this.reasonGeneral = '',
      this.reasonPersonal = '',
      final List<String> alternatives = const <String>[],
      this.historySummary = const VerdictHistorySummary()})
      : _alternatives = alternatives;

  /// 판정 신호.
  @override
  final VerdictLevel level;

  /// 분석 대상 음식명.
  @override
  final String foodName;

  /// Section 1 — 일반 분석. [unknown]에서는 비어 있을 수 있다.
  @override
  @JsonKey()
  final String reasonGeneral;

  /// Section 2 — 개인화 맞춤 분석. [unknown]에서는 비어 있을 수 있다.
  @override
  @JsonKey()
  final String reasonPersonal;

  /// 대체 음식 목록 (Section 2 하단).
  ///
  /// [recommend]·[unknown] 에서는 비어 있어야 한다(ADR-0003 §4).
  /// [caution]·[danger] 에서는 서버가 1~3개를 채울 수 있다.
  final List<String> _alternatives;

  /// 대체 음식 목록 (Section 2 하단).
  ///
  /// [recommend]·[unknown] 에서는 비어 있어야 한다(ADR-0003 §4).
  /// [caution]·[danger] 에서는 서버가 1~3개를 채울 수 있다.
  @override
  @JsonKey()
  List<String> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  /// Section 3 — 이 음식 섭취 후 기록 요약. 기록 없으면 [VerdictHistorySummary.empty].
  @override
  @JsonKey()
  final VerdictHistorySummary historySummary;

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EatVerdictCopyWith<_EatVerdict> get copyWith =>
      __$EatVerdictCopyWithImpl<_EatVerdict>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EatVerdict &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.reasonGeneral, reasonGeneral) ||
                other.reasonGeneral == reasonGeneral) &&
            (identical(other.reasonPersonal, reasonPersonal) ||
                other.reasonPersonal == reasonPersonal) &&
            const DeepCollectionEquality()
                .equals(other._alternatives, _alternatives) &&
            (identical(other.historySummary, historySummary) ||
                other.historySummary == historySummary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      level,
      foodName,
      reasonGeneral,
      reasonPersonal,
      const DeepCollectionEquality().hash(_alternatives),
      historySummary);

  @override
  String toString() {
    return 'EatVerdict(level: $level, foodName: $foodName, reasonGeneral: $reasonGeneral, reasonPersonal: $reasonPersonal, alternatives: $alternatives, historySummary: $historySummary)';
  }
}

/// @nodoc
abstract mixin class _$EatVerdictCopyWith<$Res>
    implements $EatVerdictCopyWith<$Res> {
  factory _$EatVerdictCopyWith(
          _EatVerdict value, $Res Function(_EatVerdict) _then) =
      __$EatVerdictCopyWithImpl;
  @override
  @useResult
  $Res call(
      {VerdictLevel level,
      String foodName,
      String reasonGeneral,
      String reasonPersonal,
      List<String> alternatives,
      VerdictHistorySummary historySummary});

  @override
  $VerdictHistorySummaryCopyWith<$Res> get historySummary;
}

/// @nodoc
class __$EatVerdictCopyWithImpl<$Res> implements _$EatVerdictCopyWith<$Res> {
  __$EatVerdictCopyWithImpl(this._self, this._then);

  final _EatVerdict _self;
  final $Res Function(_EatVerdict) _then;

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = null,
    Object? foodName = null,
    Object? reasonGeneral = null,
    Object? reasonPersonal = null,
    Object? alternatives = null,
    Object? historySummary = null,
  }) {
    return _then(_EatVerdict(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      reasonGeneral: null == reasonGeneral
          ? _self.reasonGeneral
          : reasonGeneral // ignore: cast_nullable_to_non_nullable
              as String,
      reasonPersonal: null == reasonPersonal
          ? _self.reasonPersonal
          : reasonPersonal // ignore: cast_nullable_to_non_nullable
              as String,
      alternatives: null == alternatives
          ? _self._alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      historySummary: null == historySummary
          ? _self.historySummary
          : historySummary // ignore: cast_nullable_to_non_nullable
              as VerdictHistorySummary,
    ));
  }

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerdictHistorySummaryCopyWith<$Res> get historySummary {
    return $VerdictHistorySummaryCopyWith<$Res>(_self.historySummary, (value) {
      return _then(_self.copyWith(historySummary: value));
    });
  }
}

// dart format on
