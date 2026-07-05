import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_info_dto.freezed.dart';
part 'medical_info_dto.g.dart';

// ---------------------------------------------------------------------------
// MedicalInfoDto — GET /my-page/health-info
// ---------------------------------------------------------------------------

/// `GET /my-page/health-info` 응답 DTO.
@freezed
abstract class MedicalInfoDto with _$MedicalInfoDto {
  const factory MedicalInfoDto({
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> medications,
  }) = _MedicalInfoDto;

  factory MedicalInfoDto.fromJson(Map<String, dynamic> json) =>
      _$MedicalInfoDtoFromJson(json);
}

// ---------------------------------------------------------------------------
// MedicalInfoUpdateRequestDto — PATCH /my-page/health-info
// ---------------------------------------------------------------------------

/// `PATCH /my-page/health-info` 요청 DTO.
///
/// 서버 필드명은 `allergens`(HealthProfile.allergies 매핑 — OnboardingRequestDto와
/// 동일 관례, allergen enum: milk|egg|wheat|soy|peanut|crustacean|tree_nut|fish_shellfish).
@freezed
abstract class MedicalInfoUpdateRequestDto with _$MedicalInfoUpdateRequestDto {
  const factory MedicalInfoUpdateRequestDto({
    @Default(<String>[]) List<String> allergens,
    @Default(<String>[]) List<String> medications,
  }) = _MedicalInfoUpdateRequestDto;

  factory MedicalInfoUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MedicalInfoUpdateRequestDtoFromJson(json);
}
