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
import 'package:can_i_eat_it/features/mypage/presentation/screens/allergy_med_edit_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/profile_info_screen.dart';

class _NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logFunnel(FunnelEvent event,
      {Map<String, Object?> params = const {}}) async {}
  @override
  Future<void> logEvent(String name,
      {Map<String, Object?> params = const {}}) async {}
}

/// ProfileInfoScreen은 context.push('/mypage/profile/allergy-med')를 호출한다.
/// 테스트 라우터에서 이 경로를 그대로 선언해 네비게이션을 검증한다.
Widget _buildWithRouter() {
  final router = GoRouter(
    initialLocation: '/mypage/profile',
    routes: [
      GoRoute(
        path: '/mypage/profile',
        builder: (context, state) => const ProfileInfoScreen(),
        routes: [
          GoRoute(
            path: 'allergy-med',
            builder: (context, state) => const AllergyMedEditScreen(),
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
  group('ProfileInfoScreen → AllergyMedEditScreen 네비게이션', () {
    testWidgets('알레르기·복용약 행 탭 → AllergyMedEditScreen으로 push됨', (tester) async {
      await tester.pumpWidget(_buildWithRouter());
      await tester.pumpAndSettle();

      // ProfileInfoScreen이 표시됨
      expect(find.byType(ProfileInfoScreen), findsOneWidget);
      expect(find.byType(AllergyMedEditScreen), findsNothing);

      // '알레르기・복용약' 행 탭
      await tester.tap(find.text('알레르기・복용약'));
      await tester.pumpAndSettle();

      // AllergyMedEditScreen으로 이동
      expect(find.byType(AllergyMedEditScreen), findsOneWidget);
    });
  });
}
