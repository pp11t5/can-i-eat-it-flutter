/// 약관 버전 단일 소스 (이슈 #20 N1).
///
/// 약관 버전은 규제·동의 이력 추적의 핵심이므로 화면·테스트가 이 상수를
/// 단일 소스로 참조한다. 하드코딩으로 인한 드리프트(화면 'v1.0' vs 테스트 '1.0.0')를
/// 방지한다. 약관 개정 시 이 값만 갱신한다.
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

/// `GET /consent/terms` 응답의 `code` → 로컬 [TermsAgreement] 슬롯 매핑 상수
/// (약관 신 계약 마이그레이션).
///
/// termId(=서버 term의 `id`)는 항상 `GET /consent/terms` 응답에서 조인하며
/// 이 클래스는 **code 문자열만** 상수화한다(termId 자체는 절대 하드코딩하지 않음 —
/// 규제성 데이터, ADR-0007).
///
/// ⚠️ 미확정: 라이브 `GET /consent/terms` 가 현재 `result:[]`(빈 배열)을 반환해
/// 실제 서버 code 값을 검증하지 못했다. 아래 값은 라이브 Swagger 예시
/// (`code:string(예 "tos")`)와 이 프로젝트의 다른 서버 enum 표기 관행
/// (snake_case: `post_meal`, `throat_foreign_body` 등)을 근거로 한 추정치다.
/// 서버가 약관을 시드한 뒤 실제 code로 검증·갱신이 필요하다.
class TermsCatalogCodes {
  const TermsCatalogCodes._();

  /// 서비스 이용약관 → [TermsAgreement.termsOfService].
  static const String tos = 'tos';

  /// 개인정보 처리방침 → [TermsAgreement.privacy].
  static const String privacy = 'privacy';

  /// 민감정보(건강정보) 수집·이용 동의 → [TermsAgreement.sensitiveInfo].
  static const String healthSensitive = 'health_sensitive';

  /// 마케팅 정보 수신 동의 → [TermsAgreement.marketing].
  static const String marketing = 'marketing';
}
