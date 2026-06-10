import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';

part 'auth_login_response_dto.freezed.dart';
part 'auth_login_response_dto.g.dart';

/// `POST /auth/{provider}/login` 성공(200) 응답 DTO (ADR-0007 §3-1 (5)).
///
/// 서버 JSON camelCase 그대로 매핑. `@JsonKey` 는 불필요.
@freezed
abstract class AuthLoginResponseDto with _$AuthLoginResponseDto {
  const factory AuthLoginResponseDto({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String role,
  }) = _AuthLoginResponseDto;

  factory AuthLoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginResponseDtoFromJson(json);
}

extension AuthLoginResponseDtoX on AuthLoginResponseDto {
  /// DTO → domain [AuthSession] 매핑.
  ///
  /// 200 성공은 항상 약관 동의 완료 + active (ADR-0007 §3-1 (6-B)).
  AuthSession toEntity(AuthProvider provider) => AuthSession(
        userId: userId,
        provider: provider,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.active,
      );
}
