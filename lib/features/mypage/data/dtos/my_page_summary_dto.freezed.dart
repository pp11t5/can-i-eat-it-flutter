// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_page_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyPageProfileSummaryDto {
  String get nickName;
  String? get profileImage;
  String get disease;

  /// Create a copy of MyPageProfileSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyPageProfileSummaryDtoCopyWith<MyPageProfileSummaryDto> get copyWith =>
      _$MyPageProfileSummaryDtoCopyWithImpl<MyPageProfileSummaryDto>(
          this as MyPageProfileSummaryDto, _$identity);

  /// Serializes this MyPageProfileSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyPageProfileSummaryDto &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.disease, disease) || other.disease == disease));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickName, profileImage, disease);

  @override
  String toString() {
    return 'MyPageProfileSummaryDto(nickName: $nickName, profileImage: $profileImage, disease: $disease)';
  }
}

/// @nodoc
abstract mixin class $MyPageProfileSummaryDtoCopyWith<$Res> {
  factory $MyPageProfileSummaryDtoCopyWith(MyPageProfileSummaryDto value,
          $Res Function(MyPageProfileSummaryDto) _then) =
      _$MyPageProfileSummaryDtoCopyWithImpl;
  @useResult
  $Res call({String nickName, String? profileImage, String disease});
}

/// @nodoc
class _$MyPageProfileSummaryDtoCopyWithImpl<$Res>
    implements $MyPageProfileSummaryDtoCopyWith<$Res> {
  _$MyPageProfileSummaryDtoCopyWithImpl(this._self, this._then);

  final MyPageProfileSummaryDto _self;
  final $Res Function(MyPageProfileSummaryDto) _then;

  /// Create a copy of MyPageProfileSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickName = null,
    Object? profileImage = freezed,
    Object? disease = null,
  }) {
    return _then(_self.copyWith(
      nickName: null == nickName
          ? _self.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      disease: null == disease
          ? _self.disease
          : disease // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [MyPageProfileSummaryDto].
extension MyPageProfileSummaryDtoPatterns on MyPageProfileSummaryDto {
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
    TResult Function(_MyPageProfileSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummaryDto() when $default != null:
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
    TResult Function(_MyPageProfileSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummaryDto():
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
    TResult? Function(_MyPageProfileSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummaryDto() when $default != null:
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
    TResult Function(String nickName, String? profileImage, String disease)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummaryDto() when $default != null:
        return $default(_that.nickName, _that.profileImage, _that.disease);
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
    TResult Function(String nickName, String? profileImage, String disease)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummaryDto():
        return $default(_that.nickName, _that.profileImage, _that.disease);
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
    TResult? Function(String nickName, String? profileImage, String disease)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummaryDto() when $default != null:
        return $default(_that.nickName, _that.profileImage, _that.disease);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MyPageProfileSummaryDto implements MyPageProfileSummaryDto {
  const _MyPageProfileSummaryDto(
      {this.nickName = '', this.profileImage, this.disease = ''});
  factory _MyPageProfileSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MyPageProfileSummaryDtoFromJson(json);

  @override
  @JsonKey()
  final String nickName;
  @override
  final String? profileImage;
  @override
  @JsonKey()
  final String disease;

  /// Create a copy of MyPageProfileSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyPageProfileSummaryDtoCopyWith<_MyPageProfileSummaryDto> get copyWith =>
      __$MyPageProfileSummaryDtoCopyWithImpl<_MyPageProfileSummaryDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MyPageProfileSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyPageProfileSummaryDto &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.disease, disease) || other.disease == disease));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickName, profileImage, disease);

  @override
  String toString() {
    return 'MyPageProfileSummaryDto(nickName: $nickName, profileImage: $profileImage, disease: $disease)';
  }
}

/// @nodoc
abstract mixin class _$MyPageProfileSummaryDtoCopyWith<$Res>
    implements $MyPageProfileSummaryDtoCopyWith<$Res> {
  factory _$MyPageProfileSummaryDtoCopyWith(_MyPageProfileSummaryDto value,
          $Res Function(_MyPageProfileSummaryDto) _then) =
      __$MyPageProfileSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String nickName, String? profileImage, String disease});
}

/// @nodoc
class __$MyPageProfileSummaryDtoCopyWithImpl<$Res>
    implements _$MyPageProfileSummaryDtoCopyWith<$Res> {
  __$MyPageProfileSummaryDtoCopyWithImpl(this._self, this._then);

  final _MyPageProfileSummaryDto _self;
  final $Res Function(_MyPageProfileSummaryDto) _then;

  /// Create a copy of MyPageProfileSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nickName = null,
    Object? profileImage = freezed,
    Object? disease = null,
  }) {
    return _then(_MyPageProfileSummaryDto(
      nickName: null == nickName
          ? _self.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      disease: null == disease
          ? _self.disease
          : disease // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$FoodHistorySummaryDto {
  int get safeCount;
  int get cautionCount;

  /// Create a copy of FoodHistorySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodHistorySummaryDtoCopyWith<FoodHistorySummaryDto> get copyWith =>
      _$FoodHistorySummaryDtoCopyWithImpl<FoodHistorySummaryDto>(
          this as FoodHistorySummaryDto, _$identity);

  /// Serializes this FoodHistorySummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodHistorySummaryDto &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionCount);

  @override
  String toString() {
    return 'FoodHistorySummaryDto(safeCount: $safeCount, cautionCount: $cautionCount)';
  }
}

/// @nodoc
abstract mixin class $FoodHistorySummaryDtoCopyWith<$Res> {
  factory $FoodHistorySummaryDtoCopyWith(FoodHistorySummaryDto value,
          $Res Function(FoodHistorySummaryDto) _then) =
      _$FoodHistorySummaryDtoCopyWithImpl;
  @useResult
  $Res call({int safeCount, int cautionCount});
}

/// @nodoc
class _$FoodHistorySummaryDtoCopyWithImpl<$Res>
    implements $FoodHistorySummaryDtoCopyWith<$Res> {
  _$FoodHistorySummaryDtoCopyWithImpl(this._self, this._then);

  final FoodHistorySummaryDto _self;
  final $Res Function(FoodHistorySummaryDto) _then;

  /// Create a copy of FoodHistorySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? safeCount = null,
    Object? cautionCount = null,
  }) {
    return _then(_self.copyWith(
      safeCount: null == safeCount
          ? _self.safeCount
          : safeCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionCount: null == cautionCount
          ? _self.cautionCount
          : cautionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodHistorySummaryDto].
extension FoodHistorySummaryDtoPatterns on FoodHistorySummaryDto {
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
    TResult Function(_FoodHistorySummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummaryDto() when $default != null:
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
    TResult Function(_FoodHistorySummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummaryDto():
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
    TResult? Function(_FoodHistorySummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummaryDto() when $default != null:
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
    TResult Function(int safeCount, int cautionCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummaryDto() when $default != null:
        return $default(_that.safeCount, _that.cautionCount);
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
    TResult Function(int safeCount, int cautionCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummaryDto():
        return $default(_that.safeCount, _that.cautionCount);
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
    TResult? Function(int safeCount, int cautionCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummaryDto() when $default != null:
        return $default(_that.safeCount, _that.cautionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FoodHistorySummaryDto implements FoodHistorySummaryDto {
  const _FoodHistorySummaryDto({this.safeCount = 0, this.cautionCount = 0});
  factory _FoodHistorySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodHistorySummaryDtoFromJson(json);

  @override
  @JsonKey()
  final int safeCount;
  @override
  @JsonKey()
  final int cautionCount;

  /// Create a copy of FoodHistorySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodHistorySummaryDtoCopyWith<_FoodHistorySummaryDto> get copyWith =>
      __$FoodHistorySummaryDtoCopyWithImpl<_FoodHistorySummaryDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FoodHistorySummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodHistorySummaryDto &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionCount);

  @override
  String toString() {
    return 'FoodHistorySummaryDto(safeCount: $safeCount, cautionCount: $cautionCount)';
  }
}

/// @nodoc
abstract mixin class _$FoodHistorySummaryDtoCopyWith<$Res>
    implements $FoodHistorySummaryDtoCopyWith<$Res> {
  factory _$FoodHistorySummaryDtoCopyWith(_FoodHistorySummaryDto value,
          $Res Function(_FoodHistorySummaryDto) _then) =
      __$FoodHistorySummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call({int safeCount, int cautionCount});
}

/// @nodoc
class __$FoodHistorySummaryDtoCopyWithImpl<$Res>
    implements _$FoodHistorySummaryDtoCopyWith<$Res> {
  __$FoodHistorySummaryDtoCopyWithImpl(this._self, this._then);

  final _FoodHistorySummaryDto _self;
  final $Res Function(_FoodHistorySummaryDto) _then;

  /// Create a copy of FoodHistorySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? safeCount = null,
    Object? cautionCount = null,
  }) {
    return _then(_FoodHistorySummaryDto(
      safeCount: null == safeCount
          ? _self.safeCount
          : safeCount // ignore: cast_nullable_to_non_nullable
              as int,
      cautionCount: null == cautionCount
          ? _self.cautionCount
          : cautionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$WeeklySummaryDto {
  int get mealRecordCount;
  int get recentSymptomCount;
  int get streakCount;
  MealCountDto get mealCount;

  /// Create a copy of WeeklySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklySummaryDtoCopyWith<WeeklySummaryDto> get copyWith =>
      _$WeeklySummaryDtoCopyWithImpl<WeeklySummaryDto>(
          this as WeeklySummaryDto, _$identity);

  /// Serializes this WeeklySummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklySummaryDto &&
            (identical(other.mealRecordCount, mealRecordCount) ||
                other.mealRecordCount == mealRecordCount) &&
            (identical(other.recentSymptomCount, recentSymptomCount) ||
                other.recentSymptomCount == recentSymptomCount) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordCount, recentSymptomCount, streakCount, mealCount);

  @override
  String toString() {
    return 'WeeklySummaryDto(mealRecordCount: $mealRecordCount, recentSymptomCount: $recentSymptomCount, streakCount: $streakCount, mealCount: $mealCount)';
  }
}

/// @nodoc
abstract mixin class $WeeklySummaryDtoCopyWith<$Res> {
  factory $WeeklySummaryDtoCopyWith(
          WeeklySummaryDto value, $Res Function(WeeklySummaryDto) _then) =
      _$WeeklySummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {int mealRecordCount,
      int recentSymptomCount,
      int streakCount,
      MealCountDto mealCount});

  $MealCountDtoCopyWith<$Res> get mealCount;
}

/// @nodoc
class _$WeeklySummaryDtoCopyWithImpl<$Res>
    implements $WeeklySummaryDtoCopyWith<$Res> {
  _$WeeklySummaryDtoCopyWithImpl(this._self, this._then);

  final WeeklySummaryDto _self;
  final $Res Function(WeeklySummaryDto) _then;

  /// Create a copy of WeeklySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealRecordCount = null,
    Object? recentSymptomCount = null,
    Object? streakCount = null,
    Object? mealCount = null,
  }) {
    return _then(_self.copyWith(
      mealRecordCount: null == mealRecordCount
          ? _self.mealRecordCount
          : mealRecordCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentSymptomCount: null == recentSymptomCount
          ? _self.recentSymptomCount
          : recentSymptomCount // ignore: cast_nullable_to_non_nullable
              as int,
      streakCount: null == streakCount
          ? _self.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      mealCount: null == mealCount
          ? _self.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as MealCountDto,
    ));
  }

  /// Create a copy of WeeklySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountDtoCopyWith<$Res> get mealCount {
    return $MealCountDtoCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WeeklySummaryDto].
extension WeeklySummaryDtoPatterns on WeeklySummaryDto {
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
    TResult Function(_WeeklySummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklySummaryDto() when $default != null:
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
    TResult Function(_WeeklySummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummaryDto():
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
    TResult? Function(_WeeklySummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummaryDto() when $default != null:
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
    TResult Function(int mealRecordCount, int recentSymptomCount,
            int streakCount, MealCountDto mealCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklySummaryDto() when $default != null:
        return $default(_that.mealRecordCount, _that.recentSymptomCount,
            _that.streakCount, _that.mealCount);
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
    TResult Function(int mealRecordCount, int recentSymptomCount,
            int streakCount, MealCountDto mealCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummaryDto():
        return $default(_that.mealRecordCount, _that.recentSymptomCount,
            _that.streakCount, _that.mealCount);
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
    TResult? Function(int mealRecordCount, int recentSymptomCount,
            int streakCount, MealCountDto mealCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummaryDto() when $default != null:
        return $default(_that.mealRecordCount, _that.recentSymptomCount,
            _that.streakCount, _that.mealCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WeeklySummaryDto implements WeeklySummaryDto {
  const _WeeklySummaryDto(
      {this.mealRecordCount = 0,
      this.recentSymptomCount = 0,
      this.streakCount = 0,
      this.mealCount = const MealCountDto()});
  factory _WeeklySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryDtoFromJson(json);

  @override
  @JsonKey()
  final int mealRecordCount;
  @override
  @JsonKey()
  final int recentSymptomCount;
  @override
  @JsonKey()
  final int streakCount;
  @override
  @JsonKey()
  final MealCountDto mealCount;

  /// Create a copy of WeeklySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklySummaryDtoCopyWith<_WeeklySummaryDto> get copyWith =>
      __$WeeklySummaryDtoCopyWithImpl<_WeeklySummaryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeeklySummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklySummaryDto &&
            (identical(other.mealRecordCount, mealRecordCount) ||
                other.mealRecordCount == mealRecordCount) &&
            (identical(other.recentSymptomCount, recentSymptomCount) ||
                other.recentSymptomCount == recentSymptomCount) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordCount, recentSymptomCount, streakCount, mealCount);

  @override
  String toString() {
    return 'WeeklySummaryDto(mealRecordCount: $mealRecordCount, recentSymptomCount: $recentSymptomCount, streakCount: $streakCount, mealCount: $mealCount)';
  }
}

/// @nodoc
abstract mixin class _$WeeklySummaryDtoCopyWith<$Res>
    implements $WeeklySummaryDtoCopyWith<$Res> {
  factory _$WeeklySummaryDtoCopyWith(
          _WeeklySummaryDto value, $Res Function(_WeeklySummaryDto) _then) =
      __$WeeklySummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int mealRecordCount,
      int recentSymptomCount,
      int streakCount,
      MealCountDto mealCount});

  @override
  $MealCountDtoCopyWith<$Res> get mealCount;
}

/// @nodoc
class __$WeeklySummaryDtoCopyWithImpl<$Res>
    implements _$WeeklySummaryDtoCopyWith<$Res> {
  __$WeeklySummaryDtoCopyWithImpl(this._self, this._then);

  final _WeeklySummaryDto _self;
  final $Res Function(_WeeklySummaryDto) _then;

  /// Create a copy of WeeklySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordCount = null,
    Object? recentSymptomCount = null,
    Object? streakCount = null,
    Object? mealCount = null,
  }) {
    return _then(_WeeklySummaryDto(
      mealRecordCount: null == mealRecordCount
          ? _self.mealRecordCount
          : mealRecordCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentSymptomCount: null == recentSymptomCount
          ? _self.recentSymptomCount
          : recentSymptomCount // ignore: cast_nullable_to_non_nullable
              as int,
      streakCount: null == streakCount
          ? _self.streakCount
          : streakCount // ignore: cast_nullable_to_non_nullable
              as int,
      mealCount: null == mealCount
          ? _self.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as MealCountDto,
    ));
  }

  /// Create a copy of WeeklySummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountDtoCopyWith<$Res> get mealCount {
    return $MealCountDtoCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }
}

/// @nodoc
mixin _$MyPageSummaryDto {
  MyPageProfileSummaryDto? get profile;
  FoodHistorySummaryDto? get foodHistory;
  WeeklySummaryDto? get weeklySummary;

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyPageSummaryDtoCopyWith<MyPageSummaryDto> get copyWith =>
      _$MyPageSummaryDtoCopyWithImpl<MyPageSummaryDto>(
          this as MyPageSummaryDto, _$identity);

  /// Serializes this MyPageSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyPageSummaryDto &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.foodHistory, foodHistory) ||
                other.foodHistory == foodHistory) &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, profile, foodHistory, weeklySummary);

  @override
  String toString() {
    return 'MyPageSummaryDto(profile: $profile, foodHistory: $foodHistory, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class $MyPageSummaryDtoCopyWith<$Res> {
  factory $MyPageSummaryDtoCopyWith(
          MyPageSummaryDto value, $Res Function(MyPageSummaryDto) _then) =
      _$MyPageSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {MyPageProfileSummaryDto? profile,
      FoodHistorySummaryDto? foodHistory,
      WeeklySummaryDto? weeklySummary});

  $MyPageProfileSummaryDtoCopyWith<$Res>? get profile;
  $FoodHistorySummaryDtoCopyWith<$Res>? get foodHistory;
  $WeeklySummaryDtoCopyWith<$Res>? get weeklySummary;
}

/// @nodoc
class _$MyPageSummaryDtoCopyWithImpl<$Res>
    implements $MyPageSummaryDtoCopyWith<$Res> {
  _$MyPageSummaryDtoCopyWithImpl(this._self, this._then);

  final MyPageSummaryDto _self;
  final $Res Function(MyPageSummaryDto) _then;

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? foodHistory = freezed,
    Object? weeklySummary = freezed,
  }) {
    return _then(_self.copyWith(
      profile: freezed == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as MyPageProfileSummaryDto?,
      foodHistory: freezed == foodHistory
          ? _self.foodHistory
          : foodHistory // ignore: cast_nullable_to_non_nullable
              as FoodHistorySummaryDto?,
      weeklySummary: freezed == weeklySummary
          ? _self.weeklySummary
          : weeklySummary // ignore: cast_nullable_to_non_nullable
              as WeeklySummaryDto?,
    ));
  }

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyPageProfileSummaryDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
      return null;
    }

    return $MyPageProfileSummaryDtoCopyWith<$Res>(_self.profile!, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodHistorySummaryDtoCopyWith<$Res>? get foodHistory {
    if (_self.foodHistory == null) {
      return null;
    }

    return $FoodHistorySummaryDtoCopyWith<$Res>(_self.foodHistory!, (value) {
      return _then(_self.copyWith(foodHistory: value));
    });
  }

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklySummaryDtoCopyWith<$Res>? get weeklySummary {
    if (_self.weeklySummary == null) {
      return null;
    }

    return $WeeklySummaryDtoCopyWith<$Res>(_self.weeklySummary!, (value) {
      return _then(_self.copyWith(weeklySummary: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MyPageSummaryDto].
extension MyPageSummaryDtoPatterns on MyPageSummaryDto {
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
    TResult Function(_MyPageSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageSummaryDto() when $default != null:
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
    TResult Function(_MyPageSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummaryDto():
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
    TResult? Function(_MyPageSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummaryDto() when $default != null:
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
            MyPageProfileSummaryDto? profile,
            FoodHistorySummaryDto? foodHistory,
            WeeklySummaryDto? weeklySummary)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageSummaryDto() when $default != null:
        return $default(_that.profile, _that.foodHistory, _that.weeklySummary);
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
    TResult Function(MyPageProfileSummaryDto? profile,
            FoodHistorySummaryDto? foodHistory, WeeklySummaryDto? weeklySummary)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummaryDto():
        return $default(_that.profile, _that.foodHistory, _that.weeklySummary);
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
            MyPageProfileSummaryDto? profile,
            FoodHistorySummaryDto? foodHistory,
            WeeklySummaryDto? weeklySummary)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummaryDto() when $default != null:
        return $default(_that.profile, _that.foodHistory, _that.weeklySummary);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MyPageSummaryDto implements MyPageSummaryDto {
  const _MyPageSummaryDto({this.profile, this.foodHistory, this.weeklySummary});
  factory _MyPageSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MyPageSummaryDtoFromJson(json);

  @override
  final MyPageProfileSummaryDto? profile;
  @override
  final FoodHistorySummaryDto? foodHistory;
  @override
  final WeeklySummaryDto? weeklySummary;

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyPageSummaryDtoCopyWith<_MyPageSummaryDto> get copyWith =>
      __$MyPageSummaryDtoCopyWithImpl<_MyPageSummaryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MyPageSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyPageSummaryDto &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.foodHistory, foodHistory) ||
                other.foodHistory == foodHistory) &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, profile, foodHistory, weeklySummary);

  @override
  String toString() {
    return 'MyPageSummaryDto(profile: $profile, foodHistory: $foodHistory, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class _$MyPageSummaryDtoCopyWith<$Res>
    implements $MyPageSummaryDtoCopyWith<$Res> {
  factory _$MyPageSummaryDtoCopyWith(
          _MyPageSummaryDto value, $Res Function(_MyPageSummaryDto) _then) =
      __$MyPageSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MyPageProfileSummaryDto? profile,
      FoodHistorySummaryDto? foodHistory,
      WeeklySummaryDto? weeklySummary});

  @override
  $MyPageProfileSummaryDtoCopyWith<$Res>? get profile;
  @override
  $FoodHistorySummaryDtoCopyWith<$Res>? get foodHistory;
  @override
  $WeeklySummaryDtoCopyWith<$Res>? get weeklySummary;
}

/// @nodoc
class __$MyPageSummaryDtoCopyWithImpl<$Res>
    implements _$MyPageSummaryDtoCopyWith<$Res> {
  __$MyPageSummaryDtoCopyWithImpl(this._self, this._then);

  final _MyPageSummaryDto _self;
  final $Res Function(_MyPageSummaryDto) _then;

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? profile = freezed,
    Object? foodHistory = freezed,
    Object? weeklySummary = freezed,
  }) {
    return _then(_MyPageSummaryDto(
      profile: freezed == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as MyPageProfileSummaryDto?,
      foodHistory: freezed == foodHistory
          ? _self.foodHistory
          : foodHistory // ignore: cast_nullable_to_non_nullable
              as FoodHistorySummaryDto?,
      weeklySummary: freezed == weeklySummary
          ? _self.weeklySummary
          : weeklySummary // ignore: cast_nullable_to_non_nullable
              as WeeklySummaryDto?,
    ));
  }

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyPageProfileSummaryDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
      return null;
    }

    return $MyPageProfileSummaryDtoCopyWith<$Res>(_self.profile!, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodHistorySummaryDtoCopyWith<$Res>? get foodHistory {
    if (_self.foodHistory == null) {
      return null;
    }

    return $FoodHistorySummaryDtoCopyWith<$Res>(_self.foodHistory!, (value) {
      return _then(_self.copyWith(foodHistory: value));
    });
  }

  /// Create a copy of MyPageSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklySummaryDtoCopyWith<$Res>? get weeklySummary {
    if (_self.weeklySummary == null) {
      return null;
    }

    return $WeeklySummaryDtoCopyWith<$Res>(_self.weeklySummary!, (value) {
      return _then(_self.copyWith(weeklySummary: value));
    });
  }
}

// dart format on
