import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// 테스트용 AuthSession (displayName·email 포함).
const _testSession = AuthSession(
  userId: 'test-user',
  provider: AuthProvider.kakao,
  hasAgreedTerms: true,
  displayName: '홍길동',
  email: 'hong@example.com',
);

Widget _wrap({
  AuthSession? session,
  HealthProfile? profile,
  bool nullSession = false,
}) {
  final authRepo = nullSession
      ? MockAuthRepository(initialSession: null)
      : MockAuthRepository(initialSession: session ?? _testSession);
  final profileRepo = profile != null
      ? MockHealthProfileRepository(initialProfile: profile)
      : MockHealthProfileRepository.noProfile();

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider.overrideWithValue(authRepo),
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
    ],
    child: const MaterialApp(
      home: MypageScreen(),
    ),
  );
}

/// AsyncNotifier 완전 수렴까지 프레임을 소진한다.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('MypageScreen — 계정 헤더', () {
    testWidgets('displayName 이 화면에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('홍길동'), findsOneWidget);
    });

    testWidgets('email 이 화면에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('hong@example.com'), findsOneWidget);
    });
  });

  group('MypageScreen — 건강 프로필 요약', () {
    testWidgets('프로필이 있으면 conditions 가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(profile: HealthProfile.sampleGerd()));
      await _settle(tester);

      expect(find.text('GERD'), findsOneWidget);
    });

    testWidgets('프로필이 있으면 triggerFoods 가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(profile: HealthProfile.sampleGerd()));
      await _settle(tester);

      // sampleGerd: triggerFoods = ['spicy', 'caffeine']
      expect(find.text('spicy'), findsOneWidget);
      expect(find.text('caffeine'), findsOneWidget);
    });

    testWidgets('프로필이 null 이면 "프로필 없음" 문구가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(profile: null));
      await _settle(tester);

      expect(find.text('아직 건강 프로필이 없어요.'), findsOneWidget);
    });
  });

  group('MypageScreen — 계정 액션', () {
    testWidgets('로그아웃 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('로그아웃'), findsOneWidget);
    });

    testWidgets('로그아웃 버튼에 Icons.logout 아이콘이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('탈퇴하기 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('탈퇴하기'), findsOneWidget);
    });

    testWidgets('로그아웃 버튼 탭 시 확인 다이얼로그가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // 진행률 바 추가로 콘텐츠 높이가 늘어날 수 있으므로 스크롤 후 탭
      await tester.scrollUntilVisible(find.text('로그아웃').first, 100);
      await tester.tap(find.text('로그아웃').first);
      await _settle(tester);

      expect(find.textContaining('정말 로그아웃 하시겠어요?'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
    });

    testWidgets('"취소" 탭 시 다이얼로그가 닫힌다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // 진행률 바 추가로 콘텐츠 높이가 늘어날 수 있으므로 스크롤 후 탭
      await tester.scrollUntilVisible(find.text('로그아웃').first, 100);
      await tester.tap(find.text('로그아웃').first);
      await _settle(tester);

      // 다이얼로그 내 취소 버튼 탭
      await tester.tap(find.text('취소'));
      await _settle(tester);

      expect(find.textContaining('정말 로그아웃 하시겠어요?'), findsNothing);
    });
  });

  group('MypageScreen — 세션 없음', () {
    testWidgets('session 이 null 이면 로그인 안내 문구가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nullSession: true));
      await _settle(tester);

      expect(find.text('로그인 정보가 없어요.'), findsOneWidget);
    });
  });

  group('MypageScreen — 프로필/설정 구분선', () {
    testWidgets('Divider 가 마이페이지 화면에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byType(Divider), findsWidgets);
    });
  });

  group('MypageScreen — 공지사항 메뉴', () {
    testWidgets("'공지사항' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('공지사항'), findsOneWidget);
    });
  });

  group('MypageScreen — 다크 모드 토글', () {
    testWidgets("'다크 모드' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('다크 모드'), findsOneWidget);
    });

    testWidgets('Switch를 탭하면 상태가 true로 바뀐다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // 다크 모드 ListTile의 Switch는 key('darkModeTile')로 특정
      final darkModeTile = find.byKey(const Key('darkModeTile'));
      final switchInDarkTile = find.descendant(
        of: darkModeTile,
        matching: find.byType(Switch),
      );
      expect(switchInDarkTile, findsOneWidget);

      final sw = tester.widget<Switch>(switchInDarkTile);
      expect(sw.value, isFalse);

      await tester.ensureVisible(switchInDarkTile);
      await tester.tap(switchInDarkTile);
      await _settle(tester);

      final swAfter = tester.widget<Switch>(switchInDarkTile);
      expect(swAfter.value, isTrue);
    });
  });

  group('MypageScreen — 프로필 편집 버튼', () {
    testWidgets("'편집' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('편집'), findsOneWidget);
    });

    testWidgets("'편집' 버튼 탭 시 /mypage/edit 라우트로 이동한다", (tester) async {
      final authRepo = MockAuthRepository(initialSession: _testSession);
      final profileRepo = MockHealthProfileRepository.noProfile();

      final router = GoRouter(
        initialLocation: '/mypage',
        routes: [
          GoRoute(
            path: '/mypage',
            builder: (_, __) => const MypageScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, __) =>
                    const Scaffold(body: Text('건강 프로필 편집')),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(authRepo),
            // ignore: scoped_providers_should_specify_dependencies
            healthProfileRepositoryProvider.overrideWithValue(profileRepo),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await _settle(tester);

      await tester.tap(find.text('편집'));
      await _settle(tester);

      expect(find.text('건강 프로필 편집'), findsOneWidget);
    });
  });

  group('MypageScreen — 언어 설정 메뉴', () {
    testWidgets("'언어 설정' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('언어 설정'), findsOneWidget);
    });

    testWidgets("'한국어' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('한국어'), findsOneWidget);
    });
  });

  group('MypageScreen — 로그아웃 실행', () {
    testWidgets("다이얼로그 '로그아웃' 버튼 탭 시 authController logout이 호출된다",
        (tester) async {
      final authRepo = MockAuthRepository(initialSession: _testSession);
      final profileRepo = MockHealthProfileRepository.noProfile();

      final router = GoRouter(
        initialLocation: '/mypage',
        routes: [
          GoRoute(
            path: '/mypage',
            builder: (_, __) => const MypageScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (_, __) =>
                const Scaffold(body: Text('login stub')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(authRepo),
            // ignore: scoped_providers_should_specify_dependencies
            healthProfileRepositoryProvider.overrideWithValue(profileRepo),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await _settle(tester);

      await tester.scrollUntilVisible(find.text('로그아웃').first, 100);
      await tester.tap(find.text('로그아웃').first);
      await _settle(tester);

      // 다이얼로그 내 '로그아웃' 버튼 탭
      await tester.tap(find.text('로그아웃').last);
      await _settle(tester);

      // logout() 호출 후 세션이 null이 됨
      expect(await authRepo.currentSession(), isNull);
    });
  });

  group('MypageScreen — 업데이트 확인 메뉴', () {
    testWidgets("'업데이트 확인' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('업데이트 확인'), findsOneWidget);
    });

    testWidgets("'업데이트 확인' 탭 시 '현재 최신 버전을 사용 중이에요.' 다이얼로그가 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.scrollUntilVisible(find.text('업데이트 확인'), 100);
      await tester.tap(find.text('업데이트 확인'));
      await _settle(tester);

      expect(find.text('최신 버전을 사용 중입니다.'), findsOneWidget);
    });
  });

  group('MypageScreen — 건강 목표 섹션', () {
    testWidgets("'건강 목표' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('건강 목표'), findsOneWidget);
    });

    testWidgets("'역류성 식도염 증상 완화' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('역류성 식도염 증상 완화'), findsOneWidget);
    });
  });

  group('MypageScreen — 앱 버전 정보', () {
    testWidgets("'버전 1.0.0' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('버전 1.0.0'), findsOneWidget);
    });
  });

  group('MypageScreen — 개인정보 처리방침', () {
    testWidgets('Icons.privacy_tip_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);
    });

    testWidgets("Icons.privacy_tip_outlined 탭 시 '개인정보 처리방침' 다이얼로그 타이틀이 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.privacy_tip_outlined));
      await _settle(tester);

      expect(find.text('개인정보 처리방침'), findsOneWidget);
    });
  });

  group('MypageScreen — 알림 설정 화면 이동', () {
    testWidgets('Icons.notifications_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets("Icons.notifications_outlined 탭 시 /mypage/notifications로 이동한다",
        (tester) async {
      final authRepo = MockAuthRepository(initialSession: _testSession);
      final profileRepo = MockHealthProfileRepository.noProfile();

      final router = GoRouter(
        initialLocation: '/mypage',
        routes: [
          GoRoute(
            path: '/mypage',
            builder: (_, __) => const MypageScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, __) =>
                    const Scaffold(body: Text('건강 프로필 편집')),
              ),
              GoRoute(
                path: 'notifications',
                builder: (_, __) =>
                    const Scaffold(body: Text('알림 설정 화면')),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(authRepo),
            // ignore: scoped_providers_should_specify_dependencies
            healthProfileRepositoryProvider.overrideWithValue(profileRepo),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await _settle(tester);

      expect(find.text('알림 설정 화면'), findsOneWidget);
    });
  });

  group('MypageScreen — 탈퇴 사유 선택', () {
    testWidgets("탈퇴 다이얼로그에 '서비스가 불편해요' 텍스트가 표시된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // '탈퇴하기' 버튼 탭
      await tester.ensureVisible(find.text('탈퇴하기'));
      await tester.tap(find.text('탈퇴하기'));
      await _settle(tester);

      expect(find.text('서비스가 불편해요'), findsOneWidget);
    });
  });

  group('MypageScreen — 테마 색상 선택', () {
    testWidgets('Icons.palette_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
    });

    testWidgets("Icons.palette_outlined 탭 시 '테마 색상 선택' 텍스트가 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.palette_outlined));
      await tester.tap(find.byIcon(Icons.palette_outlined));
      await _settle(tester);

      expect(find.text('테마 색상 선택'), findsOneWidget);
    });
  });

  group('MypageScreen — 프로필 편집 화면 이동', () {
    testWidgets('프로필 영역 탭 시 /mypage/profile-edit로 이동한다', (tester) async {
      final authRepo = MockAuthRepository(initialSession: _testSession);
      final profileRepo = MockHealthProfileRepository.noProfile();

      final router = GoRouter(
        initialLocation: '/mypage',
        routes: [
          GoRoute(
            path: '/mypage',
            builder: (_, __) => const MypageScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, __) =>
                    const Scaffold(body: Text('건강 프로필 편집')),
              ),
              GoRoute(
                path: 'notifications',
                builder: (_, __) =>
                    const Scaffold(body: Text('알림 설정 화면')),
              ),
              GoRoute(
                path: 'profile-edit',
                builder: (_, __) =>
                    const Scaffold(body: Text('프로필 편집 화면')),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(authRepo),
            // ignore: scoped_providers_should_specify_dependencies
            healthProfileRepositoryProvider.overrideWithValue(profileRepo),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await _settle(tester);

      await tester.tap(find.text('홍길동'));
      await _settle(tester);

      expect(find.text('프로필 편집 화면'), findsOneWidget);
    });
  });

  group('MypageScreen — 문의하기 메뉴', () {
    testWidgets('Icons.chat_bubble_outline 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });

    testWidgets("Icons.chat_bubble_outline 탭 시 '문의하기' 텍스트가 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.chat_bubble_outline));
      await tester.tap(find.byIcon(Icons.chat_bubble_outline));
      await _settle(tester);

      expect(find.text('문의하기'), findsAtLeastNWidgets(1));
    });
  });

  group('MypageScreen — 로그아웃 다이얼로그 개선', () {
    testWidgets("로그아웃 다이얼로그 '로그인 정보가 초기화됩니다.' 텍스트가 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.ensureVisible(find.text('로그아웃'));
      await tester.tap(find.text('로그아웃'));
      await _settle(tester);

      expect(find.textContaining('로그인 정보가 초기화됩니다.'), findsOneWidget);
    });
  });

  group('MypageScreen — 알림 설정 토글', () {
    testWidgets("'알림' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('알림'), findsOneWidget);
    });

    testWidgets("'판정 결과 알림을 받습니다.' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('판정 결과 알림을 받습니다.'), findsOneWidget);
    });
  });

  group('MypageScreen — 앱 업데이트 확인 기능', () {
    testWidgets('Icons.system_update_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.system_update_outlined), findsOneWidget);
    });

    testWidgets(
        "Icons.system_update_outlined 탭 시 '최신 버전을 사용 중입니다.' 텍스트가 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.system_update_outlined));
      await tester.tap(find.byIcon(Icons.system_update_outlined));
      await _settle(tester);

      expect(find.text('최신 버전을 사용 중입니다.'), findsOneWidget);
    });
  });

  group('MypageScreen — 계정 연동 섹션', () {
    testWidgets('Icons.link 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.link));
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets("Icons.link 탭 시 '계정 연동' 다이얼로그 타이틀이 표시된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.link));
      await tester.tap(find.byIcon(Icons.link));
      await _settle(tester);

      // ListTile 타이틀 + 다이얼로그 타이틀 2개 모두 '계정 연동'
      expect(find.text('계정 연동'), findsAtLeastNWidgets(1));
      // 다이얼로그 content 텍스트로 다이얼로그 노출 확인
      expect(find.text('연동할 계정을 선택하세요.'), findsOneWidget);
    });
  });
}
