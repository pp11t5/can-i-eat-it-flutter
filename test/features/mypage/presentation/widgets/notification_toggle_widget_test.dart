import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/prefs/notification_prefs.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/notification_toggle_widget.dart';

Widget _wrap(NotificationPrefs prefs) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      notificationPrefsProvider.overrideWithValue(prefs),
    ],
    child: const MaterialApp(
      home: Scaffold(body: NotificationToggleWidget()),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('NotificationToggleWidget', () {
    testWidgets('알림 활성화 시 스위치가 on 상태로 표시된다', (tester) async {
      final prefs = InMemoryNotificationPrefs(initial: true);
      await tester.pumpWidget(_wrap(prefs));
      await _settle(tester);

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('알림 비활성화 시 스위치가 off 상태로 표시된다', (tester) async {
      final prefs = InMemoryNotificationPrefs(initial: false);
      await tester.pumpWidget(_wrap(prefs));
      await _settle(tester);

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('스위치 탭 시 setNotificationEnabled 호출 — 상태 반전', (tester) async {
      final prefs = InMemoryNotificationPrefs(initial: true);
      await tester.pumpWidget(_wrap(prefs));
      await _settle(tester);

      // 스위치를 탭해 off로 전환
      await tester.tap(find.byType(Switch));
      await _settle(tester);

      // InMemoryNotificationPrefs의 내부 상태가 변경됐는지 확인
      expect(await prefs.isNotificationEnabled(), isFalse);
    });

    testWidgets('"앱 내 알림" 타이틀이 표시된다', (tester) async {
      final prefs = InMemoryNotificationPrefs(initial: true);
      await tester.pumpWidget(_wrap(prefs));
      await _settle(tester);

      expect(find.text('앱 내 알림'), findsOneWidget);
    });
  });
}
