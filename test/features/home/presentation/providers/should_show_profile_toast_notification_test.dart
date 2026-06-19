import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/prefs/first_visit_prefs.dart';
import 'package:can_i_eat_it/core/prefs/notification_prefs.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/home/presentation/providers/home_providers.dart';

ProviderContainer _makeContainer({
  required MockHealthProfileRepository profileRepo,
  required FirstVisitPrefs firstVisit,
  required NotificationPrefs notifPrefs,
}) {
  return ProviderContainer(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      // ignore: scoped_providers_should_specify_dependencies
      firstVisitPrefsProvider.overrideWithValue(firstVisit),
      // ignore: scoped_providers_should_specify_dependencies
      notificationPrefsProvider.overrideWithValue(notifPrefs),
    ],
  );
}

void main() {
  group('shouldShowProfileToast — 알림 설정 연동', () {
    test('알림 비활성화 시 false 반환', () async {
      final container = _makeContainer(
        profileRepo: MockHealthProfileRepository(
          initialProfile: HealthProfile.sampleGerd().copyWith(
            conditions: ['GERD'],
            triggerFoods: [],
          ),
        ),
        firstVisit: InMemoryFirstVisitPrefs(),
        notifPrefs: InMemoryNotificationPrefs(initial: false),
      );
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      final result =
          await container.read(shouldShowProfileToastProvider.future);
      expect(result, isFalse);
    });

    test('알림 활성화 + 미완성 + 미표시 → true', () async {
      final container = _makeContainer(
        profileRepo: MockHealthProfileRepository(
          initialProfile: HealthProfile.sampleGerd().copyWith(
            conditions: ['GERD'],
            triggerFoods: [],
          ),
        ),
        firstVisit: InMemoryFirstVisitPrefs(),
        notifPrefs: InMemoryNotificationPrefs(initial: true),
      );
      addTearDown(container.dispose);

      await container.read(healthProfileControllerProvider.future);
      final result =
          await container.read(shouldShowProfileToastProvider.future);
      expect(result, isTrue);
    });
  });
}
