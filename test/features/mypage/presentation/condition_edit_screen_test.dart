import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/condition_edit_screen.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _buildScreen({HealthProfile? initialProfile}) {
  final profileRepo = initialProfile == null
      ? MockHealthProfileRepository.completed()
      : MockHealthProfileRepository(initialProfile: initialProfile);

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      // ignore: scoped_providers_should_specify_dependencies
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const ConditionEditScreen(),
    ),
  );
}

void main() {
  group('ConditionEditScreen 위젯 테스트', () {
    testWidgets('앱바에 "건강 고민" 타이틀이 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('건강 고민'), findsOneWidget);
    });

    testWidgets('온보딩 헤더 "어떤 건강 고민이 있으세요?"가 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('어떤 건강 고민이 있으세요?'), findsOneWidget);
      expect(
        find.text('현재는 역류성 식도염만 지원해요\n향후 다른 질환도 추가될 예정이에요'),
        findsOneWidget,
      );
    });

    testWidgets('conditionOptions 4종 카드가 모두 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      for (final entry in conditionOptions) {
        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('하단 "저장하기" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('저장하기'), findsOneWidget);
    });

    testWidgets('초기값 — sampleGerd conditions로 저장 버튼이 활성이다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      // sampleGerd: conditions: ['GERD'] → 선택 있음 → 저장 활성
      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, '저장하기'),
      );
      expect(saveButton.onPressed, isNotNull);
    });

    testWidgets('비활성 질환 카드는 탭해도 선택되지 않는다', (tester) async {
      await tester.pumpWidget(
        _buildScreen(
          initialProfile: const HealthProfile(conditions: ['GERD']),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('위염 / 위궤양'));
      await tester.pump();

      // GERD 유지 — 저장 활성
      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, '저장하기'),
      );
      expect(saveButton.onPressed, isNotNull);
    });

    testWidgets('저장하기 탭 → 캐시에 conditions가 반영된다', (tester) async {
      final cache = InMemoryProfileCache();
      final repo = MockHealthProfileRepository.completed();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            healthProfileRepositoryProvider.overrideWithValue(repo),
            // ignore: scoped_providers_should_specify_dependencies
            profileCacheProvider.overrideWithValue(cache),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            home: const ConditionEditScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('저장하기'));
      // pump만 사용 — showAppToast의 2.5s 타이머가 pumpAndSettle을 블록함
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final cached = await cache.read();
      expect(cached?.conditions, equals(['GERD']));

      // toast 생명주기 전체 소진
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
