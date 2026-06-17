import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/health_profile.dart';

part 'onboarding_request_dto.freezed.dart';
part 'onboarding_request_dto.g.dart';

/// `POST /onboarding` 요청 DTO.
///
/// 서버 스키마(OnboardingRequestDTO, Swagger /v3/api-docs) 정합 버전.
///
/// 필드 매핑:
/// - [HealthProfile.symptomFrequency] → [symptoms]   (서버 symptom enum 값 그대로)
/// - [HealthProfile.triggerFoods]     → [triggers]   (서버 trigger enum)
/// - [HealthProfile.allergies]        → [allergens]  (서버 allergen enum)
/// - [HealthProfile.medications]      → [medications] (자유 텍스트)
/// - [HealthProfile.customTriggers]   → [customTriggerText] (null 가능)
///
/// **제외 필드**: conditions(GERD 질환), diagnosed, symptomFrequency 키.
/// 서버에 없는 필드이므로 전송하지 않는다 (COMMON400_2 원인 제거).
@freezed
abstract class OnboardingRequestDto with _$OnboardingRequestDto {
  const factory OnboardingRequestDto({
    @Default(<String>[]) List<String> symptoms,
    @Default(<String>[]) List<String> triggers,
    @Default(<String>[]) List<String> allergens,
    @Default(<String>[]) List<String> medications,
    String? customTriggerText,
  }) = _OnboardingRequestDto;

  const OnboardingRequestDto._();

  factory OnboardingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestDtoFromJson(json);

  /// [HealthProfile] 엔티티 → DTO.
  ///
  /// - [HealthProfile.symptomFrequency] → [symptoms] (서버 symptom enum과 동일 값)
  /// - [HealthProfile.triggerFoods]     → [triggers]
  /// - [HealthProfile.allergies]        → [allergens]
  /// - [HealthProfile.medications]      → [medications]
  /// - [HealthProfile.customTriggers]   → [customTriggerText] (빈 문자열은 null 처리)
  /// - [HealthProfile.conditions] / [HealthProfile.diagnosed] 는 전송하지 않는다.
  factory OnboardingRequestDto.fromEntity(HealthProfile entity) {
    final customText = entity.customTriggers != null &&
            entity.customTriggers!.isNotEmpty
        ? entity.customTriggers
        : null;

    return OnboardingRequestDto(
      symptoms: entity.symptomFrequency,
      triggers: entity.triggerFoods,
      allergens: entity.allergies,
      medications: entity.medications,
      customTriggerText: customText,
    );
  }
}
