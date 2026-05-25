import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/app/widgets/app_shell.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/splash_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_intro_screen.dart';

part 'app_router.g.dart';

/// 앱 라우터. 인증/온보딩 상태 기반 redirect 가드 + StatefulShellRoute 바텀 내비.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/splash',
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
