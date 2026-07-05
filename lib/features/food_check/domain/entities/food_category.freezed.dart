// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodCategory {
  String get code;
  String get displayName;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodCategoryCopyWith<FoodCategory> get copyWith =>
      _$FoodCategoryCopyWithImpl<FoodCategory>(
          this as FoodCategory, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodCategory &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, displayName);

  @override
  String toString() {
    return 'FoodCategory(code: $code, displayName: $displayName)';
  }
}

/// @nodoc
abstract mixin class $FoodCategoryCopyWith<$Res> {
  factory $FoodCategoryCopyWith(
          FoodCategory value, $Res Function(FoodCategory) _then) =
      _$FoodCategoryCopyWithImpl;
  @useResult
  $Res call({String code, String displayName});
}

/// @nodoc
class _$FoodCategoryCopyWithImpl<$Res> implements $FoodCategoryCopyWith<$Res> {
  _$FoodCategoryCopyWithImpl(this._self, this._then);

  final FoodCategory _self;
  final $Res Function(FoodCategory) _then;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? displayName = null,
  }) {
    return _then(_self.copyWith(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodCategory].
extension FoodCategoryPatterns on FoodCategory {
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
    TResult Function(_FoodCategory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodCategory() when $default != null:
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
    TResult Function(_FoodCategory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategory():
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
    TResult? Function(_FoodCategory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategory() when $default != null:
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
    TResult Function(String code, String displayName)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodCategory() when $default != null:
        return $default(_that.code, _that.displayName);
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
    TResult Function(String code, String displayName) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategory():
        return $default(_that.code, _that.displayName);
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
    TResult? Function(String code, String displayName)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodCategory() when $default != null:
        return $default(_that.code, _that.displayName);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodCategory implements FoodCategory {
  const _FoodCategory({required this.code, required this.displayName});

  @override
  final String code;
  @override
  final String displayName;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodCategoryCopyWith<_FoodCategory> get copyWith =>
      __$FoodCategoryCopyWithImpl<_FoodCategory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodCategory &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, displayName);

  @override
  String toString() {
    return 'FoodCategory(code: $code, displayName: $displayName)';
  }
}

/// @nodoc
abstract mixin class _$FoodCategoryCopyWith<$Res>
    implements $FoodCategoryCopyWith<$Res> {
  factory _$FoodCategoryCopyWith(
          _FoodCategory value, $Res Function(_FoodCategory) _then) =
      __$FoodCategoryCopyWithImpl;
  @override
  @useResult
  $Res call({String code, String displayName});
}

/// @nodoc
class __$FoodCategoryCopyWithImpl<$Res>
    implements _$FoodCategoryCopyWith<$Res> {
  __$FoodCategoryCopyWithImpl(this._self, this._then);

  final _FoodCategory _self;
  final $Res Function(_FoodCategory) _then;

  /// Create a copy of FoodCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? displayName = null,
  }) {
    return _then(_FoodCategory(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
