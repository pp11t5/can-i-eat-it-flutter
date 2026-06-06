/// 약관 버전 단일 소스 (이슈 #20 N1).
///
/// 약관 버전은 규제·동의 이력 추적의 핵심이므로 화면·테스트가 이 상수를
/// 단일 소스로 참조한다. 하드코딩으로 인한 드리프트(화면 'v1.0' vs 테스트 '1.0.0')를
/// 방지한다. 약관 개정 시 이 값만 갱신한다.
class TermsCatalog {
  const TermsCatalog._();

  /// 현재 약관 버전.
  static const String currentVersion = 'v1.0';
}
