import 'package:can_i_eat_it/core/config/terms_catalog.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/consent.dart';

/// 약관 동의 화면에서 행을 숨기는 항목.
///
/// 민감정보는 개인정보 수집 동의에 포함되므로 UI 행만 제거한다.
/// 서버가 필수 약관으로 들고 있으면 제출 배열에는 그대로 넣는다.
bool isHiddenConsentTerm(ConsentTerm term) =>
    term.code == TermsCatalogCodes.healthSensitive;

/// 화면에 그릴 약관. 숨긴 항목은 제외한다.
List<ConsentTerm> visibleConsentTerms(List<ConsentTerm> terms) => terms
    .where((term) => !isHiddenConsentTerm(term))
    .toList(growable: false);

/// `POST /consent`에 넣을 선택값.
///
/// 화면 항목은 체크 상태를 쓰고, 숨긴 필수 약관은 동의한 것으로 보낸다.
List<ConsentChoice> consentChoicesForSubmit({
  required List<ConsentTerm> terms,
  required Set<int> agreedTermIds,
}) =>
    [
      for (final term in terms)
        ConsentChoice(
          termId: term.id,
          agreed: isHiddenConsentTerm(term)
              ? term.isRequired
              : agreedTermIds.contains(term.id),
        ),
    ];
