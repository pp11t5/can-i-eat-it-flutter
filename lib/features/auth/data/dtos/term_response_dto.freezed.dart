// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'term_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TermResponseDto {
  int get id;
  String get code;
  String get version;
  String get title;
  String get content;
  @JsonKey(name: 'required')
  bool get isRequired;
  String? get effectiveDate;

  /// Create a copy of TermResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermResponseDtoCopyWith<TermResponseDto> get copyWith =>
      _$TermResponseDtoCopyWithImpl<TermResponseDto>(
          this as TermResponseDto, _$identity);

  /// Serializes this TermResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermResponseDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.effectiveDate, effectiveDate) ||
                other.effectiveDate == effectiveDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, version, title,
      content, isRequired, effectiveDate);

  @override
  String toString() {
    return 'TermResponseDto(id: $id, code: $code, version: $version, title: $title, content: $content, isRequired: $isRequired, effectiveDate: $effectiveDate)';
  }
}

/// @nodoc
abstract mixin class $TermResponseDtoCopyWith<$Res> {
  factory $TermResponseDtoCopyWith(
          TermResponseDto value, $Res Function(TermResponseDto) _then) =
      _$TermResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String code,
      String version,
      String title,
      String content,
      @JsonKey(name: 'required') bool isRequired,
      String? effectiveDate});
}

/// @nodoc
class _$TermResponseDtoCopyWithImpl<$Res>
    implements $TermResponseDtoCopyWith<$Res> {
  _$TermResponseDtoCopyWithImpl(this._self, this._then);

  final TermResponseDto _self;
  final $Res Function(TermResponseDto) _then;

  /// Create a copy of TermResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? version = null,
    Object? title = null,
    Object? content = null,
    Object? isRequired = null,
    Object? effectiveDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _self.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      effectiveDate: freezed == effectiveDate
          ? _self.effectiveDate
          : effectiveDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TermResponseDto].
extension TermResponseDtoPatterns on TermResponseDto {
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
    TResult Function(_TermResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermResponseDto() when $default != null:
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
    TResult Function(_TermResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermResponseDto():
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
    TResult? Function(_TermResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermResponseDto() when $default != null:
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
            int id,
            String code,
            String version,
            String title,
            String content,
            @JsonKey(name: 'required') bool isRequired,
            String? effectiveDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermResponseDto() when $default != null:
        return $default(_that.id, _that.code, _that.version, _that.title,
            _that.content, _that.isRequired, _that.effectiveDate);
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
            int id,
            String code,
            String version,
            String title,
            String content,
            @JsonKey(name: 'required') bool isRequired,
            String? effectiveDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermResponseDto():
        return $default(_that.id, _that.code, _that.version, _that.title,
            _that.content, _that.isRequired, _that.effectiveDate);
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
            int id,
            String code,
            String version,
            String title,
            String content,
            @JsonKey(name: 'required') bool isRequired,
            String? effectiveDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermResponseDto() when $default != null:
        return $default(_that.id, _that.code, _that.version, _that.title,
            _that.content, _that.isRequired, _that.effectiveDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TermResponseDto implements TermResponseDto {
  const _TermResponseDto(
      {required this.id,
      required this.code,
      required this.version,
      required this.title,
      required this.content,
      @JsonKey(name: 'required') required this.isRequired,
      this.effectiveDate});
  factory _TermResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TermResponseDtoFromJson(json);

  @override
  final int id;
  @override
  final String code;
  @override
  final String version;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey(name: 'required')
  final bool isRequired;
  @override
  final String? effectiveDate;

  /// Create a copy of TermResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TermResponseDtoCopyWith<_TermResponseDto> get copyWith =>
      __$TermResponseDtoCopyWithImpl<_TermResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TermResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TermResponseDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.effectiveDate, effectiveDate) ||
                other.effectiveDate == effectiveDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, version, title,
      content, isRequired, effectiveDate);

  @override
  String toString() {
    return 'TermResponseDto(id: $id, code: $code, version: $version, title: $title, content: $content, isRequired: $isRequired, effectiveDate: $effectiveDate)';
  }
}

/// @nodoc
abstract mixin class _$TermResponseDtoCopyWith<$Res>
    implements $TermResponseDtoCopyWith<$Res> {
  factory _$TermResponseDtoCopyWith(
          _TermResponseDto value, $Res Function(_TermResponseDto) _then) =
      __$TermResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String code,
      String version,
      String title,
      String content,
      @JsonKey(name: 'required') bool isRequired,
      String? effectiveDate});
}

/// @nodoc
class __$TermResponseDtoCopyWithImpl<$Res>
    implements _$TermResponseDtoCopyWith<$Res> {
  __$TermResponseDtoCopyWithImpl(this._self, this._then);

  final _TermResponseDto _self;
  final $Res Function(_TermResponseDto) _then;

  /// Create a copy of TermResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? version = null,
    Object? title = null,
    Object? content = null,
    Object? isRequired = null,
    Object? effectiveDate = freezed,
  }) {
    return _then(_TermResponseDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _self.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      effectiveDate: freezed == effectiveDate
          ? _self.effectiveDate
          : effectiveDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
