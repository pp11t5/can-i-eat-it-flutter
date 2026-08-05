@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';

Widget _subject() {
  final repository = MockAuthRepository(
    initialSession: const AuthSession(
      userId: 'golden-user',
      provider: AuthProvider.kakao,
      hasAgreedTerms: false,
    ),
  );
  return ProviderScope(
    overrides: [
      // 테스트 전용 repository 교체 — 앱의 scoped provider가 아니다.
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const TermsScreen(),
    ),
  );
}

void main() {
  testWidgets('375×812 필수 약관 선택 완료 상태', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 44, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 44, bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_subject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('[필수] 서비스 이용약관'));
    await tester.pump();
    await tester.tap(find.text('[필수] 개인정보 수집·이용 동의'));
    await tester.pump();
    await tester.tap(find.text('[필수] 민감정보(건강) 수집 동의'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/terms_screen_375x812.png'),
    );
  });
}
