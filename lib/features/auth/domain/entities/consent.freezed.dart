// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsentTerm {
  int get id;
  String get code;
  String get version;
  String get title;
  String get content;
  bool get isRequired;
  DateTime? get effectiveDate;

  /// Create a copy of ConsentTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConsentTermCopyWith<ConsentTerm> get copyWith =>
      _$ConsentTermCopyWithImpl<ConsentTerm>(this as ConsentTerm, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConsentTerm &&
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

  @override
  int get hashCode => Object.hash(runtimeType, id, code, version, title,
      content, isRequired, effectiveDate);

  @override
  String toString() {
    return 'ConsentTerm(id: $id, code: $code, version: $version, title: $title, content: $content, isRequired: $isRequired, effectiveDate: $effectiveDate)';
  }
}

/// @nodoc
abstract mixin class $ConsentTermCopyWith<$Res> {
  factory $ConsentTermCopyWith(
          ConsentTerm value, $Res Function(ConsentTerm) _then) =
      _$ConsentTermCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String code,
      String version,
      String title,
      String content,
      bool isRequired,
      DateTime? effectiveDate});
}

/// @nodoc
class _$ConsentTermCopyWithImpl<$Res> implements $ConsentTermCopyWith<$Res> {
  _$ConsentTermCopyWithImpl(this._self, this._then);

  final ConsentTerm _self;
  final $Res Function(ConsentTerm) _then;

  /// Create a copy of ConsentTerm
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
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConsentTerm].
extension ConsentTermPatterns on ConsentTerm {
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
    TResult Function(_ConsentTerm value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentTerm() when $default != null:
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
    TResult Function(_ConsentTerm value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentTerm():
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
    TResult? Function(_ConsentTerm value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentTerm() when $default != null:
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
    TResult Function(int id, String code, String version, String title,
            String content, bool isRequired, DateTime? effectiveDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentTerm() when $default != null:
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
    TResult Function(int id, String code, String version, String title,
            String content, bool isRequired, DateTime? effectiveDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentTerm():
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
    TResult? Function(int id, String code, String version, String title,
            String content, bool isRequired, DateTime? effectiveDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentTerm() when $default != null:
        return $default(_that.id, _that.code, _that.version, _that.title,
            _that.content, _that.isRequired, _that.effectiveDate);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConsentTerm implements ConsentTerm {
  const _ConsentTerm(
      {required this.id,
      required this.code,
      required this.version,
      required this.title,
      required this.content,
      required this.isRequired,
      this.effectiveDate});

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
  final bool isRequired;
  @override
  final DateTime? effectiveDate;

  /// Create a copy of ConsentTerm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConsentTermCopyWith<_ConsentTerm> get copyWith =>
      __$ConsentTermCopyWithImpl<_ConsentTerm>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConsentTerm &&
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

  @override
  int get hashCode => Object.hash(runtimeType, id, code, version, title,
      content, isRequired, effectiveDate);

  @override
  String toString() {
    return 'ConsentTerm(id: $id, code: $code, version: $version, title: $title, content: $content, isRequired: $isRequired, effectiveDate: $effectiveDate)';
  }
}

/// @nodoc
abstract mixin class _$ConsentTermCopyWith<$Res>
    implements $ConsentTermCopyWith<$Res> {
  factory _$ConsentTermCopyWith(
          _ConsentTerm value, $Res Function(_ConsentTerm) _then) =
      __$ConsentTermCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String code,
      String version,
      String title,
      String content,
      bool isRequired,
      DateTime? effectiveDate});
}

/// @nodoc
class __$ConsentTermCopyWithImpl<$Res> implements _$ConsentTermCopyWith<$Res> {
  __$ConsentTermCopyWithImpl(this._self, this._then);

  final _ConsentTerm _self;
  final $Res Function(_ConsentTerm) _then;

  /// Create a copy of ConsentTerm
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
    return _then(_ConsentTerm(
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
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$ConsentChoice {
  int get termId;
  bool get agreed;

  /// Create a copy of ConsentChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConsentChoiceCopyWith<ConsentChoice> get copyWith =>
      _$ConsentChoiceCopyWithImpl<ConsentChoice>(
          this as ConsentChoice, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConsentChoice &&
            (identical(other.termId, termId) || other.termId == termId) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, termId, agreed);

  @override
  String toString() {
    return 'ConsentChoice(termId: $termId, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class $ConsentChoiceCopyWith<$Res> {
  factory $ConsentChoiceCopyWith(
          ConsentChoice value, $Res Function(ConsentChoice) _then) =
      _$ConsentChoiceCopyWithImpl;
  @useResult
  $Res call({int termId, bool agreed});
}

/// @nodoc
class _$ConsentChoiceCopyWithImpl<$Res>
    implements $ConsentChoiceCopyWith<$Res> {
  _$ConsentChoiceCopyWithImpl(this._self, this._then);

  final ConsentChoice _self;
  final $Res Function(ConsentChoice) _then;

  /// Create a copy of ConsentChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termId = null,
    Object? agreed = null,
  }) {
    return _then(_self.copyWith(
      termId: null == termId
          ? _self.termId
          : termId // ignore: cast_nullable_to_non_nullable
              as int,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConsentChoice].
extension ConsentChoicePatterns on ConsentChoice {
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
    TResult Function(_ConsentChoice value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentChoice() when $default != null:
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
    TResult Function(_ConsentChoice value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentChoice():
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
    TResult? Function(_ConsentChoice value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentChoice() when $default != null:
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
    TResult Function(int termId, bool agreed)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConsentChoice() when $default != null:
        return $default(_that.termId, _that.agreed);
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
    TResult Function(int termId, bool agreed) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentChoice():
        return $default(_that.termId, _that.agreed);
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
    TResult? Function(int termId, bool agreed)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConsentChoice() when $default != null:
        return $default(_that.termId, _that.agreed);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConsentChoice implements ConsentChoice {
  const _ConsentChoice({required this.termId, required this.agreed});

  @override
  final int termId;
  @override
  final bool agreed;

  /// Create a copy of ConsentChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConsentChoiceCopyWith<_ConsentChoice> get copyWith =>
      __$ConsentChoiceCopyWithImpl<_ConsentChoice>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConsentChoice &&
            (identical(other.termId, termId) || other.termId == termId) &&
            (identical(other.agreed, agreed) || other.agreed == agreed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, termId, agreed);

  @override
  String toString() {
    return 'ConsentChoice(termId: $termId, agreed: $agreed)';
  }
}

/// @nodoc
abstract mixin class _$ConsentChoiceCopyWith<$Res>
    implements $ConsentChoiceCopyWith<$Res> {
  factory _$ConsentChoiceCopyWith(
          _ConsentChoice value, $Res Function(_ConsentChoice) _then) =
      __$ConsentChoiceCopyWithImpl;
  @override
  @useResult
  $Res call({int termId, bool agreed});
}

/// @nodoc
class __$ConsentChoiceCopyWithImpl<$Res>
    implements _$ConsentChoiceCopyWith<$Res> {
  __$ConsentChoiceCopyWithImpl(this._self, this._then);

  final _ConsentChoice _self;
  final $Res Function(_ConsentChoice) _then;

  /// Create a copy of ConsentChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? termId = null,
    Object? agreed = null,
  }) {
    return _then(_ConsentChoice(
      termId: null == termId
          ? _self.termId
          : termId // ignore: cast_nullable_to_non_nullable
              as int,
      agreed: null == agreed
          ? _self.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
