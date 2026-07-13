import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/mock_notification_repository.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/presentation/screens/notification_settings_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _wrap({
  required bool osBlocked,
  MockNotificationRepository? repo,
  VoidCallback? onOpenAppSettings,
}) {
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
      // ignore: scoped_providers_should_specify_dependencies
      osNotificationBlockedProvider.overrideWith((ref) async => osBlocked),
      openAppSettingsProvider.overrideWithValue(() async {
        onOpenAppSettings?.call();
      }),
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
  group('NotificationSettingsScreen — OS 알림 차단(denied)', () {
    testWidgets('배너 + "설정 바로 가기" 버튼이 렌더되고, 3토글 카드는 비활성화된다',
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
      await tester.pumpWidget(_wrap(osBlocked: true, repo: mock));
      await tester.pumpAndSettle();

      expect(find.text('기기 알림이 꺼져있어요'), findsOneWidget);
      expect(find.text('설정 바로 가기'), findsOneWidget);

      // "식후 2시간 알림" 토글은 IgnorePointer로 감싸져 있어 탭해도 반응하지 않는다.
      final postMealRow = find.ancestor(
        of: find.text('식후 2시간 알림'),
        matching: find.byType(Row),
      );
      final postMealSwitch = find.descendant(
        of: postMealRow.first,
        matching: find.byType(Switch),
      );
      await tester.tap(postMealSwitch, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(mock.toggleCalls, isEmpty);

      // 3토글 카드가 Opacity(0.5)로 dim 처리돼 있는지 확인.
      final dimmedFinder = find.byWidgetPredicate(
        (widget) => widget is Opacity && widget.opacity == 0.5,
      );
      expect(dimmedFinder, findsOneWidget);
      expect(
        find.ancestor(of: postMealSwitch, matching: dimmedFinder),
        findsOneWidget,
      );
    });

    testWidgets('마스터 토글은 OS 차단 중에도 항상 활성 상태를 유지한다', (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
      await tester.pumpWidget(_wrap(osBlocked: true, repo: mock));
      await tester.pumpAndSettle();

      // 마스터 토글(첫 번째 Switch)은 dim(Opacity 0.5) 처리 대상이 아니다.
      final switches = find.byType(Switch);
      final masterSwitch = switches.first;
      final dimmedFinder = find.byWidgetPredicate(
        (widget) => widget is Opacity && widget.opacity == 0.5,
      );
      expect(
        find.ancestor(of: masterSwitch, matching: dimmedFinder),
        findsNothing,
      );

      await tester.tap(masterSwitch);
      await tester.pumpAndSettle();

      expect(mock.toggleCalls, contains(NotificationToggleType.marketing));
    });

    testWidgets('"설정 바로 가기" 탭 시 openAppSettingsProvider 콜백이 호출된다',
        (tester) async {
      var openCalled = false;
      await tester.pumpWidget(
        _wrap(osBlocked: true, onOpenAppSettings: () => openCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('설정 바로 가기'));
      await tester.pumpAndSettle();

      expect(openCalled, isTrue);
    });
  });

  group('NotificationSettingsScreen — OS 알림 정상(denied 아님)', () {
    testWidgets('배너가 표시되지 않고 토글이 정상 동작한다', (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: false,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
      await tester.pumpWidget(_wrap(osBlocked: false, repo: mock));
      await tester.pumpAndSettle();

      expect(find.text('기기 알림이 꺼져있어요'), findsNothing);
      expect(find.text('설정 바로 가기'), findsNothing);

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
