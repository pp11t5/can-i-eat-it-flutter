import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:can_i_eat_it/core/prefs/notification_prefs.dart';

void main() {
  group('SharedPrefsNotificationPrefs', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('기본값은 true', () async {
      final prefs = SharedPrefsNotificationPrefs();
      expect(await prefs.isNotificationEnabled(), isTrue);
    });

    test('setNotificationEnabled(false) 후 false 반환', () async {
      final prefs = SharedPrefsNotificationPrefs();
      await prefs.setNotificationEnabled(false);
      expect(await prefs.isNotificationEnabled(), isFalse);
    });

    test('setNotificationEnabled(true) 후 true 반환', () async {
      final prefs = SharedPrefsNotificationPrefs();
      await prefs.setNotificationEnabled(false);
      await prefs.setNotificationEnabled(true);
      expect(await prefs.isNotificationEnabled(), isTrue);
    });
  });

  group('notificationEnabledProvider', () {
    test('InMemory 주입 — enabled=true', () async {
      final container = ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          notificationPrefsProvider
              .overrideWithValue(InMemoryNotificationPrefs(initial: true)),
        ],
      );
      addTearDown(container.dispose);
      expect(
        await container.read(notificationEnabledProvider.future),
        isTrue,
      );
    });

    test('InMemory 주입 — enabled=false', () async {
      final container = ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          notificationPrefsProvider
              .overrideWithValue(InMemoryNotificationPrefs(initial: false)),
        ],
      );
      addTearDown(container.dispose);
      expect(
        await container.read(notificationEnabledProvider.future),
        isFalse,
      );
    });
  });
}
