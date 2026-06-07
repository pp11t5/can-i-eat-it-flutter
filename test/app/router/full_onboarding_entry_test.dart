import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/router/app_router.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';

/// 신규 사용자 전체 진입 플로우: 로그인 → 약관 동의 → 온보딩 1페이지.
/// 약관 PopScope(뒤로가기=signOut)가 가드 redirect 로 인한 terms 제거 시
/// 잘못 발화해 로그인으로 튕기는 회귀를 잡는다.
void main() {
  Widget buildApp() => ProviderScope(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          authRepositoryProvider.overrideWithValue(MockAuthRepository.newUser()),
          // ignore: scoped_providers_should_specify_dependencies
          healthProfileRepositoryProvider
              .overrideWithValue(MockHealthProfileRepository.noProfile()),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp.router(routerConfig: ref.watch(appRouterProvider));
          },
        ),
      );

  testWidgets(
    '로그인 → 약관 3개 동의 → 다음 → 온보딩 1페이지(condition)로 진입한다',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // /splash → guard unauthenticated → /login
      expect(find.byType(LoginScreen), findsOneWidget);

      // 카카오 로그인 → 신규(약관 미동의) → /terms push
      await tester.tap(find.text('카카오로 로그인'));
      await tester.pumpAndSettle();
      expect(find.byType(TermsScreen), findsOneWidget);

      // 필수 3개 동의
      await tester.tap(find.text('[필수] 서비스 이용약관'));
      await tester.tap(find.text('[필수] 개인정보 수집·이용 동의'));
      await tester.tap(find.text('[필수] 민감정보(건강) 수집 동의'));
      await tester.pumpAndSettle();

      // 다음 → agreeToTerms → needsOnboarding → 가드가 condition 으로
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 온보딩 1페이지로 진입해야 한다 (로그인으로 튕기거나 약관에 멈추면 회귀).
      expect(
        find.byType(OnboardingConditionScreen),
        findsOneWidget,
        reason: '약관 동의 후 온보딩 1페이지로 진입해야 한다(로그인으로 튕기면 버그)',
      );
      expect(find.byType(LoginScreen), findsNothing);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );
}
