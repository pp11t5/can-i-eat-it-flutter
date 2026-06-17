import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';

/// LoginScreen 이 sign-in 후 SignInOutcome switch 로 분기하는 것을 검증한다.
/// GoRouter 컨텍스트가 필요해 최소 라우트만 등록한다.

// ---------------------------------------------------------------------------
// T1 토스트 테스트용 helper: coldStartOfflineProvider 값을 제어하는 mock
// ---------------------------------------------------------------------------

/// coldStartOfflineProvider 가 지정된 값을 반환하도록 override 할 수 있는 helper.
Widget _wrapWithOfflineFlag(MockAuthRepository repo, {required bool offline}) =>
    ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        authRepositoryProvider.overrideWithValue(repo),
        // ignore: scoped_providers_should_specify_dependencies
        coldStartOfflineProvider.overrideWithValue(offline),
      ],
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

GoRouter _testRouter() => GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(
          path: '/terms',
          builder: (_, __) => const Scaffold(body: Text('terms stub')),
        ),
        GoRoute(
          path: '/onboarding/condition',
          builder: (_, __) => const Scaffold(body: Text('onboarding stub')),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('home stub')),
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
  group('LoginScreen 플랫폼 분기', () {
    testWidgets('Android 에서는 카카오 버튼만 보이고 Apple 버튼은 없다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 로그인'), findsOneWidget);
      expect(find.text('Apple로 로그인'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('iOS 에서는 카카오와 Apple 버튼이 모두 보인다', (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.signedOut()));
      await tester.pumpAndSettle();

      expect(find.text('카카오로 로그인'), findsOneWidget);
      expect(find.text('Apple로 로그인'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });

  group('LoginScreen 로그인 동작 — SignInOutcome 분기', () {
    testWidgets(
        'NeedsTerms(newUser) — 카카오 로그인 시 /terms 로 push 된다',
        (tester) async {
      final repo = MockAuthRepository.newUser();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      // /terms stub 이 보인다.
      expect(find.text('terms stub'), findsOneWidget);
      // home 이나 onboarding 으로 이동하지 않는다.
      expect(find.text('home stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'Authenticated(onboarded=true) — 카카오 로그인 시 / 로 이동한다',
        (tester) async {
      final repo = MockAuthRepository.existing(onboarded: true);
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('home stub'), findsOneWidget);
      expect(find.text('terms stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'Authenticated(onboarded=false) — 카카오 로그인 시 /onboarding/condition 으로 이동한다',
        (tester) async {
      final repo = MockAuthRepository.existing(onboarded: false);
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('onboarding stub'), findsOneWidget);
      expect(find.text('home stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'Recoverable(deletionGrace) — 카카오 로그인 시 복구 다이얼로그가 뜬다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockAuthRepository.deletionGrace()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();

      expect(find.text('탈퇴를 진행 중인 계정이에요'), findsOneWidget);
      // 다이얼로그 분기라 /terms 로 push 되지 않음.
      expect(find.text('terms stub'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });

  group('LoginScreen 로그인 실패 T2 토스트 (Bug A 회귀)', () {
    /// ThrowingAuthRepository: signInWithKakao 가 UnexpectedFailure 를 throw 한다.
    Widget wrapWithThrowingRepo(Failure failure) => ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(
              ThrowingAuthRepository(failure: failure),
            ),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        );

    testWidgets(
        'signInWithKakao 가 UnexpectedFailure throw → T2 토스트 노출, 화면 유지, unhandled 없음',
        (tester) async {
      await tester.pumpWidget(
        wrapWithThrowingRepo(const UnexpectedFailure()),
      );
      await tester.pumpAndSettle();

      // 초기 상태: 로그인 화면 대기
      expect(find.text('카카오로 로그인'), findsOneWidget);

      // 카카오 버튼 탭
      await tester.tap(find.text('카카오로 로그인'));
      // signInWithKakao() throw → catch → showAppToast 호출
      await tester.pump(); // OverlayEntry 삽입
      await tester.pump(const Duration(milliseconds: 100)); // 등장 애니메이션 진입

      // (b) T2 토스트 노출
      expect(
        find.text('로그인에 실패했어요. 잠시 후 다시 시도해 주세요.'),
        findsOneWidget,
      );

      // (c) 화면이 로그인 화면에 잔류 (이동 없음)
      expect(find.text('home stub'), findsNothing);
      expect(find.text('terms stub'), findsNothing);
      expect(find.text('onboarding stub'), findsNothing);

      // 토스트 타이머 소진
      await tester.pump(const Duration(milliseconds: 200)); // forward 완료
      await tester.pump(const Duration(milliseconds: 2500)); // delay 완료
      await tester.pump(const Duration(milliseconds: 300)); // reverse + remove
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'signInWithKakao 가 NetworkFailure throw → T2 토스트 노출',
        (tester) async {
      await tester.pumpWidget(
        wrapWithThrowingRepo(const NetworkFailure()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('카카오로 로그인'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('로그인에 실패했어요. 잠시 후 다시 시도해 주세요.'),
        findsOneWidget,
      );

      // 토스트 타이머 소진
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pump(const Duration(milliseconds: 300));
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });

  group('LoginScreen 콜드스타트 오프라인 토스트(T1)', () {
    testWidgets(
        'coldStartOffline==true → T1 토스트 메시지가 노출된다',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithOfflineFlag(
          MockAuthRepository.signedOut(),
          offline: true,
        ),
      );
      // initState post-frame 콜백 실행 → showAppToast → OverlayEntry 삽입.
      await tester.pump();
      // 등장 애니메이션(250ms) 진행 중 — opacity > 0 이므로 텍스트 확인 가능.
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('네트워크 연결을 확인해 주세요. 다시 로그인이 필요해요.'),
        findsOneWidget,
      );

      // 남은 타이머를 순서대로 소진: forward 완료 → delay 완료 → reverse 완료 → onDismissed.
      // 총 ~3100ms(등장250 + 표시2500 + 퇴장250 - 이미 흐른 100ms).
      await tester.pump(const Duration(milliseconds: 200)); // forward 완료
      await tester.pump(const Duration(milliseconds: 2500)); // .then() + delay 완료
      await tester.pump(const Duration(milliseconds: 300)); // reverse 완료 + entry.remove()
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets(
        'coldStartOffline==false → T1 토스트 메시지가 노출되지 않는다',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithOfflineFlag(
          MockAuthRepository.signedOut(),
          offline: false,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('네트워크 연결을 확인해 주세요. 다시 로그인이 필요해요.'),
        findsNothing,
      );
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
