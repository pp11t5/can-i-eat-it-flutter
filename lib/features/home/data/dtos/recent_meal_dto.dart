import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'recent_meal_dto.freezed.dart';
part 'recent_meal_dto.g.dart';

/// GET /meal-records/recent-foods 응답 항목 DTO.
///
/// 서버 JSON 필드: camelCase. entity 변환: [toEntity].
@freezed
abstract class RecentMealDto with _$RecentMealDto {
  const factory RecentMealDto({
    required String foodName,
    String? category,
    required String eatenAt,
    String? symptomState,
  }) = _RecentMealDto;

  factory RecentMealDto.fromJson(Map<String, dynamic> json) =>
      _$RecentMealDtoFromJson(json);
}

extension RecentMealDtoMapper on RecentMealDto {
  RecentMeal toEntity() => RecentMeal(
        foodName: foodName,
        category: category,
        eatenAt: eatenAt,
        symptomState: symptomState != null
            ? SymptomStateMapper.fromServer(symptomState!)
            : null,
      );
}
