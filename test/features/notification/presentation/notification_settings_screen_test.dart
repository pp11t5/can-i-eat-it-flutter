import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/mock_notification_repository.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';
import 'package:can_i_eat_it/features/notification/presentation/screens/notification_settings_screen.dart';

class _FailingBatchNotificationRepository implements NotificationRepository {
  _FailingBatchNotificationRepository({
    required this.initial,
    required this.recovered,
  });

  final NotificationSettings initial;
  final NotificationSettings recovered;
  int fetchCalls = 0;

  @override
  Future<NotificationSettings> fetch() async {
    fetchCalls += 1;
    return fetchCalls == 1 ? initial : recovered;
  }

  @override
  Future<void> toggle(NotificationToggleType type) async {
    throw StateError('toggle failed');
  }

  @override
  Future<void> toggleMarketingConsent(bool enabled) async {}

  @override
  Future<void> updateDailyTime(DailyNotificationTime time) async {}
}

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
    test('마케팅 푸시가 OFF면 하위 알림 변경 요청을 보내지 않는다', () async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: true,
          dailyRecordEnabled: false,
          weeklyReportEnabled: false,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: false,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(mock),
        ],
      );
      addTearDown(container.dispose);
      await container.read(notificationSettingsControllerProvider.future);

      await container
          .read(notificationSettingsControllerProvider.notifier)
          .toggle(NotificationToggleType.postMeal);

      expect(mock.toggleCalls, isEmpty);
    });

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

    testWidgets('마스터 OFF 시 켜진 하위 알림을 모두 OFF로 전환하고 비활성화한다', (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: true,
          dailyRecordEnabled: true,
          weeklyReportEnabled: true,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
      await tester.pumpWidget(_wrap(repo: mock));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(mock.marketingToggleCalls, [false]);
      expect(
        mock.toggleCalls,
        containsAllInOrder([
          NotificationToggleType.postMeal,
          NotificationToggleType.dailyRecord,
          NotificationToggleType.weeklyReport,
        ]),
      );

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.map((switch_) => switch_.value), everyElement(isFalse));
      expect(switches.skip(1).map((switch_) => switch_.onChanged),
          everyElement(isNull));
    });

    testWidgets('마스터를 다시 ON으로 켜도 하위 알림은 OFF로 유지한다', (tester) async {
      final mock = MockNotificationRepository(
        seed: const NotificationSettings(
          postMealEnabled: true,
          dailyRecordEnabled: false,
          weeklyReportEnabled: true,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
      );
      await tester.pumpWidget(_wrap(repo: mock));
      await tester.pumpAndSettle();

      final masterSwitch = find.byType(Switch).first;
      await tester.tap(masterSwitch);
      await tester.pumpAndSettle();
      await tester.tap(masterSwitch);
      await tester.pumpAndSettle();

      expect(mock.marketingToggleCalls, [false, true]);
      expect(
        mock.toggleCalls,
        containsAllInOrder([
          NotificationToggleType.postMeal,
          NotificationToggleType.weeklyReport,
        ]),
      );
      expect(mock.toggleCalls, hasLength(2));

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.first.value, isTrue);
      expect(switches.skip(1).map((switch_) => switch_.value),
          everyElement(isFalse));
      expect(switches.skip(1).map((switch_) => switch_.onChanged),
          everyElement(isNotNull));
    });

    testWidgets('일괄 변경 실패 시 서버 설정을 다시 조회해 상태를 복구한다', (tester) async {
      const recovered = NotificationSettings(
        postMealEnabled: true,
        dailyRecordEnabled: false,
        weeklyReportEnabled: true,
        dailyTime: DailyNotificationTime.morning8,
        marketingPushEnabled: true,
      );
      final repository = _FailingBatchNotificationRepository(
        initial: const NotificationSettings(
          postMealEnabled: true,
          dailyRecordEnabled: true,
          weeklyReportEnabled: true,
          dailyTime: DailyNotificationTime.morning8,
          marketingPushEnabled: true,
        ),
        recovered: recovered,
      );
      await tester.pumpWidget(_wrap(repo: repository));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      expect(repository.fetchCalls, 2);
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.first.value, isTrue);
      expect(switches[1].value, isTrue);
      expect(switches[2].value, isFalse);
      expect(switches[3].value, isTrue);
      expect(find.text('알림 설정 변경에 실패했어요.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
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
