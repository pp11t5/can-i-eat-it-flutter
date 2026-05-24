import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/condition_profile/presentation/screens/condition_profile_screen.dart';
import '../../features/food_check/presentation/screens/food_check_screen.dart';

part 'app_router.g.dart';

/// 앱 라우터. 라우트는 피처 화면을 연결한다. 새 화면 추가 시 여기에 GoRoute 등록.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'food-check',
        builder: (context, state) => const FoodCheckScreen(),
      ),
      GoRoute(
        path: '/conditions',
        name: 'conditions',
        builder: (context, state) => const ConditionProfileScreen(),
      ),
    ],
  );
}
