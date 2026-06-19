import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/presentation/providers/profile_completeness_provider.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/profile_completeness_badge.dart';

Widget _wrap(MockHealthProfileRepository repo) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(home: Scaffold(body: ProfileCompletenessBadge())),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('ProfileCompletenessBadge', () {
    testWidgets('프로필 미완성 시 "프로필 미완성" 텍스트 표시', (tester) async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd().copyWith(
          conditions: ['GERD'],
          triggerFoods: [],
        ),
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('프로필 미완성'), findsOneWidget);
      expect(find.text('프로필 완성'), findsNothing);
    });

    testWidgets('프로필 완성 시 "프로필 완성" 텍스트 표시', (tester) async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd().copyWith(
          conditions: ['GERD'],
          triggerFoods: ['coffee'],
        ),
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('프로필 완성'), findsOneWidget);
      expect(find.text('프로필 미완성'), findsNothing);
    });

    testWidgets('프로필 없으면 "프로필 미완성" 표시', (tester) async {
      final repo = MockHealthProfileRepository.noProfile();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('프로필 미완성'), findsOneWidget);
    });
  });

  group('ProfileCompletenessBadge — 진행률 바', () {
    testWidgets('completeness:60일 때 LinearProgressIndicator value가 0.6이다',
        (tester) async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd().copyWith(
          conditions: ['GERD'],
          triggerFoods: [],
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            healthProfileRepositoryProvider.overrideWithValue(repo),
            // completeness를 60으로 직접 주입
            // ignore: scoped_providers_should_specify_dependencies
            profileCompletenessPercentageProvider.overrideWith((_) => 60),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ProfileCompletenessBadge()),
          ),
        ),
      );
      await _settle(tester);

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(0.6, 0.001));
    });
  });
}
