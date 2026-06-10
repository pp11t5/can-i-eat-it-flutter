// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentFood {
  /// 서버측 음식 식별자. POST /foods/recent 호출 시 사용.
  String get foodExternalId;

  /// 음식 표시 이름.
  String get name;

  /// 음식 카테고리. 서버가 없으면 null.
  String? get category;

  /// 검색(저장)된 시각.
  DateTime get searchedAt;

  /// Create a copy of RecentFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecentFoodCopyWith<RecentFood> get copyWith =>
      _$RecentFoodCopyWithImpl<RecentFood>(this as RecentFood, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecentFood &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.searchedAt, searchedAt) ||
                other.searchedAt == searchedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodExternalId, name, category, searchedAt);

  @override
  String toString() {
    return 'RecentFood(foodExternalId: $foodExternalId, name: $name, category: $category, searchedAt: $searchedAt)';
  }
}

/// @nodoc
abstract mixin class $RecentFoodCopyWith<$Res> {
  factory $RecentFoodCopyWith(
          RecentFood value, $Res Function(RecentFood) _then) =
      _$RecentFoodCopyWithImpl;
  @useResult
  $Res call(
      {String foodExternalId,
      String name,
      String? category,
      DateTime searchedAt});
}

/// @nodoc
class _$RecentFoodCopyWithImpl<$Res> implements $RecentFoodCopyWith<$Res> {
  _$RecentFoodCopyWithImpl(this._self, this._then);

  final RecentFood _self;
  final $Res Function(RecentFood) _then;

  /// Create a copy of RecentFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodExternalId = null,
    Object? name = null,
    Object? category = freezed,
    Object? searchedAt = null,
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
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      searchedAt: null == searchedAt
          ? _self.searchedAt
          : searchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecentFood].
extension RecentFoodPatterns on RecentFood {
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
    TResult Function(_RecentFood value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentFood() when $default != null:
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
    TResult Function(_RecentFood value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFood():
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
    TResult? Function(_RecentFood value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFood() when $default != null:
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
    TResult Function(String foodExternalId, String name, String? category,
            DateTime searchedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentFood() when $default != null:
        return $default(
            _that.foodExternalId, _that.name, _that.category, _that.searchedAt);
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
    TResult Function(String foodExternalId, String name, String? category,
            DateTime searchedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFood():
        return $default(
            _that.foodExternalId, _that.name, _that.category, _that.searchedAt);
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
    TResult? Function(String foodExternalId, String name, String? category,
            DateTime searchedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFood() when $default != null:
        return $default(
            _that.foodExternalId, _that.name, _that.category, _that.searchedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RecentFood implements RecentFood {
  const _RecentFood(
      {required this.foodExternalId,
      required this.name,
      this.category,
      required this.searchedAt});

  /// 서버측 음식 식별자. POST /foods/recent 호출 시 사용.
  @override
  final String foodExternalId;

  /// 음식 표시 이름.
  @override
  final String name;

  /// 음식 카테고리. 서버가 없으면 null.
  @override
  final String? category;

  /// 검색(저장)된 시각.
  @override
  final DateTime searchedAt;

  /// Create a copy of RecentFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecentFoodCopyWith<_RecentFood> get copyWith =>
      __$RecentFoodCopyWithImpl<_RecentFood>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecentFood &&
            (identical(other.foodExternalId, foodExternalId) ||
                other.foodExternalId == foodExternalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.searchedAt, searchedAt) ||
                other.searchedAt == searchedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodExternalId, name, category, searchedAt);

  @override
  String toString() {
    return 'RecentFood(foodExternalId: $foodExternalId, name: $name, category: $category, searchedAt: $searchedAt)';
  }
}

/// @nodoc
abstract mixin class _$RecentFoodCopyWith<$Res>
    implements $RecentFoodCopyWith<$Res> {
  factory _$RecentFoodCopyWith(
          _RecentFood value, $Res Function(_RecentFood) _then) =
      __$RecentFoodCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodExternalId,
      String name,
      String? category,
      DateTime searchedAt});
}

/// @nodoc
class __$RecentFoodCopyWithImpl<$Res> implements _$RecentFoodCopyWith<$Res> {
  __$RecentFoodCopyWithImpl(this._self, this._then);

  final _RecentFood _self;
  final $Res Function(_RecentFood) _then;

  /// Create a copy of RecentFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodExternalId = null,
    Object? name = null,
    Object? category = freezed,
    Object? searchedAt = null,
  }) {
    return _then(_RecentFood(
      foodExternalId: null == foodExternalId
          ? _self.foodExternalId
          : foodExternalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      searchedAt: null == searchedAt
          ? _self.searchedAt
          : searchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
