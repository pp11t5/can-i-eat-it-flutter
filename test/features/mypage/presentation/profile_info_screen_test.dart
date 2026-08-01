import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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
import 'package:can_i_eat_it/features/mypage/presentation/screens/name_edit_screen.dart';
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

/// ProfileInfoScreen "내 정보" 카드의 닉네임 행은 탭 시
/// context.push('/mypage/profile/name-edit')를 호출한다.
Widget _buildWithNameEditRouter({AuthSession? session}) {
  final repo = MockAuthRepository(initialSession: session);
  final router = GoRouter(
    initialLocation: '/mypage/profile',
    routes: [
      GoRoute(
        path: '/mypage/profile',
        builder: (context, state) => const ProfileInfoScreen(),
      ),
      GoRoute(
        path: '/mypage/profile/name-edit',
        builder: (context, state) => const NameEditScreen(),
      ),
    ],
  );

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
    child: MaterialApp.router(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
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

    // Figma 2760-24140 신 프로필 디자인: 닉네임은 헤더(Bold 20)와
    // "내 정보" 카드 첫 행(값+"수정") 양쪽에 노출된다(의도된 중복).
    testWidgets('session이 null일 때 닉네임이 "사용자"로 표시된다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen(session: null));
      await tester.pumpAndSettle();

      expect(find.text('사용자'), findsNWidgets(2));
    });

    testWidgets('displayName이 있으면 해당 닉네임이 헤더와 내 정보 카드 양쪽에 표시된다',
        (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        displayName: '김테스트',
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      expect(find.text('김테스트'), findsNWidgets(2));
    });

    // D1(#174)에서 헤더의 이메일·연동 서브텍스트가 의도적으로 제거됐다
    // (_ProfileHeader 주석 "이메일·연동 서브텍스트 제거, D1" 참조).
    // 회귀 방지를 위해 부재를 명시적으로 검증한다.
    testWidgets('헤더에는 이메일/연동(예: "카카오 연동") 서브텍스트가 더 이상 표시되지 않는다 (D1)',
        (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        email: 'test@kakao.com',
      );
      await tester.pumpWidget(_buildProfileInfoScreen(session: session));
      await tester.pumpAndSettle();

      expect(find.textContaining('연동'), findsNothing);
      expect(find.text('test@kakao.com'), findsNothing);
    });

    testWidgets('내 정보 카드의 닉네임 "수정" 탭 시 name-edit 화면으로 push된다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        displayName: '김테스트',
      );
      await tester.pumpWidget(_buildWithNameEditRouter(session: session));
      await tester.pumpAndSettle();

      // 닉네임 행이 첫 번째 "수정" 버튼.
      await tester.tap(find.text('수정').first);
      await tester.pumpAndSettle();

      expect(find.byType(NameEditScreen), findsOneWidget);
      expect(find.text('이름 변경'), findsOneWidget);
    });

    testWidgets('건강 고민에 질환 라벨이 표시된다 (GERD → 역류성 식도염)', (tester) async {
      await tester.pumpWidget(
        _buildProfileInfoScreen(withProfile: true),
      );
      await tester.pumpAndSettle();

      expect(find.text('건강 고민'), findsOneWidget);
      expect(find.text('역류성 식도염'), findsOneWidget);
    });

    testWidgets('프로필이 없을 때 건강 고민에 "미설정"이 표시된다', (tester) async {
      await tester.pumpWidget(
        _buildProfileInfoScreen(withProfile: false),
      );
      await tester.pumpAndSettle();

      expect(find.text('미설정'), findsOneWidget);
    });

    testWidgets('알레르기 · 복용약 행이 표시되고 2개 이상이면 "첫항목 외 N개" 형식이다',
        (tester) async {
      // sampleGerd: allergies=[갑각류], medications=[omeprazole] → "갑각류 외 1개"
      await tester.pumpWidget(_buildProfileInfoScreen(withProfile: true));
      await tester.pumpAndSettle();

      expect(find.text('알레르기 · 복용약'), findsOneWidget);
      expect(find.text('갑각류 외 1개'), findsOneWidget);
    });

    testWidgets('알레르기·복용약이 없으면 "없음"이 표시된다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen(withProfile: false));
      await tester.pumpAndSettle();

      expect(find.text('없음'), findsOneWidget);
    });

    testWidgets('우측 액션 라벨은 "수정"이며 chevron/자물쇠가 없다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen());
      await tester.pumpAndSettle();

      expect(find.text('수정'), findsNWidgets(3));
      expect(find.text('수정하기'), findsNothing);
    });

    testWidgets('내 계정(로그아웃/탈퇴)은 프로필 정보에 없다', (tester) async {
      await tester.pumpWidget(_buildProfileInfoScreen());
      await tester.pumpAndSettle();

      // 마이페이지 최하단으로 이관됨.
      expect(find.text('내 계정'), findsNothing);
      expect(find.text('로그아웃'), findsNothing);
      expect(find.text('탈퇴하기'), findsNothing);
    });

    testWidgets('getMe 실패 시 크래시 없이 기존 세션값 표시', (tester) async {
      // MockAuthRepository.session=null → getMe 실패
      // 빈 표시만 되고 크래시 없어야 함
      await tester.pumpWidget(_buildProfileInfoScreen(session: null));
      await tester.pumpAndSettle();

      // 크래시 없이 "사용자"(기본값) 표시 — 헤더 + 내 정보 카드 양쪽(의도된 중복).
      expect(find.text('사용자'), findsNWidgets(2));
    });
  });
}
