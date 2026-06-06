import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/step_progress.dart';
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
          path: '/onboarding/condition',
          builder: (_, __) =>
              const Scaffold(body: Text('condition stub')),
        ),
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

    testWidgets('StepProgress 위젯이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.byType(StepProgress), findsOneWidget);
    });

    testWidgets('뒤로 가기 chevron이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final has32 = sizedBoxes.any((b) => b.width == 32 && b.height == 32);
      expect(has32, isTrue);
    });

    testWidgets('symptomFrequencyOptions 6개 항목이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(symptomFrequencyOptions.length, 6);
      for (final entry in symptomFrequencyOptions) {
        await tester.scrollUntilVisible(
          find.text(entry.label),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('MedicalDisclaimer가 렌더되지 않는다 (Figma에서 제거됨)',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('이 앱은 건강 관리를 돕는'), findsNothing);
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

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        contains(entry.code),
      );

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        isNot(contains(entry.code)),
      );
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
