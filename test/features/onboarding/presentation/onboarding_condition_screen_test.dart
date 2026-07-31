import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/option_card.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/widgets/onboarding_shell.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/condition',
      routes: [
        ShellRoute(
          builder: (context, state, child) => OnboardingShell(child: child),
          routes: [
            GoRoute(
              path: '/onboarding/condition',
              builder: (_, __) => const OnboardingConditionScreen(),
            ),
            GoRoute(
              path: '/onboarding/frequency',
              builder: (_, __) =>
                  const Scaffold(body: Text('frequency stub')),
            ),
          ],
        ),
      ],
    );

Widget _wrap({List<Override> overrides = const []}) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('OnboardingConditionScreen', () {
    testWidgets('타이틀 "어떤 건강 고민이 있으세요?"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('어떤 건강 고민이 있으세요?'), findsOneWidget);
    });

    testWidgets('서브타이틀 "현재는 역류성 식도염만 지원해요" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('현재는 역류성 식도염만 지원해요'), findsOneWidget);
    });

    testWidgets('StepProgress 위젯이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.byType(StepProgress), findsOneWidget);
    });

    testWidgets('뒤로 가기 chevron이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // chevron을 감싼 32×32 SizedBox가 존재함을 확인
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final has32 = sizedBoxes.any((b) => b.width == 32 && b.height == 32);
      expect(has32, isTrue);
    });

    testWidgets('conditionOptions 항목 라벨 4개가 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(conditionOptions.length, 4);
      for (final entry in conditionOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('OptionCard 위젯이 conditionOptions 수만큼 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.byType(OptionCard), findsNWidgets(conditionOptions.length));
    });

    testWidgets('진입 시 conditions는 비어 있고 GERD 미선택이다', (tester) async {
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
        container.read(onboardingControllerProvider).conditions,
        isEmpty,
      );
    });

    testWidgets('비활성(enabled:false) 카드를 탭해도 conditions가 변경되지 않는다',
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

      final initialConditions =
          List<String>.from(container.read(onboardingControllerProvider).conditions);

      // 비활성 항목 (gastritis, ibs, functional_dyspepsia) 중 첫 번째를 탭
      final disabledEntry = conditionOptions.firstWhere((e) => !e.enabled);
      await tester.tap(find.text(disabledEntry.label));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).conditions,
        equals(initialConditions),
        reason: 'Disabled card tap must not change conditions',
      );
    });

    testWidgets('GERD 카드 탭 시 conditions가 [GERD]로 설정된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final label = conditionOptions.first.label; // '역류성 식도염'
      final code = conditionOptions.first.code; // 'GERD'

      expect(
        container.read(onboardingControllerProvider).conditions,
        isEmpty,
      );

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).conditions,
        equals([code]),
      );
    });

    testWidgets('GERD 카드를 다시 탭하면 선택이 해제된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final label = conditionOptions.first.label;

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).conditions,
        equals(['GERD']),
      );

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).conditions,
        isEmpty,
      );
    });

    testWidgets('미선택 시 "다음" 탭해도 frequency로 이동하지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('frequency stub'), findsNothing);
      expect(find.text('어떤 건강 고민이 있으세요?'), findsOneWidget);
    });

    testWidgets('GERD 선택 후 "다음" 탭 시 /onboarding/frequency로 이동한다',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text(conditionOptions.first.label));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('frequency stub'), findsOneWidget);
    });
  });
}
