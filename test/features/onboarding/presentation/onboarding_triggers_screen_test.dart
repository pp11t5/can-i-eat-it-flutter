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

    // H1: 뒤로 돌아왔을 때 드래프트에 저장된 customTriggers가 TextField에 복원된다.
    //
    // 검증하는 인과 관계:
    //   OnboardingController.setCustomTriggers('탄산음료') → draft.customTriggers = '탄산음료'
    //   → OnboardingTriggersScreen.initState: _customController.text = draft.customTriggers ?? ''
    //   → TextField 초기값으로 '탄산음료'가 표시됨.
    //
    // 이 테스트가 실패하는 경우:
    //   - initState의 복원 로직(ref.read(onboardingControllerProvider).customTriggers)이 제거된 경우.
    //   - 화면이 draft를 읽기 전에 빌드되어 빈 컨트롤러로 시작하는 경우.
    //   - 동일 컨테이너가 공유되지 않아 화면이 별도 provider 인스턴스를 보는 경우.
    testWidgets('draft에 customTriggers가 있으면 TextField에 해당 값이 복원된다 (H1)', (tester) async {
      // 화면과 동일한 컨테이너를 공유해야 initState가 draft를 올바르게 읽는다.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 위젯 빌드 전에 draft에 customTriggers를 설정한다.
      // initState는 첫 build 직전에 실행되므로 반드시 pumpWidget 이전에 호출해야 한다.
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

      // TextField가 스크롤 영역 안에 있으므로 보이도록 스크롤한다.
      await tester.scrollUntilVisible(
        find.byType(TextField),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // initState 복원이 동작했다면 TextField의 EditableText에 '탄산음료'가 있어야 한다.
      // find.text()는 Text 위젯과 EditableText 양쪽에 매치되므로
      // TextField 안의 EditableText를 직접 찾아 값을 검증한다.
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
  });
}
