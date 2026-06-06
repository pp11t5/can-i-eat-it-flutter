import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_done_screen.dart';

// ---------------------------------------------------------------------------
// 제출 상태를 고정하기 위한 Notifier 더블
// ---------------------------------------------------------------------------

/// 제출을 실행하지 않고 state를 초기 AsyncData(null)로 고정하는 stub.
class _IdleSubmitNotifier extends OnboardingSubmit {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  @override
  Future<void> submit() async {
    // 테스트에서 직접 state를 조작하기 위해 아무것도 하지 않는다.
  }
}

/// loading 상태를 반환하는 stub.
class _LoadingSubmitNotifier extends OnboardingSubmit {
  @override
  AsyncValue<void> build() => const AsyncLoading();

  @override
  Future<void> submit() async {}
}

/// error 상태를 반환하는 stub.
class _ErrorSubmitNotifier extends OnboardingSubmit {
  @override
  AsyncValue<void> build() =>
      AsyncError(Exception('서버 오류'), StackTrace.empty);

  @override
  Future<void> submit() async {}
}

/// submit() 호출 여부를 외부 콜백으로 기록하는 spy stub.
///
/// Notifier 공개 프로퍼티 금지(avoid_public_notifier_properties)를 피하기 위해
/// 호출 기록은 private 콜백으로 외부 변수에 전달한다.
class _SpySubmitNotifier extends OnboardingSubmit {
  _SpySubmitNotifier(this._onSubmit);

  final void Function() _onSubmit;

  @override
  AsyncValue<void> build() => const AsyncData(null);

  @override
  Future<void> submit() async {
    _onSubmit();
  }
}

/// submit() 성공 전이를 시뮬레이션하는 stub.
/// build() → AsyncData(null) (초기), submit() → AsyncLoading → AsyncData
/// ref.listen이 AsyncLoading→AsyncData 전이를 감지해 홈 이동을 트리거한다.
class _SuccessSubmitNotifier extends OnboardingSubmit {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  @override
  Future<void> submit() async {
    // loading 전이 후 즉시 data 전이 — 동기적으로 수행해 pumpAndSettle 없이 감지 가능.
    state = const AsyncLoading();
    state = const AsyncData(null);
  }
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter() => GoRouter(
      initialLocation: '/onboarding/done',
      routes: [
        GoRoute(
          path: '/onboarding/done',
          builder: (_, __) => const OnboardingDoneScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) =>
              const Scaffold(body: Text('home stub')),
        ),
      ],
    );

Widget _wrap(List<Override> overrides) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('OnboardingDoneScreen', () {
    testWidgets('타이틀 "입력이 완료됐어요"가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_IdleSubmitNotifier.new),
      ]));
      await tester.pumpAndSettle();

      expect(find.text('입력이 완료됐어요'), findsOneWidget);
    });

    testWidgets('서브타이틀 "이제 음식을 검색해" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_IdleSubmitNotifier.new),
      ]));
      await tester.pumpAndSettle();

      expect(find.textContaining('이제 음식을 검색해'), findsOneWidget);
    });

    testWidgets('MedicalDisclaimer 위젯이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_IdleSubmitNotifier.new),
      ]));
      await tester.pumpAndSettle();

      expect(find.byType(MedicalDisclaimer), findsOneWidget);
    });

    testWidgets('MedicalDisclaimer에 kOnboardingDisclaimerText가 포함된다',
        (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_IdleSubmitNotifier.new),
      ]));
      await tester.pumpAndSettle();

      expect(find.textContaining('이 앱은 건강 관리를 돕는'), findsOneWidget);
    });

    testWidgets('초기(idle) 상태: "시작하기" 버튼이 활성 상태다', (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_IdleSubmitNotifier.new),
      ]));
      await tester.pumpAndSettle();

      // onPressed가 null이 아님 → FilledButton이 활성 상태
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('loading 상태: "시작하기" 버튼이 비활성이고 CircularProgressIndicator가 렌더된다',
        (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_LoadingSubmitNotifier.new),
      ]));
      // CircularProgressIndicator는 계속 애니메이션하므로 pump(1프레임)으로만 렌더 확인한다.
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error 상태: 에러 메시지가 렌더되고 버튼이 재활성된다', (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_ErrorSubmitNotifier.new),
      ]));
      await tester.pumpAndSettle();

      expect(
        find.text('저장 중 오류가 발생했어요. 다시 시도해 주세요.'),
        findsOneWidget,
      );

      // 에러 상태에서는 버튼이 활성 (재시도 가능)
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('"시작하기" 버튼 탭 시 onboardingSubmitProvider.notifier.submit()이 호출된다',
        (tester) async {
      var submitCalled = false;
      final spy = _SpySubmitNotifier(() => submitCalled = true);

      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(() => spy),
      ]));
      await tester.pumpAndSettle();

      expect(submitCalled, isFalse);

      await tester.tap(find.text('시작하기'));
      await tester.pumpAndSettle();

      expect(submitCalled, isTrue);
    });

    testWidgets('제출 성공(AsyncLoading→AsyncData) 전이 시 홈("/")으로 이동한다',
        (tester) async {
      await tester.pumpWidget(_wrap([
        onboardingSubmitProvider.overrideWith(_SuccessSubmitNotifier.new),
      ]));
      await tester.pump();

      // "시작하기" 탭 → submit() → AsyncLoading→AsyncData → ref.listen → context.go('/')
      await tester.tap(find.text('시작하기'));
      // pump 여러 번으로 상태 전이와 라우터 재빌드를 완료시킨다.
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('home stub'), findsOneWidget);
    });
  });
}
