import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/app/widgets/app_shell.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/login_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/splash_screen.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_screen.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_detail_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_group_detail_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_screen.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/edit_profile_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';
import 'package:can_i_eat_it/app/observers/route_observer.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/favorites_screen.dart';
import 'package:can_i_eat_it/features/verdict_history/presentation/screens/verdict_history_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_frequency_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_intro_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_medications_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_triggers_screen.dart';

part 'app_router.g.dart';

/// 앱 라우터. 인증/온보딩 상태 기반 redirect 가드 + StatefulShellRoute 바텀 내비.
///
/// [sessionStatusProvider] 값이 의미있게 전이될 때만 go_router redirect를 재평가한다.
/// 기존 authControllerProvider 직접 listen 대비 중복발화(이슈 #20 S3)를 구조적으로 제거.
@riverpod
GoRouter appRouter(Ref ref) {
  // sessionStatus 전이 시에만 go_router redirect 재평가를 트리거하는 브리지.
  final notifier = ValueNotifier<int>(0);

  ref.listen<SessionStatus>(sessionStatusProvider, (prev, next) {
    if (prev != next) notifier.value++;
  });

  // provider가 dispose될 때 notifier도 함께 해제한다.
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    observers: [routeObserver],
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
        path: '/onboarding/condition',
        name: 'onboarding-condition',
        builder: (context, state) => const OnboardingConditionScreen(),
      ),
      GoRoute(
        path: '/onboarding/frequency',
        name: 'onboarding-frequency',
        builder: (context, state) => const OnboardingFrequencyScreen(),
      ),
      GoRoute(
        path: '/onboarding/triggers',
        name: 'onboarding-triggers',
        builder: (context, state) => const OnboardingTriggersScreen(),
      ),
      GoRoute(
        path: '/onboarding/medications',
        name: 'onboarding-medications',
        builder: (context, state) => const OnboardingMedicationsScreen(),
      ),
      GoRoute(
        path: '/check',
        name: 'food-check',
        pageBuilder: (context, state) {
          final recordContext = state.extra as MealRecordContext?;
          final initialQuery = state.uri.queryParameters['initialQuery'];
          return MaterialPage(
            fullscreenDialog: true,
            child: FoodCheckScreen(
              recordContext: recordContext,
              initialQuery: initialQuery,
            ),
          );
        },
      ),
      GoRoute(
        path: '/meal/record',
        name: 'meal-record',
        pageBuilder: (context, state) {
          final mealGroupId = state.extra as String?;
          return MaterialPage(
            fullscreenDialog: true,
            child: MealRecordScreen(mealGroupId: mealGroupId),
          );
        },
      ),
      // 끼니 그룹 상세 — extra: MealGroup
      GoRoute(
        path: '/meal/group',
        name: 'meal-group-detail',
        pageBuilder: (context, state) {
          final group = state.extra! as MealGroup;
          return MaterialPage(
            fullscreenDialog: true,
            child: MealGroupDetailScreen(group: group),
          );
        },
      ),
      // 단일 식사 기록 상세 — :mealId 경로 파라미터
      GoRoute(
        path: '/meal/:mealId',
        name: 'meal-detail',
        pageBuilder: (context, state) {
          final mealId = state.pathParameters['mealId']!;
          return MaterialPage(
            fullscreenDialog: true,
            child: MealDetailScreen(mealId: mealId),
          );
        },
      ),
      // 판정 화면 — FoodCheckScreen에서 present-modal로 진입 (티켓 6).
      // extra: VerdictArgs (externalId 있으면 by-id, 없으면 by-text).
      GoRoute(
        path: '/verdict',
        name: 'verdict',
        pageBuilder: (context, state) {
          final args = state.extra as VerdictArgs? ??
              const VerdictArgs(text: '');
          return MaterialPage(
            fullscreenDialog: true,
            child: VerdictScreen(args: args),
          );
        },
      ),
      GoRoute(
        path: '/history',
        name: 'verdict-history',
        builder: (context, state) => const VerdictHistoryScreen(),
      ),
      // 홈 "오늘의 식사 > 더 보기" 진입점 — TimelineScreen으로 연결.
      GoRoute(
        path: '/meal-log',
        name: 'meal-log',
        builder: (context, state) => const TimelineScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
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
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'mypage-edit',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: 'mypage-notifications',
                    builder: (context, state) => const Scaffold(
                      body: Center(child: Text('알림 설정')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
