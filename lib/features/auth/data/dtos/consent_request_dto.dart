import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_request_dto.freezed.dart';
part 'consent_request_dto.g.dart';

/// `POST /consent` 요청 항목 DTO — 약관 신 계약(termId 기반).
///
/// [termId] 는 `GET /consent/terms` 응답의 `id` 를 그대로 사용한다
/// (하드코딩 절대 금지, 규제성 데이터).
@freezed
abstract class ConsentItemDto with _$ConsentItemDto {
  const factory ConsentItemDto({
    required int termId,
    required bool agreed,
  }) = _ConsentItemDto;

  factory ConsentItemDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentItemDtoFromJson(json);
}

/// `POST /consent` 요청 바디 DTO (약관 신 계약 마이그레이션).
///
/// 화면에 표시된 최신 약관의 termId와 선택값을 그대로 배열로 전달한다.
@freezed
abstract class ConsentRequestDto with _$ConsentRequestDto {
  const factory ConsentRequestDto({
    required List<ConsentItemDto> consents,
  }) = _ConsentRequestDto;

  factory ConsentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentRequestDtoFromJson(json);
}
