import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
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
import 'package:can_i_eat_it/features/mypage/presentation/screens/withdraw_screen.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/mock_notification_repository.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/analytics/analytics_event.dart';

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

Widget _buildMypageScreen({
  AuthSession? session,
  bool withProfile = true,
  bool withSummary = true,
}) {
  final repo = MockAuthRepository(initialSession: session);
  final profileRepo = withProfile
      ? MockHealthProfileRepository.completed()
      : MockHealthProfileRepository.noProfile();
  final summaryRepo = withSummary
      ? MockMyPageRepository.seeded()
      : MockMyPageRepository.empty();

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
      myPageRepositoryProvider.overrideWithValue(summaryRepo),
      // ignore: scoped_providers_should_specify_dependencies
      notificationRepositoryProvider.overrideWithValue(
        MockNotificationRepository.defaults(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MypageScreen(),
    ),
  );
}

/// 탈퇴하기 탭 시 context.push('/mypage/withdraw') 네비게이션 검증용.
Widget _buildMypageWithWithdrawRouter({AuthSession? session}) {
  final repo = MockAuthRepository(initialSession: session);
  final router = GoRouter(
    initialLocation: '/mypage',
    routes: [
      GoRoute(
        path: '/mypage',
        builder: (context, state) => const MypageScreen(),
      ),
      GoRoute(
        path: '/mypage/withdraw',
        builder: (context, state) => const WithdrawScreen(),
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
      // ignore: scoped_providers_should_specify_dependencies
      dictionaryRepositoryProvider.overrideWithValue(
        MockDictionaryRepository.seeded(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      myPageRepositoryProvider.overrideWithValue(MockMyPageRepository.seeded()),
      // ignore: scoped_providers_should_specify_dependencies
      notificationRepositoryProvider.overrideWithValue(
        MockNotificationRepository.defaults(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ),
  );
}

void main() {
  group('MypageScreen', () {
    testWidgets('앱바에 "마이페이지" 타이틀이 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      expect(find.text('마이페이지'), findsOneWidget);
    });

    testWidgets('session이 null일 때 닉네임이 "사용자"로 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen(session: null));
      await tester.pumpAndSettle();

      expect(find.text('사용자'), findsOneWidget);
    });

    testWidgets('displayName이 있으면 해당 닉네임이 표시된다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
        displayName: '홍길동',
      );
      await tester.pumpWidget(_buildMypageScreen(session: session));
      await tester.pumpAndSettle();

      expect(find.text('홍길동'), findsOneWidget);
    });

    testWidgets('프로필이 있을 때 질환 라벨 "역류성 식도염 관리중"이 표시된다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      await tester.pumpWidget(
        _buildMypageScreen(session: session, withProfile: true),
      );
      await tester.pumpAndSettle();

      expect(find.text('역류성 식도염 관리중'), findsOneWidget);
    });

    testWidgets('프로필이 없을 때 "건강 정보 미설정"이 표시된다', (tester) async {
      await tester.pumpWidget(
        _buildMypageScreen(withProfile: false),
      );
      await tester.pumpAndSettle();

      expect(find.text('건강 정보 미설정'), findsOneWidget);
    });

    testWidgets('음식 히스토리 카드에 실카운트 부제가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      // MockDictionaryRepository.seeded() — 안전 3개, 주의/위험 2개.
      expect(find.text('안전 음식 3개, 주의 음식 2개'), findsOneWidget);
    });

    testWidgets('주간 리포트 타이틀과 데이터가 있을 때 "전체 보기"가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      expect(find.text('주간 리포트'), findsOneWidget);
      expect(find.text('전체 보기'), findsOneWidget);
    });

    testWidgets('주간 리포트 카드에 mySummaryProvider 실카운트가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      // MockMyPageRepository.seeded() — mealRecordCount:9, recentSymptomCount:2,
      // streakCount:4, mealCount(recommend:9, caution:3, risk:1).
      expect(find.text('9'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('권장음식 9끼'), findsOneWidget);
      expect(find.text('주의 음식 3끼'), findsOneWidget);
      expect(find.text('위험 음식 1끼'), findsOneWidget);
    });

    testWidgets('지난주 데이터가 없으면 수집 중 빈 상태와 "전체 보기" 미표시', (tester) async {
      await tester.pumpWidget(_buildMypageScreen(withSummary: false));
      await tester.pumpAndSettle();

      expect(find.text('주간 리포트'), findsOneWidget);
      expect(find.text('내 데이터를 모으고 있어요.'), findsOneWidget);
      expect(find.text('전체 보기'), findsNothing);
      expect(find.text('권장음식 0끼'), findsNothing);
    });

    testWidgets('알림 설정 항목이 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      // 설정 섹션은 스크롤 아래에 있으므로 스크롤한다.
      await tester.scrollUntilVisible(
        find.text('알림 설정'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('약관 섹션에 서비스 이용 약관·개인정보 수집·이용 동의가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('서비스 이용 약관'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('서비스 이용 약관'), findsOneWidget);
      expect(find.text('개인정보 수집·이용 동의'), findsOneWidget);
      // 구 항목 제거
      expect(find.text('개인정보 보호 약관'), findsNothing);
      expect(find.text('마케팅 정보 수신'), findsNothing);
    });

    testWidgets('내 계정 섹션(로그아웃/탈퇴하기)이 최하단에 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('탈퇴하기'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('내 계정'), findsOneWidget);
      expect(find.text('로그아웃'), findsOneWidget);
      expect(find.text('탈퇴하기'), findsOneWidget);
    });

    testWidgets('로그아웃 버튼 탭 시 확인 다이얼로그가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('로그아웃'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      expect(find.text('로그아웃 하시겠어요?'), findsOneWidget);
    });

    testWidgets('로그아웃 다이얼로그에서 취소하면 닫힌다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('로그아웃'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소하기'));
      await tester.pumpAndSettle();

      expect(find.text('로그아웃 하시겠어요?'), findsNothing);
    });

    testWidgets('탈퇴하기 버튼 탭 시 팝업 없이 탈퇴 안내 화면으로 이동한다', (tester) async {
      const session = AuthSession(
        userId: 'test-user',
        provider: AuthProvider.kakao,
        hasAgreedTerms: true,
      );
      // 마이페이지 하단 섹션까지 스크롤 가능하도록 뷰포트 확보.
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildMypageWithWithdrawRouter(session: session));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('탈퇴하기'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text('탈퇴하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();

      expect(find.text('정말 탈퇴하시겠어요?'), findsNothing);
      expect(find.byType(WithdrawScreen), findsOneWidget);
      expect(find.text('데이터 영구 삭제'), findsOneWidget);
    });
  });
}
