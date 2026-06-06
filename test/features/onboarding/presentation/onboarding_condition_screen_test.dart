import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/option_card.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/condition',
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

    testWidgets('GERD 카드는 기본값으로 선택 상태다 (draft starts with [GERD])',
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
        container.read(onboardingControllerProvider).conditions,
        contains('GERD'),
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

    testWidgets('GERD 카드 탭 시 single-select — conditions가 [GERD]로 유지된다',
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

      final label = conditionOptions.first.label; // '역류성 식도염'
      final code = conditionOptions.first.code; // 'GERD'

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).conditions,
        equals([code]),
      );
    });

    testWidgets('"다음" 버튼 탭 시 /onboarding/frequency로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // 기본값 conditions=['GERD']이므로 다음 버튼 활성
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('frequency stub'), findsOneWidget);
    });
  });
}
