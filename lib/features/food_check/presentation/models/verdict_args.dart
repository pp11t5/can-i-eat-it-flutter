/// 판정 화면 진입 인자 (go_router /verdict extra).
///
/// 진입 경로에 따라 판정 메서드를 선택한다:
/// - [externalId] 있음 → [FoodRepository.judgeById] (검색 결과 셀 탭)
/// - [externalId] null → [FoodRepository.judgeByText] (raw text 직접 분석)
///
/// [text]: 분석할 음식명 (by-text) 또는 표시용 음식명 (by-id 로딩 중 임시).
class VerdictArgs {
  const VerdictArgs({
    required this.text,
    this.externalId,
  });

  /// 분석할 음식명 또는 by-id 로딩 중 표시용 음식명.
  final String text;

  /// 서버 음식 식별자. null이면 by-text 진입.
  final String? externalId;

  /// by-id 진입 여부.
  bool get isById => externalId != null;
}
