// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_food_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentFoodDto {
  int get id;
  String get query;
  DateTime get searchedAt;

  /// Create a copy of RecentFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecentFoodDtoCopyWith<RecentFoodDto> get copyWith =>
      _$RecentFoodDtoCopyWithImpl<RecentFoodDto>(
          this as RecentFoodDto, _$identity);

  /// Serializes this RecentFoodDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecentFoodDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.searchedAt, searchedAt) ||
                other.searchedAt == searchedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, query, searchedAt);

  @override
  String toString() {
    return 'RecentFoodDto(id: $id, query: $query, searchedAt: $searchedAt)';
  }
}

/// @nodoc
abstract mixin class $RecentFoodDtoCopyWith<$Res> {
  factory $RecentFoodDtoCopyWith(
          RecentFoodDto value, $Res Function(RecentFoodDto) _then) =
      _$RecentFoodDtoCopyWithImpl;
  @useResult
  $Res call({int id, String query, DateTime searchedAt});
}

/// @nodoc
class _$RecentFoodDtoCopyWithImpl<$Res>
    implements $RecentFoodDtoCopyWith<$Res> {
  _$RecentFoodDtoCopyWithImpl(this._self, this._then);

  final RecentFoodDto _self;
  final $Res Function(RecentFoodDto) _then;

  /// Create a copy of RecentFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? searchedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      searchedAt: null == searchedAt
          ? _self.searchedAt
          : searchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecentFoodDto].
extension RecentFoodDtoPatterns on RecentFoodDto {
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
    TResult Function(_RecentFoodDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentFoodDto() when $default != null:
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
    TResult Function(_RecentFoodDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFoodDto():
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
    TResult? Function(_RecentFoodDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFoodDto() when $default != null:
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
    TResult Function(int id, String query, DateTime searchedAt)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecentFoodDto() when $default != null:
        return $default(_that.id, _that.query, _that.searchedAt);
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
    TResult Function(int id, String query, DateTime searchedAt) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFoodDto():
        return $default(_that.id, _that.query, _that.searchedAt);
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
    TResult? Function(int id, String query, DateTime searchedAt)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecentFoodDto() when $default != null:
        return $default(_that.id, _that.query, _that.searchedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecentFoodDto implements RecentFoodDto {
  const _RecentFoodDto(
      {required this.id, required this.query, required this.searchedAt});
  factory _RecentFoodDto.fromJson(Map<String, dynamic> json) =>
      _$RecentFoodDtoFromJson(json);

  @override
  final int id;
  @override
  final String query;
  @override
  final DateTime searchedAt;

  /// Create a copy of RecentFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecentFoodDtoCopyWith<_RecentFoodDto> get copyWith =>
      __$RecentFoodDtoCopyWithImpl<_RecentFoodDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecentFoodDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecentFoodDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.searchedAt, searchedAt) ||
                other.searchedAt == searchedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, query, searchedAt);

  @override
  String toString() {
    return 'RecentFoodDto(id: $id, query: $query, searchedAt: $searchedAt)';
  }
}

/// @nodoc
abstract mixin class _$RecentFoodDtoCopyWith<$Res>
    implements $RecentFoodDtoCopyWith<$Res> {
  factory _$RecentFoodDtoCopyWith(
          _RecentFoodDto value, $Res Function(_RecentFoodDto) _then) =
      __$RecentFoodDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String query, DateTime searchedAt});
}

/// @nodoc
class __$RecentFoodDtoCopyWithImpl<$Res>
    implements _$RecentFoodDtoCopyWith<$Res> {
  __$RecentFoodDtoCopyWithImpl(this._self, this._then);

  final _RecentFoodDto _self;
  final $Res Function(_RecentFoodDto) _then;

  /// Create a copy of RecentFoodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? searchedAt = null,
  }) {
    return _then(_RecentFoodDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      searchedAt: null == searchedAt
          ? _self.searchedAt
          : searchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
