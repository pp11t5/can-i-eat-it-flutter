import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/figma_checkbox.dart';

/// 약관 동의는 로그인 후 진입하므로, 세션이 있는 mock 으로 감싼다
/// (recordTermsAgreement 는 세션이 없으면 StateError).
MockAuthRepository _loggedInRepo() => MockAuthRepository(
      initialSession: const AuthSession(
        userId: 'u1',
        provider: AuthProvider.kakao,
      ),
    );

// _onNext 가 context.push('/onboarding/condition') 를 호출하므로
// GoRouter 컨텍스트가 필요하다. /terms + /onboarding/condition 스텁을 포함한
// 최소 라우터를 제공한다.
GoRouter _testRouter() => GoRouter(
      initialLocation: '/terms',
      routes: [
        GoRoute(
          path: '/terms',
          builder: (_, __) => const TermsScreen(),
        ),
        GoRoute(
          path: '/onboarding/condition',
          builder: (_, __) =>
              const Scaffold(body: Text('onboarding stub')),
        ),
      ],
    );

Widget _wrap(MockAuthRepository repo) => ProviderScope(
      // 테스트 루트 ProviderScope override — dependencies 불필요.
      // ignore: scoped_providers_should_specify_dependencies
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: _testRouter()),
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

      // 각 행은 InkWell 로 감싸져 있어 라벨 탭이 체크박스를 토글한다.
      await tester.tap(find.text('[필수] 서비스 이용약관'));
      await tester.tap(find.text('[필수] 개인정보 수집·이용 동의'));
      await tester.tap(find.text('[필수] 민감정보(건강) 수집 동의'));
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

      // FigmaCheckbox 5개(전체동의 + 필수3 + 선택1) 모두 checked=true.
      final boxes =
          tester.widgetList<FigmaCheckbox>(find.byType(FigmaCheckbox));
      expect(boxes.every((b) => b.checked), isTrue);
    });
  });
}
