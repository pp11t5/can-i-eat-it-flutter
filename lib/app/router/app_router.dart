import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/app/widgets/app_shell.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/splash_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_intro_screen.dart';

part 'app_router.g.dart';

/// 앱 라우터. 인증/온보딩 상태 기반 redirect 가드 + StatefulShellRoute 바텀 내비.
///
/// [authControllerProvider] 변화 시 [refreshListenable]이 go_router의
/// redirect를 재평가하도록 ValueNotifier 브리지를 사용한다.
@riverpod
GoRouter appRouter(Ref ref) {
  // auth 상태가 바뀔 때마다 go_router redirect 재평가를 트리거하는 브리지.
  final notifier = ValueNotifier<int>(0);

  ref.listen<AsyncValue<dynamic>>(authControllerProvider, (_, __) {
    notifier.value++;
  });

  // provider가 dispose될 때 notifier도 함께 해제한다.
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final status = ref.read(sessionStatusProvider);
      return resolveRedirect(status: status, location: state.matchedLocation);
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/onboarding/intro',
        name: 'onboarding-intro',
        builder: (context, state) => const OnboardingIntroScreen(),
      ),
      GoRoute(
        path: '/check',
        name: 'food-check',
        builder: (context, state) => const FoodCheckScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timeline',
                name: 'timeline',
                builder: (context, state) => const TimelineScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mypage',
                name: 'mypage',
                builder: (context, state) => const MypageScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
