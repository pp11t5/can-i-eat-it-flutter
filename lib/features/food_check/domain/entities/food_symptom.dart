import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'food_symptom.freezed.dart';

/// 특정 음식에 연결된 과거 증상 이력 항목 엔티티 (GET /foods/{foodExternalId}/symptoms 대응).
///
/// 판정 상세 "이전 증상 이력" 섹션(디자인 확정 시 배선)에서 사용 예정 — 현재는
/// 데이터레이어만 구현한다(W7 Phase 5, UI 배선 defer).
///
/// [occurredAt]은 서버 ISO-8601(+09:00) 원문 문자열을 그대로 보관한다 —
/// KST 이중변환 방지(core/utils/kst_time.dart parseKst 계약).
@freezed
abstract class FoodSymptom with _$FoodSymptom {
  const factory FoodSymptom({
    required String symptomId,
    required SymptomState symptomState,
    @Default(<String>[]) List<String> symptomTypes,
    required String occurredAt,
    required String mealRecordId,
    @Default(0) int afterMealMinutes,
  }) = _FoodSymptom;
}
