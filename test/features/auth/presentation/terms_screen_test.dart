import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';

/// 약관 동의는 로그인 후 진입하므로, 세션이 있는 mock 으로 감싼다
/// (recordTermsAgreement 는 세션이 없으면 StateError).
MockAuthRepository _loggedInRepo() => MockAuthRepository(
      initialSession: const AuthSession(
        userId: 'u1',
        provider: AuthProvider.kakao,
      ),
    );

Widget _wrap(MockAuthRepository repo) => ProviderScope(
      // 테스트 루트 ProviderScope override — dependencies 불필요.
      // ignore: scoped_providers_should_specify_dependencies
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: TermsScreen()),
    );

void main() {
  group('TermsScreen', () {
    testWidgets('초기 상태에서는 다음을 눌러도 약관이 기록되지 않는다(비활성)',
        (tester) async {
      final repo = _loggedInRepo();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(repo.lastTermsAgreement, isNull);
    });

    testWidgets('필수 3개를 체크한 뒤 다음을 누르면 약관 동의가 기록된다',
        (tester) async {
      final repo = _loggedInRepo();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Checkbox 순서: 0=전체동의, 1=이용약관, 2=개인정보, 3=민감정보, 4=마케팅
      await tester.tap(find.byType(Checkbox).at(1));
      await tester.tap(find.byType(Checkbox).at(2));
      await tester.tap(find.byType(Checkbox).at(3));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(repo.lastTermsAgreement, isNotNull);
      expect(repo.lastTermsAgreement!.allRequiredAgreed, isTrue);
    });

    testWidgets('전체 동의를 탭하면 모든 체크박스가 체크된다', (tester) async {
      await tester.pumpWidget(_wrap(_loggedInRepo()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('모든 약관에 동의합니다'));
      await tester.pumpAndSettle();

      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox));
      expect(checkboxes.every((c) => c.value == true), isTrue);
    });
  });
}
