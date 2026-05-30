// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_agreement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TermsAgreement {
  String get version;
  DateTime get agreedAt;
  bool get termsOfService;
  bool get privacy;
  bool get sensitiveInfo;
  bool get marketing;

  /// Create a copy of TermsAgreement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TermsAgreementCopyWith<TermsAgreement> get copyWith =>
      _$TermsAgreementCopyWithImpl<TermsAgreement>(
          this as TermsAgreement, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TermsAgreement &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.agreedAt, agreedAt) ||
                other.agreedAt == agreedAt) &&
            (identical(other.termsOfService, termsOfService) ||
                other.termsOfService == termsOfService) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.sensitiveInfo, sensitiveInfo) ||
                other.sensitiveInfo == sensitiveInfo) &&
            (identical(other.marketing, marketing) ||
                other.marketing == marketing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, agreedAt,
      termsOfService, privacy, sensitiveInfo, marketing);

  @override
  String toString() {
    return 'TermsAgreement(version: $version, agreedAt: $agreedAt, termsOfService: $termsOfService, privacy: $privacy, sensitiveInfo: $sensitiveInfo, marketing: $marketing)';
  }
}

/// @nodoc
abstract mixin class $TermsAgreementCopyWith<$Res> {
  factory $TermsAgreementCopyWith(
          TermsAgreement value, $Res Function(TermsAgreement) _then) =
      _$TermsAgreementCopyWithImpl;
  @useResult
  $Res call(
      {String version,
      DateTime agreedAt,
      bool termsOfService,
      bool privacy,
      bool sensitiveInfo,
      bool marketing});
}

/// @nodoc
class _$TermsAgreementCopyWithImpl<$Res>
    implements $TermsAgreementCopyWith<$Res> {
  _$TermsAgreementCopyWithImpl(this._self, this._then);

  final TermsAgreement _self;
  final $Res Function(TermsAgreement) _then;

  /// Create a copy of TermsAgreement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? agreedAt = null,
    Object? termsOfService = null,
    Object? privacy = null,
    Object? sensitiveInfo = null,
    Object? marketing = null,
  }) {
    return _then(_self.copyWith(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      agreedAt: null == agreedAt
          ? _self.agreedAt
          : agreedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      termsOfService: null == termsOfService
          ? _self.termsOfService
          : termsOfService // ignore: cast_nullable_to_non_nullable
              as bool,
      privacy: null == privacy
          ? _self.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as bool,
      sensitiveInfo: null == sensitiveInfo
          ? _self.sensitiveInfo
          : sensitiveInfo // ignore: cast_nullable_to_non_nullable
              as bool,
      marketing: null == marketing
          ? _self.marketing
          : marketing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [TermsAgreement].
extension TermsAgreementPatterns on TermsAgreement {
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
    TResult Function(_TermsAgreement value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsAgreement() when $default != null:
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
    TResult Function(_TermsAgreement value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsAgreement():
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
    TResult? Function(_TermsAgreement value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsAgreement() when $default != null:
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
    TResult Function(String version, DateTime agreedAt, bool termsOfService,
            bool privacy, bool sensitiveInfo, bool marketing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TermsAgreement() when $default != null:
        return $default(_that.version, _that.agreedAt, _that.termsOfService,
            _that.privacy, _that.sensitiveInfo, _that.marketing);
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
    TResult Function(String version, DateTime agreedAt, bool termsOfService,
            bool privacy, bool sensitiveInfo, bool marketing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsAgreement():
        return $default(_that.version, _that.agreedAt, _that.termsOfService,
            _that.privacy, _that.sensitiveInfo, _that.marketing);
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
    TResult? Function(String version, DateTime agreedAt, bool termsOfService,
            bool privacy, bool sensitiveInfo, bool marketing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TermsAgreement() when $default != null:
        return $default(_that.version, _that.agreedAt, _that.termsOfService,
            _that.privacy, _that.sensitiveInfo, _that.marketing);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TermsAgreement extends TermsAgreement {
  const _TermsAgreement(
      {required this.version,
      required this.agreedAt,
      required this.termsOfService,
      required this.privacy,
      required this.sensitiveInfo,
      this.marketing = false})
      : super._();

  @override
  final String version;
  @override
  final DateTime agreedAt;
  @override
  final bool termsOfService;
  @override
  final bool privacy;
  @override
  final bool sensitiveInfo;
  @override
  @JsonKey()
  final bool marketing;

  /// Create a copy of TermsAgreement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TermsAgreementCopyWith<_TermsAgreement> get copyWith =>
      __$TermsAgreementCopyWithImpl<_TermsAgreement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TermsAgreement &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.agreedAt, agreedAt) ||
                other.agreedAt == agreedAt) &&
            (identical(other.termsOfService, termsOfService) ||
                other.termsOfService == termsOfService) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.sensitiveInfo, sensitiveInfo) ||
                other.sensitiveInfo == sensitiveInfo) &&
            (identical(other.marketing, marketing) ||
                other.marketing == marketing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, agreedAt,
      termsOfService, privacy, sensitiveInfo, marketing);

  @override
  String toString() {
    return 'TermsAgreement(version: $version, agreedAt: $agreedAt, termsOfService: $termsOfService, privacy: $privacy, sensitiveInfo: $sensitiveInfo, marketing: $marketing)';
  }
}

/// @nodoc
abstract mixin class _$TermsAgreementCopyWith<$Res>
    implements $TermsAgreementCopyWith<$Res> {
  factory _$TermsAgreementCopyWith(
          _TermsAgreement value, $Res Function(_TermsAgreement) _then) =
      __$TermsAgreementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String version,
      DateTime agreedAt,
      bool termsOfService,
      bool privacy,
      bool sensitiveInfo,
      bool marketing});
}

/// @nodoc
class __$TermsAgreementCopyWithImpl<$Res>
    implements _$TermsAgreementCopyWith<$Res> {
  __$TermsAgreementCopyWithImpl(this._self, this._then);

  final _TermsAgreement _self;
  final $Res Function(_TermsAgreement) _then;

  /// Create a copy of TermsAgreement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? version = null,
    Object? agreedAt = null,
    Object? termsOfService = null,
    Object? privacy = null,
    Object? sensitiveInfo = null,
    Object? marketing = null,
  }) {
    return _then(_TermsAgreement(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      agreedAt: null == agreedAt
          ? _self.agreedAt
          : agreedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      termsOfService: null == termsOfService
          ? _self.termsOfService
          : termsOfService // ignore: cast_nullable_to_non_nullable
              as bool,
      privacy: null == privacy
          ? _self.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as bool,
      sensitiveInfo: null == sensitiveInfo
          ? _self.sensitiveInfo
          : sensitiveInfo // ignore: cast_nullable_to_non_nullable
              as bool,
      marketing: null == marketing
          ? _self.marketing
          : marketing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
