import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'food_symptom_dto.freezed.dart';
part 'food_symptom_dto.g.dart';

/// GET /foods/{foodExternalId}/symptoms 응답 항목 DTO.
///
/// 서버 JSON 필드: camelCase. entity 변환: [toEntity].
@freezed
abstract class FoodSymptomDto with _$FoodSymptomDto {
  const factory FoodSymptomDto({
    required String symptomId,
    required String symptomState,
    @Default(<String>[]) List<String> symptomTypes,
    required String occurredAt,
    required String mealRecordId,
    @Default(0) int afterMealMinutes,
  }) = _FoodSymptomDto;

  factory FoodSymptomDto.fromJson(Map<String, dynamic> json) =>
      _$FoodSymptomDtoFromJson(json);
}

extension FoodSymptomDtoMapper on FoodSymptomDto {
  FoodSymptom toEntity() => FoodSymptom(
        symptomId: symptomId,
        symptomState: SymptomStateMapper.fromServer(symptomState),
        symptomTypes: symptomTypes,
        occurredAt: occurredAt,
        mealRecordId: mealRecordId,
        afterMealMinutes: afterMealMinutes,
      );
}
