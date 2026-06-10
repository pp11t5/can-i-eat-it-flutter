import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/terms_agreement.dart';

part 'consent_request_dto.freezed.dart';
part 'consent_request_dto.g.dart';

/// `POST /consent` 요청 DTO (ADR-0007 §3-1 (5)).
///
/// [TermsAgreement] 엔티티를 서버 스키마로 변환한다.
///
/// 필드 매핑:
/// - [TermsAgreement.termsOfService] → [tos]
/// - [TermsAgreement.privacy]        → [privacy]
/// - [TermsAgreement.sensitiveInfo]  → [healthSensitive]
/// - [TermsAgreement.marketing]      → [marketing]
@freezed
abstract class ConsentRequestDto with _$ConsentRequestDto {
  const factory ConsentRequestDto({
    required bool tos,
    required bool privacy,
    required bool healthSensitive,
    required bool marketing,
  }) = _ConsentRequestDto;

  const ConsentRequestDto._();

  factory ConsentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentRequestDtoFromJson(json);

  /// [TermsAgreement] 엔티티 → DTO.
  factory ConsentRequestDto.fromEntity(TermsAgreement agreement) =>
      ConsentRequestDto(
        tos: agreement.termsOfService,
        privacy: agreement.privacy,
        healthSensitive: agreement.sensitiveInfo,
        marketing: agreement.marketing,
      );
}
