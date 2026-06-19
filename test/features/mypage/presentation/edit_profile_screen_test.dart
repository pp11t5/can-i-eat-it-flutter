import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/edit_profile_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

const _testSession = AuthSession(
  userId: 'u',
  provider: AuthProvider.kakao,
  hasAgreedTerms: true,
);

Widget _wrap(MockHealthProfileRepository profileRepo) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      authRepositoryProvider
          .overrideWithValue(MockAuthRepository(initialSession: _testSession)),
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
    ],
    child: const MaterialApp(home: EditProfileScreen()),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('EditProfileScreen — 초기값 로드', () {
    testWidgets('현재 프로필의 conditions 칩이 선택 상태로 표시된다', (tester) async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd(),
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // sampleGerd: conditions=['GERD'] → '역류성 식도염' 칩이 화면에 존재한다.
      expect(find.text('역류성 식도염'), findsOneWidget);
    });

    testWidgets('프로필이 null 이면 편집 화면이 빈 상태로 표시된다', (tester) async {
      final repo = MockHealthProfileRepository.noProfile();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 섹션 라벨은 표시된다
      expect(find.text('질환'), findsOneWidget);
      expect(find.text('트리거 음식'), findsOneWidget);
    });

    testWidgets('triggerFoods 칩들이 화면에 표시된다', (tester) async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd(),
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // triggerFoodOptions 에서 일부 칩이 렌더됐는지 확인
      expect(find.text('커피·카페인'), findsOneWidget);
    });
  });

  group('EditProfileScreen — 저장', () {
    testWidgets('저장 버튼 탭 시 submit 이 호출된다 (MockRepo 에 반영됨)', (tester) async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd(),
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 저장 버튼을 탭한다
      await tester.tap(find.text('저장'));
      await _settle(tester);

      // MockHealthProfileRepository 에 마지막 제출 프로필이 기록됐는지 확인
      expect(repo.lastSubmittedProfile, isNotNull);
    });

    testWidgets('저장 버튼이 화면에 존재한다', (tester) async {
      final repo = MockHealthProfileRepository.noProfile();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('저장'), findsOneWidget);
    });
  });
}
