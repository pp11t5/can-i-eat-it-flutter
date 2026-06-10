import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';

part 'auth_me_response_dto.freezed.dart';
part 'auth_me_response_dto.g.dart';

/// `GET /auth/me` 응답 DTO (ADR-0007 §3-1 (5)).
@freezed
abstract class AuthMeResponseDto with _$AuthMeResponseDto {
  const factory AuthMeResponseDto({
    required String userId,
    required String nickname,
    required String email,
    String? profileImage,
  }) = _AuthMeResponseDto;

  factory AuthMeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseDtoFromJson(json);
}

extension AuthMeResponseDtoX on AuthMeResponseDto {
  /// DTO → domain [AuthSession] 매핑.
  ///
  /// me 엔드포인트에서 provider 를 알 수 없으므로 호출자가 [provider] 를 주입한다.
  AuthSession toEntity(AuthProvider provider) => AuthSession(
        userId: userId,
        provider: provider,
        hasAgreedTerms: true,
        accountStatus: AccountStatus.active,
      );
}
