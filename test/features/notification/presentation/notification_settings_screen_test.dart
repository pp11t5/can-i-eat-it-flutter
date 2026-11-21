import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/notification/data/notification_providers.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/mock_notification_repository.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';
import 'package:can_i_eat_it/features/notification/presentation/screens/notification_settings_screen.dart';

NotificationSettings _settings({
  bool marketing = true,
  bool children = false,
}) =>
    NotificationSettings(
      postMealEnabled: children,
      dailyRecordEnabled: children,
      weeklyReportEnabled: children,
      dailyTime: DailyNotificationTime.morning8,
      marketingPushEnabled: marketing,
    );

class _FailingBatchNotificationRepository extends MockNotificationRepository {
  _FailingBatchNotificationRepository()
      : super(seed: _settings(children: true));

  @override
  Future<void> toggle(NotificationToggleType type) async {
    throw StateError('toggle failed');
  }
}

/// 동의 토글 요청이 [gate]가 완료될 때까지 서버에 반영되지 않는 느린 서버.
class _SlowNotificationRepository extends MockNotificationRepository {
  _SlowNotificationRepository() : super(seed: _settings());

  final gate = Completer<void>();

  @override
  Future<bool> toggleMarketingConsent() async {
    await gate.future;
    return super.toggleMarketingConsent();
  }
}

Widget _wrap({NotificationRepository? repo}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      notificationRepositoryProvider.overrideWithValue(
        repo ?? MockNotificationRepository(seed: _settings()),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const NotificationSettingsScreen(),
    ),
  );
}

bool _switchValue(WidgetTester tester) =>
    tester.widget<Switch>(find.byType(Switch)).value;

void main() {
  group('NotificationSettingsScreen — 렌더링', () {
    testWidgets('마케팅 정보 수신 토글 하나만 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('알림 설정'), findsOneWidget);
      expect(find.text('마케팅 정보 수신'), findsOneWidget);
      expect(find.text('신규 기능, 혜택, 이벤트를 알려드려요.'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      // #261: 앱 알림 하위 토글은 OS 권한으로 대체돼 제거됐다.
      expect(find.text('식후 2시간 알림'), findsNothing);
      expect(find.text('식단 기록 알림'), findsNothing);
      expect(find.text('주간 리포트'), findsNothing);
    });

    testWidgets('서버의 마케팅 동의 값을 토글에 반영한다', (tester) async {
      await tester.pumpWidget(
        _wrap(
            repo:
                MockNotificationRepository(seed: _settings(marketing: false))),
      );
      await tester.pumpAndSettle();
      expect(_switchValue(tester), isFalse);
    });
  });

  group('NotificationSettingsScreen — 토글 상호작용', () {
    testWidgets('탭하면 마케팅 동의 토글을 호출하고 서버 값으로 맞춘다', (tester) async {
      final repo = MockNotificationRepository(seed: _settings());
      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(_switchValue(tester), isFalse);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(repo.marketingToggleCalls, [false, true]);
      expect(_switchValue(tester), isTrue);
    });

    testWidgets('일괄 변경 실패 시 서버 값으로 맞추고 토스트를 띄운다', (tester) async {
      await tester
          .pumpWidget(_wrap(repo: _FailingBatchNotificationRepository()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // 동의 토글은 성공(OFF)했으므로 토글은 서버 동의 값을 따른다.
      expect(_switchValue(tester), isFalse);
      expect(find.text('알림 설정 변경에 실패했어요.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    // MY-005: 요청 처리 중 나갔다 바로 재진입해도 이전 값으로 돌아가지 않는다.
    testWidgets('토글 요청 중 재진입해도 새 값이 유지된다', (tester) async {
      final server = _SlowNotificationRepository();
      final showScreen = ValueNotifier(true);
      addTearDown(showScreen.dispose);

      // 실제 앱처럼 ProviderScope는 유지하고 화면만 dispose/재생성한다.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            notificationRepositoryProvider.overrideWithValue(server),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: ValueListenableBuilder<bool>(
              valueListenable: showScreen,
              builder: (_, show, __) =>
                  show ? const NotificationSettingsScreen() : const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch)); // OFF — 서버 응답 대기 중
      await tester.pump();

      showScreen.value = false;
      await tester.pumpAndSettle();
      showScreen.value = true;
      await tester.pumpAndSettle();

      expect(server.marketingToggleCalls, isEmpty); // 서버는 아직 처리 전
      expect(_switchValue(tester), isFalse); // 화면은 이전 값으로 돌아가지 않음

      server.gate.complete();
      await tester.pumpAndSettle();

      expect(server.marketingToggleCalls, [false]);
      expect(_switchValue(tester), isFalse);
    });
  });
}
