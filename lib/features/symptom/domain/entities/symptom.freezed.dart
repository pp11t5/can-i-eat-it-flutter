// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symptom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SymptomAnalysisItem {
  /// 강조 문구.
  String get emphasis;

  /// 본문.
  String get body;

  /// Create a copy of SymptomAnalysisItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomAnalysisItemCopyWith<SymptomAnalysisItem> get copyWith =>
      _$SymptomAnalysisItemCopyWithImpl<SymptomAnalysisItem>(
          this as SymptomAnalysisItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomAnalysisItem &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'SymptomAnalysisItem(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class $SymptomAnalysisItemCopyWith<$Res> {
  factory $SymptomAnalysisItemCopyWith(
          SymptomAnalysisItem value, $Res Function(SymptomAnalysisItem) _then) =
      _$SymptomAnalysisItemCopyWithImpl;
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class _$SymptomAnalysisItemCopyWithImpl<$Res>
    implements $SymptomAnalysisItemCopyWith<$Res> {
  _$SymptomAnalysisItemCopyWithImpl(this._self, this._then);

  final SymptomAnalysisItem _self;
  final $Res Function(SymptomAnalysisItem) _then;

  /// Create a copy of SymptomAnalysisItem
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

/// Adds pattern-matching-related methods to [SymptomAnalysisItem].
extension SymptomAnalysisItemPatterns on SymptomAnalysisItem {
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
    TResult Function(_SymptomAnalysisItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItem() when $default != null:
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
    TResult Function(_SymptomAnalysisItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItem():
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
    TResult? Function(_SymptomAnalysisItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomAnalysisItem() when $default != null:
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
      case _SymptomAnalysisItem() when $default != null:
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
      case _SymptomAnalysisItem():
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
      case _SymptomAnalysisItem() when $default != null:
        return $default(_that.emphasis, _that.body);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SymptomAnalysisItem implements SymptomAnalysisItem {
  const _SymptomAnalysisItem({required this.emphasis, required this.body});

  /// 강조 문구.
  @override
  final String emphasis;

  /// 본문.
  @override
  final String body;

  /// Create a copy of SymptomAnalysisItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomAnalysisItemCopyWith<_SymptomAnalysisItem> get copyWith =>
      __$SymptomAnalysisItemCopyWithImpl<_SymptomAnalysisItem>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomAnalysisItem &&
            (identical(other.emphasis, emphasis) ||
                other.emphasis == emphasis) &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emphasis, body);

  @override
  String toString() {
    return 'SymptomAnalysisItem(emphasis: $emphasis, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$SymptomAnalysisItemCopyWith<$Res>
    implements $SymptomAnalysisItemCopyWith<$Res> {
  factory _$SymptomAnalysisItemCopyWith(_SymptomAnalysisItem value,
          $Res Function(_SymptomAnalysisItem) _then) =
      __$SymptomAnalysisItemCopyWithImpl;
  @override
  @useResult
  $Res call({String emphasis, String body});
}

/// @nodoc
class __$SymptomAnalysisItemCopyWithImpl<$Res>
    implements _$SymptomAnalysisItemCopyWith<$Res> {
  __$SymptomAnalysisItemCopyWithImpl(this._self, this._then);

  final _SymptomAnalysisItem _self;
  final $Res Function(_SymptomAnalysisItem) _then;

  /// Create a copy of SymptomAnalysisItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? emphasis = null,
    Object? body = null,
  }) {
    return _then(_SymptomAnalysisItem(
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
mixin _$SymptomLinkedFood {
  /// 음식 식별자.
  String get mealFoodId;

  /// 음식 표시 이름.
  String get name;

  /// 음식 카테고리. 서버가 없으면 null.
  String? get category;

  /// Create a copy of SymptomLinkedFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomLinkedFoodCopyWith<SymptomLinkedFood> get copyWith =>
      _$SymptomLinkedFoodCopyWithImpl<SymptomLinkedFood>(
          this as SymptomLinkedFood, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomLinkedFood &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealFoodId, name, category);

  @override
  String toString() {
    return 'SymptomLinkedFood(mealFoodId: $mealFoodId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class $SymptomLinkedFoodCopyWith<$Res> {
  factory $SymptomLinkedFoodCopyWith(
          SymptomLinkedFood value, $Res Function(SymptomLinkedFood) _then) =
      _$SymptomLinkedFoodCopyWithImpl;
  @useResult
  $Res call({String mealFoodId, String name, String? category});
}

/// @nodoc
class _$SymptomLinkedFoodCopyWithImpl<$Res>
    implements $SymptomLinkedFoodCopyWith<$Res> {
  _$SymptomLinkedFoodCopyWithImpl(this._self, this._then);

  final SymptomLinkedFood _self;
  final $Res Function(SymptomLinkedFood) _then;

  /// Create a copy of SymptomLinkedFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomLinkedFood].
extension SymptomLinkedFoodPatterns on SymptomLinkedFood {
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
    TResult Function(_SymptomLinkedFood value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFood() when $default != null:
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
    TResult Function(_SymptomLinkedFood value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFood():
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
    TResult? Function(_SymptomLinkedFood value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFood() when $default != null:
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
    TResult Function(String mealFoodId, String name, String? category)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFood() when $default != null:
        return $default(_that.mealFoodId, _that.name, _that.category);
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
    TResult Function(String mealFoodId, String name, String? category) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFood():
        return $default(_that.mealFoodId, _that.name, _that.category);
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
    TResult? Function(String mealFoodId, String name, String? category)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedFood() when $default != null:
        return $default(_that.mealFoodId, _that.name, _that.category);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SymptomLinkedFood implements SymptomLinkedFood {
  const _SymptomLinkedFood(
      {required this.mealFoodId, required this.name, this.category});

  /// 음식 식별자.
  @override
  final String mealFoodId;

  /// 음식 표시 이름.
  @override
  final String name;

  /// 음식 카테고리. 서버가 없으면 null.
  @override
  final String? category;

  /// Create a copy of SymptomLinkedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomLinkedFoodCopyWith<_SymptomLinkedFood> get copyWith =>
      __$SymptomLinkedFoodCopyWithImpl<_SymptomLinkedFood>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomLinkedFood &&
            (identical(other.mealFoodId, mealFoodId) ||
                other.mealFoodId == mealFoodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealFoodId, name, category);

  @override
  String toString() {
    return 'SymptomLinkedFood(mealFoodId: $mealFoodId, name: $name, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$SymptomLinkedFoodCopyWith<$Res>
    implements $SymptomLinkedFoodCopyWith<$Res> {
  factory _$SymptomLinkedFoodCopyWith(
          _SymptomLinkedFood value, $Res Function(_SymptomLinkedFood) _then) =
      __$SymptomLinkedFoodCopyWithImpl;
  @override
  @useResult
  $Res call({String mealFoodId, String name, String? category});
}

/// @nodoc
class __$SymptomLinkedFoodCopyWithImpl<$Res>
    implements _$SymptomLinkedFoodCopyWith<$Res> {
  __$SymptomLinkedFoodCopyWithImpl(this._self, this._then);

  final _SymptomLinkedFood _self;
  final $Res Function(_SymptomLinkedFood) _then;

  /// Create a copy of SymptomLinkedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealFoodId = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(_SymptomLinkedFood(
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
    ));
  }
}

/// @nodoc
mixin _$SymptomLinkedMeal {
  /// 연결 식사 기록 식별자.
  String get mealRecordId;

  /// 연결 식사 내 음식 목록.
  List<SymptomLinkedFood> get foods;

  /// Create a copy of SymptomLinkedMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomLinkedMealCopyWith<SymptomLinkedMeal> get copyWith =>
      _$SymptomLinkedMealCopyWithImpl<SymptomLinkedMeal>(
          this as SymptomLinkedMeal, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymptomLinkedMeal &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            const DeepCollectionEquality().equals(other.foods, foods));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordId, const DeepCollectionEquality().hash(foods));

  @override
  String toString() {
    return 'SymptomLinkedMeal(mealRecordId: $mealRecordId, foods: $foods)';
  }
}

/// @nodoc
abstract mixin class $SymptomLinkedMealCopyWith<$Res> {
  factory $SymptomLinkedMealCopyWith(
          SymptomLinkedMeal value, $Res Function(SymptomLinkedMeal) _then) =
      _$SymptomLinkedMealCopyWithImpl;
  @useResult
  $Res call({String mealRecordId, List<SymptomLinkedFood> foods});
}

/// @nodoc
class _$SymptomLinkedMealCopyWithImpl<$Res>
    implements $SymptomLinkedMealCopyWith<$Res> {
  _$SymptomLinkedMealCopyWithImpl(this._self, this._then);

  final SymptomLinkedMeal _self;
  final $Res Function(SymptomLinkedMeal) _then;

  /// Create a copy of SymptomLinkedMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordId = null,
    Object? foods = null,
  }) {
    return _then(_self.copyWith(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _self.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<SymptomLinkedFood>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SymptomLinkedMeal].
extension SymptomLinkedMealPatterns on SymptomLinkedMeal {
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
    TResult Function(_SymptomLinkedMeal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMeal() when $default != null:
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
    TResult Function(_SymptomLinkedMeal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMeal():
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
    TResult? Function(_SymptomLinkedMeal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMeal() when $default != null:
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
    TResult Function(String mealRecordId, List<SymptomLinkedFood> foods)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMeal() when $default != null:
        return $default(_that.mealRecordId, _that.foods);
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
    TResult Function(String mealRecordId, List<SymptomLinkedFood> foods)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMeal():
        return $default(_that.mealRecordId, _that.foods);
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
    TResult? Function(String mealRecordId, List<SymptomLinkedFood> foods)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SymptomLinkedMeal() when $default != null:
        return $default(_that.mealRecordId, _that.foods);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SymptomLinkedMeal implements SymptomLinkedMeal {
  const _SymptomLinkedMeal(
      {required this.mealRecordId,
      final List<SymptomLinkedFood> foods = const <SymptomLinkedFood>[]})
      : _foods = foods;

  /// 연결 식사 기록 식별자.
  @override
  final String mealRecordId;

  /// 연결 식사 내 음식 목록.
  final List<SymptomLinkedFood> _foods;

  /// 연결 식사 내 음식 목록.
  @override
  @JsonKey()
  List<SymptomLinkedFood> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  /// Create a copy of SymptomLinkedMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomLinkedMealCopyWith<_SymptomLinkedMeal> get copyWith =>
      __$SymptomLinkedMealCopyWithImpl<_SymptomLinkedMeal>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymptomLinkedMeal &&
            (identical(other.mealRecordId, mealRecordId) ||
                other.mealRecordId == mealRecordId) &&
            const DeepCollectionEquality().equals(other._foods, _foods));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordId, const DeepCollectionEquality().hash(_foods));

  @override
  String toString() {
    return 'SymptomLinkedMeal(mealRecordId: $mealRecordId, foods: $foods)';
  }
}

/// @nodoc
abstract mixin class _$SymptomLinkedMealCopyWith<$Res>
    implements $SymptomLinkedMealCopyWith<$Res> {
  factory _$SymptomLinkedMealCopyWith(
          _SymptomLinkedMeal value, $Res Function(_SymptomLinkedMeal) _then) =
      __$SymptomLinkedMealCopyWithImpl;
  @override
  @useResult
  $Res call({String mealRecordId, List<SymptomLinkedFood> foods});
}

/// @nodoc
class __$SymptomLinkedMealCopyWithImpl<$Res>
    implements _$SymptomLinkedMealCopyWith<$Res> {
  __$SymptomLinkedMealCopyWithImpl(this._self, this._then);

  final _SymptomLinkedMeal _self;
  final $Res Function(_SymptomLinkedMeal) _then;

  /// Create a copy of SymptomLinkedMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordId = null,
    Object? foods = null,
  }) {
    return _then(_SymptomLinkedMeal(
      mealRecordId: null == mealRecordId
          ? _self.mealRecordId
          : mealRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _self._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<SymptomLinkedFood>,
    ));
  }
}

/// @nodoc
mixin _$Symptom {
  /// 증상 기록 식별자 (UUID).
  String get symptomId;

  /// 증상 5단계 상태.
  SymptomState get symptomState;

  /// 서버 제공 상태 제목 문자열.
  String get stateTitle;

  /// 증상 유형 목록 (≤4 unique).
  List<SymptomType> get symptomTypes;

  /// 발생 시각 (ISO-8601 문자열 그대로, 표시 전용).
  String get occurredAt;

  /// 연결 식사. 없으면 null.
  SymptomLinkedMeal? get linkedMeal;

  /// 분석 항목 목록. 없으면 빈 목록.
  List<SymptomAnalysisItem> get analysisItems;

  /// Create a copy of Symptom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymptomCopyWith<Symptom> get copyWith =>
      _$SymptomCopyWithImpl<Symptom>(this as Symptom, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Symptom &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.stateTitle, stateTitle) ||
                other.stateTitle == stateTitle) &&
            const DeepCollectionEquality()
                .equals(other.symptomTypes, symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.linkedMeal, linkedMeal) ||
                other.linkedMeal == linkedMeal) &&
            const DeepCollectionEquality()
                .equals(other.analysisItems, analysisItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      stateTitle,
      const DeepCollectionEquality().hash(symptomTypes),
      occurredAt,
      linkedMeal,
      const DeepCollectionEquality().hash(analysisItems));

  @override
  String toString() {
    return 'Symptom(symptomId: $symptomId, symptomState: $symptomState, stateTitle: $stateTitle, symptomTypes: $symptomTypes, occurredAt: $occurredAt, linkedMeal: $linkedMeal, analysisItems: $analysisItems)';
  }
}

/// @nodoc
abstract mixin class $SymptomCopyWith<$Res> {
  factory $SymptomCopyWith(Symptom value, $Res Function(Symptom) _then) =
      _$SymptomCopyWithImpl;
  @useResult
  $Res call(
      {String symptomId,
      SymptomState symptomState,
      String stateTitle,
      List<SymptomType> symptomTypes,
      String occurredAt,
      SymptomLinkedMeal? linkedMeal,
      List<SymptomAnalysisItem> analysisItems});

  $SymptomLinkedMealCopyWith<$Res>? get linkedMeal;
}

/// @nodoc
class _$SymptomCopyWithImpl<$Res> implements $SymptomCopyWith<$Res> {
  _$SymptomCopyWithImpl(this._self, this._then);

  final Symptom _self;
  final $Res Function(Symptom) _then;

  /// Create a copy of Symptom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? stateTitle = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? linkedMeal = freezed,
    Object? analysisItems = null,
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
      stateTitle: null == stateTitle
          ? _self.stateTitle
          : stateTitle // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self.symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<SymptomType>,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      linkedMeal: freezed == linkedMeal
          ? _self.linkedMeal
          : linkedMeal // ignore: cast_nullable_to_non_nullable
              as SymptomLinkedMeal?,
      analysisItems: null == analysisItems
          ? _self.analysisItems
          : analysisItems // ignore: cast_nullable_to_non_nullable
              as List<SymptomAnalysisItem>,
    ));
  }

  /// Create a copy of Symptom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomLinkedMealCopyWith<$Res>? get linkedMeal {
    if (_self.linkedMeal == null) {
      return null;
    }

    return $SymptomLinkedMealCopyWith<$Res>(_self.linkedMeal!, (value) {
      return _then(_self.copyWith(linkedMeal: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Symptom].
extension SymptomPatterns on Symptom {
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
    TResult Function(_Symptom value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Symptom() when $default != null:
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
    TResult Function(_Symptom value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Symptom():
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
    TResult? Function(_Symptom value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Symptom() when $default != null:
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
            String stateTitle,
            List<SymptomType> symptomTypes,
            String occurredAt,
            SymptomLinkedMeal? linkedMeal,
            List<SymptomAnalysisItem> analysisItems)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Symptom() when $default != null:
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.stateTitle,
            _that.symptomTypes,
            _that.occurredAt,
            _that.linkedMeal,
            _that.analysisItems);
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
            String stateTitle,
            List<SymptomType> symptomTypes,
            String occurredAt,
            SymptomLinkedMeal? linkedMeal,
            List<SymptomAnalysisItem> analysisItems)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Symptom():
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.stateTitle,
            _that.symptomTypes,
            _that.occurredAt,
            _that.linkedMeal,
            _that.analysisItems);
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
            String stateTitle,
            List<SymptomType> symptomTypes,
            String occurredAt,
            SymptomLinkedMeal? linkedMeal,
            List<SymptomAnalysisItem> analysisItems)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Symptom() when $default != null:
        return $default(
            _that.symptomId,
            _that.symptomState,
            _that.stateTitle,
            _that.symptomTypes,
            _that.occurredAt,
            _that.linkedMeal,
            _that.analysisItems);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Symptom implements Symptom {
  const _Symptom(
      {required this.symptomId,
      required this.symptomState,
      required this.stateTitle,
      final List<SymptomType> symptomTypes = const <SymptomType>[],
      required this.occurredAt,
      this.linkedMeal,
      final List<SymptomAnalysisItem> analysisItems =
          const <SymptomAnalysisItem>[]})
      : _symptomTypes = symptomTypes,
        _analysisItems = analysisItems;

  /// 증상 기록 식별자 (UUID).
  @override
  final String symptomId;

  /// 증상 5단계 상태.
  @override
  final SymptomState symptomState;

  /// 서버 제공 상태 제목 문자열.
  @override
  final String stateTitle;

  /// 증상 유형 목록 (≤4 unique).
  final List<SymptomType> _symptomTypes;

  /// 증상 유형 목록 (≤4 unique).
  @override
  @JsonKey()
  List<SymptomType> get symptomTypes {
    if (_symptomTypes is EqualUnmodifiableListView) return _symptomTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptomTypes);
  }

  /// 발생 시각 (ISO-8601 문자열 그대로, 표시 전용).
  @override
  final String occurredAt;

  /// 연결 식사. 없으면 null.
  @override
  final SymptomLinkedMeal? linkedMeal;

  /// 분석 항목 목록. 없으면 빈 목록.
  final List<SymptomAnalysisItem> _analysisItems;

  /// 분석 항목 목록. 없으면 빈 목록.
  @override
  @JsonKey()
  List<SymptomAnalysisItem> get analysisItems {
    if (_analysisItems is EqualUnmodifiableListView) return _analysisItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_analysisItems);
  }

  /// Create a copy of Symptom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymptomCopyWith<_Symptom> get copyWith =>
      __$SymptomCopyWithImpl<_Symptom>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Symptom &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomState, symptomState) ||
                other.symptomState == symptomState) &&
            (identical(other.stateTitle, stateTitle) ||
                other.stateTitle == stateTitle) &&
            const DeepCollectionEquality()
                .equals(other._symptomTypes, _symptomTypes) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.linkedMeal, linkedMeal) ||
                other.linkedMeal == linkedMeal) &&
            const DeepCollectionEquality()
                .equals(other._analysisItems, _analysisItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      symptomId,
      symptomState,
      stateTitle,
      const DeepCollectionEquality().hash(_symptomTypes),
      occurredAt,
      linkedMeal,
      const DeepCollectionEquality().hash(_analysisItems));

  @override
  String toString() {
    return 'Symptom(symptomId: $symptomId, symptomState: $symptomState, stateTitle: $stateTitle, symptomTypes: $symptomTypes, occurredAt: $occurredAt, linkedMeal: $linkedMeal, analysisItems: $analysisItems)';
  }
}

/// @nodoc
abstract mixin class _$SymptomCopyWith<$Res> implements $SymptomCopyWith<$Res> {
  factory _$SymptomCopyWith(_Symptom value, $Res Function(_Symptom) _then) =
      __$SymptomCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String symptomId,
      SymptomState symptomState,
      String stateTitle,
      List<SymptomType> symptomTypes,
      String occurredAt,
      SymptomLinkedMeal? linkedMeal,
      List<SymptomAnalysisItem> analysisItems});

  @override
  $SymptomLinkedMealCopyWith<$Res>? get linkedMeal;
}

/// @nodoc
class __$SymptomCopyWithImpl<$Res> implements _$SymptomCopyWith<$Res> {
  __$SymptomCopyWithImpl(this._self, this._then);

  final _Symptom _self;
  final $Res Function(_Symptom) _then;

  /// Create a copy of Symptom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symptomId = null,
    Object? symptomState = null,
    Object? stateTitle = null,
    Object? symptomTypes = null,
    Object? occurredAt = null,
    Object? linkedMeal = freezed,
    Object? analysisItems = null,
  }) {
    return _then(_Symptom(
      symptomId: null == symptomId
          ? _self.symptomId
          : symptomId // ignore: cast_nullable_to_non_nullable
              as String,
      symptomState: null == symptomState
          ? _self.symptomState
          : symptomState // ignore: cast_nullable_to_non_nullable
              as SymptomState,
      stateTitle: null == stateTitle
          ? _self.stateTitle
          : stateTitle // ignore: cast_nullable_to_non_nullable
              as String,
      symptomTypes: null == symptomTypes
          ? _self._symptomTypes
          : symptomTypes // ignore: cast_nullable_to_non_nullable
              as List<SymptomType>,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      linkedMeal: freezed == linkedMeal
          ? _self.linkedMeal
          : linkedMeal // ignore: cast_nullable_to_non_nullable
              as SymptomLinkedMeal?,
      analysisItems: null == analysisItems
          ? _self._analysisItems
          : analysisItems // ignore: cast_nullable_to_non_nullable
              as List<SymptomAnalysisItem>,
    ));
  }

  /// Create a copy of Symptom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymptomLinkedMealCopyWith<$Res>? get linkedMeal {
    if (_self.linkedMeal == null) {
      return null;
    }

    return $SymptomLinkedMealCopyWith<$Res>(_self.linkedMeal!, (value) {
      return _then(_self.copyWith(linkedMeal: value));
    });
  }
}

// dart format on
