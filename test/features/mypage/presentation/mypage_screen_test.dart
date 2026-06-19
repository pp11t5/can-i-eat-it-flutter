import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

      expect(find.text('정말 로그아웃하시겠어요?'), findsOneWidget);
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

      expect(find.text('정말 로그아웃하시겠어요?'), findsNothing);
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

      // 다크 모드 ListTile의 Switch는 Icons.dark_mode_outlined 아이콘과 함께 존재
      final darkModeTile = find.ancestor(
        of: find.byIcon(Icons.dark_mode_outlined),
        matching: find.byType(ListTile),
      );
      final switchInDarkTile = find.descendant(
        of: darkModeTile,
        matching: find.byType(Switch),
      );
      expect(switchInDarkTile, findsOneWidget);

      final sw = tester.widget<Switch>(switchInDarkTile);
      expect(sw.value, isFalse);

      await tester.tap(switchInDarkTile);
      await _settle(tester);

      final swAfter = tester.widget<Switch>(switchInDarkTile);
      expect(swAfter.value, isTrue);
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
}
