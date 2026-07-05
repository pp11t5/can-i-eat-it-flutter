// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_page_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyPageSummary {
  MyPageProfileSummary get profile;
  FoodHistorySummary get foodHistory;
  WeeklySummary get weeklySummary;

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyPageSummaryCopyWith<MyPageSummary> get copyWith =>
      _$MyPageSummaryCopyWithImpl<MyPageSummary>(
          this as MyPageSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyPageSummary &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.foodHistory, foodHistory) ||
                other.foodHistory == foodHistory) &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profile, foodHistory, weeklySummary);

  @override
  String toString() {
    return 'MyPageSummary(profile: $profile, foodHistory: $foodHistory, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class $MyPageSummaryCopyWith<$Res> {
  factory $MyPageSummaryCopyWith(
          MyPageSummary value, $Res Function(MyPageSummary) _then) =
      _$MyPageSummaryCopyWithImpl;
  @useResult
  $Res call(
      {MyPageProfileSummary profile,
      FoodHistorySummary foodHistory,
      WeeklySummary weeklySummary});

  $MyPageProfileSummaryCopyWith<$Res> get profile;
  $FoodHistorySummaryCopyWith<$Res> get foodHistory;
  $WeeklySummaryCopyWith<$Res> get weeklySummary;
}

/// @nodoc
class _$MyPageSummaryCopyWithImpl<$Res>
    implements $MyPageSummaryCopyWith<$Res> {
  _$MyPageSummaryCopyWithImpl(this._self, this._then);

  final MyPageSummary _self;
  final $Res Function(MyPageSummary) _then;

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? foodHistory = null,
    Object? weeklySummary = null,
  }) {
    return _then(_self.copyWith(
      profile: null == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as MyPageProfileSummary,
      foodHistory: null == foodHistory
          ? _self.foodHistory
          : foodHistory // ignore: cast_nullable_to_non_nullable
              as FoodHistorySummary,
      weeklySummary: null == weeklySummary
          ? _self.weeklySummary
          : weeklySummary // ignore: cast_nullable_to_non_nullable
              as WeeklySummary,
    ));
  }

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyPageProfileSummaryCopyWith<$Res> get profile {
    return $MyPageProfileSummaryCopyWith<$Res>(_self.profile, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodHistorySummaryCopyWith<$Res> get foodHistory {
    return $FoodHistorySummaryCopyWith<$Res>(_self.foodHistory, (value) {
      return _then(_self.copyWith(foodHistory: value));
    });
  }

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklySummaryCopyWith<$Res> get weeklySummary {
    return $WeeklySummaryCopyWith<$Res>(_self.weeklySummary, (value) {
      return _then(_self.copyWith(weeklySummary: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MyPageSummary].
extension MyPageSummaryPatterns on MyPageSummary {
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
    TResult Function(_MyPageSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageSummary() when $default != null:
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
    TResult Function(_MyPageSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummary():
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
    TResult? Function(_MyPageSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummary() when $default != null:
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
    TResult Function(MyPageProfileSummary profile,
            FoodHistorySummary foodHistory, WeeklySummary weeklySummary)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageSummary() when $default != null:
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
    TResult Function(MyPageProfileSummary profile,
            FoodHistorySummary foodHistory, WeeklySummary weeklySummary)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummary():
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
    TResult? Function(MyPageProfileSummary profile,
            FoodHistorySummary foodHistory, WeeklySummary weeklySummary)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageSummary() when $default != null:
        return $default(_that.profile, _that.foodHistory, _that.weeklySummary);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MyPageSummary implements MyPageSummary {
  const _MyPageSummary(
      {required this.profile,
      required this.foodHistory,
      required this.weeklySummary});

  @override
  final MyPageProfileSummary profile;
  @override
  final FoodHistorySummary foodHistory;
  @override
  final WeeklySummary weeklySummary;

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyPageSummaryCopyWith<_MyPageSummary> get copyWith =>
      __$MyPageSummaryCopyWithImpl<_MyPageSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyPageSummary &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.foodHistory, foodHistory) ||
                other.foodHistory == foodHistory) &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, profile, foodHistory, weeklySummary);

  @override
  String toString() {
    return 'MyPageSummary(profile: $profile, foodHistory: $foodHistory, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class _$MyPageSummaryCopyWith<$Res>
    implements $MyPageSummaryCopyWith<$Res> {
  factory _$MyPageSummaryCopyWith(
          _MyPageSummary value, $Res Function(_MyPageSummary) _then) =
      __$MyPageSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MyPageProfileSummary profile,
      FoodHistorySummary foodHistory,
      WeeklySummary weeklySummary});

  @override
  $MyPageProfileSummaryCopyWith<$Res> get profile;
  @override
  $FoodHistorySummaryCopyWith<$Res> get foodHistory;
  @override
  $WeeklySummaryCopyWith<$Res> get weeklySummary;
}

/// @nodoc
class __$MyPageSummaryCopyWithImpl<$Res>
    implements _$MyPageSummaryCopyWith<$Res> {
  __$MyPageSummaryCopyWithImpl(this._self, this._then);

  final _MyPageSummary _self;
  final $Res Function(_MyPageSummary) _then;

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? profile = null,
    Object? foodHistory = null,
    Object? weeklySummary = null,
  }) {
    return _then(_MyPageSummary(
      profile: null == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as MyPageProfileSummary,
      foodHistory: null == foodHistory
          ? _self.foodHistory
          : foodHistory // ignore: cast_nullable_to_non_nullable
              as FoodHistorySummary,
      weeklySummary: null == weeklySummary
          ? _self.weeklySummary
          : weeklySummary // ignore: cast_nullable_to_non_nullable
              as WeeklySummary,
    ));
  }

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyPageProfileSummaryCopyWith<$Res> get profile {
    return $MyPageProfileSummaryCopyWith<$Res>(_self.profile, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodHistorySummaryCopyWith<$Res> get foodHistory {
    return $FoodHistorySummaryCopyWith<$Res>(_self.foodHistory, (value) {
      return _then(_self.copyWith(foodHistory: value));
    });
  }

  /// Create a copy of MyPageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeeklySummaryCopyWith<$Res> get weeklySummary {
    return $WeeklySummaryCopyWith<$Res>(_self.weeklySummary, (value) {
      return _then(_self.copyWith(weeklySummary: value));
    });
  }
}

/// @nodoc
mixin _$MyPageProfileSummary {
  String get nickName;
  String? get profileImage;
  MyPageDisease get disease;

  /// Create a copy of MyPageProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyPageProfileSummaryCopyWith<MyPageProfileSummary> get copyWith =>
      _$MyPageProfileSummaryCopyWithImpl<MyPageProfileSummary>(
          this as MyPageProfileSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyPageProfileSummary &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.disease, disease) || other.disease == disease));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nickName, profileImage, disease);

  @override
  String toString() {
    return 'MyPageProfileSummary(nickName: $nickName, profileImage: $profileImage, disease: $disease)';
  }
}

/// @nodoc
abstract mixin class $MyPageProfileSummaryCopyWith<$Res> {
  factory $MyPageProfileSummaryCopyWith(MyPageProfileSummary value,
          $Res Function(MyPageProfileSummary) _then) =
      _$MyPageProfileSummaryCopyWithImpl;
  @useResult
  $Res call({String nickName, String? profileImage, MyPageDisease disease});
}

/// @nodoc
class _$MyPageProfileSummaryCopyWithImpl<$Res>
    implements $MyPageProfileSummaryCopyWith<$Res> {
  _$MyPageProfileSummaryCopyWithImpl(this._self, this._then);

  final MyPageProfileSummary _self;
  final $Res Function(MyPageProfileSummary) _then;

  /// Create a copy of MyPageProfileSummary
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
              as MyPageDisease,
    ));
  }
}

/// Adds pattern-matching-related methods to [MyPageProfileSummary].
extension MyPageProfileSummaryPatterns on MyPageProfileSummary {
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
    TResult Function(_MyPageProfileSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummary() when $default != null:
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
    TResult Function(_MyPageProfileSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummary():
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
    TResult? Function(_MyPageProfileSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummary() when $default != null:
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
            String nickName, String? profileImage, MyPageDisease disease)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummary() when $default != null:
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
    TResult Function(
            String nickName, String? profileImage, MyPageDisease disease)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummary():
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
    TResult? Function(
            String nickName, String? profileImage, MyPageDisease disease)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageProfileSummary() when $default != null:
        return $default(_that.nickName, _that.profileImage, _that.disease);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MyPageProfileSummary implements MyPageProfileSummary {
  const _MyPageProfileSummary(
      {required this.nickName, this.profileImage, required this.disease});

  @override
  final String nickName;
  @override
  final String? profileImage;
  @override
  final MyPageDisease disease;

  /// Create a copy of MyPageProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyPageProfileSummaryCopyWith<_MyPageProfileSummary> get copyWith =>
      __$MyPageProfileSummaryCopyWithImpl<_MyPageProfileSummary>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyPageProfileSummary &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.disease, disease) || other.disease == disease));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nickName, profileImage, disease);

  @override
  String toString() {
    return 'MyPageProfileSummary(nickName: $nickName, profileImage: $profileImage, disease: $disease)';
  }
}

/// @nodoc
abstract mixin class _$MyPageProfileSummaryCopyWith<$Res>
    implements $MyPageProfileSummaryCopyWith<$Res> {
  factory _$MyPageProfileSummaryCopyWith(_MyPageProfileSummary value,
          $Res Function(_MyPageProfileSummary) _then) =
      __$MyPageProfileSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({String nickName, String? profileImage, MyPageDisease disease});
}

/// @nodoc
class __$MyPageProfileSummaryCopyWithImpl<$Res>
    implements _$MyPageProfileSummaryCopyWith<$Res> {
  __$MyPageProfileSummaryCopyWithImpl(this._self, this._then);

  final _MyPageProfileSummary _self;
  final $Res Function(_MyPageProfileSummary) _then;

  /// Create a copy of MyPageProfileSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nickName = null,
    Object? profileImage = freezed,
    Object? disease = null,
  }) {
    return _then(_MyPageProfileSummary(
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
              as MyPageDisease,
    ));
  }
}

/// @nodoc
mixin _$FoodHistorySummary {
  int get safeCount;
  int get cautionCount;

  /// Create a copy of FoodHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodHistorySummaryCopyWith<FoodHistorySummary> get copyWith =>
      _$FoodHistorySummaryCopyWithImpl<FoodHistorySummary>(
          this as FoodHistorySummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodHistorySummary &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionCount);

  @override
  String toString() {
    return 'FoodHistorySummary(safeCount: $safeCount, cautionCount: $cautionCount)';
  }
}

/// @nodoc
abstract mixin class $FoodHistorySummaryCopyWith<$Res> {
  factory $FoodHistorySummaryCopyWith(
          FoodHistorySummary value, $Res Function(FoodHistorySummary) _then) =
      _$FoodHistorySummaryCopyWithImpl;
  @useResult
  $Res call({int safeCount, int cautionCount});
}

/// @nodoc
class _$FoodHistorySummaryCopyWithImpl<$Res>
    implements $FoodHistorySummaryCopyWith<$Res> {
  _$FoodHistorySummaryCopyWithImpl(this._self, this._then);

  final FoodHistorySummary _self;
  final $Res Function(FoodHistorySummary) _then;

  /// Create a copy of FoodHistorySummary
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

/// Adds pattern-matching-related methods to [FoodHistorySummary].
extension FoodHistorySummaryPatterns on FoodHistorySummary {
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
    TResult Function(_FoodHistorySummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummary() when $default != null:
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
    TResult Function(_FoodHistorySummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummary():
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
    TResult? Function(_FoodHistorySummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodHistorySummary() when $default != null:
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
      case _FoodHistorySummary() when $default != null:
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
      case _FoodHistorySummary():
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
      case _FoodHistorySummary() when $default != null:
        return $default(_that.safeCount, _that.cautionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodHistorySummary implements FoodHistorySummary {
  const _FoodHistorySummary({this.safeCount = 0, this.cautionCount = 0});

  @override
  @JsonKey()
  final int safeCount;
  @override
  @JsonKey()
  final int cautionCount;

  /// Create a copy of FoodHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodHistorySummaryCopyWith<_FoodHistorySummary> get copyWith =>
      __$FoodHistorySummaryCopyWithImpl<_FoodHistorySummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodHistorySummary &&
            (identical(other.safeCount, safeCount) ||
                other.safeCount == safeCount) &&
            (identical(other.cautionCount, cautionCount) ||
                other.cautionCount == cautionCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, safeCount, cautionCount);

  @override
  String toString() {
    return 'FoodHistorySummary(safeCount: $safeCount, cautionCount: $cautionCount)';
  }
}

/// @nodoc
abstract mixin class _$FoodHistorySummaryCopyWith<$Res>
    implements $FoodHistorySummaryCopyWith<$Res> {
  factory _$FoodHistorySummaryCopyWith(
          _FoodHistorySummary value, $Res Function(_FoodHistorySummary) _then) =
      __$FoodHistorySummaryCopyWithImpl;
  @override
  @useResult
  $Res call({int safeCount, int cautionCount});
}

/// @nodoc
class __$FoodHistorySummaryCopyWithImpl<$Res>
    implements _$FoodHistorySummaryCopyWith<$Res> {
  __$FoodHistorySummaryCopyWithImpl(this._self, this._then);

  final _FoodHistorySummary _self;
  final $Res Function(_FoodHistorySummary) _then;

  /// Create a copy of FoodHistorySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? safeCount = null,
    Object? cautionCount = null,
  }) {
    return _then(_FoodHistorySummary(
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
mixin _$WeeklySummary {
  int get mealRecordCount;
  int get recentSymptomCount;
  int get streakCount;
  MealCount get mealCount;

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklySummaryCopyWith<WeeklySummary> get copyWith =>
      _$WeeklySummaryCopyWithImpl<WeeklySummary>(
          this as WeeklySummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklySummary &&
            (identical(other.mealRecordCount, mealRecordCount) ||
                other.mealRecordCount == mealRecordCount) &&
            (identical(other.recentSymptomCount, recentSymptomCount) ||
                other.recentSymptomCount == recentSymptomCount) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordCount, recentSymptomCount, streakCount, mealCount);

  @override
  String toString() {
    return 'WeeklySummary(mealRecordCount: $mealRecordCount, recentSymptomCount: $recentSymptomCount, streakCount: $streakCount, mealCount: $mealCount)';
  }
}

/// @nodoc
abstract mixin class $WeeklySummaryCopyWith<$Res> {
  factory $WeeklySummaryCopyWith(
          WeeklySummary value, $Res Function(WeeklySummary) _then) =
      _$WeeklySummaryCopyWithImpl;
  @useResult
  $Res call(
      {int mealRecordCount,
      int recentSymptomCount,
      int streakCount,
      MealCount mealCount});

  $MealCountCopyWith<$Res> get mealCount;
}

/// @nodoc
class _$WeeklySummaryCopyWithImpl<$Res>
    implements $WeeklySummaryCopyWith<$Res> {
  _$WeeklySummaryCopyWithImpl(this._self, this._then);

  final WeeklySummary _self;
  final $Res Function(WeeklySummary) _then;

  /// Create a copy of WeeklySummary
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
              as MealCount,
    ));
  }

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountCopyWith<$Res> get mealCount {
    return $MealCountCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WeeklySummary].
extension WeeklySummaryPatterns on WeeklySummary {
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
    TResult Function(_WeeklySummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklySummary() when $default != null:
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
    TResult Function(_WeeklySummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummary():
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
    TResult? Function(_WeeklySummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummary() when $default != null:
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
            int streakCount, MealCount mealCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklySummary() when $default != null:
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
            int streakCount, MealCount mealCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummary():
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
            int streakCount, MealCount mealCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklySummary() when $default != null:
        return $default(_that.mealRecordCount, _that.recentSymptomCount,
            _that.streakCount, _that.mealCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WeeklySummary implements WeeklySummary {
  const _WeeklySummary(
      {this.mealRecordCount = 0,
      this.recentSymptomCount = 0,
      this.streakCount = 0,
      required this.mealCount});

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
  final MealCount mealCount;

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklySummaryCopyWith<_WeeklySummary> get copyWith =>
      __$WeeklySummaryCopyWithImpl<_WeeklySummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklySummary &&
            (identical(other.mealRecordCount, mealRecordCount) ||
                other.mealRecordCount == mealRecordCount) &&
            (identical(other.recentSymptomCount, recentSymptomCount) ||
                other.recentSymptomCount == recentSymptomCount) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mealRecordCount, recentSymptomCount, streakCount, mealCount);

  @override
  String toString() {
    return 'WeeklySummary(mealRecordCount: $mealRecordCount, recentSymptomCount: $recentSymptomCount, streakCount: $streakCount, mealCount: $mealCount)';
  }
}

/// @nodoc
abstract mixin class _$WeeklySummaryCopyWith<$Res>
    implements $WeeklySummaryCopyWith<$Res> {
  factory _$WeeklySummaryCopyWith(
          _WeeklySummary value, $Res Function(_WeeklySummary) _then) =
      __$WeeklySummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int mealRecordCount,
      int recentSymptomCount,
      int streakCount,
      MealCount mealCount});

  @override
  $MealCountCopyWith<$Res> get mealCount;
}

/// @nodoc
class __$WeeklySummaryCopyWithImpl<$Res>
    implements _$WeeklySummaryCopyWith<$Res> {
  __$WeeklySummaryCopyWithImpl(this._self, this._then);

  final _WeeklySummary _self;
  final $Res Function(_WeeklySummary) _then;

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mealRecordCount = null,
    Object? recentSymptomCount = null,
    Object? streakCount = null,
    Object? mealCount = null,
  }) {
    return _then(_WeeklySummary(
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
              as MealCount,
    ));
  }

  /// Create a copy of WeeklySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealCountCopyWith<$Res> get mealCount {
    return $MealCountCopyWith<$Res>(_self.mealCount, (value) {
      return _then(_self.copyWith(mealCount: value));
    });
  }
}

// dart format on
