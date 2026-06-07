// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/health_profile.dart';

part 'health_profile_dto.freezed.dart';
part 'health_profile_dto.g.dart';

/// 건강 프로필 DTO.
///
/// JSON 키는 api-contract.md POST /users/profile 스키마와 1:1 snake_case 매핑.
/// [toEntity] / [fromEntity]로 도메인 엔티티와 상호 변환한다.
@freezed
abstract class HealthProfileDto with _$HealthProfileDto {
  const factory HealthProfileDto({
    @Default(<String>[]) List<String> conditions,
    @Default(<String>[]) @JsonKey(name: 'symptom_frequency') List<String> symptomFrequency,
    @Default(false) bool diagnosed,
    @Default(<String>[]) @JsonKey(name: 'trigger_foods') List<String> triggerFoods,
    @JsonKey(name: 'custom_triggers') String? customTriggers,
    @Default(<String>[]) List<String> medications,
    @Default(<String>[]) List<String> allergies,
  }) = _HealthProfileDto;

  const HealthProfileDto._();

  factory HealthProfileDto.fromJson(Map<String, dynamic> json) =>
      _$HealthProfileDtoFromJson(json);

  // ---------------------------------------------------------------------------
  // 엔티티 변환
  // ---------------------------------------------------------------------------

  /// DTO → 도메인 엔티티.
  HealthProfile toEntity() => HealthProfile(
        conditions: conditions,
        symptomFrequency: symptomFrequency,
        diagnosed: diagnosed,
        triggerFoods: triggerFoods,
        customTriggers: customTriggers,
        medications: medications,
        allergies: allergies,
      );

  /// 도메인 엔티티 → DTO.
  factory HealthProfileDto.fromEntity(HealthProfile entity) => HealthProfileDto(
        conditions: entity.conditions,
        symptomFrequency: entity.symptomFrequency,
        diagnosed: entity.diagnosed,
        triggerFoods: entity.triggerFoods,
        customTriggers: entity.customTriggers,
        medications: entity.medications,
        allergies: entity.allergies,
      );
}
