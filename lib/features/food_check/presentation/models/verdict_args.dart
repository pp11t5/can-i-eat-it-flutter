/// 식사 기록 컨텍스트 — /check 진입 시 전달해 판정 후 기록에 활용.
///
/// food_check 패키지 내에 선언해 순환 의존 없이 meal_log → food_check 방향 유지.
class MealRecordContext {
  const MealRecordContext({
    required this.eatenAt,
    this.mealGroupId,
  });

  /// 섭취 시각 (KST DateTime).
  final DateTime eatenAt;

  /// 기존 끼니 그룹에 추가할 때 지정. null이면 신규 그룹.
  final String? mealGroupId;
}

/// 판정 화면 진입 인자 (go_router /verdict extra).
///
/// 진입 경로에 따라 판정 메서드를 선택한다:
/// - [externalId] 있음 → [FoodRepository.judgeById] (검색 결과 셀 탭)
/// - [externalId] null → [FoodRepository.judgeByText] (raw text 직접 분석)
///
/// [text]: 분석할 음식명 (by-text) 또는 표시용 음식명 (by-id 로딩 중 임시).
/// [recordContext]: 식사 기록 흐름에서 진입 시 전달. null이면 단순 판정.
class VerdictArgs {
  const VerdictArgs({
    required this.text,
    this.externalId,
    this.recordContext,
  });

  /// 분석할 음식명 또는 by-id 로딩 중 표시용 음식명.
  final String text;

  /// 서버 음식 식별자. null이면 by-text 진입.
  final String? externalId;

  /// 식사 기록 컨텍스트. null이면 단순 판정 흐름.
  final MealRecordContext? recordContext;

  /// by-id 진입 여부.
  bool get isById => externalId != null;
}
