// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteItem {
  String get foodName;
  VerdictLevel get level;
  DateTime get savedAt;
  String? get foodExternalId;

  /// Create a copy of FavoriteItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FavoriteItemCopyWith<FavoriteItem> get copyWith =>
      _$FavoriteItemCopyWithImpl<FavoriteItem>(
          this as FavoriteItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FavoriteItem &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodName, level, savedAt, foodExternalId);

  @override
  String toString() {
    return 'FavoriteItem(foodName: $foodName, level: $level, savedAt: $savedAt, foodExternalId: $foodExternalId)';
  }
}

/// @nodoc
abstract mixin class $FavoriteItemCopyWith<$Res> {
  factory $FavoriteItemCopyWith(
          FavoriteItem value, $Res Function(FavoriteItem) _then) =
      _$FavoriteItemCopyWithImpl;
  @useResult
  $Res call(
      {String foodName,
      VerdictLevel level,
      DateTime savedAt,
      String? foodExternalId});
}

/// @nodoc
class _$FavoriteItemCopyWithImpl<$Res> implements $FavoriteItemCopyWith<$Res> {
  _$FavoriteItemCopyWithImpl(this._self, this._then);

  final FavoriteItem _self;
  final $Res Function(FavoriteItem) _then;

  /// Create a copy of FavoriteItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? level = null,
    Object? savedAt = null,
    Object? foodExternalId = freezed,
  }) {
    return _then(_self.copyWith(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      savedAt: null == savedAt
          ? _self.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      foodExternalId: freezed == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FavoriteItem].
extension FavoriteItemPatterns on FavoriteItem {
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
    TResult Function(_FavoriteItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FavoriteItem() when $default != null:
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
    TResult Function(_FavoriteItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavoriteItem():
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
    TResult? Function(_FavoriteItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavoriteItem() when $default != null:
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
    TResult Function(String foodName, VerdictLevel level, DateTime savedAt,
            String? foodExternalId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FavoriteItem() when $default != null:
        return $default(
            _that.foodName, _that.level, _that.savedAt, _that.foodExternalId);
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
    TResult Function(String foodName, VerdictLevel level, DateTime savedAt,
            String? foodExternalId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavoriteItem():
        return $default(
            _that.foodName, _that.level, _that.savedAt, _that.foodExternalId);
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
    TResult? Function(String foodName, VerdictLevel level, DateTime savedAt,
            String? foodExternalId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FavoriteItem() when $default != null:
        return $default(
            _that.foodName, _that.level, _that.savedAt, _that.foodExternalId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FavoriteItem implements FavoriteItem {
  const _FavoriteItem(
      {required this.foodName,
      required this.level,
      required this.savedAt,
      this.foodExternalId});

  @override
  final String foodName;
  @override
  final VerdictLevel level;
  @override
  final DateTime savedAt;
  @override
  final String? foodExternalId;

  /// Create a copy of FavoriteItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FavoriteItemCopyWith<_FavoriteItem> get copyWith =>
      __$FavoriteItemCopyWithImpl<_FavoriteItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FavoriteItem &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodName, level, savedAt, foodExternalId);

  @override
  String toString() {
    return 'FavoriteItem(foodName: $foodName, level: $level, savedAt: $savedAt, foodExternalId: $foodExternalId)';
  }
}

/// @nodoc
abstract mixin class _$FavoriteItemCopyWith<$Res>
    implements $FavoriteItemCopyWith<$Res> {
  factory _$FavoriteItemCopyWith(
          _FavoriteItem value, $Res Function(_FavoriteItem) _then) =
      __$FavoriteItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodName,
      VerdictLevel level,
      DateTime savedAt,
      String? foodExternalId});
}

/// @nodoc
class __$FavoriteItemCopyWithImpl<$Res>
    implements _$FavoriteItemCopyWith<$Res> {
  __$FavoriteItemCopyWithImpl(this._self, this._then);

  final _FavoriteItem _self;
  final $Res Function(_FavoriteItem) _then;

  /// Create a copy of FavoriteItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodName = null,
    Object? level = null,
    Object? savedAt = null,
    Object? foodExternalId = freezed,
  }) {
    return _then(_FavoriteItem(
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
      savedAt: null == savedAt
          ? _self.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      foodExternalId: freezed == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
