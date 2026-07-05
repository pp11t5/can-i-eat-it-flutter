import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'recent_meal.freezed.dart';

/// 최근 식사 항목 엔티티 (GET /meal-records/recent-foods 대응).
///
/// [eatenAt]은 서버 ISO-8601(+09:00) 원문 문자열을 그대로 보관한다 — KST 이중변환
/// 방지 (core/utils/kst_time.dart parseKst 계약, meal_timeline_list.dart와 동일 원칙).
/// 표시 시 [parseKst] + 수동 포맷으로 변환한다.
@freezed
abstract class RecentMeal with _$RecentMeal {
  const factory RecentMeal({
    required String foodName,

    /// 음식 카테고리 코드. 서버가 없으면 null.
    String? category,
    required String eatenAt,

    /// 연결된 증상 상태. 증상 기록이 없으면 null.
    SymptomState? symptomState,
  }) = _RecentMeal;
}
