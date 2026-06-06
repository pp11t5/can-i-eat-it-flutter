import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/router/app_router.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';

/// 실 라우터(appRouterProvider) + guard 통합 검증 (ADR-0006 §3).
///
/// sign-in → context.go('/') → guard 재평가 → 목적지 화면이 올바른지 확인.
/// 각 케이스는 [ProviderScope] override 로 auth + health_profile 시나리오를 주입한다.
///
/// 주의: appRouterProvider는 sessionStatusProvider를 listen하고,
/// sessionStatusProvider는 healthProfileControllerProvider를 watch한다.
/// 이 때문에 실 라우터가 pumpAndSettle 중에 redirect를 재평가한다.
void main() {
  // ---------------------------------------------------------------------------
  // 헬퍼: 실 appRouter를 포함한 ProviderScope + MaterialApp.router 마운트.
  // login_screen_test.dart의 _wrap 패턴을 따르되 appRouterProvider를 실제로 사용.
  // ---------------------------------------------------------------------------
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
          return MaterialApp.router(
            routerConfig: router,
          );
        },
      ),
    );
  }

  group('appRouter redirect 통합 — sign-in 후 guard hop', () {
    testWidgets(
      '기존 사용자(약관 동의) + 프로필 없음 → /onboarding/condition 로 redirect',
      (tester) async {
        final authRepo = MockAuthRepository.existing();
        final profileRepo = MockHealthProfileRepository.noProfile();

        await tester.pumpWidget(
          buildApp(authRepo: authRepo, profileRepo: profileRepo),
        );
        // 초기 라우터 구성 + 첫 redirect 처리.
        await tester.pumpAndSettle();

        // 시작점은 /splash → guard가 unauthenticated → /login 으로 redirect.
        // sign-in 전이므로 LoginScreen이 보여야 한다.
        expect(find.text('카카오로 시작하기'), findsOneWidget);

        // 카카오 버튼 탭 → signInWithKakao() → context.go('/') →
        // guard 재평가 → needsOnboarding → /onboarding/condition
        await tester.tap(find.text('카카오로 시작하기'));
        await tester.pumpAndSettle();

        // OnboardingConditionScreen 위젯 타입으로 확인 (텍스트 충돌 방지).
        expect(
          find.byType(OnboardingConditionScreen),
          findsOneWidget,
          reason: '프로필 없는 기존 사용자는 /onboarding/condition 로 가야 한다',
        );
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );

    testWidgets(
      '기존 사용자(약관 동의) + 프로필 완료 → / (HomeScreen) 로 redirect',
      (tester) async {
        final authRepo = MockAuthRepository.existing();
        final profileRepo = MockHealthProfileRepository.completed();

        await tester.pumpWidget(
          buildApp(authRepo: authRepo, profileRepo: profileRepo),
        );
        await tester.pumpAndSettle();

        // 미인증 상태 → /login 으로 redirect돼 LoginScreen이 보여야 한다.
        expect(find.text('카카오로 시작하기'), findsOneWidget);

        // 카카오 버튼 탭 → signInWithKakao() → context.go('/') →
        // guard 재평가 → ready → / (HomeScreen)
        await tester.tap(find.text('카카오로 시작하기'));
        await tester.pumpAndSettle();

        // HomeScreen 위젯 타입으로 확인 (NavigationBar 라벨 '홈'과 충돌 방지).
        expect(
          find.byType(HomeScreen),
          findsOneWidget,
          reason: '프로필 완료 기존 사용자는 홈(/)으로 가야 한다',
        );
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  });
}
