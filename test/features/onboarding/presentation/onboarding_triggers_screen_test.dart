import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_triggers_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/triggers',
      routes: [
        GoRoute(
          path: '/onboarding/frequency',
          builder: (_, __) =>
              const Scaffold(body: Text('frequency stub')),
        ),
        GoRoute(
          path: '/onboarding/triggers',
          builder: (_, __) => const OnboardingTriggersScreen(),
        ),
        GoRoute(
          path: '/onboarding/medications',
          builder: (_, __) =>
              const Scaffold(body: Text('medications stub')),
        ),
      ],
    );

Widget _wrap({List<Override> overrides = const []}) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('OnboardingTriggersScreen', () {
    testWidgets('타이틀 "불편함이 유발되는" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('불편함이 유발되는'), findsOneWidget);
    });

    testWidgets('서브타이틀 "평소 먹고 나면 속이 불편했던 음식을 선택해 주세요"가 렌더된다',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(
        find.text('평소 먹고 나면 속이 불편했던 음식을 선택해 주세요'),
        findsOneWidget,
      );
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

    testWidgets('triggerFoodOptions 12개 칩이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(triggerFoodOptions.length, 12);
      for (final entry in triggerFoodOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('SelectableChip 위젯이 triggerFoodOptions 수만큼 렌더된다',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(
        find.byType(SelectableChip),
        findsNWidgets(triggerFoodOptions.length),
      );
    });

    testWidgets('트리거 칩 탭 시 draft.triggerFoods에 코드가 추가된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final entry = triggerFoodOptions.first; // coffee_caffeine

      expect(
        container.read(onboardingControllerProvider).triggerFoods,
        isNot(contains(entry.code)),
      );

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).triggerFoods,
        contains(entry.code),
      );
    });

    testWidgets('트리거 칩 재탭 시 draft.triggerFoods에서 제거된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final entry = triggerFoodOptions.first;

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).triggerFoods,
        contains(entry.code),
      );

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).triggerFoods,
        isNot(contains(entry.code)),
      );
    });

    testWidgets('기타 "해당하는 음식이 없나요?" 라벨이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('해당하는 음식이 없나요?'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('해당하는 음식이 없나요?'), findsOneWidget);
    });

    testWidgets('기타 TextField에 입력 시 customTriggers가 설정된다', (tester) async {
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
        find.byType(TextField),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.enterText(find.byType(TextField), '냉면');
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).customTriggers,
        equals('냉면'),
      );
    });

    testWidgets('기타 TextField를 비우면 customTriggers가 null이 된다', (tester) async {
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
        find.byType(TextField),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.enterText(find.byType(TextField), '냉면');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).customTriggers,
        isNull,
      );
    });

    testWidgets(
        'draft에 customTriggers가 있으면 TextField에 해당 값이 복원된다 (H1)',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(onboardingControllerProvider.notifier)
          .setCustomTriggers('탄산음료');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byType(TextField),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      final editableText = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(TextField),
          matching: find.byType(EditableText),
        ),
      );
      expect(
        editableText.controller.text,
        equals('탄산음료'),
        reason: 'initState에서 draft.customTriggers를 _customController에 복원해야 한다',
      );
    });

    testWidgets('"건너뛰기" 버튼이 렌더되지 않는다 (Figma에서 제거됨)', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('건너뛰기'), findsNothing);
    });

    testWidgets('"다음" 버튼 탭 시 /onboarding/medications로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(find.text('medications stub'), findsOneWidget);
    });
  });
}
