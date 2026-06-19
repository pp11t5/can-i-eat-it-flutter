import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:can_i_eat_it/core/app_info/app_info_provider.dart';
import 'package:can_i_eat_it/core/prefs/first_visit_prefs.dart';
import 'package:can_i_eat_it/core/prefs/notification_prefs.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/mypage_screen.dart';
import 'package:can_i_eat_it/features/verdict_history/data/repositories/mock_verdict_history_repository.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';

// ---------------------------------------------------------------------------
// 공통 픽스처
// ---------------------------------------------------------------------------

const _testSession = AuthSession(
  userId: 'smoke-user',
  provider: AuthProvider.kakao,
  hasAgreedTerms: true,
  displayName: '김연기',
  email: 'smoke@example.com',
);

final _mockPackageInfo = PackageInfo(
  appName: 'can_i_eat_it',
  packageName: 'com.example.can_i_eat_it',
  version: '1.0.0',
  buildNumber: '1',
  buildSignature: '',
);

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _wrap({
  AuthSession? session,
  bool nullSession = false,
  HealthProfile? profile,
  bool notifEnabled = true,
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
      // ignore: scoped_providers_should_specify_dependencies
      verdictHistoryRepositoryProvider
          .overrideWithValue(MockVerdictHistoryRepository()),
      // ignore: scoped_providers_should_specify_dependencies
      notificationPrefsProvider.overrideWithValue(
        InMemoryNotificationPrefs(initial: notifEnabled),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      firstVisitPrefsProvider.overrideWithValue(InMemoryFirstVisitPrefs()),
      // ignore: scoped_providers_should_specify_dependencies
      appInfoProvider.overrideWith((_) async => _mockPackageInfo),
    ],
    child: const MaterialApp(home: MypageScreen()),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

// ---------------------------------------------------------------------------
// 시나리오
// ---------------------------------------------------------------------------

void main() {
  group('MypageScreen E2E 스모크 — 시나리오 1: 기본 렌더', () {
    testWidgets('로그인+완성 프로필: 헤더·프로필 섹션·알림 토글·판정 이력·버전 모두 표시', (tester) async {
      final completeProfile = HealthProfile.sampleGerd().copyWith(
        conditions: ['GERD'],
        triggerFoods: ['coffee'],
      );
      await tester.pumpWidget(_wrap(profile: completeProfile));
      await _settle(tester);

      // 계정 헤더
      expect(find.text('김연기'), findsOneWidget);

      // 건강 프로필 섹션 레이블
      expect(find.text('건강 프로필'), findsOneWidget);

      // 알림 토글 레이블
      expect(find.text('앱 내 알림'), findsOneWidget);

      // 판정 이력 ListTile
      expect(find.text('판정 이력'), findsOneWidget);

      // 앱 버전
      expect(find.text('v1.0.0'), findsOneWidget);
    });
  });

  group('MypageScreen E2E 스모크 — 시나리오 2: 프로필 미완성 배지', () {
    testWidgets('triggerFoods 비어있으면 "프로필 미완성" 배지 표시', (tester) async {
      final incomplete = HealthProfile.sampleGerd().copyWith(
        conditions: ['GERD'],
        triggerFoods: [],
      );
      await tester.pumpWidget(_wrap(profile: incomplete));
      await _settle(tester);

      expect(find.text('프로필 미완성'), findsOneWidget);
      expect(find.text('프로필 완성'), findsNothing);
    });
  });

  group('MypageScreen E2E 스모크 — 시나리오 3: 프로필 완성 배지', () {
    testWidgets('conditions + triggerFoods 있으면 "프로필 완성" 배지 표시', (tester) async {
      final complete = HealthProfile.sampleGerd().copyWith(
        conditions: ['GERD'],
        triggerFoods: ['coffee'],
      );
      await tester.pumpWidget(_wrap(profile: complete));
      await _settle(tester);

      expect(find.text('프로필 완성'), findsOneWidget);
      expect(find.text('프로필 미완성'), findsNothing);
    });
  });

  group('MypageScreen E2E 스모크 — 시나리오 4: 로그아웃 플로우', () {
    testWidgets('로그인 세션 있으면 "로그아웃" 텍스트 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('로그아웃'), findsOneWidget);
    });
  });

  group('MypageScreen E2E 스모크 — 시나리오 5: 세션 없음', () {
    testWidgets('세션 없으면 "로그인 정보가 없어요." 표시', (tester) async {
      await tester.pumpWidget(_wrap(nullSession: true));
      await _settle(tester);

      expect(find.text('로그인 정보가 없어요.'), findsOneWidget);

      // 헤더·프로필 섹션 미표시
      expect(find.text('건강 프로필'), findsNothing);
      expect(find.text('로그아웃'), findsNothing);
    });
  });
}
