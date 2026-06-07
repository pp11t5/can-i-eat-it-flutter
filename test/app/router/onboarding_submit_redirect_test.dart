import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/router/app_router.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';

/// M3: 온보딩 submit → gate-flip → HomeScreen redirect 통합 검증.
///
/// 실 appRouterProvider + sessionStatusProvider + healthProfileControllerProvider
/// 연결 고리를 단 하나의 시나리오로 관통한다.
///
/// 검증하는 인과 관계:
///   sign-in(기존 사용자 + 프로필 없음)
///   → guard: needsOnboarding → /onboarding/condition
///   → onboardingSubmitProvider.notifier.submit()
///   → healthProfileController.state = AsyncData(profile)  ← gate flip
///   → sessionStatus: needsOnboarding → ready
///   → guard: ready + onboarding 경로 → redirect '/'
///   → HomeScreen 렌더
///
/// 이 테스트가 실패하는 경우:
///   - OnboardingSubmit.submit()이 healthProfileController를 갱신하지 않는 경우.
///   - healthProfileController 상태 변경이 sessionStatusProvider에 전파되지 않는 경우.
///   - appRouter refreshListenable이 sessionStatus 전이를 감지하지 못하는 경우.
///   - guard의 ready 판정 조건이 변경된 경우.
void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // 헬퍼: 실 appRouter를 포함한 ProviderScope + MaterialApp.router 마운트.
  // app_router_redirect_test.dart의 buildApp 패턴을 그대로 따른다.
  // ──────────────────────────────────────────────────────────────────────────
  Widget buildApp({
    required MockAuthRepository authRepo,
    required MockHealthProfileRepository profileRepo,
  }) {
    return ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        authRepositoryProvider.overrideWithValue(authRepo),
        // ignore: scoped_providers_should_specify_dependencies
        healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(appRouterProvider);
          return MaterialApp.router(routerConfig: router);
        },
      ),
    );
  }

  group('onboarding submit → gate-flip → redirect 통합 (M3)', () {
    testWidgets(
      'submit() 호출 후 sessionStatus가 ready로 전이되고 HomeScreen으로 이동한다',
      (tester) async {
        final authRepo = MockAuthRepository.existing();
        final profileRepo = MockHealthProfileRepository.noProfile();

        await tester.pumpWidget(
          buildApp(authRepo: authRepo, profileRepo: profileRepo),
        );
        await tester.pumpAndSettle();

        // 1단계: 미인증 → LoginScreen 확인.
        expect(find.text('카카오로 로그인'), findsOneWidget);

        // 2단계: 카카오 버튼 탭 → signInWithKakao() → context.go('/') →
        //        guard 재평가 → needsOnboarding → /onboarding/condition.
        await tester.tap(find.text('카카오로 로그인'));
        await tester.pumpAndSettle();

        expect(
          find.byType(OnboardingConditionScreen),
          findsOneWidget,
          reason: '프로필 없는 기존 사용자는 OnboardingConditionScreen으로 가야 한다',
        );

        // 3단계: submit() 호출.
        // ProviderScope.containerOf로 실제 컨테이너에서 notifier에 접근한다.
        // OnboardingConditionScreen이 현재 빌드 트리에 존재하므로 이를 anchor로 사용.
        final container = ProviderScope.containerOf(
          tester.element(find.byType(OnboardingConditionScreen)),
        );
        await container.read(onboardingSubmitProvider.notifier).submit();
        await tester.pumpAndSettle();

        // 4단계: gate가 flip됐고 router가 HomeScreen으로 redirect했음을 확인.
        expect(
          find.byType(HomeScreen),
          findsOneWidget,
          reason: 'submit 성공 후 sessionStatus=ready → guard가 HomeScreen(/)으로 redirect해야 한다',
        );
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  });
}
