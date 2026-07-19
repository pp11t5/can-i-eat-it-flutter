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
/// 구 계약(`{tos,privacy,healthSensitive,marketing}` 4-bool)에서
/// `{consents:[{termId,agreed}]}` 형태로 전환됐다. 로컬 [TermsAgreement] 엔티티
/// (구 4-bool 슬롯)를 서버 termId 기반 배열로 매핑하는 책임은
/// `AuthRepositoryImpl.recordTermsAgreement` 가 진다(termId 조인이 필요하므로
/// `GET /consent/terms` 응답 없이는 이 DTO를 순수 함수로 만들 수 없음).
@freezed
abstract class ConsentRequestDto with _$ConsentRequestDto {
  const factory ConsentRequestDto({
    required List<ConsentItemDto> consents,
  }) = _ConsentRequestDto;

  factory ConsentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentRequestDtoFromJson(json);
}
