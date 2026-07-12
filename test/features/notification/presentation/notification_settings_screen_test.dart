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

    testWidgets('토글 3개 항목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('식후 2시간 알림'), findsOneWidget);
      expect(find.text('식단 기록 알림'), findsOneWidget);
      expect(find.text('주간 리포트'), findsOneWidget);
    });

    testWidgets('알림 수신 시간 라디오 4개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('아침 08:00'), findsOneWidget);
      expect(find.text('점심 12:00'), findsOneWidget);
      expect(find.text('저녁 18:00'), findsOneWidget);
      expect(find.text('밤 22:00'), findsOneWidget);
    });
  });

  group('NotificationSettingsScreen — 토글 상호작용', () {
    testWidgets('식후 알림 토글 탭 시 toggle(postMeal) 호출된다', (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
        ),
      );
      await tester.pumpWidget(_wrap(repo: mock));
      await tester.pumpAndSettle();

      // Switch를 찾아 탭한다 (첫 번째 Switch = postMeal).
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      expect(mock.toggleCalls, contains(NotificationToggleType.postMeal));
    });

    testWidgets('daily-time "저녁 18:00" 탭 시 updateDailyTime(night9) 호출된다',
        (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
        ),
      );
      await tester.pumpWidget(_wrap(repo: mock));
      await tester.pumpAndSettle();

      // Figma 정합으로 카드가 커져 라디오가 뷰포트 아래로 밀리므로 스크롤한다.
      await tester.ensureVisible(find.text('저녁 18:00'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('저녁 18:00'));
      await tester.pumpAndSettle();

      expect(mock.dailyTimeCalls, contains(DailyNotificationTime.night9));
    });
  });
}
