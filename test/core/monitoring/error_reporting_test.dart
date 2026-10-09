import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/firebase_analytics_service.dart';
import 'package:can_i_eat_it/core/analytics/funnel_once_store.dart';
import 'package:can_i_eat_it/core/monitoring/error_reporter.dart';

final _refProbeProvider = Provider<Ref>((ref) => ref);

class _RecordingReporter implements ErrorReporter {
  final reasons = <String>[];
  final errors = <Object>[];

  @override
  void recordNonFatal(Object error, StackTrace stack,
      {required String reason}) {
    reasons.add(reason);
    errors.add(error);
  }
}

/// 실제 저장소처럼 예외 메시지에 저장 키(userId 포함)를 싣는다.
class _ThrowingStore extends InMemoryFunnelOnceStore {
  @override
  Future<bool> claim(String userId, FunnelEvent event) async =>
      throw Exception('read failed for key analytics.funnel_once_v1.x.$userId');
}

void main() {
  test('logEvent 전송이 실패하면 삼키고 reporter 에 보고한다', () async {
    final reporter = _RecordingReporter();
    final service = FirebaseAnalyticsService(
      send: (_, __) async => throw Exception('send failed'),
      errorReporter: reporter,
    );

    await service.logEvent('some_event');

    expect(reporter.reasons, ['analytics.logEvent(some_event)']);
  });

  test('setUserId 가 실패하면 삼키고 reporter 에 보고한다', () async {
    final reporter = _RecordingReporter();
    final service = FirebaseAnalyticsService(
      setUser: (_) async => throw Exception('set failed'),
      errorReporter: reporter,
    );

    await service.setUserId('user-1');

    expect(reporter.reasons, ['analytics.setUserId']);
  });

  test('claimFunnelOnce 저장 실패는 false 를 돌려주고 reporter 에 보고한다', () async {
    final reporter = _RecordingReporter();
    final container = ProviderContainer(
      overrides: [
        analyticsSubjectIdProvider.overrideWithValue('user-1'),
        funnelOnceStoreProvider.overrideWithValue(_ThrowingStore()),
        errorReporterProvider.overrideWithValue(reporter),
      ],
    );
    addTearDown(container.dispose);

    final claimed = await claimFunnelOnce(
      container.read(_refProbeProvider),
      FunnelEvent.accountFirstMealRecorded,
    );

    expect(claimed, isFalse);
    expect(reporter.reasons, ['analytics.claim(account_first_meal_recorded)']);
  });

  test('claim 실패를 보고할 때 예외 본문의 userId 는 올리지 않는다', () async {
    final reporter = _RecordingReporter();
    final container = ProviderContainer(
      overrides: [
        analyticsSubjectIdProvider.overrideWithValue('secret-user-id'),
        funnelOnceStoreProvider.overrideWithValue(_ThrowingStore()),
        errorReporterProvider.overrideWithValue(reporter),
      ],
    );
    addTearDown(container.dispose);

    await claimFunnelOnce(
      container.read(_refProbeProvider),
      FunnelEvent.accountFirstMealRecorded,
    );

    expect(
        reporter.errors.single.toString(), isNot(contains('secret-user-id')));
  });
}
