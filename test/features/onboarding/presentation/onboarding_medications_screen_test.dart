import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/app/widgets/step_progress.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
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
          path: '/onboarding/triggers',
          builder: (_, __) =>
              const Scaffold(body: Text('triggers stub')),
        ),
        GoRoute(
          path: '/onboarding/medications',
          builder: (_, __) => const OnboardingMedicationsScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('home stub')),
        ),
      ],
    );

/// submit 성공 시나리오: MockHealthProfileRepository.noProfile() 주입
List<Override> _submitOverrides() => [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider
          .overrideWithValue(MockHealthProfileRepository.noProfile()),
    ];

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

    testWidgets('알레르기 섹션 헤더 "알레르기"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('알레르기'), findsOneWidget);
    });

    testWidgets('allergyOptions 8개 칩이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(allergyOptions.length, 8);
      for (final entry in allergyOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('SelectableChip 위젯이 allergyOptions 수만큼 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(
        find.byType(SelectableChip),
        findsNWidgets(allergyOptions.length),
      );
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

      final entry = allergyOptions.first; // milk_dairy

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

      // 복용약 TextField는 스크롤 영역 안에 있으므로 보이도록 스크롤한다.
      await tester.scrollUntilVisible(
        find.byType(TextField).first,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField).first, '오메프라졸');
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

      await tester.scrollUntilVisible(
        find.byType(TextField).first,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField).first, '란소프라졸');
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

      await tester.scrollUntilVisible(
        find.byType(TextField).first,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField).first, '오메프라졸');
      await tester.tap(find.text('＋ 복용약 추가'));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).medications,
        contains('오메프라졸'),
      );

      // 약 칩이 스크롤 영역 아래에 생성되므로 보이도록 스크롤한다.
      await tester.scrollUntilVisible(
        find.byIcon(Icons.close),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingControllerProvider).medications,
        isNot(contains('오메프라졸')),
      );
    });

    testWidgets('MedicalDisclaimer 위젯이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

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

    testWidgets('"완료" 버튼 탭 시 onboardingSubmitProvider.submit()이 호출된다',
        (tester) async {
      await tester.pumpWidget(_wrap(overrides: _submitOverrides()));
      await tester.pumpAndSettle();

      // 완료 버튼을 탭하면 submit이 실행된다 (mock repo이므로 에러 없이 성공)
      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      // 성공 후 홈(/)으로 이동함을 확인
      expect(find.text('home stub'), findsOneWidget);
    });

    testWidgets('"건너뛰기" 버튼이 렌더되지 않는다 (Figma에서 제거됨)', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('건너뛰기'), findsNothing);
    });
  });
}
