@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/food_dictionary_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/repositories/mock_dictionary_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';
import 'package:can_i_eat_it/features/mypage/data/repositories/mock_my_page_repository.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/profile_info_screen.dart';

/// 골든 테스트 — 마이페이지 화면 (마스터 Figma 대조용 PNG 스냅샷).
///
/// 생성된 PNG 경로:
/// - test/features/mypage/presentation/goldens/mypage_summary_with_profile.png
/// - test/features/mypage/presentation/goldens/mypage_summary_no_profile.png
/// - test/features/mypage/presentation/goldens/profile_info_screen.png
///
/// 재생성:
///   flutter test --update-goldens --tags golden \
///     test/features/mypage/presentation/mypage_golden_test.dart

class _NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logFunnel(FunnelEvent event,
      {Map<String, Object?> params = const {}}) async {}
  @override
  Future<void> logEvent(String name,
      {Map<String, Object?> params = const {}}) async {}
}

Widget _buildMypage({
  AuthSession? session,
  bool withProfile = true,
}) {
  final repo = MockAuthRepository(initialSession: session);
  final profileRepo = withProfile
      ? MockHealthProfileRepository.completed()
      : MockHealthProfileRepository.noProfile();

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(repo),
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      // ignore: scoped_providers_should_specify_dependencies
      analyticsServiceProvider.overrideWithValue(_NoopAnalytics()),
      // ignore: scoped_providers_should_specify_dependencies
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
      // ignore: scoped_providers_should_specify_dependencies
      dictionaryRepositoryProvider.overrideWithValue(
        MockDictionaryRepository.seeded(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      myPageRepositoryProvider.overrideWithValue(
        MockMyPageRepository.seeded(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MypageScreen(),
    ),
  );
}

Widget _buildProfileInfo({AuthSession? session}) {
  final repo = MockAuthRepository(initialSession: session);

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(repo),
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(
        MockHealthProfileRepository.completed(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      analyticsServiceProvider.overrideWithValue(_NoopAnalytics()),
      // ignore: scoped_providers_should_specify_dependencies
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const ProfileInfoScreen(),
    ),
  );
}

void main() {
  const testSession = AuthSession(
    userId: 'golden-user',
    provider: AuthProvider.kakao,
    hasAgreedTerms: true,
    displayName: '홍길동',
    email: 'gildong@kakao.com',
  );

  group('마이페이지 골든 테스트', () {
    testWidgets('요약 화면 — 프로필 있음 (캐시 placeholder 포함)', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildMypage(session: testSession, withProfile: true),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MypageScreen),
        matchesGoldenFile('goldens/mypage_summary_with_profile.png'),
      );
    });

    testWidgets('요약 화면 — 건강 정보 미설정 (placeholder 상태)', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildMypage(session: null, withProfile: false),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MypageScreen),
        matchesGoldenFile('goldens/mypage_summary_no_profile.png'),
      );
    });

    testWidgets('프로필 정보 화면', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildProfileInfo(session: testSession),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ProfileInfoScreen),
        matchesGoldenFile('goldens/profile_info_screen.png'),
      );
    });
  });
}
