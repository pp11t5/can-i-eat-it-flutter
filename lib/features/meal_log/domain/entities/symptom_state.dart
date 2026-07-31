/// 증상 5단계 enum (증상레이어 공유).
///
/// 서버 소문자 문자열(comfortable|good|normal|uncomfortable|severe)과 1:1 정합.
/// W5-1 타임라인 symptom 변형이 즉시 사용하고, W5-2 증상레이어도 같은 enum을 공유한다.
library;

/// 증상 5단계.
///
/// - [comfortable]: 편안함
/// - [good]: 좋음
/// - [normal]: 보통
/// - [uncomfortable]: 불편함
/// - [severe]: 심함
enum SymptomState { comfortable, good, normal, uncomfortable, severe }

/// [SymptomState] 서버 변환·표시 확장.
extension SymptomStateMapper on SymptomState {
  /// 서버 [v] 문자열을 [SymptomState] 로 변환한다. 미지 코드는 null.
  static SymptomState? fromServerNullable(String v) => switch (v) {
        'comfortable' => SymptomState.comfortable,
        'good' => SymptomState.good,
        'normal' => SymptomState.normal,
        'uncomfortable' => SymptomState.uncomfortable,
        'severe' => SymptomState.severe,
        _ => null,
      };

  /// 서버 [v] 문자열을 [SymptomState] 로 변환한다.
  ///
  /// 미지값은 [SymptomState.normal] (중립)로 폴백 — 신규 상태 추가 시
  /// 앱이 죽지 않도록 하는 안전 기본값(grade의 `_ => unknown`과 동일 철학).
  static SymptomState fromServer(String v) =>
      fromServerNullable(v) ?? SymptomState.normal;

  /// 도메인 [SymptomState] 를 서버 문자열로 변환한다 (W5-2 POST용).
  String toServer() => switch (this) {
        SymptomState.comfortable => 'comfortable',
        SymptomState.good => 'good',
        SymptomState.normal => 'normal',
        SymptomState.uncomfortable => 'uncomfortable',
        SymptomState.severe => 'severe',
      };

  /// 화면 표시용 한국어 라벨.
  String get label => switch (this) {
        SymptomState.comfortable => '편안함',
        SymptomState.good => '좋음',
        SymptomState.normal => '보통',
        SymptomState.uncomfortable => '불편함',
        SymptomState.severe => '심함',
      };

  /// 서버 코드·표시 문자열을 [SymptomState] 로 매핑한다.
  ///
  /// 1) 서버 enum code (`severe` 등) 정확 매칭
  /// 2) 한글 표시 라벨 근사 (`편안해요`·`불편함` 등)
  /// 미상 값은 [SymptomState.normal] 로 폴백.
  /// ('불편'은 '편'을 포함하므로 '편안'을 먼저 검사.)
  static SymptomState fromLabel(String label) {
    final byCode = fromServerNullable(label);
    if (byCode != null) return byCode;
    if (label.contains('편안')) return SymptomState.comfortable;
    if (label.contains('불편')) return SymptomState.uncomfortable;
    if (label.contains('심')) return SymptomState.severe;
    if (label.contains('좋')) return SymptomState.good;
    if (label.contains('보통')) return SymptomState.normal;
    return SymptomState.normal;
  }

  /// 서버 raw 라벨을 화면용 한글로 정규화한다.
  ///
  /// 알려진 상태 코드면 [label], 그 외(레거시 문자열 등)는 원문 유지.
  static String displayLabel(String raw) =>
      fromServerNullable(raw)?.label ?? raw;
}
