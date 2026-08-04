import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/consent.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';

void main() {
  const choices = [
    ConsentChoice(termId: 1, agreed: true),
    ConsentChoice(termId: 2, agreed: true),
    ConsentChoice(termId: 3, agreed: true),
    ConsentChoice(termId: 4, agreed: false),
  ];

  group('미인증', () {
    test('로그인 안 한 상태에서 currentSession 은 null 이다', () async {
      final repo = MockAuthRepository.signedOut();
      expect(await repo.currentSession(), isNull);
    });
  });

  group('신규 가입 — Authenticated + 약관 pending', () {
    test('카카오와 Apple 모두 onboarded=false Authenticated 를 반환한다', () async {
      final kakao = await MockAuthRepository.newUser().signInWithKakao();
      final apple = await MockAuthRepository.newUser().signInWithApple();

      expect(kakao, isA<Authenticated>());
      expect((kakao as Authenticated).onboarded, isFalse);
      expect(apple, isA<Authenticated>());
      expect((apple as Authenticated).onboarded, isFalse);
    });

    test('로그인 후 세션은 hasAgreedTerms=false 이고 provider를 보존한다', () async {
      final repo = MockAuthRepository.newUser();
      await repo.signInWithKakao();
      final current = await repo.currentSession();

      expect(current, isNotNull);
      expect(current!.hasAgreedTerms, isFalse);
      expect(current.provider, AuthProvider.kakao);
    });
  });

  group('기존 가입', () {
    test('온보딩 완료 사용자는 동의 완료 세션으로 인증된다', () async {
      final repo = MockAuthRepository.existing(onboarded: true);
      final outcome = await repo.signInWithKakao() as Authenticated;

      expect(outcome.onboarded, isTrue);
      expect(outcome.session.hasAgreedTerms, isTrue);
      expect(outcome.session.accountStatus, AccountStatus.active);
    });

    test('온보딩 미완료 사용자는 다시 약관 pending 세션으로 인증된다', () async {
      final outcome = await MockAuthRepository.existing(onboarded: false)
          .signInWithKakao() as Authenticated;

      expect(outcome.onboarded, isFalse);
      expect(outcome.session.hasAgreedTerms, isFalse);
    });
  });

  group('동적 약관', () {
    test('서버 약관 목록을 반환한다', () async {
      final repo = MockAuthRepository.newUser();
      expect(await repo.fetchConsentTerms(), hasLength(4));
    });

    test('submitConsent 후 선택값을 기록하고 세션 동의를 완료한다', () async {
      final repo = MockAuthRepository.newUser();
      await repo.signInWithKakao();
      await repo.submitConsent(choices);

      expect(repo.lastConsentChoices, choices);
      expect((await repo.currentSession())!.hasAgreedTerms, isTrue);
    });

    test('세션 없이 submitConsent 호출 시 StateError 를 던진다', () async {
      final repo = MockAuthRepository.signedOut();
      await expectLater(
        repo.submitConsent(choices),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('삭제 유예 복구', () {
    test('복구 가능한 로그인 결과와 active 복구 세션을 반환한다', () async {
      final repo = MockAuthRepository.deletionGrace();
      final outcome = await repo.signInWithKakao();
      expect(outcome, isA<Recoverable>());

      final recovered = await repo.recoverAccount(
        AuthProvider.kakao,
        idToken: 'test-id-token',
      );
      expect(recovered.accountStatus, AccountStatus.active);
    });
  });

  group('signOut / logout', () {
    test('signOut 과 logout 후 currentSession 은 null 이다', () async {
      final signOutRepo = MockAuthRepository.existing(onboarded: true);
      await signOutRepo.signInWithKakao();
      await signOutRepo.signOut();
      expect(await signOutRepo.currentSession(), isNull);

      final logoutRepo = MockAuthRepository.existing(onboarded: true);
      await logoutRepo.signInWithKakao();
      await logoutRepo.logout();
      expect(await logoutRepo.currentSession(), isNull);
    });
  });
}
