import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_medications_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/medications',
      routes: [
        GoRoute(
          path: '/onboarding/medications',
          builder: (_, __) => const OnboardingMedicationsScreen(),
        ),
        GoRoute(
          path: '/onboarding/done',
          builder: (_, __) =>
              const Scaffold(body: Text('done stub')),
        ),
      ],
    );

Widget _wrap({List<Override> overrides = const []}) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('OnboardingMedicationsScreen', () {
    testWidgets('타이틀 "알레르기와 복용 중인 약을" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('알레르기와 복용 중인 약을'), findsOneWidget);
    });

    testWidgets('서브타이틀 "없으면 완료를 눌러주세요"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('없으면 완료를 눌러주세요'), findsOneWidget);
    });

    testWidgets('알레르기 섹션 헤더 "알레르기"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('알레르기'), findsOneWidget);
    });

    testWidgets('allergyOptions 6개 칩이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(allergyOptions.length, 6);
      for (final entry in allergyOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('알레르기 칩 탭 시 draft.allergies에 코드가 추가된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final entry = allergyOptions.first; // egg / 계란

      expect(
        container.read(onboardingControllerProvider).allergies,
        isNot(contains(entry.code)),
      );

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).allergies,
        contains(entry.code),
      );
    });

    testWidgets('알레르기 칩 재탭 시 draft.allergies에서 제거된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      final entry = allergyOptions.first;

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).allergies,
        contains(entry.code),
      );

      await tester.tap(find.text(entry.label));
      await tester.pumpAndSettle();
      expect(
        container.read(onboardingControllerProvider).allergies,
        isNot(contains(entry.code)),
      );
    });

    testWidgets('복용약 섹션 헤더 "복용 중인 약"이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('복용 중인 약'), findsOneWidget);
    });

    testWidgets('TextField에 텍스트 입력 후 "＋ 복용약 추가" 탭 시 draft.medications에 추가된다',
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

      await tester.enterText(find.byType(TextField), '오메프라졸');
      await tester.tap(find.text('＋ 복용약 추가'));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).medications,
        contains('오메프라졸'),
      );
    });

    testWidgets('추가된 약 이름이 화면에 렌더된다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '란소프라졸');
      await tester.tap(find.text('＋ 복용약 추가'));
      await tester.pumpAndSettle();

      expect(find.text('란소프라졸'), findsOneWidget);
    });

    testWidgets('Chip X 버튼(Icons.close) 탭 시 draft.medications에서 제거된다',
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

      await tester.enterText(find.byType(TextField), '오메프라졸');
      await tester.tap(find.text('＋ 복용약 추가'));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).medications,
        contains('오메프라졸'),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).medications,
        isNot(contains('오메프라졸')),
      );
    });

    testWidgets('"건너뛰기" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('건너뛰기'), findsOneWidget);
    });

    testWidgets('"건너뛰기" 탭 시 /onboarding/done으로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('건너뛰기'));
      await tester.pumpAndSettle();

      expect(find.text('done stub'), findsOneWidget);
    });

    testWidgets('"완료" 버튼 탭 시 /onboarding/done으로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      expect(find.text('done stub'), findsOneWidget);
    });
  });
}
