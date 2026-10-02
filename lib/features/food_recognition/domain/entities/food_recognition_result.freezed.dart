// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_recognition_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodCandidate {
  /// 음식명. 자유 문자열 — 150클래스 제약은 OnDevice 구현 내부 사정이며,
  /// 이 라벨은 검색어로 기존 `food_check`의 judgeByText/judgeById에 넘어간다.
  String get label;

  /// 신뢰도 점수.
  ///
  /// OnDevice: softmax 원점수(재정규화 없음, `top3_output.md` 그대로).
  /// Gemini: 항상 null — Gemini는 확률을 산출하지 않으므로 점수를 지어내지 않는다.
  double? get score;

  /// Create a copy of FoodCandidate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodCandidateCopyWith<FoodCandidate> get copyWith =>
      _$FoodCandidateCopyWithImpl<FoodCandidate>(
          this as FoodCandidate, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodCandidate &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, score);

  @override
  String toString() {
    return 'FoodCandidate(label: $label, score: $score)';
  }
}

/// @nodoc
abstract mixin class $FoodCandidateCopyWith<$Res> {
  factory $FoodCandidateCopyWith(
          FoodCandidate value, $Res Function(FoodCandidate) _then) =
      _$FoodCandidateCopyWithImpl;
  @useResult
  $Res call({String label, double? score});
}

/// @nodoc
class _$FoodCandidateCopyWithImpl<$Res>
    implements $FoodCandidateCopyWith<$Res> {
  _$FoodCandidateCopyWithImpl(this._self, this._then);

  final FoodCandidate _self;
  final $Res Function(FoodCandidate) _then;

  /// Create a copy of FoodCandidate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? score = freezed,
  }) {
    return _then(_self.copyWith(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodCandidate].
extension FoodCandidatePatterns on FoodCandidate {
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
    TResult Function(_FoodCandidate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodCandidate() when $default != null:
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
    TResult Function(_FoodCandidate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCandidate():
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
    TResult? Function(_FoodCandidate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCandidate() when $default != null:
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
    TResult Function(String label, double? score)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodCandidate() when $default != null:
        return $default(_that.label, _that.score);
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
    TResult Function(String label, double? score) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCandidate():
        return $default(_that.label, _that.score);
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
    TResult? Function(String label, double? score)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCandidate() when $default != null:
        return $default(_that.label, _that.score);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodCandidate implements FoodCandidate {
  const _FoodCandidate({required this.label, this.score});

  /// 음식명. 자유 문자열 — 150클래스 제약은 OnDevice 구현 내부 사정이며,
  /// 이 라벨은 검색어로 기존 `food_check`의 judgeByText/judgeById에 넘어간다.
  @override
  final String label;

  /// 신뢰도 점수.
  ///
  /// OnDevice: softmax 원점수(재정규화 없음, `top3_output.md` 그대로).
  /// Gemini: 항상 null — Gemini는 확률을 산출하지 않으므로 점수를 지어내지 않는다.
  @override
  final double? score;

  /// Create a copy of FoodCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodCandidateCopyWith<_FoodCandidate> get copyWith =>
      __$FoodCandidateCopyWithImpl<_FoodCandidate>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodCandidate &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, score);

  @override
  String toString() {
    return 'FoodCandidate(label: $label, score: $score)';
  }
}

/// @nodoc
abstract mixin class _$FoodCandidateCopyWith<$Res>
    implements $FoodCandidateCopyWith<$Res> {
  factory _$FoodCandidateCopyWith(
          _FoodCandidate value, $Res Function(_FoodCandidate) _then) =
      __$FoodCandidateCopyWithImpl;
  @override
  @useResult
  $Res call({String label, double? score});
}

/// @nodoc
class __$FoodCandidateCopyWithImpl<$Res>
    implements _$FoodCandidateCopyWith<$Res> {
  __$FoodCandidateCopyWithImpl(this._self, this._then);

  final _FoodCandidate _self;
  final $Res Function(_FoodCandidate) _then;

  /// Create a copy of FoodCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? score = freezed,
  }) {
    return _then(_FoodCandidate(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$FoodRecognitionResult {
  /// 인식 후보 목록. 0~3개 (Top-3, `top3_output.md`).
  List<FoodCandidate> get candidates;

  /// 이 결과를 생성한 엔진.
  RecognitionSource get source;

  /// Create a copy of FoodRecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodRecognitionResultCopyWith<FoodRecognitionResult> get copyWith =>
      _$FoodRecognitionResultCopyWithImpl<FoodRecognitionResult>(
          this as FoodRecognitionResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodRecognitionResult &&
            const DeepCollectionEquality()
                .equals(other.candidates, candidates) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(candidates), source);

  @override
  String toString() {
    return 'FoodRecognitionResult(candidates: $candidates, source: $source)';
  }
}

/// @nodoc
abstract mixin class $FoodRecognitionResultCopyWith<$Res> {
  factory $FoodRecognitionResultCopyWith(FoodRecognitionResult value,
          $Res Function(FoodRecognitionResult) _then) =
      _$FoodRecognitionResultCopyWithImpl;
  @useResult
  $Res call({List<FoodCandidate> candidates, RecognitionSource source});
}

/// @nodoc
class _$FoodRecognitionResultCopyWithImpl<$Res>
    implements $FoodRecognitionResultCopyWith<$Res> {
  _$FoodRecognitionResultCopyWithImpl(this._self, this._then);

  final FoodRecognitionResult _self;
  final $Res Function(FoodRecognitionResult) _then;

  /// Create a copy of FoodRecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidates = null,
    Object? source = null,
  }) {
    return _then(_self.copyWith(
      candidates: null == candidates
          ? _self.candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<FoodCandidate>,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as RecognitionSource,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodRecognitionResult].
extension FoodRecognitionResultPatterns on FoodRecognitionResult {
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
    TResult Function(_FoodRecognitionResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodRecognitionResult() when $default != null:
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
    TResult Function(_FoodRecognitionResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodRecognitionResult():
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
    TResult? Function(_FoodRecognitionResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodRecognitionResult() when $default != null:
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
    TResult Function(List<FoodCandidate> candidates, RecognitionSource source)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodRecognitionResult() when $default != null:
        return $default(_that.candidates, _that.source);
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
    TResult Function(List<FoodCandidate> candidates, RecognitionSource source)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodRecognitionResult():
        return $default(_that.candidates, _that.source);
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
    TResult? Function(List<FoodCandidate> candidates, RecognitionSource source)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodRecognitionResult() when $default != null:
        return $default(_that.candidates, _that.source);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodRecognitionResult implements FoodRecognitionResult {
  const _FoodRecognitionResult(
      {final List<FoodCandidate> candidates = const <FoodCandidate>[],
      required this.source})
      : _candidates = candidates;

  /// 인식 후보 목록. 0~3개 (Top-3, `top3_output.md`).
  final List<FoodCandidate> _candidates;

  /// 인식 후보 목록. 0~3개 (Top-3, `top3_output.md`).
  @override
  @JsonKey()
  List<FoodCandidate> get candidates {
    if (_candidates is EqualUnmodifiableListView) return _candidates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidates);
  }

  /// 이 결과를 생성한 엔진.
  @override
  final RecognitionSource source;

  /// Create a copy of FoodRecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodRecognitionResultCopyWith<_FoodRecognitionResult> get copyWith =>
      __$FoodRecognitionResultCopyWithImpl<_FoodRecognitionResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodRecognitionResult &&
            const DeepCollectionEquality()
                .equals(other._candidates, _candidates) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_candidates), source);

  @override
  String toString() {
    return 'FoodRecognitionResult(candidates: $candidates, source: $source)';
  }
}

/// @nodoc
abstract mixin class _$FoodRecognitionResultCopyWith<$Res>
    implements $FoodRecognitionResultCopyWith<$Res> {
  factory _$FoodRecognitionResultCopyWith(_FoodRecognitionResult value,
          $Res Function(_FoodRecognitionResult) _then) =
      __$FoodRecognitionResultCopyWithImpl;
  @override
  @useResult
  $Res call({List<FoodCandidate> candidates, RecognitionSource source});
}

/// @nodoc
class __$FoodRecognitionResultCopyWithImpl<$Res>
    implements _$FoodRecognitionResultCopyWith<$Res> {
  __$FoodRecognitionResultCopyWithImpl(this._self, this._then);

  final _FoodRecognitionResult _self;
  final $Res Function(_FoodRecognitionResult) _then;

  /// Create a copy of FoodRecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? candidates = null,
    Object? source = null,
  }) {
    return _then(_FoodRecognitionResult(
      candidates: null == candidates
          ? _self._candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<FoodCandidate>,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as RecognitionSource,
    ));
  }
}

// dart format on
