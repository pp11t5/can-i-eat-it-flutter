// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dictionary_food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DictionaryFoodItem {
  /// 음식 식별자 (서버 foodId).
  String get foodId;

  /// 음식 표시 이름.
  String get name;

  /// 음식 카테고리 코드. 서버 미제공 시 null.
  String? get categoryCode;

  /// 신호등 판정.
  VerdictLevel get verdict;

  /// Create a copy of DictionaryFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DictionaryFoodItemCopyWith<DictionaryFoodItem> get copyWith =>
      _$DictionaryFoodItemCopyWithImpl<DictionaryFoodItem>(
          this as DictionaryFoodItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DictionaryFoodItem &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryCode, categoryCode) ||
                other.categoryCode == categoryCode) &&
            (identical(other.verdict, verdict) || other.verdict == verdict));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodId, name, categoryCode, verdict);

  @override
  String toString() {
    return 'DictionaryFoodItem(foodId: $foodId, name: $name, categoryCode: $categoryCode, verdict: $verdict)';
  }
}

/// @nodoc
abstract mixin class $DictionaryFoodItemCopyWith<$Res> {
  factory $DictionaryFoodItemCopyWith(
          DictionaryFoodItem value, $Res Function(DictionaryFoodItem) _then) =
      _$DictionaryFoodItemCopyWithImpl;
  @useResult
  $Res call(
      {String foodId, String name, String? categoryCode, VerdictLevel verdict});
}

/// @nodoc
class _$DictionaryFoodItemCopyWithImpl<$Res>
    implements $DictionaryFoodItemCopyWith<$Res> {
  _$DictionaryFoodItemCopyWithImpl(this._self, this._then);

  final DictionaryFoodItem _self;
  final $Res Function(DictionaryFoodItem) _then;

  /// Create a copy of DictionaryFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? categoryCode = freezed,
    Object? verdict = null,
  }) {
    return _then(_self.copyWith(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categoryCode: freezed == categoryCode
          ? _self.categoryCode
          : categoryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      verdict: null == verdict
          ? _self.verdict
          : verdict // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
    ));
  }
}

/// Adds pattern-matching-related methods to [DictionaryFoodItem].
extension DictionaryFoodItemPatterns on DictionaryFoodItem {
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
    TResult Function(_DictionaryFoodItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryFoodItem() when $default != null:
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
    TResult Function(_DictionaryFoodItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryFoodItem():
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
    TResult? Function(_DictionaryFoodItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryFoodItem() when $default != null:
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
    TResult Function(String foodId, String name, String? categoryCode,
            VerdictLevel verdict)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryFoodItem() when $default != null:
        return $default(
            _that.foodId, _that.name, _that.categoryCode, _that.verdict);
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
    TResult Function(String foodId, String name, String? categoryCode,
            VerdictLevel verdict)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryFoodItem():
        return $default(
            _that.foodId, _that.name, _that.categoryCode, _that.verdict);
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
    TResult? Function(String foodId, String name, String? categoryCode,
            VerdictLevel verdict)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryFoodItem() when $default != null:
        return $default(
            _that.foodId, _that.name, _that.categoryCode, _that.verdict);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DictionaryFoodItem implements DictionaryFoodItem {
  const _DictionaryFoodItem(
      {required this.foodId,
      required this.name,
      this.categoryCode,
      required this.verdict});

  /// 음식 식별자 (서버 foodId).
  @override
  final String foodId;

  /// 음식 표시 이름.
  @override
  final String name;

  /// 음식 카테고리 코드. 서버 미제공 시 null.
  @override
  final String? categoryCode;

  /// 신호등 판정.
  @override
  final VerdictLevel verdict;

  /// Create a copy of DictionaryFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DictionaryFoodItemCopyWith<_DictionaryFoodItem> get copyWith =>
      __$DictionaryFoodItemCopyWithImpl<_DictionaryFoodItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DictionaryFoodItem &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryCode, categoryCode) ||
                other.categoryCode == categoryCode) &&
            (identical(other.verdict, verdict) || other.verdict == verdict));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodId, name, categoryCode, verdict);

  @override
  String toString() {
    return 'DictionaryFoodItem(foodId: $foodId, name: $name, categoryCode: $categoryCode, verdict: $verdict)';
  }
}

/// @nodoc
abstract mixin class _$DictionaryFoodItemCopyWith<$Res>
    implements $DictionaryFoodItemCopyWith<$Res> {
  factory _$DictionaryFoodItemCopyWith(
          _DictionaryFoodItem value, $Res Function(_DictionaryFoodItem) _then) =
      __$DictionaryFoodItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodId, String name, String? categoryCode, VerdictLevel verdict});
}

/// @nodoc
class __$DictionaryFoodItemCopyWithImpl<$Res>
    implements _$DictionaryFoodItemCopyWith<$Res> {
  __$DictionaryFoodItemCopyWithImpl(this._self, this._then);

  final _DictionaryFoodItem _self;
  final $Res Function(_DictionaryFoodItem) _then;

  /// Create a copy of DictionaryFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? categoryCode = freezed,
    Object? verdict = null,
  }) {
    return _then(_DictionaryFoodItem(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categoryCode: freezed == categoryCode
          ? _self.categoryCode
          : categoryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      verdict: null == verdict
          ? _self.verdict
          : verdict // ignore: cast_nullable_to_non_nullable
              as VerdictLevel,
    ));
  }
}

/// @nodoc
mixin _$DictionaryPage {
  /// 이번 페이지 항목 목록.
  List<DictionaryFoodItem> get items;

  /// 다음 페이지 커서. null 이면 더 없음.
  int? get nextCursor;

  /// 다음 페이지 존재 여부.
  bool get hasNext;

  /// Create a copy of DictionaryPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DictionaryPageCopyWith<DictionaryPage> get copyWith =>
      _$DictionaryPageCopyWithImpl<DictionaryPage>(
          this as DictionaryPage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DictionaryPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), nextCursor, hasNext);

  @override
  String toString() {
    return 'DictionaryPage(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class $DictionaryPageCopyWith<$Res> {
  factory $DictionaryPageCopyWith(
          DictionaryPage value, $Res Function(DictionaryPage) _then) =
      _$DictionaryPageCopyWithImpl;
  @useResult
  $Res call({List<DictionaryFoodItem> items, int? nextCursor, bool hasNext});
}

/// @nodoc
class _$DictionaryPageCopyWithImpl<$Res>
    implements $DictionaryPageCopyWith<$Res> {
  _$DictionaryPageCopyWithImpl(this._self, this._then);

  final DictionaryPage _self;
  final $Res Function(DictionaryPage) _then;

  /// Create a copy of DictionaryPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<DictionaryFoodItem>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [DictionaryPage].
extension DictionaryPagePatterns on DictionaryPage {
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
    TResult Function(_DictionaryPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryPage() when $default != null:
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
    TResult Function(_DictionaryPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryPage():
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
    TResult? Function(_DictionaryPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryPage() when $default != null:
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
            List<DictionaryFoodItem> items, int? nextCursor, bool hasNext)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryPage() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
            List<DictionaryFoodItem> items, int? nextCursor, bool hasNext)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryPage():
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
            List<DictionaryFoodItem> items, int? nextCursor, bool hasNext)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryPage() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DictionaryPage implements DictionaryPage {
  const _DictionaryPage(
      {final List<DictionaryFoodItem> items = const <DictionaryFoodItem>[],
      this.nextCursor,
      this.hasNext = false})
      : _items = items;

  /// 이번 페이지 항목 목록.
  final List<DictionaryFoodItem> _items;

  /// 이번 페이지 항목 목록.
  @override
  @JsonKey()
  List<DictionaryFoodItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// 다음 페이지 커서. null 이면 더 없음.
  @override
  final int? nextCursor;

  /// 다음 페이지 존재 여부.
  @override
  @JsonKey()
  final bool hasNext;

  /// Create a copy of DictionaryPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DictionaryPageCopyWith<_DictionaryPage> get copyWith =>
      __$DictionaryPageCopyWithImpl<_DictionaryPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DictionaryPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, hasNext);

  @override
  String toString() {
    return 'DictionaryPage(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class _$DictionaryPageCopyWith<$Res>
    implements $DictionaryPageCopyWith<$Res> {
  factory _$DictionaryPageCopyWith(
          _DictionaryPage value, $Res Function(_DictionaryPage) _then) =
      __$DictionaryPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<DictionaryFoodItem> items, int? nextCursor, bool hasNext});
}

/// @nodoc
class __$DictionaryPageCopyWithImpl<$Res>
    implements _$DictionaryPageCopyWith<$Res> {
  __$DictionaryPageCopyWithImpl(this._self, this._then);

  final _DictionaryPage _self;
  final $Res Function(_DictionaryPage) _then;

  /// Create a copy of DictionaryPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_DictionaryPage(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<DictionaryFoodItem>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$DictionaryCount {
  /// 권장(안전) 음식 수.
  int get safeCount;

  /// 주의·위험 음식 수.
  int get cautionRiskCount;

  /// Create a copy of DictionaryCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DictionaryCountCopyWith<DictionaryCount> get copyWith =>
      _$DictionaryCountCopyWithImpl<DictionaryCount>(
          this as DictionaryCount, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DictionaryCount &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionRiskCount, cautionRiskCount) ||
                other.cautionRiskCount == cautionRiskCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionRiskCount);

  @override
  String toString() {
    return 'DictionaryCount(safeCount: $safeCount, cautionRiskCount: $cautionRiskCount)';
  }
}

/// @nodoc
abstract mixin class $DictionaryCountCopyWith<$Res> {
  factory $DictionaryCountCopyWith(
          DictionaryCount value, $Res Function(DictionaryCount) _then) =
      _$DictionaryCountCopyWithImpl;
  @useResult
  $Res call({int safeCount, int cautionRiskCount});
}

/// @nodoc
class _$DictionaryCountCopyWithImpl<$Res>
    implements $DictionaryCountCopyWith<$Res> {
  _$DictionaryCountCopyWithImpl(this._self, this._then);

  final DictionaryCount _self;
  final $Res Function(DictionaryCount) _then;

  /// Create a copy of DictionaryCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? safeCount = null,
    Object? cautionRiskCount = null,
  }) {
    return _then(_self.copyWith(
      safeCount: null == safeCount
          ? _self.safeCount
          : safeCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionRiskCount: null == cautionRiskCount
          ? _self.cautionRiskCount
          : cautionRiskCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [DictionaryCount].
extension DictionaryCountPatterns on DictionaryCount {
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
    TResult Function(_DictionaryCount value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryCount() when $default != null:
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
    TResult Function(_DictionaryCount value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCount():
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
    TResult? Function(_DictionaryCount value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCount() when $default != null:
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
    TResult Function(int safeCount, int cautionRiskCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DictionaryCount() when $default != null:
        return $default(_that.safeCount, _that.cautionRiskCount);
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
    TResult Function(int safeCount, int cautionRiskCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCount():
        return $default(_that.safeCount, _that.cautionRiskCount);
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
    TResult? Function(int safeCount, int cautionRiskCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DictionaryCount() when $default != null:
        return $default(_that.safeCount, _that.cautionRiskCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DictionaryCount implements DictionaryCount {
  const _DictionaryCount(
      {required this.safeCount, required this.cautionRiskCount});

  /// 권장(안전) 음식 수.
  @override
  final int safeCount;

  /// 주의·위험 음식 수.
  @override
  final int cautionRiskCount;

  /// Create a copy of DictionaryCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DictionaryCountCopyWith<_DictionaryCount> get copyWith =>
      __$DictionaryCountCopyWithImpl<_DictionaryCount>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DictionaryCount &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionRiskCount, cautionRiskCount) ||
                other.cautionRiskCount == cautionRiskCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionRiskCount);

  @override
  String toString() {
    return 'DictionaryCount(safeCount: $safeCount, cautionRiskCount: $cautionRiskCount)';
  }
}

/// @nodoc
abstract mixin class _$DictionaryCountCopyWith<$Res>
    implements $DictionaryCountCopyWith<$Res> {
  factory _$DictionaryCountCopyWith(
          _DictionaryCount value, $Res Function(_DictionaryCount) _then) =
      __$DictionaryCountCopyWithImpl;
  @override
  @useResult
  $Res call({int safeCount, int cautionRiskCount});
}

/// @nodoc
class __$DictionaryCountCopyWithImpl<$Res>
    implements _$DictionaryCountCopyWith<$Res> {
  __$DictionaryCountCopyWithImpl(this._self, this._then);

  final _DictionaryCount _self;
  final $Res Function(_DictionaryCount) _then;

  /// Create a copy of DictionaryCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? safeCount = null,
    Object? cautionRiskCount = null,
  }) {
    return _then(_DictionaryCount(
      safeCount: null == safeCount
          ? _self.safeCount
          : safeCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionRiskCount: null == cautionRiskCount
          ? _self.cautionRiskCount
          : cautionRiskCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
