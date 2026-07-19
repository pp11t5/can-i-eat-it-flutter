import 'package:freezed_annotation/freezed_annotation.dart';

part 'nickname_update_request_dto.freezed.dart';
part 'nickname_update_request_dto.g.dart';

// ---------------------------------------------------------------------------
// NicknameUpdateRequestDto — PATCH /my-page/nickname
// ---------------------------------------------------------------------------

/// `PATCH /my-page/nickname` 요청 DTO.
///
/// 서버 계약(NicknameUpdateRequestDTO): `nickname:string`, maxLength 12, minLength 1.
/// Figma는 15자 — 사용자 결정으로 클라이언트 상한은 15로 구현(scratchpad api-contracts.md
/// "Nickname (D3)" 참조). 서버가 400(length)으로 거부하면 상한을 12로 하향해야 한다.
@freezed
abstract class NicknameUpdateRequestDto with _$NicknameUpdateRequestDto {
  const factory NicknameUpdateRequestDto({
    required String nickname,
  }) = _NicknameUpdateRequestDto;

  factory NicknameUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$NicknameUpdateRequestDtoFromJson(json);
}
