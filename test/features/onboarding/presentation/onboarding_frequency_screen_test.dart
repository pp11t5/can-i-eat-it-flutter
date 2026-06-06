import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_frequency_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/frequency',
      routes: [
        GoRoute(
          path: '/onboarding/frequency',
          builder: (_, __) => const OnboardingFrequencyScreen(),
        ),
        GoRoute(
          path: '/onboarding/triggers',
          builder: (_, __) =>
              const Scaffold(body: Text('triggers stub')),
        ),
      ],
    );

Widget _wrap({List<Override> overrides = const []}) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('OnboardingFrequencyScreen', () {
    testWidgets('타이틀 "최근 4주간 어떤 불편함이"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('최근 4주간 어떤 불편함이'), findsOneWidget);
    });

    testWidgets('서브타이틀 "해당되는 항목을 모두 선택해 주세요"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('해당되는 항목을 모두 선택해 주세요'), findsOneWidget);
    });

    testWidgets('symptomFrequencyOptions 5개 항목이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(symptomFrequencyOptions.length, 5);
      for (final entry in symptomFrequencyOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('항목 탭 시 draft.symptomFrequency에 코드가 추가된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final entry = symptomFrequencyOptions.first;
      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        isNot(contains(entry.code)),
      );

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        contains(entry.code),
      );
    });

    testWidgets('선택된 증상 항목을 다시 탭하면 draft.symptomFrequency에서 제거된다',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final entry = symptomFrequencyOptions.first;

      // 추가
      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        contains(entry.code),
      );

      // 제거
      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        isNot(contains(entry.code)),
      );
    });

    testWidgets('diagnosedLabel 타일 탭 시 draft.diagnosed가 true가 된다',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).diagnosed,
        isFalse,
      );

      // diagnosedLabel 타일은 스크롤 아래에 있을 수 있으므로 스크롤 후 탭한다.
      await tester.scrollUntilVisible(
        find.text(diagnosedLabel),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(diagnosedLabel));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).diagnosed,
        isTrue,
      );
    });

    testWidgets('diagnosedLabel 타일을 두 번 탭하면 draft.diagnosed가 false로 돌아온다',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text(diagnosedLabel),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(find.text(diagnosedLabel));
      await tester.pumpAndSettle();
      expect(container.read(onboardingControllerProvider).diagnosed, isTrue);

      await tester.tap(find.text(diagnosedLabel));
      await tester.pumpAndSettle();
      expect(container.read(onboardingControllerProvider).diagnosed, isFalse);
    });

    testWidgets('MedicalDisclaimer 위젯이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // 스크롤해서 면책 고지 확인
      await tester.scrollUntilVisible(
        find.byType(MedicalDisclaimer),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.byType(MedicalDisclaimer), findsOneWidget);
    });

    testWidgets('MedicalDisclaimer에 kOnboardingDisclaimerText가 포함된다',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.textContaining('이 앱은 건강 관리를 돕는'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('이 앱은 건강 관리를 돕는'), findsOneWidget);
    });

    testWidgets('"다음" 버튼 탭 시 /onboarding/triggers로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('triggers stub'), findsOneWidget);
    });
  });
}
