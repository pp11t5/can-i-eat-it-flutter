import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/mock_notification_repository.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';
import 'package:can_i_eat_it/features/notification/presentation/screens/notification_settings_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _wrap({NotificationRepository? repo}) {
  final repository = repo ??
      MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: true,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      notificationRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const NotificationSettingsScreen(),
    ),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('NotificationSettingsScreen — 렌더링', () {
    testWidgets('AppBar 타이틀 "알림 설정" 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('마스터 토글(마케팅·푸시 알림 수신)이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('마케팅·푸시 알림 수신'), findsOneWidget);
      expect(find.text('식단 기록, 리포트 등 알림을 보내드릴게요.'), findsOneWidget);
    });

    testWidgets('토글 3개 항목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('식후 2시간 알림'), findsOneWidget);
      expect(find.text('식단 기록 알림'), findsOneWidget);
      expect(find.text('주간 리포트'), findsOneWidget);
    });

    testWidgets('알림 받을 시간 섹션은 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('알림 받을 시간'), findsNothing);
      expect(find.text('아침 08:00'), findsNothing);
    });
  });

  group('NotificationSettingsScreen — 토글 상호작용', () {
    testWidgets('마스터 토글 탭 시 toggleMarketingConsent(false) 호출된다 (A2: 별도 경로)',
        (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
      await tester.pumpWidget(_wrap(repo: mock));
      await tester.pumpAndSettle();

      // Switch를 찾아 탭한다 (첫 번째 Switch = 마스터 토글).
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      // 마케팅 토글은 더 이상 toggleCalls(/notifications/settings/toggle)가 아닌
      // 별도 경로(toggleMarketingConsent)를 호출한다 (A2).
      expect(mock.toggleCalls, isEmpty);
      expect(mock.marketingToggleCalls, contains(false));
    });

    testWidgets('식후 알림 토글 탭 시 toggle(postMeal) 호출된다', (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
      await tester.pumpWidget(_wrap(repo: mock));
      await tester.pumpAndSettle();

      // "식후 2시간 알림" 행 안의 Switch를 찾아 탭한다.
      final postMealRow = find.ancestor(
        of: find.text('식후 2시간 알림'),
        matching: find.byType(Row),
      );
      final postMealSwitch = find.descendant(
        of: postMealRow.first,
        matching: find.byType(Switch),
      );
      await tester.tap(postMealSwitch);
      await tester.pumpAndSettle();

      expect(mock.toggleCalls, contains(NotificationToggleType.postMeal));
    });
  });
}
