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
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/profile_info_screen.dart';

// ---------------------------------------------------------------------------
// Stubs
// ---------------------------------------------------------------------------

class _NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logFunnel(FunnelEvent event,
      {Map<String, Object?> params = const {}}) async {}
  @override
  Future<void> logEvent(String name,
      {Map<String, Object?> params = const {}}) async {}
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _buildProfileInfoScreen({
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
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const ProfileInfoScreen(),
    ),
  );
}

void main() {
  group('ProfileInfoScreen', () {
    testWidgets('앱바에 "프로필 정보" 타이틀이 표시된다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen());
      await tester.pumpAndSettle();

      expect(find.text('프로필 정보'), findsOneWidget);
    });

    testWidgets('session이 null일 때 닉네임이 "사용자"로 표시된다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen(session: null));
      await tester.pumpAndSettle();

      expect(find.text('사용자'), findsOneWidget);
    });

    testWidgets('displayName이 있으면 해당 닉네임이 표시된다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        displayName: '김테스트',
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      expect(find.text('김테스트'), findsOneWidget);
    });

    testWidgets('카카오 연동 표시가 나타난다 (email+provider)', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        email: 'test@kakao.com',
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      expect(find.textContaining('카카오 연동'), findsOneWidget);
    });

    testWidgets('건강 고민에 질환 라벨이 표시된다 (GERD → 역류성 식도염)', (tester) async {
      await tester.pumpWidget(
        _buildProfileInfoScreen(withProfile: true),
      );
      await tester.pumpAndSettle();

      expect(find.text('역류성 식도염'), findsOneWidget);
    });

    testWidgets('프로필이 없을 때 건강 고민에 "미설정"이 표시된다', (tester) async {
      await tester.pumpWidget(
        _buildProfileInfoScreen(withProfile: false),
      );
      await tester.pumpAndSettle();

      expect(find.text('미설정'), findsOneWidget);
    });

    testWidgets('알레르기·복용약 행이 표시된다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen());
      await tester.pumpAndSettle();

      expect(find.text('알레르기 · 복용약'), findsOneWidget);
    });

    testWidgets('로그아웃 버튼 탭 시 확인 다이얼로그가 표시된다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      expect(find.text('로그아웃 하시겠어요?'), findsOneWidget);
    });

    testWidgets('로그아웃 다이얼로그에서 취소하면 닫힌다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      // 다이얼로그가 닫힘 → "로그아웃 하시겠어요?" 없음
      expect(find.text('로그아웃 하시겠어요?'), findsNothing);
    });

    testWidgets('탈퇴하기 버튼 탭 시 Danger 다이얼로그가 표시된다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();

      expect(find.text('정말 탈퇴하시겠어요?'), findsOneWidget);
    });

    testWidgets('탈퇴 다이얼로그에서 취소하면 닫힌다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(find.text('정말 탈퇴하시겠어요?'), findsNothing);
    });

    testWidgets('getMe 실패 시 크래시 없이 기존 세션값 표시', (tester) async {
      // MockAuthRepository.session=null → getMe 실패
      // 빈 표시만 되고 크래시 없어야 함
      await tester.pumpWidget(_buildProfileInfoScreen(session: null));
      await tester.pumpAndSettle();

      // 크래시 없이 "사용자"(기본값) 표시
      expect(find.text('사용자'), findsOneWidget);
    });
  });
}
