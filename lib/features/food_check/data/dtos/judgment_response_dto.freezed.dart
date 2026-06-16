// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'judgment_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JudgmentItemDto {
  String get emphasis;
  String get body;

  /// Create a copy of JudgmentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JudgmentItemDtoCopyWith<JudgmentItemDto> get copyWith =>
      _$JudgmentItemDtoCopyWithImpl<JudgmentItemDto>(
          this as JudgmentItemDto, _$identity);

  /// Serializes this JudgmentItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JudgmentItemDto &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'JudgmentItemDto(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class $JudgmentItemDtoCopyWith<$Res> {
  factory $JudgmentItemDtoCopyWith(
          JudgmentItemDto value, $Res Function(JudgmentItemDto) _then) =
      _$JudgmentItemDtoCopyWithImpl;
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class _$JudgmentItemDtoCopyWithImpl<$Res>
    implements $JudgmentItemDtoCopyWith<$Res> {
  _$JudgmentItemDtoCopyWithImpl(this._self, this._then);

  final JudgmentItemDto _self;
  final $Res Function(JudgmentItemDto) _then;

  /// Create a copy of JudgmentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emphasis = null,
    Object? body = null,
  }) {
    return _then(_self.copyWith(
      emphasis: null == emphasis
          ? _self.emphasis
          : emphasis // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [JudgmentItemDto].
extension JudgmentItemDtoPatterns on JudgmentItemDto {
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
    TResult Function(_JudgmentItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JudgmentItemDto() when $default != null:
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
    TResult Function(_JudgmentItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentItemDto():
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
    TResult? Function(_JudgmentItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentItemDto() when $default != null:
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
    TResult Function(String emphasis, String body)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JudgmentItemDto() when $default != null:
        return $default(_that.emphasis, _that.body);
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
    TResult Function(String emphasis, String body) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentItemDto():
        return $default(_that.emphasis, _that.body);
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
    TResult? Function(String emphasis, String body)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentItemDto() when $default != null:
        return $default(_that.emphasis, _that.body);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _JudgmentItemDto implements JudgmentItemDto {
  const _JudgmentItemDto({required this.emphasis, required this.body});
  factory _JudgmentItemDto.fromJson(Map<String, dynamic> json) =>
      _$JudgmentItemDtoFromJson(json);

  @override
  final String emphasis;
  @override
  final String body;

  /// Create a copy of JudgmentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$JudgmentItemDtoCopyWith<_JudgmentItemDto> get copyWith =>
      __$JudgmentItemDtoCopyWithImpl<_JudgmentItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$JudgmentItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _JudgmentItemDto &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'JudgmentItemDto(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$JudgmentItemDtoCopyWith<$Res>
    implements $JudgmentItemDtoCopyWith<$Res> {
  factory _$JudgmentItemDtoCopyWith(
          _JudgmentItemDto value, $Res Function(_JudgmentItemDto) _then) =
      __$JudgmentItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class __$JudgmentItemDtoCopyWithImpl<$Res>
    implements _$JudgmentItemDtoCopyWith<$Res> {
  __$JudgmentItemDtoCopyWithImpl(this._self, this._then);

  final _JudgmentItemDto _self;
  final $Res Function(_JudgmentItemDto) _then;

  /// Create a copy of JudgmentItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? emphasis = null,
    Object? body = null,
  }) {
    return _then(_JudgmentItemDto(
      emphasis: null == emphasis
          ? _self.emphasis
          : emphasis // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$StateRecordDto {
  String get label;
  String get date; // "YYYY-MM-DD" 문자열 그대로
  String get timing;

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
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, date, timing);

  @override
  String toString() {
    return 'StateRecordDto(label: $label, date: $date, timing: $timing)';
  }
}

/// @nodoc
abstract mixin class $StateRecordDtoCopyWith<$Res> {
  factory $StateRecordDtoCopyWith(
          StateRecordDto value, $Res Function(StateRecordDto) _then) =
      _$StateRecordDtoCopyWithImpl;
  @useResult
  $Res call({String label, String date, String timing});
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
    Object? label = null,
    Object? date = null,
    Object? timing = null,
  }) {
    return _then(_self.copyWith(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _self.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
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
    TResult Function(String label, String date, String timing)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
        return $default(_that.label, _that.date, _that.timing);
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
    TResult Function(String label, String date, String timing) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto():
        return $default(_that.label, _that.date, _that.timing);
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
    TResult? Function(String label, String date, String timing)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordDto() when $default != null:
        return $default(_that.label, _that.date, _that.timing);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StateRecordDto implements StateRecordDto {
  const _StateRecordDto(
      {required this.label, required this.date, required this.timing});
  factory _StateRecordDto.fromJson(Map<String, dynamic> json) =>
      _$StateRecordDtoFromJson(json);

  @override
  final String label;
  @override
  final String date;
// "YYYY-MM-DD" 문자열 그대로
  @override
  final String timing;

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
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, date, timing);

  @override
  String toString() {
    return 'StateRecordDto(label: $label, date: $date, timing: $timing)';
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
  $Res call({String label, String date, String timing});
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
    Object? label = null,
    Object? date = null,
    Object? timing = null,
  }) {
    return _then(_StateRecordDto(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _self.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$StateRecordsDto {
  int get total;
  List<StateRecordDto> get records;

  /// Create a copy of StateRecordsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateRecordsDtoCopyWith<StateRecordsDto> get copyWith =>
      _$StateRecordsDtoCopyWithImpl<StateRecordsDto>(
          this as StateRecordsDto, _$identity);

  /// Serializes this StateRecordsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateRecordsDto &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other.records, records));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, total, const DeepCollectionEquality().hash(records));

  @override
  String toString() {
    return 'StateRecordsDto(total: $total, records: $records)';
  }
}

/// @nodoc
abstract mixin class $StateRecordsDtoCopyWith<$Res> {
  factory $StateRecordsDtoCopyWith(
          StateRecordsDto value, $Res Function(StateRecordsDto) _then) =
      _$StateRecordsDtoCopyWithImpl;
  @useResult
  $Res call({int total, List<StateRecordDto> records});
}

/// @nodoc
class _$StateRecordsDtoCopyWithImpl<$Res>
    implements $StateRecordsDtoCopyWith<$Res> {
  _$StateRecordsDtoCopyWithImpl(this._self, this._then);

  final StateRecordsDto _self;
  final $Res Function(StateRecordsDto) _then;

  /// Create a copy of StateRecordsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? records = null,
  }) {
    return _then(_self.copyWith(
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      records: null == records
          ? _self.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<StateRecordDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [StateRecordsDto].
extension StateRecordsDtoPatterns on StateRecordsDto {
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
    TResult Function(_StateRecordsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecordsDto() when $default != null:
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
    TResult Function(_StateRecordsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordsDto():
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
    TResult? Function(_StateRecordsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordsDto() when $default != null:
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
    TResult Function(int total, List<StateRecordDto> records)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StateRecordsDto() when $default != null:
        return $default(_that.total, _that.records);
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
    TResult Function(int total, List<StateRecordDto> records) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordsDto():
        return $default(_that.total, _that.records);
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
    TResult? Function(int total, List<StateRecordDto> records)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StateRecordsDto() when $default != null:
        return $default(_that.total, _that.records);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StateRecordsDto implements StateRecordsDto {
  const _StateRecordsDto(
      {required this.total,
      final List<StateRecordDto> records = const <StateRecordDto>[]})
      : _records = records;
  factory _StateRecordsDto.fromJson(Map<String, dynamic> json) =>
      _$StateRecordsDtoFromJson(json);

  @override
  final int total;
  final List<StateRecordDto> _records;
  @override
  @JsonKey()
  List<StateRecordDto> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

  /// Create a copy of StateRecordsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StateRecordsDtoCopyWith<_StateRecordsDto> get copyWith =>
      __$StateRecordsDtoCopyWithImpl<_StateRecordsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StateRecordsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StateRecordsDto &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, total, const DeepCollectionEquality().hash(_records));

  @override
  String toString() {
    return 'StateRecordsDto(total: $total, records: $records)';
  }
}

/// @nodoc
abstract mixin class _$StateRecordsDtoCopyWith<$Res>
    implements $StateRecordsDtoCopyWith<$Res> {
  factory _$StateRecordsDtoCopyWith(
          _StateRecordsDto value, $Res Function(_StateRecordsDto) _then) =
      __$StateRecordsDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int total, List<StateRecordDto> records});
}

/// @nodoc
class __$StateRecordsDtoCopyWithImpl<$Res>
    implements _$StateRecordsDtoCopyWith<$Res> {
  __$StateRecordsDtoCopyWithImpl(this._self, this._then);

  final _StateRecordsDto _self;
  final $Res Function(_StateRecordsDto) _then;

  /// Create a copy of StateRecordsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? total = null,
    Object? records = null,
  }) {
    return _then(_StateRecordsDto(
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      records: null == records
          ? _self._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<StateRecordDto>,
    ));
  }
}

/// @nodoc
mixin _$SubstituteDto {
  String get foodExternalId;
  String get name;

  /// Create a copy of SubstituteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubstituteDtoCopyWith<SubstituteDto> get copyWith =>
      _$SubstituteDtoCopyWithImpl<SubstituteDto>(
          this as SubstituteDto, _$identity);

  /// Serializes this SubstituteDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubstituteDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodExternalId, name);

  @override
  String toString() {
    return 'SubstituteDto(foodExternalId: $foodExternalId, name: $name)';
  }
}

/// @nodoc
abstract mixin class $SubstituteDtoCopyWith<$Res> {
  factory $SubstituteDtoCopyWith(
          SubstituteDto value, $Res Function(SubstituteDto) _then) =
      _$SubstituteDtoCopyWithImpl;
  @useResult
  $Res call({String foodExternalId, String name});
}

/// @nodoc
class _$SubstituteDtoCopyWithImpl<$Res>
    implements $SubstituteDtoCopyWith<$Res> {
  _$SubstituteDtoCopyWithImpl(this._self, this._then);

  final SubstituteDto _self;
  final $Res Function(SubstituteDto) _then;

  /// Create a copy of SubstituteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodExternalId = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubstituteDto].
extension SubstituteDtoPatterns on SubstituteDto {
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
    TResult Function(_SubstituteDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubstituteDto() when $default != null:
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
    TResult Function(_SubstituteDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubstituteDto():
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
    TResult? Function(_SubstituteDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubstituteDto() when $default != null:
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
    TResult Function(String foodExternalId, String name)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubstituteDto() when $default != null:
        return $default(_that.foodExternalId, _that.name);
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
    TResult Function(String foodExternalId, String name) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubstituteDto():
        return $default(_that.foodExternalId, _that.name);
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
    TResult? Function(String foodExternalId, String name)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubstituteDto() when $default != null:
        return $default(_that.foodExternalId, _that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SubstituteDto implements SubstituteDto {
  const _SubstituteDto({required this.foodExternalId, required this.name});
  factory _SubstituteDto.fromJson(Map<String, dynamic> json) =>
      _$SubstituteDtoFromJson(json);

  @override
  final String foodExternalId;
  @override
  final String name;

  /// Create a copy of SubstituteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubstituteDtoCopyWith<_SubstituteDto> get copyWith =>
      __$SubstituteDtoCopyWithImpl<_SubstituteDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubstituteDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubstituteDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodExternalId, name);

  @override
  String toString() {
    return 'SubstituteDto(foodExternalId: $foodExternalId, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$SubstituteDtoCopyWith<$Res>
    implements $SubstituteDtoCopyWith<$Res> {
  factory _$SubstituteDtoCopyWith(
          _SubstituteDto value, $Res Function(_SubstituteDto) _then) =
      __$SubstituteDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String foodExternalId, String name});
}

/// @nodoc
class __$SubstituteDtoCopyWithImpl<$Res>
    implements _$SubstituteDtoCopyWith<$Res> {
  __$SubstituteDtoCopyWithImpl(this._self, this._then);

  final _SubstituteDto _self;
  final $Res Function(_SubstituteDto) _then;

  /// Create a copy of SubstituteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodExternalId = null,
    Object? name = null,
  }) {
    return _then(_SubstituteDto(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$JudgmentResponseDto {
  String get foodExternalId;
  String get foodName;
  String? get category;
  String get grade; // RECOMMEND|CAUTION|RISK|UNKNOWN
  String get personalTitle;
  List<JudgmentItemDto> get items;
  StateRecordsDto get stateRecords;
  List<SubstituteDto> get substitutes;

  /// Create a copy of JudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JudgmentResponseDtoCopyWith<JudgmentResponseDto> get copyWith =>
      _$JudgmentResponseDtoCopyWithImpl<JudgmentResponseDto>(
          this as JudgmentResponseDto, _$identity);

  /// Serializes this JudgmentResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JudgmentResponseDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.personalTitle, personalTitle) ||
                other.personalTitle == personalTitle) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.stateRecords, stateRecords) ||
                other.stateRecords == stateRecords) &&
            const DeepCollectionEquality()
                .equals(other.substitutes, substitutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      foodExternalId,
      foodName,
      category,
      grade,
      personalTitle,
      const DeepCollectionEquality().hash(items),
      stateRecords,
      const DeepCollectionEquality().hash(substitutes));

  @override
  String toString() {
    return 'JudgmentResponseDto(foodExternalId: $foodExternalId, foodName: $foodName, category: $category, grade: $grade, personalTitle: $personalTitle, items: $items, stateRecords: $stateRecords, substitutes: $substitutes)';
  }
}

/// @nodoc
abstract mixin class $JudgmentResponseDtoCopyWith<$Res> {
  factory $JudgmentResponseDtoCopyWith(
          JudgmentResponseDto value, $Res Function(JudgmentResponseDto) _then) =
      _$JudgmentResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {String foodExternalId,
      String foodName,
      String? category,
      String grade,
      String personalTitle,
      List<JudgmentItemDto> items,
      StateRecordsDto stateRecords,
      List<SubstituteDto> substitutes});

  $StateRecordsDtoCopyWith<$Res> get stateRecords;
}

/// @nodoc
class _$JudgmentResponseDtoCopyWithImpl<$Res>
    implements $JudgmentResponseDtoCopyWith<$Res> {
  _$JudgmentResponseDtoCopyWithImpl(this._self, this._then);

  final JudgmentResponseDto _self;
  final $Res Function(JudgmentResponseDto) _then;

  /// Create a copy of JudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodExternalId = null,
    Object? foodName = null,
    Object? category = freezed,
    Object? grade = null,
    Object? personalTitle = null,
    Object? items = null,
    Object? stateRecords = null,
    Object? substitutes = null,
  }) {
    return _then(_self.copyWith(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      personalTitle: null == personalTitle
          ? _self.personalTitle
          : personalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<JudgmentItemDto>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as StateRecordsDto,
      substitutes: null == substitutes
          ? _self.substitutes
          : substitutes // ignore: cast_nullable_to_non_nullable
              as List<SubstituteDto>,
    ));
  }

  /// Create a copy of JudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateRecordsDtoCopyWith<$Res> get stateRecords {
    return $StateRecordsDtoCopyWith<$Res>(_self.stateRecords, (value) {
      return _then(_self.copyWith(stateRecords: value));
    });
  }
}

/// Adds pattern-matching-related methods to [JudgmentResponseDto].
extension JudgmentResponseDtoPatterns on JudgmentResponseDto {
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
    TResult Function(_JudgmentResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JudgmentResponseDto() when $default != null:
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
    TResult Function(_JudgmentResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentResponseDto():
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
    TResult? Function(_JudgmentResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentResponseDto() when $default != null:
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
            String foodExternalId,
            String foodName,
            String? category,
            String grade,
            String personalTitle,
            List<JudgmentItemDto> items,
            StateRecordsDto stateRecords,
            List<SubstituteDto> substitutes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JudgmentResponseDto() when $default != null:
        return $default(
            _that.foodExternalId,
            _that.foodName,
            _that.category,
            _that.grade,
            _that.personalTitle,
            _that.items,
            _that.stateRecords,
            _that.substitutes);
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
            String foodExternalId,
            String foodName,
            String? category,
            String grade,
            String personalTitle,
            List<JudgmentItemDto> items,
            StateRecordsDto stateRecords,
            List<SubstituteDto> substitutes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentResponseDto():
        return $default(
            _that.foodExternalId,
            _that.foodName,
            _that.category,
            _that.grade,
            _that.personalTitle,
            _that.items,
            _that.stateRecords,
            _that.substitutes);
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
            String foodExternalId,
            String foodName,
            String? category,
            String grade,
            String personalTitle,
            List<JudgmentItemDto> items,
            StateRecordsDto stateRecords,
            List<SubstituteDto> substitutes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JudgmentResponseDto() when $default != null:
        return $default(
            _that.foodExternalId,
            _that.foodName,
            _that.category,
            _that.grade,
            _that.personalTitle,
            _that.items,
            _that.stateRecords,
            _that.substitutes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _JudgmentResponseDto implements JudgmentResponseDto {
  const _JudgmentResponseDto(
      {required this.foodExternalId,
      required this.foodName,
      this.category,
      required this.grade,
      required this.personalTitle,
      final List<JudgmentItemDto> items = const <JudgmentItemDto>[],
      required this.stateRecords,
      final List<SubstituteDto> substitutes = const <SubstituteDto>[]})
      : _items = items,
        _substitutes = substitutes;
  factory _JudgmentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$JudgmentResponseDtoFromJson(json);

  @override
  final String foodExternalId;
  @override
  final String foodName;
  @override
  final String? category;
  @override
  final String grade;
// RECOMMEND|CAUTION|RISK|UNKNOWN
  @override
  final String personalTitle;
  final List<JudgmentItemDto> _items;
  @override
  @JsonKey()
  List<JudgmentItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final StateRecordsDto stateRecords;
  final List<SubstituteDto> _substitutes;
  @override
  @JsonKey()
  List<SubstituteDto> get substitutes {
    if (_substitutes is EqualUnmodifiableListView) return _substitutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_substitutes);
  }

  /// Create a copy of JudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$JudgmentResponseDtoCopyWith<_JudgmentResponseDto> get copyWith =>
      __$JudgmentResponseDtoCopyWithImpl<_JudgmentResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$JudgmentResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _JudgmentResponseDto &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.personalTitle, personalTitle) ||
                other.personalTitle == personalTitle) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.stateRecords, stateRecords) ||
                other.stateRecords == stateRecords) &&
            const DeepCollectionEquality()
                .equals(other._substitutes, _substitutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      foodExternalId,
      foodName,
      category,
      grade,
      personalTitle,
      const DeepCollectionEquality().hash(_items),
      stateRecords,
      const DeepCollectionEquality().hash(_substitutes));

  @override
  String toString() {
    return 'JudgmentResponseDto(foodExternalId: $foodExternalId, foodName: $foodName, category: $category, grade: $grade, personalTitle: $personalTitle, items: $items, stateRecords: $stateRecords, substitutes: $substitutes)';
  }
}

/// @nodoc
abstract mixin class _$JudgmentResponseDtoCopyWith<$Res>
    implements $JudgmentResponseDtoCopyWith<$Res> {
  factory _$JudgmentResponseDtoCopyWith(_JudgmentResponseDto value,
          $Res Function(_JudgmentResponseDto) _then) =
      __$JudgmentResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodExternalId,
      String foodName,
      String? category,
      String grade,
      String personalTitle,
      List<JudgmentItemDto> items,
      StateRecordsDto stateRecords,
      List<SubstituteDto> substitutes});

  @override
  $StateRecordsDtoCopyWith<$Res> get stateRecords;
}

/// @nodoc
class __$JudgmentResponseDtoCopyWithImpl<$Res>
    implements _$JudgmentResponseDtoCopyWith<$Res> {
  __$JudgmentResponseDtoCopyWithImpl(this._self, this._then);

  final _JudgmentResponseDto _self;
  final $Res Function(_JudgmentResponseDto) _then;

  /// Create a copy of JudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodExternalId = null,
    Object? foodName = null,
    Object? category = freezed,
    Object? grade = null,
    Object? personalTitle = null,
    Object? items = null,
    Object? stateRecords = null,
    Object? substitutes = null,
  }) {
    return _then(_JudgmentResponseDto(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      personalTitle: null == personalTitle
          ? _self.personalTitle
          : personalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<JudgmentItemDto>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as StateRecordsDto,
      substitutes: null == substitutes
          ? _self._substitutes
          : substitutes // ignore: cast_nullable_to_non_nullable
              as List<SubstituteDto>,
    ));
  }

  /// Create a copy of JudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateRecordsDtoCopyWith<$Res> get stateRecords {
    return $StateRecordsDtoCopyWith<$Res>(_self.stateRecords, (value) {
      return _then(_self.copyWith(stateRecords: value));
    });
  }
}

/// @nodoc
mixin _$TextJudgmentResponseDto {
  String get foodName;
  String get grade;
  String get personalTitle;
  List<JudgmentItemDto> get items;
  StateRecordsDto get stateRecords;

  /// Create a copy of TextJudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TextJudgmentResponseDtoCopyWith<TextJudgmentResponseDto> get copyWith =>
      _$TextJudgmentResponseDtoCopyWithImpl<TextJudgmentResponseDto>(
          this as TextJudgmentResponseDto, _$identity);

  /// Serializes this TextJudgmentResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TextJudgmentResponseDto &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.personalTitle, personalTitle) ||
                other.personalTitle == personalTitle) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.stateRecords, stateRecords) ||
                other.stateRecords == stateRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, grade, personalTitle,
      const DeepCollectionEquality().hash(items), stateRecords);

  @override
  String toString() {
    return 'TextJudgmentResponseDto(foodName: $foodName, grade: $grade, personalTitle: $personalTitle, items: $items, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class $TextJudgmentResponseDtoCopyWith<$Res> {
  factory $TextJudgmentResponseDtoCopyWith(TextJudgmentResponseDto value,
          $Res Function(TextJudgmentResponseDto) _then) =
      _$TextJudgmentResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {String foodName,
      String grade,
      String personalTitle,
      List<JudgmentItemDto> items,
      StateRecordsDto stateRecords});

  $StateRecordsDtoCopyWith<$Res> get stateRecords;
}

/// @nodoc
class _$TextJudgmentResponseDtoCopyWithImpl<$Res>
    implements $TextJudgmentResponseDtoCopyWith<$Res> {
  _$TextJudgmentResponseDtoCopyWithImpl(this._self, this._then);

  final TextJudgmentResponseDto _self;
  final $Res Function(TextJudgmentResponseDto) _then;

  /// Create a copy of TextJudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? grade = null,
    Object? personalTitle = null,
    Object? items = null,
    Object? stateRecords = null,
  }) {
    return _then(_self.copyWith(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      personalTitle: null == personalTitle
          ? _self.personalTitle
          : personalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<JudgmentItemDto>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as StateRecordsDto,
    ));
  }

  /// Create a copy of TextJudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateRecordsDtoCopyWith<$Res> get stateRecords {
    return $StateRecordsDtoCopyWith<$Res>(_self.stateRecords, (value) {
      return _then(_self.copyWith(stateRecords: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TextJudgmentResponseDto].
extension TextJudgmentResponseDtoPatterns on TextJudgmentResponseDto {
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
    TResult Function(_TextJudgmentResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TextJudgmentResponseDto() when $default != null:
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
    TResult Function(_TextJudgmentResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextJudgmentResponseDto():
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
    TResult? Function(_TextJudgmentResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextJudgmentResponseDto() when $default != null:
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
    TResult Function(String foodName, String grade, String personalTitle,
            List<JudgmentItemDto> items, StateRecordsDto stateRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TextJudgmentResponseDto() when $default != null:
        return $default(_that.foodName, _that.grade, _that.personalTitle,
            _that.items, _that.stateRecords);
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
    TResult Function(String foodName, String grade, String personalTitle,
            List<JudgmentItemDto> items, StateRecordsDto stateRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextJudgmentResponseDto():
        return $default(_that.foodName, _that.grade, _that.personalTitle,
            _that.items, _that.stateRecords);
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
    TResult? Function(String foodName, String grade, String personalTitle,
            List<JudgmentItemDto> items, StateRecordsDto stateRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextJudgmentResponseDto() when $default != null:
        return $default(_that.foodName, _that.grade, _that.personalTitle,
            _that.items, _that.stateRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TextJudgmentResponseDto implements TextJudgmentResponseDto {
  const _TextJudgmentResponseDto(
      {required this.foodName,
      required this.grade,
      required this.personalTitle,
      final List<JudgmentItemDto> items = const <JudgmentItemDto>[],
      required this.stateRecords})
      : _items = items;
  factory _TextJudgmentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TextJudgmentResponseDtoFromJson(json);

  @override
  final String foodName;
  @override
  final String grade;
  @override
  final String personalTitle;
  final List<JudgmentItemDto> _items;
  @override
  @JsonKey()
  List<JudgmentItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final StateRecordsDto stateRecords;

  /// Create a copy of TextJudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TextJudgmentResponseDtoCopyWith<_TextJudgmentResponseDto> get copyWith =>
      __$TextJudgmentResponseDtoCopyWithImpl<_TextJudgmentResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TextJudgmentResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TextJudgmentResponseDto &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.personalTitle, personalTitle) ||
                other.personalTitle == personalTitle) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.stateRecords, stateRecords) ||
                other.stateRecords == stateRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, grade, personalTitle,
      const DeepCollectionEquality().hash(_items), stateRecords);

  @override
  String toString() {
    return 'TextJudgmentResponseDto(foodName: $foodName, grade: $grade, personalTitle: $personalTitle, items: $items, stateRecords: $stateRecords)';
  }
}

/// @nodoc
abstract mixin class _$TextJudgmentResponseDtoCopyWith<$Res>
    implements $TextJudgmentResponseDtoCopyWith<$Res> {
  factory _$TextJudgmentResponseDtoCopyWith(_TextJudgmentResponseDto value,
          $Res Function(_TextJudgmentResponseDto) _then) =
      __$TextJudgmentResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodName,
      String grade,
      String personalTitle,
      List<JudgmentItemDto> items,
      StateRecordsDto stateRecords});

  @override
  $StateRecordsDtoCopyWith<$Res> get stateRecords;
}

/// @nodoc
class __$TextJudgmentResponseDtoCopyWithImpl<$Res>
    implements _$TextJudgmentResponseDtoCopyWith<$Res> {
  __$TextJudgmentResponseDtoCopyWithImpl(this._self, this._then);

  final _TextJudgmentResponseDto _self;
  final $Res Function(_TextJudgmentResponseDto) _then;

  /// Create a copy of TextJudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodName = null,
    Object? grade = null,
    Object? personalTitle = null,
    Object? items = null,
    Object? stateRecords = null,
  }) {
    return _then(_TextJudgmentResponseDto(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      personalTitle: null == personalTitle
          ? _self.personalTitle
          : personalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<JudgmentItemDto>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as StateRecordsDto,
    ));
  }

  /// Create a copy of TextJudgmentResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StateRecordsDtoCopyWith<$Res> get stateRecords {
    return $StateRecordsDtoCopyWith<$Res>(_self.stateRecords, (value) {
      return _then(_self.copyWith(stateRecords: value));
    });
  }
}

// dart format on
