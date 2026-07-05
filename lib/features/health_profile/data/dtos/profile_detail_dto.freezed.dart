// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileDetailDto {
  String get nickName;
  String? get profileImage;
  String get email;
  String get provider;
  String get diseaseType;
  String? get representativeInfo;
  int get etcCount;

  /// Create a copy of ProfileDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileDetailDtoCopyWith<ProfileDetailDto> get copyWith =>
      _$ProfileDetailDtoCopyWithImpl<ProfileDetailDto>(
          this as ProfileDetailDto, _$identity);

  /// Serializes this ProfileDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileDetailDto &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.diseaseType, diseaseType) ||
                other.diseaseType == diseaseType) &&
            (identical(other.representativeInfo, representativeInfo) ||
                other.representativeInfo == representativeInfo) &&
            (identical(other.etcCount, etcCount) ||
                other.etcCount == etcCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickName, profileImage, email,
      provider, diseaseType, representativeInfo, etcCount);

  @override
  String toString() {
    return 'ProfileDetailDto(nickName: $nickName, profileImage: $profileImage, email: $email, provider: $provider, diseaseType: $diseaseType, representativeInfo: $representativeInfo, etcCount: $etcCount)';
  }
}

/// @nodoc
abstract mixin class $ProfileDetailDtoCopyWith<$Res> {
  factory $ProfileDetailDtoCopyWith(
          ProfileDetailDto value, $Res Function(ProfileDetailDto) _then) =
      _$ProfileDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String nickName,
      String? profileImage,
      String email,
      String provider,
      String diseaseType,
      String? representativeInfo,
      int etcCount});
}

/// @nodoc
class _$ProfileDetailDtoCopyWithImpl<$Res>
    implements $ProfileDetailDtoCopyWith<$Res> {
  _$ProfileDetailDtoCopyWithImpl(this._self, this._then);

  final ProfileDetailDto _self;
  final $Res Function(ProfileDetailDto) _then;

  /// Create a copy of ProfileDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickName = null,
    Object? profileImage = freezed,
    Object? email = null,
    Object? provider = null,
    Object? diseaseType = null,
    Object? representativeInfo = freezed,
    Object? etcCount = null,
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
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      diseaseType: null == diseaseType
          ? _self.diseaseType
          : diseaseType // ignore: cast_nullable_to_non_nullable
              as String,
      representativeInfo: freezed == representativeInfo
          ? _self.representativeInfo
          : representativeInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      etcCount: null == etcCount
          ? _self.etcCount
          : etcCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileDetailDto].
extension ProfileDetailDtoPatterns on ProfileDetailDto {
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
    TResult Function(_ProfileDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileDetailDto() when $default != null:
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
    TResult Function(_ProfileDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileDetailDto():
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
    TResult? Function(_ProfileDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileDetailDto() when $default != null:
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
            String nickName,
            String? profileImage,
            String email,
            String provider,
            String diseaseType,
            String? representativeInfo,
            int etcCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileDetailDto() when $default != null:
        return $default(
            _that.nickName,
            _that.profileImage,
            _that.email,
            _that.provider,
            _that.diseaseType,
            _that.representativeInfo,
            _that.etcCount);
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
            String nickName,
            String? profileImage,
            String email,
            String provider,
            String diseaseType,
            String? representativeInfo,
            int etcCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileDetailDto():
        return $default(
            _that.nickName,
            _that.profileImage,
            _that.email,
            _that.provider,
            _that.diseaseType,
            _that.representativeInfo,
            _that.etcCount);
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
            String nickName,
            String? profileImage,
            String email,
            String provider,
            String diseaseType,
            String? representativeInfo,
            int etcCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileDetailDto() when $default != null:
        return $default(
            _that.nickName,
            _that.profileImage,
            _that.email,
            _that.provider,
            _that.diseaseType,
            _that.representativeInfo,
            _that.etcCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfileDetailDto extends ProfileDetailDto {
  const _ProfileDetailDto(
      {this.nickName = '',
      this.profileImage,
      this.email = '',
      this.provider = 'LOCAL',
      this.diseaseType = 'gerd',
      this.representativeInfo,
      this.etcCount = 0})
      : super._();
  factory _ProfileDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailDtoFromJson(json);

  @override
  @JsonKey()
  final String nickName;
  @override
  final String? profileImage;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String provider;
  @override
  @JsonKey()
  final String diseaseType;
  @override
  final String? representativeInfo;
  @override
  @JsonKey()
  final int etcCount;

  /// Create a copy of ProfileDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileDetailDtoCopyWith<_ProfileDetailDto> get copyWith =>
      __$ProfileDetailDtoCopyWithImpl<_ProfileDetailDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileDetailDto &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.diseaseType, diseaseType) ||
                other.diseaseType == diseaseType) &&
            (identical(other.representativeInfo, representativeInfo) ||
                other.representativeInfo == representativeInfo) &&
            (identical(other.etcCount, etcCount) ||
                other.etcCount == etcCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickName, profileImage, email,
      provider, diseaseType, representativeInfo, etcCount);

  @override
  String toString() {
    return 'ProfileDetailDto(nickName: $nickName, profileImage: $profileImage, email: $email, provider: $provider, diseaseType: $diseaseType, representativeInfo: $representativeInfo, etcCount: $etcCount)';
  }
}

/// @nodoc
abstract mixin class _$ProfileDetailDtoCopyWith<$Res>
    implements $ProfileDetailDtoCopyWith<$Res> {
  factory _$ProfileDetailDtoCopyWith(
          _ProfileDetailDto value, $Res Function(_ProfileDetailDto) _then) =
      __$ProfileDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String nickName,
      String? profileImage,
      String email,
      String provider,
      String diseaseType,
      String? representativeInfo,
      int etcCount});
}

/// @nodoc
class __$ProfileDetailDtoCopyWithImpl<$Res>
    implements _$ProfileDetailDtoCopyWith<$Res> {
  __$ProfileDetailDtoCopyWithImpl(this._self, this._then);

  final _ProfileDetailDto _self;
  final $Res Function(_ProfileDetailDto) _then;

  /// Create a copy of ProfileDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nickName = null,
    Object? profileImage = freezed,
    Object? email = null,
    Object? provider = null,
    Object? diseaseType = null,
    Object? representativeInfo = freezed,
    Object? etcCount = null,
  }) {
    return _then(_ProfileDetailDto(
      nickName: null == nickName
          ? _self.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      diseaseType: null == diseaseType
          ? _self.diseaseType
          : diseaseType // ignore: cast_nullable_to_non_nullable
              as String,
      representativeInfo: freezed == representativeInfo
          ? _self.representativeInfo
          : representativeInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      etcCount: null == etcCount
          ? _self.etcCount
          : etcCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
