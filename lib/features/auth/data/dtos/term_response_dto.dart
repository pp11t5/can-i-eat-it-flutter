// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'term_response_dto.freezed.dart';
part 'term_response_dto.g.dart';

/// `GET /consent/terms` 배열 원소 응답 DTO (약관 신 계약 마이그레이션).
///
/// 서버 `TermResponseDTO`. [code] 는 [id](termId)로 조인하기 위한 키이며,
/// 화면·로컬 슬롯(tos/privacy/healthSensitive/marketing)과의 매핑은
/// `TermsCatalog` 상수를 통해 이뤄진다. termId 는 절대 하드코딩하지 않고
/// 항상 이 응답에서 조인한다(규제성 데이터).
///
/// [isRequired] 는 서버 JSON 키가 `required`(Dart 예약어)이므로 `@JsonKey` 로 우회.
/// [effectiveDate] 는 nullable 방어(라이브 계약에 date 타입이나 값 부재 가능성 대비).
@freezed
abstract class TermResponseDto with _$TermResponseDto {
  const factory TermResponseDto({
    required int id,
    required String code,
    required String version,
    required String title,
    required String content,
    @JsonKey(name: 'required') required bool isRequired,
    String? effectiveDate,
  }) = _TermResponseDto;

  factory TermResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TermResponseDtoFromJson(json);
}
