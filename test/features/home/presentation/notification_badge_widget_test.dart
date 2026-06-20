import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/notification_badge_widget.dart';

void main() {
  group('NotificationBadgeWidget', () {
    testWidgets('Icons.notifications_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NotificationBadgeWidget())),
      );

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('빨간 원형 배지(BoxDecoration circle)가 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NotificationBadgeWidget())),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasBadge = containers.any((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.shape == BoxShape.circle;
        }
        return false;
      });
      expect(hasBadge, isTrue);
    });
  });
}
