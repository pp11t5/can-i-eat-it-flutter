import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent.freezed.dart';

/// 서버가 제공하는 최신 약관 한 건.
@freezed
abstract class ConsentTerm with _$ConsentTerm {
  const factory ConsentTerm({
    required int id,
    required String code,
    required String version,
    required String title,
    required String content,
    required bool isRequired,
    DateTime? effectiveDate,
  }) = _ConsentTerm;
}

/// `POST /consent`에 전송할 사용자 선택 한 건.
@freezed
abstract class ConsentChoice with _$ConsentChoice {
  const factory ConsentChoice({
    required int termId,
    required bool agreed,
  }) = _ConsentChoice;
}
