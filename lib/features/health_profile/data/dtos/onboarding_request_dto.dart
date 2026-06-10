import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/health_profile.dart';

part 'onboarding_request_dto.freezed.dart';
part 'onboarding_request_dto.g.dart';

/// `POST /onboarding` 요청 DTO (ADR-0007 §3-1 (5)).
///
/// [HealthProfile] 엔티티를 서버 스키마로 변환한다.
///
/// 필드 상이분 흡수 매핑:
/// - [HealthProfile.conditions]       → [symptoms] (List<String>)
/// - [HealthProfile.symptomFrequency] → [symptomFrequency] (List<String>)
/// - [HealthProfile.diagnosed]        → [diagnosed] (bool)
/// - [HealthProfile.triggerFoods]     → [triggers] (List<String>, conditions + customTriggers 통합)
/// - [HealthProfile.customTriggers]   → triggers 리스트에 단일 항목으로 병합
/// - [HealthProfile.medications]      → [medications] (List<String>)
/// - [HealthProfile.allergies]        → [allergens] (List<String>)
///
/// 서버 스키마: { symptoms, symptomFrequency, diagnosed, triggers, medications, allergens }
/// 엔티티 스키마: { conditions, symptomFrequency, diagnosed, triggerFoods, customTriggers, medications, allergies }
@freezed
abstract class OnboardingRequestDto with _$OnboardingRequestDto {
  const factory OnboardingRequestDto({
    @Default(<String>[]) List<String> symptoms,
    @Default(<String>[]) List<String> symptomFrequency,
    @Default(false) bool diagnosed,
    @Default(<String>[]) List<String> triggers,
    @Default(<String>[]) List<String> medications,
    @Default(<String>[]) List<String> allergens,
  }) = _OnboardingRequestDto;

  const OnboardingRequestDto._();

  factory OnboardingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestDtoFromJson(json);

  /// [HealthProfile] 엔티티 → DTO.
  ///
  /// [HealthProfile.triggerFoods] + [HealthProfile.customTriggers]를
  /// 단일 [triggers] 리스트로 병합한다.
  factory OnboardingRequestDto.fromEntity(HealthProfile entity) {
    // customTriggers가 있으면 triggers 리스트 끝에 추가
    final triggers = [
      ...entity.triggerFoods,
      if (entity.customTriggers != null &&
          entity.customTriggers!.isNotEmpty)
        entity.customTriggers!,
    ];

    return OnboardingRequestDto(
      symptoms: entity.conditions,
      symptomFrequency: entity.symptomFrequency,
      diagnosed: entity.diagnosed,
      triggers: triggers,
      medications: entity.medications,
      allergens: entity.allergies,
    );
  }
}
