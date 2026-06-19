import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/presentation/providers/profile_completeness_provider.dart';

ProviderContainer _makeContainer(MockHealthProfileRepository repo) {
  return ProviderContainer(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  group('profileCompleteProvider', () {
    test('프로필 없으면 false', () async {
      final container = _makeContainer(MockHealthProfileRepository.noProfile());
      addTearDown(container.dispose);

      // 초기 로딩 대기
      await container.read(healthProfileControllerProvider.future);
      expect(container.read(profileCompleteProvider), isFalse);
    });

    test('conditions·triggerFoods 모두 있으면 true', () async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd().copyWith(
          conditions: ['GERD'],
          triggerFoods: ['coffee'],
        ),
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      expect(container.read(profileCompleteProvider), isTrue);
    });

    test('triggerFoods 비어있으면 false', () async {
      final repo = MockHealthProfileRepository(
        initialProfile: HealthProfile.sampleGerd().copyWith(
          conditions: ['GERD'],
          triggerFoods: [],
        ),
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      expect(container.read(profileCompleteProvider), isFalse);
    });
  });
}
