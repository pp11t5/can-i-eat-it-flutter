import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MypageScreen(),
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

    testWidgets('주간 기록 "전체보기" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      expect(find.text('전체보기'), findsOneWidget);
    });

    testWidgets('주간 기록 카드에 mySummaryProvider 실카운트가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      // MockMyPageRepository.seeded() — mealRecordCount:9, recentSymptomCount:2,
      // streakCount:4, mealCount(recommend:9, caution:3, risk:1).
      expect(find.text('9'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('권장 9'), findsOneWidget);
      expect(find.text('주의 3'), findsOneWidget);
      expect(find.text('위험 1'), findsOneWidget);
    });

    testWidgets('요약 데이터가 빈 상태면 주간 기록 카드 수치가 0으로 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen(withSummary: false));
      await tester.pumpAndSettle();

      expect(find.text('권장 0'), findsOneWidget);
      expect(find.text('주의 0'), findsOneWidget);
      expect(find.text('위험 0'), findsOneWidget);
    });

    testWidgets('알림 설정 항목이 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('약관 항목 2개가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      // 설정·약관 섹션은 스크롤 아래에 있으므로 끝까지 스크롤한다.
      await tester.scrollUntilVisible(
        find.text('개인정보 보호 약관'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('개인정보 보호 약관'), findsOneWidget);
      expect(find.text('서비스 이용 약관'), findsOneWidget);
    });

    testWidgets('로그아웃 항목이 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      expect(find.text('로그아웃'), findsOneWidget);
    });

    testWidgets('탈퇴 항목이 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      expect(find.text('탈퇴'), findsOneWidget);
    });

    testWidgets('로그아웃 탭 시 확인 다이얼로그가 표시된다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      expect(find.text('로그아웃 하시겠어요?'), findsOneWidget);
      // Figma 577:10285: Primary(green) 라벨은 "취소하기".
      expect(find.text('취소하기'), findsOneWidget);
      expect(find.text('로그아웃하기'), findsOneWidget);
    });

    testWidgets('로그아웃 다이얼로그 취소 시 다이얼로그가 닫힌다', (tester) async {
      await tester.pumpWidget(_buildMypageScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소하기'));
      await tester.pumpAndSettle();

      expect(find.text('로그아웃 하시겠어요?'), findsNothing);
    });
  });
}
