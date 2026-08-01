import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';

part 'auth_me_response_dto.freezed.dart';
part 'auth_me_response_dto.g.dart';

/// `GET /auth/me` 응답 DTO (ADR-0007 §3-1 (5)).
///
/// [nickname]·[email]·[createdDate] 는 nullable(관대 파싱, A5) — 서버가 값을 누락해도
/// 파싱이 throw 하지 않는다. `toEntity()` 에서 nickname 누락 시 안전 기본값
/// ('사용자')으로 폴백하고, email·가입일은 null 을 그대로 허용한다.
///
/// 서버 JSON 키는 **`createdDate`** (예: `"2026-08-01"`). 로컬 필드명도 동일.
@freezed
abstract class AuthMeResponseDto with _$AuthMeResponseDto {
  const factory AuthMeResponseDto({
    required String userId,
    String? nickname,
    String? email,
    String? profileImage,

    /// 계정 생성일. 서버 `createdDate` — `YYYY-MM-DD` 또는 ISO datetime.
    String? createdDate,
  }) = _AuthMeResponseDto;

  factory AuthMeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseDtoFromJson(json);
}

extension AuthMeResponseDtoX on AuthMeResponseDto {
  /// DTO → domain [AuthSession] 매핑.
  ///
  /// me 엔드포인트에서 provider 를 알 수 없으므로 호출자가 [provider] 를 주입한다.
  /// nickname → displayName(누락 시 '사용자' 폴백), email(누락 허용),
  /// profileImage → profileImageUrl, createdDate → 가입일(날짜만) 을 실어 반환한다.
  AuthSession toEntity(AuthProvider provider) => AuthSession(
        userId: userId,
        provider: provider,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.active,
        displayName: nickname ?? '사용자',
        email: email,
        profileImageUrl: profileImage,
        createdAt: _parseJoinDate(createdDate),
      );
}

/// 서버 가입일 문자열 → 날짜만 남긴 KST wall-clock. 파싱 실패 시 null.
///
/// 지원: `2026-08-01`, `2026-08-01T12:34:56`, `...+09:00`.
DateTime? _parseJoinDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final dt = parseKst(raw);
    return DateTime(dt.year, dt.month, dt.day);
  } catch (_) {
    return null;
  }
}
