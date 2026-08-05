/// 마이페이지의 기존 정적 약관 링크 카탈로그.
///
/// 소셜 로그인 뒤 동의 화면은 이 값을 사용하지 않고 `GET /consent/terms`
/// 응답의 제목·필수 여부·버전·상세 URL을 유일한 진실 원천으로 사용한다.
class TermsCatalog {
  const TermsCatalog._();

  /// 현재 약관 버전.
  static const String currentVersion = 'v1.0';

  /// 서비스 이용약관 실 URL (Notion).
  static const String tosUrl =
      'https://neoself.notion.site/39712597ad8781198700d25f23713bad';

  /// 개인정보 처리방침 실 URL (Notion).
  static const String privacyUrl =
      'https://neoself.notion.site/39712597ad87811bb70fd8033f4736ad';

  /// 마케팅 정보 수신 동의 실 URL (Notion, 선택 항목).
  static const String marketingUrl =
      'https://neoself.notion.site/39712597ad878100ad99e610642e69f4';
}

/// `GET /consent/terms` 응답에서 알려진 약관의 `code` 상수.
///
/// termId(=서버 term의 `id`)는 항상 `GET /consent/terms` 응답에서 조인하며
/// 이 클래스는 **code 문자열만** 상수화한다(termId 자체는 절대 하드코딩하지 않음 —
/// 규제성 데이터, ADR-0007).
///
class TermsCatalogCodes {
  const TermsCatalogCodes._();

  /// 서비스 이용약관.
  static const String tos = 'tos';

  /// 개인정보 처리방침.
  static const String privacy = 'privacy';

  /// 민감정보(건강정보) 수집·이용 동의.
  static const String healthSensitive = 'health_sensitive';

  /// 마케팅 정보 수신 동의.
  static const String marketing = 'marketing';
}
