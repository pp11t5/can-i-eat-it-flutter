import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/prefs/first_visit_prefs.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/home/presentation/providers/home_providers.dart';

ProviderContainer _makeContainer({
  required MockHealthProfileRepository profileRepo,
  required FirstVisitPrefs prefs,
}) {
  return ProviderContainer(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      // ignore: scoped_providers_should_specify_dependencies
      firstVisitPrefsProvider.overrideWithValue(prefs),
    ],
  );
}

void main() {
  group('shouldShowProfileToastProvider', () {
    test('프로필 미완성 + 토스트 미표시 → true', () async {
      final container = _makeContainer(
        profileRepo: MockHealthProfileRepository(
          initialProfile: HealthProfile.sampleGerd().copyWith(
            conditions: ['GERD'],
            triggerFoods: [],
          ),
        ),
        prefs: InMemoryFirstVisitPrefs(),
      );
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      final result =
          await container.read(shouldShowProfileToastProvider.future);
      expect(result, isTrue);
    });

    test('프로필 완성 → false', () async {
      final container = _makeContainer(
        profileRepo: MockHealthProfileRepository(
          initialProfile: HealthProfile.sampleGerd().copyWith(
            conditions: ['GERD'],
            triggerFoods: ['coffee'],
          ),
        ),
        prefs: InMemoryFirstVisitPrefs(),
      );
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      final result =
          await container.read(shouldShowProfileToastProvider.future);
      expect(result, isFalse);
    });

    test('토스트 이미 표시됨 → false', () async {
      final prefs = InMemoryFirstVisitPrefs();
      await prefs.markToastShown();

      final container = _makeContainer(
        profileRepo: MockHealthProfileRepository(
          initialProfile: HealthProfile.sampleGerd().copyWith(
            conditions: ['GERD'],
            triggerFoods: [],
          ),
        ),
        prefs: prefs,
      );
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      final result =
          await container.read(shouldShowProfileToastProvider.future);
      expect(result, isFalse);
    });

    test('프로필 없음 + 토스트 미표시 → true', () async {
      final container = _makeContainer(
        profileRepo: MockHealthProfileRepository.noProfile(),
        prefs: InMemoryFirstVisitPrefs(),
      );
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      final result =
          await container.read(shouldShowProfileToastProvider.future);
      expect(result, isTrue);
    });
  });
}
