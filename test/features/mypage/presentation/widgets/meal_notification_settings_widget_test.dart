import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/mypage/presentation/widgets/meal_notification_settings_widget.dart';

Widget _wrap() => const MaterialApp(
      home: Scaffold(body: MealNotificationSettingsWidget()),
    );

void main() {
  group('MealNotificationSettingsWidget', () {
    testWidgets('"식사 알림" Switch가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('식사 알림'), findsOneWidget);
      // Switch가 2개 렌더됨(식사 알림 + 건강 팁 알림)
      expect(find.byType(Switch), findsNWidgets(2));
    });

    testWidgets('"식사 알림" Switch 탭 시 상태가 false로 바뀐다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // 첫 번째 Switch = 식사 알림 (초기값 true)
      final switchFinder = find.byType(Switch).first;
      final beforeSwitch = tester.widget<Switch>(switchFinder);
      expect(beforeSwitch.value, isTrue);

      await tester.tap(switchFinder);
      await tester.pump();

      final afterSwitch = tester.widget<Switch>(switchFinder);
      expect(afterSwitch.value, isFalse);
    });
  });
}
