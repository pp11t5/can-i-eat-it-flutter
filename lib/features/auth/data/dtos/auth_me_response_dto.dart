import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';

part 'auth_me_response_dto.freezed.dart';
part 'auth_me_response_dto.g.dart';

/// `GET /auth/me` 응답 DTO (ADR-0007 §3-1 (5)).
///
/// [nickname]·[email] 은 nullable(관대 파싱, A5) — 서버가 값을 누락해도 파싱이
/// throw 하지 않는다. `toEntity()` 에서 nickname 누락 시 안전 기본값('사용자')으로
/// 폴백하고, email 은 null 을 그대로 허용한다.
@freezed
abstract class AuthMeResponseDto with _$AuthMeResponseDto {
  const factory AuthMeResponseDto({
    required String userId,
    String? nickname,
    String? email,
    String? profileImage,
  }) = _AuthMeResponseDto;

  factory AuthMeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseDtoFromJson(json);
}

extension AuthMeResponseDtoX on AuthMeResponseDto {
  /// DTO → domain [AuthSession] 매핑.
  ///
  /// me 엔드포인트에서 provider 를 알 수 없으므로 호출자가 [provider] 를 주입한다.
  /// nickname → displayName(누락 시 '사용자' 폴백), email(누락 허용),
  /// profileImage → profileImageUrl 을 실어 반환한다 (A5 관대 파싱).
  AuthSession toEntity(AuthProvider provider) => AuthSession(
        userId: userId,
        provider: provider,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.active,
        displayName: nickname ?? '사용자',
        email: email,
        profileImageUrl: profileImage,
      );
}
