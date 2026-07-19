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
import 'package:can_i_eat_it/features/food_dictionary/presentation/screens/food_history_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_food_detail_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_detail_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_screen.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/allergy_med_edit_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/name_edit_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/profile_info_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/withdraw_screen.dart';
import 'package:can_i_eat_it/features/notification/presentation/screens/notification_settings_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_condition_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_frequency_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_medications_screen.dart';
import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_triggers_screen.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_detail_screen.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_write_screen.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/unrecorded_meals_screen.dart';
import 'package:can_i_eat_it/features/weekly_report/presentation/screens/weekly_report_screen.dart';

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
          return MaterialPage(
            fullscreenDialog: true,
            child: FoodCheckScreen(recordContext: recordContext),
          );
        },
      ),
      // 증상 작성/수정 화면 (fullscreenDialog 모달).
      // extra: Symptom? (null=신규, 비-null=수정) 또는 SymptomWriteArgs
      // (신규 작성 시 원인 식사 프리필, 예: 미기록 식단 목록 진입).
      GoRoute(
        path: '/symptom/record',
        name: 'symptom-record',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final existing = extra is Symptom ? extra : null;
          final args = extra is SymptomWriteArgs ? extra : null;
          return MaterialPage(
            fullscreenDialog: true,
            child: SymptomWriteScreen(
              existingSymptom: existing,
              initialMealRecordId: args?.initialMealRecordId,
              initialMealName: args?.initialMealName,
            ),
          );
        },
      ),

      // 증상 미기록 식단 화면 (push, 뒤로가기 진입).
      GoRoute(
        path: '/unrecorded-meals',
        name: 'unrecorded-meals',
        builder: (context, state) => const UnrecordedMealsScreen(),
      ),

      // 음식 히스토리(내 도감) 화면 (push, 뒤로가기 진입).
      GoRoute(
        path: '/food-history',
        name: 'food-history',
        builder: (context, state) => const FoodHistoryScreen(),
      ),

      // 증상 상세 화면 (fullscreenDialog 모달).
      // extra: int? afterMealMinutes (타임라인 탭 진입 시 전달, 직접 진입 시 null).
      GoRoute(
        path: '/symptom/:symptomId',
        name: 'symptom-detail',
        pageBuilder: (context, state) {
          final symptomId = state.pathParameters['symptomId']!;
          final afterMealMinutes = state.extra as int?;
          return MaterialPage(
            fullscreenDialog: true,
            child: SymptomDetailScreen(
              symptomId: symptomId,
              afterMealMinutes: afterMealMinutes,
            ),
          );
        },
      ),

      // 정적/2-세그먼트 라우트를 동적 :mealRecordId 보다 위에 배치(go_router 매칭 순서).
      GoRoute(
        path: '/meal/record',
        name: 'meal-record',
        pageBuilder: (context, state) {
          final mealRecordId = state.extra as String?;
          return MaterialPage(
            fullscreenDialog: true,
            child: MealRecordScreen(mealRecordId: mealRecordId),
          );
        },
      ),
      // 음식 상세 — GET /meal-records/foods/:mealFoodId
      GoRoute(
        path: '/meal/food/:mealFoodId',
        name: 'meal-food-detail',
        pageBuilder: (context, state) {
          final mealFoodId = state.pathParameters['mealFoodId']!;
          return MaterialPage(
            fullscreenDialog: true,
            child: MealFoodDetailScreen(mealFoodId: mealFoodId),
          );
        },
      ),
      // 식사 상세 — GET /meal-records/:mealRecordId (ID-only, 화면이 GET 조회)
      GoRoute(
        path: '/meal/:mealRecordId',
        name: 'meal-record-detail',
        pageBuilder: (context, state) {
          final mealRecordId = state.pathParameters['mealRecordId']!;
          return MaterialPage(
            fullscreenDialog: true,
            child: MealRecordDetailScreen(mealRecordId: mealRecordId),
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
      // 주간 리포트 화면 — 마이페이지 "전체보기"에서 present(X) 진입.
      GoRoute(
        path: '/weekly-report',
        name: 'weekly-report',
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: WeeklyReportScreen(),
        ),
      ),

      // 마이페이지 상세 — 최상위(shell 밖) push 라 바텀네비를 덮는다.
      GoRoute(
        path: '/mypage/profile',
        name: 'mypage-profile',
        builder: (context, state) => const ProfileInfoScreen(),
        routes: [
          GoRoute(
            path: 'allergy-med',
            name: 'mypage-profile-allergy-med',
            builder: (context, state) => const AllergyMedEditScreen(),
          ),
          GoRoute(
            path: 'name-edit',
            name: 'mypage-profile-name-edit',
            builder: (context, state) => const NameEditScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/mypage/notification-settings',
        name: 'mypage-notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/mypage/withdraw',
        name: 'mypage-withdraw',
        builder: (context, state) => const WithdrawScreen(),
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
