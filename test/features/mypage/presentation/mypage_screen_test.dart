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

      // 로그아웃 버튼은 여러 위젯에 텍스트가 있을 수 있으므로 first 사용
      await tester.tap(find.text('로그아웃').first);
      await _settle(tester);

      expect(find.text('정말 로그아웃하시겠어요?'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
    });

    testWidgets('"취소" 탭 시 다이얼로그가 닫힌다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

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
}
