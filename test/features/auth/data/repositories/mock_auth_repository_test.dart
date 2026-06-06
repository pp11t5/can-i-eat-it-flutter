import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 헬퍼: 테스트용 필수 3개 동의 TermsAgreement
  // ---------------------------------------------------------------------------
  TermsAgreement requiredAgreed({bool marketing = false}) => TermsAgreement(
        version: '1.0.0',
        agreedAt: DateTime(2026, 1, 1),
        termsOfService: true,
        privacy: true,
        sensitiveInfo: true,
        marketing: marketing,
      );

  // ---------------------------------------------------------------------------
  group('미인증', () {
    test('로그인 안 한 상태에서 currentSession 은 null 이다', () async {
      final repo = MockAuthRepository.signedOut();
      expect(await repo.currentSession(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('신규 가입(약관 미동의)', () {
    test('카카오 로그인 시 약관 미동의 신규 세션을 반환한다', () async {
      final repo = MockAuthRepository.newUser();
      final session = await repo.signInWithKakao();
      expect(session.hasAgreedTerms, isFalse);
      expect(session.provider, AuthProvider.kakao);
    });

    test('애플 로그인 시 provider 가 apple 이다', () async {
      final repo = MockAuthRepository.newUser();
      final session = await repo.signInWithApple();
      expect(session.provider, AuthProvider.apple);
    });

    test('로그인 후 currentSession 이 해당 세션을 반환한다', () async {
      final repo = MockAuthRepository.newUser();
      final signedIn = await repo.signInWithKakao();
      final current = await repo.currentSession();
      expect(current, equals(signedIn));
    });
  });

  // ---------------------------------------------------------------------------
  group('기존 가입(약관 동의됨)', () {
    test('existing() 계정은 약관 동의됨, active 상태다', () async {
      final repo = MockAuthRepository.existing();
      final session = await repo.signInWithKakao();
      expect(session.hasAgreedTerms, isTrue);
      expect(session.accountStatus, AccountStatus.active);
    });

    test('existing() 계정의 provider 가 kakao 다', () async {
      final repo = MockAuthRepository.existing();
      final session = await repo.signInWithKakao();
      expect(session.provider, AuthProvider.kakao);
    });
  });

  // ---------------------------------------------------------------------------
  group('약관 동의 이력', () {
    test('recordTermsAgreement 후 세션 hasAgreedTerms 가 true 가 된다', () async {
      final repo = MockAuthRepository.newUser();
      await repo.signInWithKakao();
      await repo.recordTermsAgreement(requiredAgreed());
      final session = await repo.currentSession();
      expect(session!.hasAgreedTerms, isTrue);
    });

    test('동의 이력(lastTermsAgreement)이 기록된다', () async {
      final repo = MockAuthRepository.newUser();
      await repo.signInWithKakao();
      final agreement = requiredAgreed();
      await repo.recordTermsAgreement(agreement);
      expect(repo.lastTermsAgreement, equals(agreement));
    });

    test('세션 없이 recordTermsAgreement 호출 시 StateError 를 던진다', () async {
      final repo = MockAuthRepository.signedOut();
      expect(
        () => repo.recordTermsAgreement(requiredAgreed()),
        throwsA(isA<StateError>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('삭제 유예 복구(02a)', () {
    test('삭제유예 계정 로그인 시 accountStatus 가 deletionGrace 다', () async {
      final repo = MockAuthRepository.deletionGrace();
      final session = await repo.signInWithKakao();
      expect(session.accountStatus, AccountStatus.deletionGrace);
    });

    test('recoverAccount 후 accountStatus 가 active 가 된다', () async {
      final repo = MockAuthRepository.deletionGrace();
      await repo.signInWithKakao();
      final recovered = await repo.recoverAccount();
      expect(recovered.accountStatus, AccountStatus.active);
    });
  });

  // ---------------------------------------------------------------------------
  group('signOut', () {
    test('signOut 후 currentSession 은 null 이다', () async {
      final repo = MockAuthRepository.newUser();
      await repo.signInWithKakao();
      await repo.signOut();
      expect(await repo.currentSession(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('TermsAgreement.allRequiredAgreed', () {
    test('필수 3개가 모두 true 면 allRequiredAgreed 가 true 다', () {
      final agreement = requiredAgreed(marketing: false);
      expect(agreement.allRequiredAgreed, isTrue);
    });

    test('marketing 이 false 여도 필수 3개가 true 면 allRequiredAgreed 가 true 다', () {
      final agreement = TermsAgreement(
        version: '1.0.0',
        agreedAt: DateTime(2026, 1, 1),
        termsOfService: true,
        privacy: true,
        sensitiveInfo: true,
        marketing: false,
      );
      expect(agreement.allRequiredAgreed, isTrue);
    });

    test('필수 중 하나라도 false 면 allRequiredAgreed 가 false 다 — termsOfService', () {
      final agreement = TermsAgreement(
        version: '1.0.0',
        agreedAt: DateTime(2026, 1, 1),
        termsOfService: false,
        privacy: true,
        sensitiveInfo: true,
        marketing: true,
      );
      expect(agreement.allRequiredAgreed, isFalse);
    });

    test('필수 중 하나라도 false 면 allRequiredAgreed 가 false 다 — privacy', () {
      final agreement = TermsAgreement(
        version: '1.0.0',
        agreedAt: DateTime(2026, 1, 1),
        termsOfService: true,
        privacy: false,
        sensitiveInfo: true,
        marketing: true,
      );
      expect(agreement.allRequiredAgreed, isFalse);
    });

    test('필수 중 하나라도 false 면 allRequiredAgreed 가 false 다 — sensitiveInfo', () {
      final agreement = TermsAgreement(
        version: '1.0.0',
        agreedAt: DateTime(2026, 1, 1),
        termsOfService: true,
        privacy: true,
        sensitiveInfo: false,
        marketing: true,
      );
      expect(agreement.allRequiredAgreed, isFalse);
    });
  });
}
