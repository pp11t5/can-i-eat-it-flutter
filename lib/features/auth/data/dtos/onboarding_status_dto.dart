import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_status_dto.freezed.dart';
part 'onboarding_status_dto.g.dart';

/// `GET /onboarding/status` 응답 DTO (ADR-0007 §3-1 (5)).
@freezed
abstract class OnboardingStatusDto with _$OnboardingStatusDto {
  const factory OnboardingStatusDto({
    required bool onboarded,
  }) = _OnboardingStatusDto;

  factory OnboardingStatusDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusDtoFromJson(json);
}
