// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verdict_history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerdictHistoryItem {
  String get foodName;
  String get verdict;
  DateTime get checkedAt;

  /// Create a copy of VerdictHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerdictHistoryItemCopyWith<VerdictHistoryItem> get copyWith =>
      _$VerdictHistoryItemCopyWithImpl<VerdictHistoryItem>(
          this as VerdictHistoryItem, _$identity);

  /// Serializes this VerdictHistoryItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerdictHistoryItem &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            (identical(other.checkedAt, checkedAt) ||
                other.checkedAt == checkedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, verdict, checkedAt);

  @override
  String toString() {
    return 'VerdictHistoryItem(foodName: $foodName, verdict: $verdict, checkedAt: $checkedAt)';
  }
}

/// @nodoc
abstract mixin class $VerdictHistoryItemCopyWith<$Res> {
  factory $VerdictHistoryItemCopyWith(
          VerdictHistoryItem value, $Res Function(VerdictHistoryItem) _then) =
      _$VerdictHistoryItemCopyWithImpl;
  @useResult
  $Res call({String foodName, String verdict, DateTime checkedAt});
}

/// @nodoc
class _$VerdictHistoryItemCopyWithImpl<$Res>
    implements $VerdictHistoryItemCopyWith<$Res> {
  _$VerdictHistoryItemCopyWithImpl(this._self, this._then);

  final VerdictHistoryItem _self;
  final $Res Function(VerdictHistoryItem) _then;

  /// Create a copy of VerdictHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? verdict = null,
    Object? checkedAt = null,
  }) {
    return _then(_self.copyWith(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      verdict: null == verdict
          ? _self.verdict
          : verdict // ignore: cast_nullable_to_non_nullable
              as String,
      checkedAt: null == checkedAt
          ? _self.checkedAt
          : checkedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [VerdictHistoryItem].
extension VerdictHistoryItemPatterns on VerdictHistoryItem {
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
    TResult Function(_VerdictHistoryItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictHistoryItem() when $default != null:
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
    TResult Function(_VerdictHistoryItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistoryItem():
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
    TResult? Function(_VerdictHistoryItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistoryItem() when $default != null:
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
    TResult Function(String foodName, String verdict, DateTime checkedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerdictHistoryItem() when $default != null:
        return $default(_that.foodName, _that.verdict, _that.checkedAt);
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
    TResult Function(String foodName, String verdict, DateTime checkedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistoryItem():
        return $default(_that.foodName, _that.verdict, _that.checkedAt);
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
    TResult? Function(String foodName, String verdict, DateTime checkedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerdictHistoryItem() when $default != null:
        return $default(_that.foodName, _that.verdict, _that.checkedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VerdictHistoryItem implements VerdictHistoryItem {
  const _VerdictHistoryItem(
      {required this.foodName, required this.verdict, required this.checkedAt});
  factory _VerdictHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$VerdictHistoryItemFromJson(json);

  @override
  final String foodName;
  @override
  final String verdict;
  @override
  final DateTime checkedAt;

  /// Create a copy of VerdictHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerdictHistoryItemCopyWith<_VerdictHistoryItem> get copyWith =>
      __$VerdictHistoryItemCopyWithImpl<_VerdictHistoryItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VerdictHistoryItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerdictHistoryItem &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            (identical(other.checkedAt, checkedAt) ||
                other.checkedAt == checkedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, verdict, checkedAt);

  @override
  String toString() {
    return 'VerdictHistoryItem(foodName: $foodName, verdict: $verdict, checkedAt: $checkedAt)';
  }
}

/// @nodoc
abstract mixin class _$VerdictHistoryItemCopyWith<$Res>
    implements $VerdictHistoryItemCopyWith<$Res> {
  factory _$VerdictHistoryItemCopyWith(
          _VerdictHistoryItem value, $Res Function(_VerdictHistoryItem) _then) =
      __$VerdictHistoryItemCopyWithImpl;
  @override
  @useResult
  $Res call({String foodName, String verdict, DateTime checkedAt});
}

/// @nodoc
class __$VerdictHistoryItemCopyWithImpl<$Res>
    implements _$VerdictHistoryItemCopyWith<$Res> {
  __$VerdictHistoryItemCopyWithImpl(this._self, this._then);

  final _VerdictHistoryItem _self;
  final $Res Function(_VerdictHistoryItem) _then;

  /// Create a copy of VerdictHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodName = null,
    Object? verdict = null,
    Object? checkedAt = null,
  }) {
    return _then(_VerdictHistoryItem(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      verdict: null == verdict
          ? _self.verdict
          : verdict // ignore: cast_nullable_to_non_nullable
              as String,
      checkedAt: null == checkedAt
          ? _self.checkedAt
          : checkedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
