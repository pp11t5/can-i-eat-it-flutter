import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/withdraw_screen.dart';

import '../../../core/push/fcm_test_helpers.dart';

// ---------------------------------------------------------------------------
// 목 AuthRepository
// ---------------------------------------------------------------------------

class _MockAuthRepository implements AuthRepository {
  bool withdrawCalled = false;
  bool logoutCalled = false;

  @override
  Future<void> withdraw() async {
    withdrawCalled = true;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<AuthSession?> currentSession() async => null;

  @override
  bool consumeOfflineRestoreFlag() => false;

  @override
  Future<AuthSession> getMe() => throw UnimplementedError();

  @override
  Future<void> recordTermsAgreement(TermsAgreement agreement) =>
      throw UnimplementedError();

  @override
  Future<void> refresh() => throw UnimplementedError();

  @override
  Future<AuthSession> recoverAccount(
    AuthProvider provider, {
    required String idToken,
  }) =>
      throw UnimplementedError();

  @override
  Future<SignInOutcome> signInWithApple() => throw UnimplementedError();

  @override
  Future<SignInOutcome> signInWithKakao() => throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _wrap({_MockAuthRepository? authRepo}) {
  final repo = authRepo ?? _MockAuthRepository();
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(repo),
      // ignore: scoped_providers_should_specify_dependencies
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
      // ignore: scoped_providers_should_specify_dependencies
      fcmLifecycleProvider.overrideWithValue(noopFcmLifecycle()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const WithdrawScreen(),
    ),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('WithdrawScreen — 렌더링', () {
    testWidgets('AppBar 타이틀 "탈퇴" 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('탈퇴'), findsOneWidget);
    });

    testWidgets('"정말 계정을 삭제하시겠어요?" 문구 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('정말 계정을 삭제하시겠어요?'), findsOneWidget);
    });

    testWidgets('삭제 항목 4개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('식사 기록'), findsOneWidget);
      expect(find.text('증상 기록'), findsOneWidget);
      expect(find.text('건강 정보'), findsOneWidget);
      expect(find.text('주간 리포트'), findsOneWidget);
    });

    testWidgets('"데이터 영구 삭제" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('데이터 영구 삭제'), findsOneWidget);
    });
  });

  group('WithdrawScreen — 탈퇴 동작', () {
    testWidgets('"데이터 영구 삭제" 버튼 탭 시 withdraw() 호출된다', (tester) async {
      final mock = _MockAuthRepository();
      await tester.pumpWidget(_wrap(authRepo: mock));
      await tester.pumpAndSettle();

      await tester.tap(find.text('데이터 영구 삭제'));
      // withdraw() 비동기 완료 대기 (pumpAndSettle은 setState 루프로 timeout 우려).
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(mock.withdrawCalled, isTrue);
    });
  });
}
