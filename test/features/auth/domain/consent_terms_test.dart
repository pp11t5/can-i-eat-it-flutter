import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/domain/consent_terms.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/consent.dart';

const _tos = ConsentTerm(
  id: 1,
  code: 'tos',
  version: '1.0',
  title: '서비스 이용약관',
  content: 'https://example.com/tos',
  isRequired: true,
);
const _privacy = ConsentTerm(
  id: 2,
  code: 'privacy',
  version: '1.0',
  title: '개인정보 수집·이용 동의',
  content: 'https://example.com/privacy',
  isRequired: true,
);
const _health = ConsentTerm(
  id: 3,
  code: 'health_sensitive',
  version: '1.0',
  title: '민감정보 수집 동의',
  content: 'https://example.com/health',
  isRequired: true,
);
const _marketing = ConsentTerm(
  id: 4,
  code: 'marketing',
  version: '1.0',
  title: '마케팅 수신 동의',
  content: 'https://example.com/marketing',
  isRequired: false,
);

void main() {
  group('visibleConsentTerms', () {
    test('민감정보 행은 화면 목록에서 뺀다', () {
      expect(
        visibleConsentTerms(const [_tos, _privacy, _health, _marketing]),
        const [_tos, _privacy, _marketing],
      );
    });
  });

  group('consentChoicesForSubmit', () {
    test('숨긴 필수 약관은 체크 여부와 상관없이 agreed true로 넣는다', () {
      final choices = consentChoicesForSubmit(
        terms: const [_tos, _privacy, _health, _marketing],
        agreedTermIds: {1, 2},
      );

      expect(
        choices,
        const [
          ConsentChoice(termId: 1, agreed: true),
          ConsentChoice(termId: 2, agreed: true),
          ConsentChoice(termId: 3, agreed: true),
          ConsentChoice(termId: 4, agreed: false),
        ],
      );
    });

    test('숨긴 선택 약관은 자동 동의하지 않는다', () {
      const optionalHidden = ConsentTerm(
        id: 5,
        code: 'health_sensitive',
        version: '1.0',
        title: '민감정보',
        content: 'https://example.com/health',
        isRequired: false,
      );

      final choices = consentChoicesForSubmit(
        terms: const [_tos, optionalHidden],
        agreedTermIds: {1},
      );

      expect(
        choices,
        const [
          ConsentChoice(termId: 1, agreed: true),
          ConsentChoice(termId: 5, agreed: false),
        ],
      );
    });
  });
}
