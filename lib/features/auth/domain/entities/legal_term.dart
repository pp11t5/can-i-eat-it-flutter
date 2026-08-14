/// 서버 약관 항목 (`GET /consent/terms` 원소).
///
/// 동의 제출 시 [id]를 termId 로 쓰고, 상세 화면은 [title]·[content] 를 표시한다.
/// [code] 는 로컬 동의 슬롯([TermsAgreement]) 매핑 키다.
class LegalTerm {
  const LegalTerm({
    required this.id,
    required this.code,
    required this.version,
    required this.title,
    required this.content,
    required this.isRequired,
  });

  /// 서버 term PK — POST /consent 의 termId.
  final int id;

  /// 약관 코드 (예: `tos`, `privacy`, `health_sensitive`, `marketing`).
  final String code;

  final String version;
  final String title;

  /// 약관 본문 (상세 화면 표시용).
  final String content;

  /// 필수 동의 여부.
  final bool isRequired;
}
