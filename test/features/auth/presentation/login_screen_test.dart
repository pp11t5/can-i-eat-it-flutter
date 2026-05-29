import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';

Widget _wrap(MockAuthRepository repo) => ProviderScope(
      // 테스트 루트 ProviderScope override — dependencies 불필요.
      // ignore: scoped_providers_should_specify_dependencies
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: LoginScreen()),
    );

void main() {
  group('LoginScreen 플랫폼 분기', () {
    testWidgets('Android 에서는 카카오 버튼만 보이고 Apple 버튼은 없다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 시작하기'), findsOneWidget);
      expect(find.text('Apple로 계속하기'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('iOS 에서는 카카오와 Apple 버튼이 모두 보인다', (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 시작하기'), findsOneWidget);
      expect(find.text('Apple로 계속하기'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });

  group('LoginScreen 로그인 동작', () {
    testWidgets('카카오 버튼 탭 시 로그인 후 세션이 생성된다', (tester) async {
      final repo = MockAuthRepository.newUser();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 시작하기'));
      await tester.pumpAndSettle();

      expect(await repo.currentSession(), isNotNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('삭제유예 계정으로 로그인하면 복구 다이얼로그가 뜬다', (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.deletionGrace()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 시작하기'));
      await tester.pumpAndSettle();

      expect(find.text('탈퇴를 진행 중인 계정이에요'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
