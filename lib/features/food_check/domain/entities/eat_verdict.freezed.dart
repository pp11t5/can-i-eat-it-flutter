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
mixin _$VerdictItem {
  String get emphasis;
  String get body;

  /// Create a copy of VerdictItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerdictItemCopyWith<VerdictItem> get copyWith =>
      _$VerdictItemCopyWithImpl<VerdictItem>(this as VerdictItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerdictItem &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'VerdictItem(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class $VerdictItemCopyWith<$Res> {
  factory $VerdictItemCopyWith(
          VerdictItem value, $Res Function(VerdictItem) _then) =
      _$VerdictItemCopyWithImpl;
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class _$VerdictItemCopyWithImpl<$Res> implements $VerdictItemCopyWith<$Res> {
  _$VerdictItemCopyWithImpl(this._self, this._then);

  final VerdictItem _self;
  final $Res Function(VerdictItem) _then;

  /// Create a copy of VerdictItem
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

/// Adds pattern-matching-related methods to [VerdictItem].
extension VerdictItemPatterns on VerdictItem {
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
    TResult Function(_VerdictItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictItem() when $default != null:
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
    TResult Function(_VerdictItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictItem():
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
    TResult? Function(_VerdictItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictItem() when $default != null:
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
      case _VerdictItem() when $default != null:
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
      case _VerdictItem():
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
      case _VerdictItem() when $default != null:
        return $default(_that.emphasis, _that.body);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VerdictItem implements VerdictItem {
  const _VerdictItem({required this.emphasis, required this.body});

  @override
  final String emphasis;
  @override
  final String body;

  /// Create a copy of VerdictItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerdictItemCopyWith<_VerdictItem> get copyWith =>
      __$VerdictItemCopyWithImpl<_VerdictItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerdictItem &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'VerdictItem(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$VerdictItemCopyWith<$Res>
    implements $VerdictItemCopyWith<$Res> {
  factory _$VerdictItemCopyWith(
          _VerdictItem value, $Res Function(_VerdictItem) _then) =
      __$VerdictItemCopyWithImpl;
  @override
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class __$VerdictItemCopyWithImpl<$Res> implements _$VerdictItemCopyWith<$Res> {
  __$VerdictItemCopyWithImpl(this._self, this._then);

  final _VerdictItem _self;
  final $Res Function(_VerdictItem) _then;

  /// Create a copy of VerdictItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? emphasis = null,
    Object? body = null,
  }) {
    return _then(_VerdictItem(
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
mixin _$VerdictStateRecord {
  int get stateRecordId;
  String get label;
  String get date; // "YYYY-MM-DD" 문자열 그대로 (표시 전용)
  int get timingMinutes;

  /// Create a copy of VerdictStateRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerdictStateRecordCopyWith<VerdictStateRecord> get copyWith =>
      _$VerdictStateRecordCopyWithImpl<VerdictStateRecord>(
          this as VerdictStateRecord, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerdictStateRecord &&
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
    return 'VerdictStateRecord(stateRecordId: $stateRecordId, label: $label, date: $date, timingMinutes: $timingMinutes)';
  }
}

/// @nodoc
abstract mixin class $VerdictStateRecordCopyWith<$Res> {
  factory $VerdictStateRecordCopyWith(
          VerdictStateRecord value, $Res Function(VerdictStateRecord) _then) =
      _$VerdictStateRecordCopyWithImpl;
  @useResult
  $Res call({int stateRecordId, String label, String date, int timingMinutes});
}

/// @nodoc
class _$VerdictStateRecordCopyWithImpl<$Res>
    implements $VerdictStateRecordCopyWith<$Res> {
  _$VerdictStateRecordCopyWithImpl(this._self, this._then);

  final VerdictStateRecord _self;
  final $Res Function(VerdictStateRecord) _then;

  /// Create a copy of VerdictStateRecord
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
              as int,
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

/// Adds pattern-matching-related methods to [VerdictStateRecord].
extension VerdictStateRecordPatterns on VerdictStateRecord {
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
    TResult Function(_VerdictStateRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecord() when $default != null:
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
    TResult Function(_VerdictStateRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecord():
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
    TResult? Function(_VerdictStateRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecord() when $default != null:
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
            int stateRecordId, String label, String date, int timingMinutes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecord() when $default != null:
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
            int stateRecordId, String label, String date, int timingMinutes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecord():
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
            int stateRecordId, String label, String date, int timingMinutes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecord() when $default != null:
        return $default(
            _that.stateRecordId, _that.label, _that.date, _that.timingMinutes);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VerdictStateRecord extends VerdictStateRecord {
  const _VerdictStateRecord(
      {required this.stateRecordId,
      required this.label,
      required this.date,
      required this.timingMinutes})
      : super._();

  @override
  final int stateRecordId;
  @override
  final String label;
  @override
  final String date;
// "YYYY-MM-DD" 문자열 그대로 (표시 전용)
  @override
  final int timingMinutes;

  /// Create a copy of VerdictStateRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerdictStateRecordCopyWith<_VerdictStateRecord> get copyWith =>
      __$VerdictStateRecordCopyWithImpl<_VerdictStateRecord>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerdictStateRecord &&
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
    return 'VerdictStateRecord(stateRecordId: $stateRecordId, label: $label, date: $date, timingMinutes: $timingMinutes)';
  }
}

/// @nodoc
abstract mixin class _$VerdictStateRecordCopyWith<$Res>
    implements $VerdictStateRecordCopyWith<$Res> {
  factory _$VerdictStateRecordCopyWith(
          _VerdictStateRecord value, $Res Function(_VerdictStateRecord) _then) =
      __$VerdictStateRecordCopyWithImpl;
  @override
  @useResult
  $Res call({int stateRecordId, String label, String date, int timingMinutes});
}

/// @nodoc
class __$VerdictStateRecordCopyWithImpl<$Res>
    implements _$VerdictStateRecordCopyWith<$Res> {
  __$VerdictStateRecordCopyWithImpl(this._self, this._then);

  final _VerdictStateRecord _self;
  final $Res Function(_VerdictStateRecord) _then;

  /// Create a copy of VerdictStateRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stateRecordId = null,
    Object? label = null,
    Object? date = null,
    Object? timingMinutes = null,
  }) {
    return _then(_VerdictStateRecord(
      stateRecordId: null == stateRecordId
          ? _self.stateRecordId
          : stateRecordId // ignore: cast_nullable_to_non_nullable
              as int,
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
mixin _$VerdictStateRecords {
  int get total;
  List<VerdictStateRecord> get records;

  /// Create a copy of VerdictStateRecords
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerdictStateRecordsCopyWith<VerdictStateRecords> get copyWith =>
      _$VerdictStateRecordsCopyWithImpl<VerdictStateRecords>(
          this as VerdictStateRecords, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerdictStateRecords &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other.records, records));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, total, const DeepCollectionEquality().hash(records));

  @override
  String toString() {
    return 'VerdictStateRecords(total: $total, records: $records)';
  }
}

/// @nodoc
abstract mixin class $VerdictStateRecordsCopyWith<$Res> {
  factory $VerdictStateRecordsCopyWith(
          VerdictStateRecords value, $Res Function(VerdictStateRecords) _then) =
      _$VerdictStateRecordsCopyWithImpl;
  @useResult
  $Res call({int total, List<VerdictStateRecord> records});
}

/// @nodoc
class _$VerdictStateRecordsCopyWithImpl<$Res>
    implements $VerdictStateRecordsCopyWith<$Res> {
  _$VerdictStateRecordsCopyWithImpl(this._self, this._then);

  final VerdictStateRecords _self;
  final $Res Function(VerdictStateRecords) _then;

  /// Create a copy of VerdictStateRecords
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
              as List<VerdictStateRecord>,
    ));
  }
}

/// Adds pattern-matching-related methods to [VerdictStateRecords].
extension VerdictStateRecordsPatterns on VerdictStateRecords {
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
    TResult Function(_VerdictStateRecords value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecords() when $default != null:
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
    TResult Function(_VerdictStateRecords value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecords():
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
    TResult? Function(_VerdictStateRecords value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecords() when $default != null:
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
    TResult Function(int total, List<VerdictStateRecord> records)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecords() when $default != null:
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
    TResult Function(int total, List<VerdictStateRecord> records) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecords():
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
    TResult? Function(int total, List<VerdictStateRecord> records)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictStateRecords() when $default != null:
        return $default(_that.total, _that.records);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VerdictStateRecords implements VerdictStateRecords {
  const _VerdictStateRecords(
      {this.total = 0,
      final List<VerdictStateRecord> records = const <VerdictStateRecord>[]})
      : _records = records;

  @override
  @JsonKey()
  final int total;
  final List<VerdictStateRecord> _records;
  @override
  @JsonKey()
  List<VerdictStateRecord> get records {
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_records);
  }

  /// Create a copy of VerdictStateRecords
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerdictStateRecordsCopyWith<_VerdictStateRecords> get copyWith =>
      __$VerdictStateRecordsCopyWithImpl<_VerdictStateRecords>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerdictStateRecords &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, total, const DeepCollectionEquality().hash(_records));

  @override
  String toString() {
    return 'VerdictStateRecords(total: $total, records: $records)';
  }
}

/// @nodoc
abstract mixin class _$VerdictStateRecordsCopyWith<$Res>
    implements $VerdictStateRecordsCopyWith<$Res> {
  factory _$VerdictStateRecordsCopyWith(_VerdictStateRecords value,
          $Res Function(_VerdictStateRecords) _then) =
      __$VerdictStateRecordsCopyWithImpl;
  @override
  @useResult
  $Res call({int total, List<VerdictStateRecord> records});
}

/// @nodoc
class __$VerdictStateRecordsCopyWithImpl<$Res>
    implements _$VerdictStateRecordsCopyWith<$Res> {
  __$VerdictStateRecordsCopyWithImpl(this._self, this._then);

  final _VerdictStateRecords _self;
  final $Res Function(_VerdictStateRecords) _then;

  /// Create a copy of VerdictStateRecords
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? total = null,
    Object? records = null,
  }) {
    return _then(_VerdictStateRecords(
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      records: null == records
          ? _self._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<VerdictStateRecord>,
    ));
  }
}

/// @nodoc
mixin _$VerdictSubstitute {
  String get foodExternalId;
  String get name;

  /// Create a copy of VerdictSubstitute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerdictSubstituteCopyWith<VerdictSubstitute> get copyWith =>
      _$VerdictSubstituteCopyWithImpl<VerdictSubstitute>(
          this as VerdictSubstitute, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerdictSubstitute &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, foodExternalId, name);

  @override
  String toString() {
    return 'VerdictSubstitute(foodExternalId: $foodExternalId, name: $name)';
  }
}

/// @nodoc
abstract mixin class $VerdictSubstituteCopyWith<$Res> {
  factory $VerdictSubstituteCopyWith(
          VerdictSubstitute value, $Res Function(VerdictSubstitute) _then) =
      _$VerdictSubstituteCopyWithImpl;
  @useResult
  $Res call({String foodExternalId, String name});
}

/// @nodoc
class _$VerdictSubstituteCopyWithImpl<$Res>
    implements $VerdictSubstituteCopyWith<$Res> {
  _$VerdictSubstituteCopyWithImpl(this._self, this._then);

  final VerdictSubstitute _self;
  final $Res Function(VerdictSubstitute) _then;

  /// Create a copy of VerdictSubstitute
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

/// Adds pattern-matching-related methods to [VerdictSubstitute].
extension VerdictSubstitutePatterns on VerdictSubstitute {
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
    TResult Function(_VerdictSubstitute value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictSubstitute() when $default != null:
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
    TResult Function(_VerdictSubstitute value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictSubstitute():
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
    TResult? Function(_VerdictSubstitute value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictSubstitute() when $default != null:
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
      case _VerdictSubstitute() when $default != null:
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
      case _VerdictSubstitute():
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
      case _VerdictSubstitute() when $default != null:
        return $default(_that.foodExternalId, _that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VerdictSubstitute implements VerdictSubstitute {
  const _VerdictSubstitute({required this.foodExternalId, required this.name});

  @override
  final String foodExternalId;
  @override
  final String name;

  /// Create a copy of VerdictSubstitute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerdictSubstituteCopyWith<_VerdictSubstitute> get copyWith =>
      __$VerdictSubstituteCopyWithImpl<_VerdictSubstitute>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerdictSubstitute &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, foodExternalId, name);

  @override
  String toString() {
    return 'VerdictSubstitute(foodExternalId: $foodExternalId, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$VerdictSubstituteCopyWith<$Res>
    implements $VerdictSubstituteCopyWith<$Res> {
  factory _$VerdictSubstituteCopyWith(
          _VerdictSubstitute value, $Res Function(_VerdictSubstitute) _then) =
      __$VerdictSubstituteCopyWithImpl;
  @override
  @useResult
  $Res call({String foodExternalId, String name});
}

/// @nodoc
class __$VerdictSubstituteCopyWithImpl<$Res>
    implements _$VerdictSubstituteCopyWith<$Res> {
  __$VerdictSubstituteCopyWithImpl(this._self, this._then);

  final _VerdictSubstitute _self;
  final $Res Function(_VerdictSubstitute) _then;

  /// Create a copy of VerdictSubstitute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodExternalId = null,
    Object? name = null,
  }) {
    return _then(_VerdictSubstitute(
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
mixin _$EatVerdict {
  /// 판정 신호 (grade 매핑).
  VerdictLevel get level;

  /// 음식명 (foodName).
  String get foodName;

  /// 개인화 헤드라인 (personalTitle) — HeroSection 텍스트.
  String get personalTitle;

  /// 분석 항목 2종.
  /// [0] = 트리거/증상 분석, [1] = 알레르기/복용약 분석.
  List<VerdictItem> get items;

  /// 연관 섭취 기록 요약. 기록 없으면 VerdictStateRecords(total:0).
  VerdictStateRecords get stateRecords;

  /// 대체 음식. RECOMMEND·UNKNOWN·by-text 에서 빈배열.
  List<VerdictSubstitute> get substitutes;

  /// 서버 음식 식별자. by-text 판정이면 null.
  String? get foodExternalId;

  /// 음식 분류. by-text 판정이면 null.
  String? get category;

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
            (identical(other.personalTitle, personalTitle) ||
                other.personalTitle == personalTitle) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.stateRecords, stateRecords) ||
                other.stateRecords == stateRecords) &&
            const DeepCollectionEquality()
                .equals(other.substitutes, substitutes) &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      level,
      foodName,
      personalTitle,
      const DeepCollectionEquality().hash(items),
      stateRecords,
      const DeepCollectionEquality().hash(substitutes),
      foodExternalId,
      category);

  @override
  String toString() {
    return 'EatVerdict(level: $level, foodName: $foodName, personalTitle: $personalTitle, items: $items, stateRecords: $stateRecords, substitutes: $substitutes, foodExternalId: $foodExternalId, category: $category)';
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
      String personalTitle,
      List<VerdictItem> items,
      VerdictStateRecords stateRecords,
      List<VerdictSubstitute> substitutes,
      String? foodExternalId,
      String? category});

  $VerdictStateRecordsCopyWith<$Res> get stateRecords;
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
    Object? personalTitle = null,
    Object? items = null,
    Object? stateRecords = null,
    Object? substitutes = null,
    Object? foodExternalId = freezed,
    Object? category = freezed,
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
      personalTitle: null == personalTitle
          ? _self.personalTitle
          : personalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<VerdictItem>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as VerdictStateRecords,
      substitutes: null == substitutes
          ? _self.substitutes
          : substitutes // ignore: cast_nullable_to_non_nullable
              as List<VerdictSubstitute>,
      foodExternalId: freezed == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerdictStateRecordsCopyWith<$Res> get stateRecords {
    return $VerdictStateRecordsCopyWith<$Res>(_self.stateRecords, (value) {
      return _then(_self.copyWith(stateRecords: value));
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
            String personalTitle,
            List<VerdictItem> items,
            VerdictStateRecords stateRecords,
            List<VerdictSubstitute> substitutes,
            String? foodExternalId,
            String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EatVerdict() when $default != null:
        return $default(
            _that.level,
            _that.foodName,
            _that.personalTitle,
            _that.items,
            _that.stateRecords,
            _that.substitutes,
            _that.foodExternalId,
            _that.category);
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
            String personalTitle,
            List<VerdictItem> items,
            VerdictStateRecords stateRecords,
            List<VerdictSubstitute> substitutes,
            String? foodExternalId,
            String? category)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdict():
        return $default(
            _that.level,
            _that.foodName,
            _that.personalTitle,
            _that.items,
            _that.stateRecords,
            _that.substitutes,
            _that.foodExternalId,
            _that.category);
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
            String personalTitle,
            List<VerdictItem> items,
            VerdictStateRecords stateRecords,
            List<VerdictSubstitute> substitutes,
            String? foodExternalId,
            String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EatVerdict() when $default != null:
        return $default(
            _that.level,
            _that.foodName,
            _that.personalTitle,
            _that.items,
            _that.stateRecords,
            _that.substitutes,
            _that.foodExternalId,
            _that.category);
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
      this.personalTitle = '',
      final List<VerdictItem> items = const <VerdictItem>[],
      this.stateRecords = const VerdictStateRecords(),
      final List<VerdictSubstitute> substitutes = const <VerdictSubstitute>[],
      this.foodExternalId,
      this.category})
      : _items = items,
        _substitutes = substitutes;

  /// 판정 신호 (grade 매핑).
  @override
  final VerdictLevel level;

  /// 음식명 (foodName).
  @override
  final String foodName;

  /// 개인화 헤드라인 (personalTitle) — HeroSection 텍스트.
  @override
  @JsonKey()
  final String personalTitle;

  /// 분석 항목 2종.
  /// [0] = 트리거/증상 분석, [1] = 알레르기/복용약 분석.
  final List<VerdictItem> _items;

  /// 분석 항목 2종.
  /// [0] = 트리거/증상 분석, [1] = 알레르기/복용약 분석.
  @override
  @JsonKey()
  List<VerdictItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// 연관 섭취 기록 요약. 기록 없으면 VerdictStateRecords(total:0).
  @override
  @JsonKey()
  final VerdictStateRecords stateRecords;

  /// 대체 음식. RECOMMEND·UNKNOWN·by-text 에서 빈배열.
  final List<VerdictSubstitute> _substitutes;

  /// 대체 음식. RECOMMEND·UNKNOWN·by-text 에서 빈배열.
  @override
  @JsonKey()
  List<VerdictSubstitute> get substitutes {
    if (_substitutes is EqualUnmodifiableListView) return _substitutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_substitutes);
  }

  /// 서버 음식 식별자. by-text 판정이면 null.
  @override
  final String? foodExternalId;

  /// 음식 분류. by-text 판정이면 null.
  @override
  final String? category;

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
            (identical(other.personalTitle, personalTitle) ||
                other.personalTitle == personalTitle) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.stateRecords, stateRecords) ||
                other.stateRecords == stateRecords) &&
            const DeepCollectionEquality()
                .equals(other._substitutes, _substitutes) &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      level,
      foodName,
      personalTitle,
      const DeepCollectionEquality().hash(_items),
      stateRecords,
      const DeepCollectionEquality().hash(_substitutes),
      foodExternalId,
      category);

  @override
  String toString() {
    return 'EatVerdict(level: $level, foodName: $foodName, personalTitle: $personalTitle, items: $items, stateRecords: $stateRecords, substitutes: $substitutes, foodExternalId: $foodExternalId, category: $category)';
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
      String personalTitle,
      List<VerdictItem> items,
      VerdictStateRecords stateRecords,
      List<VerdictSubstitute> substitutes,
      String? foodExternalId,
      String? category});

  @override
  $VerdictStateRecordsCopyWith<$Res> get stateRecords;
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
    Object? personalTitle = null,
    Object? items = null,
    Object? stateRecords = null,
    Object? substitutes = null,
    Object? foodExternalId = freezed,
    Object? category = freezed,
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
      personalTitle: null == personalTitle
          ? _self.personalTitle
          : personalTitle // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<VerdictItem>,
      stateRecords: null == stateRecords
          ? _self.stateRecords
          : stateRecords // ignore: cast_nullable_to_non_nullable
              as VerdictStateRecords,
      substitutes: null == substitutes
          ? _self._substitutes
          : substitutes // ignore: cast_nullable_to_non_nullable
              as List<VerdictSubstitute>,
      foodExternalId: freezed == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of EatVerdict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerdictStateRecordsCopyWith<$Res> get stateRecords {
    return $VerdictStateRecordsCopyWith<$Res>(_self.stateRecords, (value) {
      return _then(_self.copyWith(stateRecords: value));
    });
  }
}

// dart format on
