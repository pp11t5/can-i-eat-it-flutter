import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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
    testWidgets('타이틀 "어떤 음식이 증상을" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('어떤 음식이 증상을'), findsOneWidget);
    });

    testWidgets('서브타이틀 "해당하는 음식을 모두 선택해 주세요 (선택)"이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('해당하는 음식을 모두 선택해 주세요 (선택)'), findsOneWidget);
    });

    testWidgets('triggerFoodOptions 8개 칩이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(triggerFoodOptions.length, 8);
      for (final entry in triggerFoodOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
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

      final entry = triggerFoodOptions.first; // spicy / 매운 음식

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

    testWidgets('"건너뛰기" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('건너뛰기'), findsOneWidget);
    });

    testWidgets('"건너뛰기" 탭 시 /onboarding/medications로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('건너뛰기'));
      await tester.pumpAndSettle();

      expect(find.text('medications stub'), findsOneWidget);
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
