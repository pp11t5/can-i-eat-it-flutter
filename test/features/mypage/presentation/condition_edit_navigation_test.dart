import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/condition_edit_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/profile_info_screen.dart';

class _NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logFunnel(FunnelEvent event,
      {Map<String, Object?> params = const {}}) async {}
  @override
  Future<void> logEvent(String name,
      {Map<String, Object?> params = const {}}) async {}
}

/// ProfileInfoScreen은 context.push('/mypage/profile/condition')를 호출한다.
Widget _buildWithRouter() {
  final router = GoRouter(
    initialLocation: '/mypage/profile',
    routes: [
      GoRoute(
        path: '/mypage/profile',
        builder: (context, state) => const ProfileInfoScreen(),
        routes: [
          GoRoute(
            path: 'condition',
            builder: (context, state) => const ConditionEditScreen(),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(
        MockAuthRepository(initialSession: null),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(
        MockHealthProfileRepository.completed(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      analyticsServiceProvider.overrideWithValue(_NoopAnalytics()),
      // ignore: scoped_providers_should_specify_dependencies
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ),
  );
}

void main() {
  group('ProfileInfoScreen → ConditionEditScreen 네비게이션', () {
    testWidgets('건강 고민 "수정" 버튼 탭 → ConditionEditScreen으로 push됨',
        (tester) async {
      await tester.pumpWidget(_buildWithRouter());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileInfoScreen), findsOneWidget);
      expect(find.byType(ConditionEditScreen), findsNothing);

      // 수정 버튼 3개: 닉네임 / 건강 고민 / 알레르기·복용약 — 건강 고민은 두 번째
      await tester.tap(find.text('수정').at(1));
      await tester.pumpAndSettle();

      expect(find.byType(ConditionEditScreen), findsOneWidget);
      expect(find.text('어떤 건강 고민이 있으세요?'), findsOneWidget);
    });
  });
}
