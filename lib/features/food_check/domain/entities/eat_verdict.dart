/// 신호등 판정 4상태 (ADR-0003).
///
/// - [recommend]: 권장 — 섭취해도 무방한 식품.
/// - [caution]: 주의 — 조건부 섭취 또는 소량 섭취 권장.
/// - [danger]: 위험 — 섭취를 피해야 하는 식품.
/// - [unknown]: 확인어려움 — LLM 신뢰도 미달·DB 미매칭 폴백. 단정 금지.
///
/// 전체 EatVerdict 엔티티(reason, alternatives 등)는 W3에서 추가.
enum VerdictLevel { recommend, caution, danger, unknown }

/// [VerdictLevel] 한국어 라벨 확장.
extension VerdictLevelLabel on VerdictLevel {
  /// 화면 표시용 한국어 라벨.
  String get label {
    return switch (this) {
      VerdictLevel.recommend => '권장',
      VerdictLevel.caution => '주의',
      VerdictLevel.danger => '위험',
      VerdictLevel.unknown => '확인어려움',
    };
  }
}
