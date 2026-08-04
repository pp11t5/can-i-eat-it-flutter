import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/consent.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/widgets/figma_checkbox.dart';

MockAuthRepository _loggedInRepo({
  List<ConsentTerm> terms = MockAuthRepository.defaultConsentTerms,
  Object? fetchError,
  Duration fetchDelay = Duration.zero,
  Object? submitError,
  Duration submitDelay = Duration.zero,
}) =>
    MockAuthRepository(
      initialSession: const AuthSession(
        userId: 'u1',
        provider: AuthProvider.kakao,
        hasAgreedTerms: false,
      ),
      consentTerms: terms,
      consentFetchError: fetchError,
      consentFetchDelay: fetchDelay,
      consentSubmitError: submitError,
      consentSubmitDelay: submitDelay,
    );

GoRouter _testRouter(TermsScreen screen) => GoRouter(
      initialLocation: '/terms',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => const Scaffold(body: Text('login stub')),
        ),
        GoRoute(path: '/terms', builder: (_, __) => screen),
        GoRoute(
          path: '/onboarding/condition',
          builder: (_, __) => const Scaffold(body: Text('onboarding stub')),
        ),
      ],
    );

Widget _wrap(MockAuthRepository repo,
        {TermsScreen screen = const TermsScreen()}) =>
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: _testRouter(screen),
      ),
    );

void main() {
  group('TermsScreen 서버 약관 상태', () {
    testWidgets('로딩 중에는 스피너가 보이고 다음 버튼이 비활성이다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _loggedInRepo(fetchDelay: const Duration(milliseconds: 50)),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, '다음'),
      );
      expect(button.onPressed, isNull);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
    });

    testWidgets('조회 실패 시 오류와 다시 시도를 표시한다', (tester) async {
      await tester.pumpWidget(
        _wrap(_loggedInRepo(fetchError: const NetworkFailure('불러오기 실패'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('불러오기 실패'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('필수 우선 + 알려진 code 순서로 서버 약관을 표시한다', (tester) async {
      const terms = [
        ConsentTerm(
          id: 4,
          code: 'marketing',
          version: '1.0',
          title: '마케팅 정보 수신 동의',
          content: 'https://example.com/marketing',
          isRequired: false,
        ),
        ConsentTerm(
          id: 3,
          code: 'health_sensitive',
          version: '1.0',
          title: '민감정보 수집 동의',
          content: 'https://example.com/health',
          isRequired: true,
        ),
        ConsentTerm(
          id: 1,
          code: 'tos',
          version: '1.0',
          title: '서비스 이용약관',
          content: 'https://example.com/tos',
          isRequired: true,
        ),
        ConsentTerm(
          id: 2,
          code: 'privacy',
          version: '1.0',
          title: '개인정보 처리방침',
          content: 'https://example.com/privacy',
          isRequired: true,
        ),
      ];
      await tester.pumpWidget(_wrap(_loggedInRepo(terms: terms)));
      await tester.pumpAndSettle();

      final tosY = tester.getTopLeft(find.text('[필수] 서비스 이용약관')).dy;
      final privacyY = tester.getTopLeft(find.text('[필수] 개인정보 처리방침')).dy;
      final healthY = tester.getTopLeft(find.text('[필수] 민감정보 수집 동의')).dy;
      final marketingY = tester.getTopLeft(find.text('[선택] 마케팅 정보 수신 동의')).dy;
      expect(tosY, lessThan(privacyY));
      expect(privacyY, lessThan(healthY));
      expect(healthY, lessThan(marketingY));
    });
  });

  group('TermsScreen 동의 및 제출', () {
    testWidgets('필수 항목만 선택하면 선택 약관 false를 포함해 제출한다', (tester) async {
      final repo = _loggedInRepo();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('[필수] 서비스 이용약관'));
      await tester.tap(find.text('[필수] 개인정보 수집·이용 동의'));
      await tester.tap(find.text('[필수] 민감정보(건강) 수집 동의'));
      await tester.pump();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('onboarding stub'), findsOneWidget);
      expect(
        repo.lastConsentChoices,
        const [
          ConsentChoice(termId: 1, agreed: true),
          ConsentChoice(termId: 2, agreed: true),
          ConsentChoice(termId: 3, agreed: true),
          ConsentChoice(termId: 4, agreed: false),
        ],
      );
    });

    testWidgets('전체 동의는 모든 체크박스를 선택하고 다시 탭하면 해제한다', (tester) async {
      await tester.pumpWidget(_wrap(_loggedInRepo()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('모든 약관에 동의합니다'));
      await tester.pump();
      var boxes = tester.widgetList<FigmaCheckbox>(find.byType(FigmaCheckbox));
      expect(boxes.every((box) => box.checked), isTrue);

      await tester.tap(find.text('모든 약관에 동의합니다'));
      await tester.pump();
      boxes = tester.widgetList<FigmaCheckbox>(find.byType(FigmaCheckbox));
      expect(boxes.every((box) => !box.checked), isTrue);
    });

    testWidgets('제출 실패 시 화면을 유지하고 오류 토스트를 표시한다', (tester) async {
      final repo = _loggedInRepo(
        submitError: const NetworkFailure('저장 실패'),
      );
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('모든 약관에 동의합니다'));
      await tester.pump();
      await tester.tap(find.text('다음'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('저장 실패'), findsOneWidget);
      expect(find.byType(TermsScreen), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('제출 중 연속 탭해도 API는 한 번만 호출한다', (tester) async {
      final repo = _loggedInRepo(submitDelay: const Duration(milliseconds: 50));
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('모든 약관에 동의합니다'));
      await tester.pump();
      await tester.tap(find.text('다음'));
      await tester.tap(find.text('다음'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(repo.submitConsentCallCount, 1);
    });
  });

  testWidgets('상세 화살표는 서버 content URL을 전달한다', (tester) async {
    ConsentTerm? openedTerm;
    await tester.pumpWidget(
      _wrap(
        _loggedInRepo(),
        screen: TermsScreen(
          openTerm: (_, term) async => openedTerm = term,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('약관 상세 열기').first);
    await tester.pump();

    expect(openedTerm?.title, '서비스 이용약관');
    expect(openedTerm?.content, 'https://example.com/tos');
  });

  testWidgets('루트 약관 화면에서 뒤로가면 로그인으로 이동하고 로그아웃한다', (tester) async {
    final repo = _loggedInRepo();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('뒤로'));
    await tester.pumpAndSettle();

    expect(find.text('login stub'), findsOneWidget);
    expect(await repo.currentSession(), isNull);
  });
}
